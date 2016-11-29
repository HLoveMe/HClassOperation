//
//  NSObject+Proxy.m
//  ZZH_NSProxy
//
//  Created by 朱子豪 on 2016/11/28.
//  Copyright © 2016年 Space. All rights reserved.
//

#import "NSObject+Proxy.h"
#import "HGProperty.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

/**
 1:如何实现方法监听
    >开启监听   保存监听方法的签名 对象 回调等信息
    >对需要监听的方法进行 Method 和 "固定方法"交换  （这里就有参数个数，参数是否为对象等等问题）
    >"固定方法"(-(id)METHOD...)内部调用了不存在的方法@selector(udid_sel)  就会进入设计好的错误处理流程
    >-(NSMethodSignature *)_methodSignatureForSelector:(SEL)aSelector
        返回之前保存好的 正确的方法签名
        说明:(这里为了不影响其他框架或者开发者调用@selector*(methodSignatureForSelector))
        在load中 对 (@selector(_methodSignatureForSelector),@selector*(methodSignatureForSelector))进行了掉包,保证其正确性
    >-(void)forwardInvocation:(NSInvocation *)anInvocation
        在上面返回正确方法签名之后 在这里对正确调用（对调用NSInvacation进行参数设置，返回值获取等操作)
        并且执行回调
    
 
 缺点: 对需要监听的方法 参数必须为对象（int BOOL 不被容许）
 
 2:实现属性监听
    对需要监听属性的set方法掉包 监听 

缺点:对类目里面的计算属性 无法监听
*/

#define METHOD_IMP   NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;\
NSString *methStr = NSStringFromSelector(_cmd);\
NSMutableDictionary *dic = objc_getAssociatedObject(self,"HG_Proxy");\
HGMethod *method = dic[methStr];\
[method.pars addObjectsFromArray:_pars];\
[self performSelector:NSSelectorFromString([NSString stringWithFormat:@"%@_%@",uuid,NSStringFromSelector(_cmd)])];\
return method.result;


@implementation NSObject (Proxy)
+(void)load{
    Method  one = class_getInstanceMethod([self class], @selector(methodSignatureForSelector:));
    Method two = class_getInstanceMethod([self class], @selector(_methodSignatureForSelector:));
    method_exchangeImplementations(one, two);
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void)set_pro:(id)value{
    [self set_pro:value];
    NSString *name = [self propertyNameScanFromSetterSelector:_cmd];
    NSMutableDictionary *dic = objc_getAssociatedObject(self,"HG_Proxy");
    HGProperty *proper = dic[name];
    if(proper.block){
        proper.block(self);
    }else{
        if([proper.target respondsToSelector:@selector(changeTarget:)]){
            [proper.target performSelector:@selector(changeTarget:) withObject:self];
        }
    }
    
}
-(void)set_proN:(double)value{
    [self set_proN:value];
    NSString *name = [self propertyNameScanFromSetterSelector:_cmd];
    NSMutableDictionary *dic = objc_getAssociatedObject(self,"HG_Proxy");
    HGProperty *proper = dic[name];
    if(proper.block){
        proper.block(self);
    }else{
        if([proper.target respondsToSelector:@selector(changeTarget:)]){
            [proper.target performSelector:@selector(changeTarget:) withObject:self];
        }
    }
}
#pragma clang diagnostic pop

-(void)startPropertyListen:(id)target proName:(NSString *)name{
//    HGProxy *proxy = [[HGProxy alloc]init:self listener:target proName:name];
    NSMutableDictionary *dic = objc_getAssociatedObject(self,"HG_Proxy");
    if(!dic){
        dic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self,"HG_Proxy", dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    HGProperty *proper = [[HGProperty alloc]init];
    proper.name = name;
    proper.target = target;
    
    dic[name]= proper;
    
    
    objc_property_t pro = class_getProperty(self.class, [name cStringUsingEncoding:4]);
    
    NSString *atr = [[NSString alloc]initWithUTF8String:property_getAttributes(pro)];
    NSString *proOne = [[atr componentsSeparatedByString:@","] firstObject];
    
    NSString *selStr=[[NSString alloc]initWithFormat:@"set%@:",[name capitalizedString]];
    SEL change;
    if([proOne containsString:@"@"]){
        change = @selector(set_pro:);
    }else{
        change = @selector(set_proN:);
    }
    SEL asel = NSSelectorFromString(selStr);
    method_exchangeImplementations(class_getInstanceMethod(self.class, asel),class_getInstanceMethod(self.class,change));
    proper.asel=asel;
    proper.bsel = change;
}


-(void)startPropertyListenProName:(NSString *)name withChange:(ChangeBlock) block{
    [self startPropertyListen:nil proName:name];
    NSMutableDictionary *dic = objc_getAssociatedObject(self,"HG_Proxy");
    HGProperty *proper = dic[name];
    proper.block = block;
}
-(void)endPropertyListen:(NSString *)name{
    NSMutableDictionary *dic = objc_getAssociatedObject(self,"HG_Proxy");
    HGProperty *proper = dic[name];
    method_exchangeImplementations(class_getInstanceMethod(self.class, proper.asel),class_getInstanceMethod(self.class,proper.bsel));
}
/////////////////
-(void)startMethodListen:(SEL)sel befor:(BeforMethod)befor after:(AfterMethod)after{
    NSMutableDictionary *dic = objc_getAssociatedObject(self,"HG_Proxy");
    if(!dic){
        dic = [NSMutableDictionary dictionary];
        
        objc_setAssociatedObject(self,"HG_Proxy", dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    Method one = class_getInstanceMethod(self.class, sel);
    
    NSString *methStr = NSStringFromSelector(sel);
    NSArray *arr = [methStr componentsSeparatedByString:@":"];
    BOOL flag = [methStr containsString:@":"];
    NSMutableString *selStr = [NSMutableString stringWithFormat:@"METHOD"];
    for (int i=0; i<arr.count-1; i++) {
        if(i==0 && flag){
            [selStr appendString:@":"];
        }else{
            [selStr appendString:@"par:"];
        }
        
    }
    Method two = class_getInstanceMethod(self.class, NSSelectorFromString(selStr));
    method_exchangeImplementations(one, two);
    
    HGMethod *method = [[HGMethod alloc]init];
    SEL cc = NSSelectorFromString(selStr);
    method.trueSig = [[self class] instanceMethodSignatureForSelector:cc];
    method.asel = sel;
    method.bsel = cc;
    method.before=befor;
    method.after = after;
    dic[NSStringFromSelector(sel)]= method;
}
-(void)endMethodListen:(SEL)sel{
    NSMutableDictionary *dic = objc_getAssociatedObject(self,"HG_Proxy");
    NSString *selStr = NSStringFromSelector(sel);
    HGMethod *method = dic[selStr];
    method_exchangeImplementations(class_getInstanceMethod(self.class, method.asel), class_getInstanceMethod(self.class, method.bsel));
    [dic removeObjectForKey:selStr];
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
-(NSMethodSignature *)_methodSignatureForSelector:(SEL)aSelector{
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    NSString * asel = [[NSStringFromSelector(aSelector) stringByReplacingOccurrencesOfString:uuid.UUIDString withString:@""] substringFromIndex:1];
    NSMutableDictionary *dic = objc_getAssociatedObject(self,"HG_Proxy");
    HGMethod *method = dic[asel];
    if(method) return method.trueSig;
    else return [self _methodSignatureForSelector:aSelector];
}
//-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
//    return [self methodSignatureForSelector:aSelector];
//    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
//    NSString * asel = [[NSStringFromSelector(aSelector) stringByReplacingOccurrencesOfString:uuid.UUIDString withString:@""] substringFromIndex:1];
//    NSMutableDictionary *dic = objc_getAssociatedObject(self,"HG_Proxy");
//    HGMethod *method = dic[asel];
//    return method.trueSig;
//}
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    NSString * asel = [[NSStringFromSelector(anInvocation.selector) stringByReplacingOccurrencesOfString:uuid.UUIDString withString:@""] substringFromIndex:1];
    NSMutableDictionary *dic = objc_getAssociatedObject(self,"HG_Proxy");
    HGMethod *method = dic[asel];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:method.trueSig];
    inv.selector = method.bsel;
    for (int i=0; i<method.pars.count; i++) {
        id value = method.pars[i];
        [inv setArgument:&value atIndex:2+i];
    }
    if(method.before){method.before(method.pars);}
    [inv invokeWithTarget:self];
    if(method.after){method.after();}
    id result;
    [inv getReturnValue:&result];
    method.result = result;
}
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (NSString *)propertyNameScanFromSetterSelector:(SEL)selector
{
    NSString *selectorName = NSStringFromSelector(selector);
    NSUInteger parameterCount = [[selectorName componentsSeparatedByString:@":"] count] - 1;
    if ([selectorName hasPrefix:@"set"] && parameterCount == 1) {
        NSUInteger firstColonLocation = [selectorName rangeOfString:@":"].location;
        return [selectorName substringWithRange:NSMakeRange(3, firstColonLocation - 3)].lowercaseString;
    }
    return nil;
}

-(id)METHOD{
    NSArray *_pars = @[];
    METHOD_IMP
    
}
-(id)METHOD:(id)par0{
    NSArray *_pars = @[par0];
    METHOD_IMP
    
}
-(id)METHOD:(id)par0 par:(id)par1{
    NSArray *_pars = @[par0,par1];
    METHOD_IMP
    
}
-(id)METHOD:(id)par0 par:(id)par1 par:(id)par2{
    NSArray *_pars = @[par0,par1,par2];
    METHOD_IMP
    
}
-(id)METHOD:(id)par0 par:(id)par1 par:(id)par2 par:(id)par3{
    NSArray *_pars = @[par0,par1,par2,par3];
    METHOD_IMP
    
}
-(id)METHOD:(id)par0 par:(id)par1 par:(id)par2 par:(id)par3 par:(id)par4{
    NSArray *_pars = @[par0,par1,par2,par3,par4];
    METHOD_IMP
    
}
-(id)METHOD:(id)par0 par:(id)par1 par:(id)par2 par:(id)par3 par:(id)par4 par:(id)par5{
    NSArray *_pars = @[par0,par1,par2,par3,par4,par5];
    METHOD_IMP
    
}
-(id)METHOD:(id)par0 par:(id)par1 par:(id)par2 par:(id)par3 par:(id)par4 par:(id)par5 par:(id)par6{
    NSArray *_pars = @[par0,par1,par2,par3,par4,par5,par6];
    METHOD_IMP
}
-(id)METHOD:(id)par0 par:(id)par1 par:(id)par2 par:(id)par3 par:(id)par4 par:(id)par5 par:(id)par6 par:(id)par7{
    NSArray *_pars = @[par0,par1,par2,par3,par4,par5,par6,par7];
    METHOD_IMP
}
-(id)METHOD:(id)par0 par:(id)par1 par:(id)par2 par:(id)par3 par:(id)par4 par:(id)par5 par:(id)par6 par:(id)par7 par:(id)par8{
    NSArray *_pars = @[par0,par1,par2,par3,par4,par5,par6,par7,par8];
    METHOD_IMP
}
#pragma clang diagnostic pop
@end
