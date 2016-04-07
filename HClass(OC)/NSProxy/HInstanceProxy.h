
//
//  Created by space on 15/12/4.
//  Copyright © 2015年 Space. All rights reserved.
//
/**
 * 1： 创建 HInstanceProxy 并成为 Object的代理
 * 2： 增加监听方法
 * 3： 代理 调用 Object的选择器   就会进入错误流程
 */
#import <Foundation/Foundation.h>

@interface HInstanceProxy : NSProxy
@property(nonatomic,retain)NSObject *object;
-(instancetype)initWithObject:(NSObject *)object;
 /**增加插入执行的方法*/
-(void)addBeformethod:(id)target selector:(SEL)sel;
-(void)addBAftermethod:(id)target selector:(SEL)sel;

+(void)newProxy:(id)target sel:(SEL)aSel before:(void(^)())before  after:(void(^)())after;
@end
