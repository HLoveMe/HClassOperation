//
//  ViewController.m
//  runtime2
//
//  Created by 朱子豪 on 16/4/5.
//  Copyright © 2016年 朱子豪. All rights reserved.
//


#import "ViewController.h"
#import "HGClass.h"
#import "oneViewController.h"
#import "twoViewController.h"
#import "thereViewController.h"
#import "fourViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)int age;
@end

@implementation ViewController
-(NSMutableArray *)dataArray{
    if (nil==_dataArray) {
        _dataArray=@[@"查看所有属性",@"查看所有方法",@"查看UIView的层级关系",@"对类的动态操作",@"错误流程 and NSProxy"].mutableCopy;
    }
    return _dataArray;
}
-(UITableView *)tableView{
    if (nil==_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"HClass";
    [self.view addSubview:self.tableView];
    
    [self startPropertyListenProName:@"age" withChange:^(id target) {
        
    }];
    self.age = 1;
    
    [self startMethodListen:@selector(ABCD:) befor:nil after:^{
        
    }];
    [self ABCD:@(100)];
    
}
-(void)ABCD:(NSNumber *)num{
    NSLog(@"=%@=",num);
}
#pragma -mark TableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *HID=@"HCell";
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
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[oneViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[twoViewController new] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[thereViewController new] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[fourViewController new] animated:YES];
            break;
        default:
            break;
    }

}

@end
