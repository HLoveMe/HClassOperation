//
//  NSObject+Proxy.h
//  ZZH_NSProxy
//
//  Created by 朱子豪 on 2016/11/28.
//  Copyright © 2016年 Space. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGMethod.h"
#import "HGProperty.h"
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
@interface NSObject (Proxy)
//监听方法调用
//所有参数都必须是对象
-(void)startMethodListen:(SEL)sel befor:(BeforMethod)befor after:(AfterMethod)after;
//结束方法监听
-(void)endMethodListen:(SEL)sel;

//调用者 需要监听者   target 谁监听该属性   属性名
// model:{name:,age:}
//  [model startPropertyListen:self proName:@"age"];
//调用 -(void)changeTarget:(id)listen;
-(void)startPropertyListen:(id)target proName:(NSString *)name;
-(void)startPropertyListenProName:(NSString *)name withChange:(ChangeBlock) block;

-(void)endPropertyListen:(NSString *)name;
@end
