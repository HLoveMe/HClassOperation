//
//  HGMethod.m
//  ZZH_NSProxy
//
//  Created by 朱子豪 on 2016/11/28.
//  Copyright © 2016年 Space. All rights reserved.
//

#import "HGMethod.h"

@implementation HGMethod
-(NSMutableArray *)pars{
    if(_pars==nil){
        _pars = [NSMutableArray array];
    }
    return _pars;
}
@end
