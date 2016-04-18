//
//  twoViewController.m
//  runtime2
//
//  Created by 朱子豪 on 16/4/6.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

#import "twoViewController.h"
#import "two2ViewController.h"
@interface twoViewController()
@property(nonatomic,strong)NSMutableArray *dataArray;
@end
@implementation twoViewController
-(NSMutableArray *)dataArray{
    if (nil==_dataArray) {
        _dataArray=@[@"UIView",@"UIViewController",@"UIButton",@"NSURL",@"NSObject",@"NSString",@"NSURLRequest",@"NSURLSession",@"HInvocation",@"NSRunLoop"].mutableCopy;
    }
    return _dataArray;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
}
#pragma -mark TableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *HID=@"H2Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:HID];
    if (nil==cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HID];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self tableView:self.tableView heightForRowAtIndexPath:indexPath])];
    lab.textAlignment =NSTextAlignmentCenter;
    lab.text = self.dataArray[indexPath.row];
    [cell.contentView addSubview:lab];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str  = self.dataArray[indexPath.row];
    two2ViewController *target = [two2ViewController new];
    target.clazz = NSClassFromString(str);
    [self.navigationController pushViewController:target animated:YES];
}
@end