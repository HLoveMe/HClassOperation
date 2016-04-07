//
//  fiveViewController.m
//  HClass(OC)
//
//  Created by 朱子豪 on 16/4/7.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

#import "fiveViewController.h"
#import "HInstanceProxy.h"
@interface fiveViewController()
@property(nonatomic,strong)HInstanceProxy *proxy;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIView *testView;

@end
@implementation fiveViewController
-(void)viewDidLoad{
    [super viewDidLoad];
}
-(void)before{
    NSLog(@"before");
}
-(void)after{
    NSLog(@"after");
}
-(void)test:(NSString *)a with:(NSString *)b{
    NSLog(@"%@---%@",a,b);
}
- (IBAction)impProxy:(id)sender {
    self.proxy = [[HInstanceProxy alloc]initWithObject:self];
    [self.proxy addBeformethod:self selector:@selector(before)];
    [self.proxy addBAftermethod:self selector:@selector(after)];
}
- (IBAction)test:(id)sender {
     /**利用NSProxy错误机制*/
    [self.proxy performSelector:@selector(test:with:) withObject:@"A" withObject:@"B"];
}
 /**错误机制*/
- (IBAction)messageChange:(id)sender {
     /**错误调用 进入下面的流程*/
    [self performSelector:@selector(setBackgroundColor:) withObject:[UIColor  colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]];
}

// /////////////////////第一步 或者是最后一步/////////////////////
 /**实现消息转发*/
- (id)forwardingTargetForSelector:(SEL)aSelector{
    //两种方式
    if (arc4random()%2) {
         /**能够处理就不走下面的*/
        return self.testButton;
    }else{
        /**进入下面的流程*/
        return nil;
       //return self.nibName;
    }
}
// /////////////////////第二步/////////////////////
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
//  return  [self.testButton methodSignatureForSelector:aSelector];
    return  [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}
// /////////////////////第三步/////////////////////
- (void)forwardInvocation:(NSInvocation *)anInvocation {
     /**具体转发 随意*/
    if (arc4random()%2) {
        anInvocation.target = self.testView;
        [anInvocation invoke];
    }else{
        anInvocation.target = self.testButton;
        [anInvocation invoke];
    }
}
@end
