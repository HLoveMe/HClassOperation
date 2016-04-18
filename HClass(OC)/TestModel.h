//
//  TestModel.h
//  HClass(OC)
//
//  Created by 朱子豪 on 16/4/7.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)int age;
@property(nonatomic,assign)double weight;
@property(nonatomic,strong)NSArray *friends;
@property(nonatomic,copy)NSString *NSRuss;
-(void)methodA;
-(void)methodB;
@end
