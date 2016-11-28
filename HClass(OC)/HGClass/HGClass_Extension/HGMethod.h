//
//  HGMethod.h
//  ZZH_NSProxy
//
//  Created by 朱子豪 on 2016/11/28.
//  Copyright © 2016年 Space. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^BeforMethod)(NSMutableArray *pars);
typedef void(^AfterMethod)();
@interface HGMethod : NSObject
//监听的sel
@property(nonatomic,assign)SEL asel;
@property(nonatomic,assign)BeforMethod before;
@property(nonatomic,assign)AfterMethod after;
//调用的参数
@property(nonatomic,strong)NSMutableArray *pars;
//调用结果
@property(nonatomic,strong)id result;

//交换之后的sel
@property(nonatomic,assign)SEL bsel;
//交换之前的方法签名
@property(nonatomic,strong)NSMethodSignature *trueSig;


@end
