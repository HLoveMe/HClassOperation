//
//  ZZHProxy.m
//  ZZH_NSProxy
//
//  Created by space on 15/12/4.
//  Copyright © 2015年 Space. All rights reserved.
//

#import "HInstanceProxy.h"
#import <objc/runtime.h>
@interface HInstanceProxy()
@property(nonatomic,strong)NSMutableDictionary<NSString *, NSInvocation *> *dictionary;
@end

@implementation HInstanceProxy
-(NSMutableDictionary *)dictionary{
    if (nil==_dictionary) {
        _dictionary=[NSMutableDictionary dictionary];
    }
    return _dictionary;
}
-(instancetype)initWithObject:(NSObject *)obj{
    _object=obj;
    return self;
}
-(void)setObject:(NSObject *)object{
    _object = object;
}
-(void)forwardInvocation:(NSInvocation *)invocation{
    if (invocation) {
         /**执行插入之前的方法*/
        NSInvocation *before=self.dictionary[@"before"];
        if (before) [before invoke];
        
        [invocation setTarget:_object];
        [invocation invoke];
         /**之后的*/
         NSInvocation *after=self.dictionary[@"after"];
        if (after) [after invoke];
    } 

}
-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    NSMethodSignature *signature;
    if (_object) {
        signature=[_object methodSignatureForSelector:sel];
    }else{
        signature=[super methodSignatureForSelector:sel];
    }
    return signature;
}
-(void)addBeformethod:(id)target selector:(SEL)sel{
    NSInvocation *invocation=  [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:sel]];
    [invocation setTarget:target];
    [invocation setSelector:sel];
    [self.dictionary setObject:invocation forKey:@"before"];
}
-(void)addBAftermethod:(id)target selector:(SEL)sel {
    NSInvocation *invocation= [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:sel]];
    [invocation setTarget:target];
    [invocation setSelector:sel];
    [self.dictionary setObject:invocation forKey:@"after"];
}
+(void)newProxy:(id)target sel:(SEL)aSel before:(void(^)())before  after:(void(^)())after{
    if (before) {
        before();
    }
    [target performSelector:aSel];
    if (after) {
        after();
    }
}
-(BOOL)respondsToSelector:(SEL)aSelector{
    if ([self.object respondsToSelector:aSelector]) {
        return  YES;
    }
    return  NO;
}

@end
