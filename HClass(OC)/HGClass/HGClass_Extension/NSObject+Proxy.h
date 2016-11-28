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
