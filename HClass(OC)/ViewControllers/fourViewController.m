//
//  fourViewController.m
//  HClass(OC)
//
//  Created by 朱子豪 on 16/4/7.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

#import "fourViewController.h"
#import "TestModel.h"
#import "HClassExtension.h"
#import "UITableView+HTable.h"
@interface fourViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)HInvocation *invocation;



@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation fourViewController
-(NSMutableArray *)dataArray{
    if (nil==_dataArray) {
        _dataArray=[NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D", nil];
    }
    return _dataArray;
}
-(UITableView *)tableView{
    if (nil==_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,30,375)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
- (IBAction)insertMethod:(id)sender {
   self.invocation = [HClassExtension classAddInstanceMethod:[TestModel class] sel:@selector(XXOO) blockImpWithResult:^id(id _self, id info) {
        return [NSString stringWithFormat:@"%@ %@",info,@"china"];
    }];
}
- (IBAction)invokeMethod:(id)sender {
    TestModel *model = [[TestModel alloc] init];
     /**方式一*/
    id result1 = [model performSelector:@selector(XXOO) withObject:@"hellow "];
    NSLog(@"%@",result1);
//     /**方式二*/
//    [self.invocation invokeWithTarget:model Object:@"你好"];
//    id result2;
//    [self.invocation getReturnValue:&result2];
//    NSLog(@"%@",result2);
    
}

- (IBAction)insertProperty:(id)sender {
    [HClassExtension classAddProperty:[self class] proType:@"NSURL" type:TYPE_NC propertyName:@"baidu"];
     /**设置属性的值*/
    [self performSelector:@selector(setBaidu:) withObject:[NSURL URLWithString:@"http://www.baidu.com"]];
    
}
- (IBAction)testProperty:(id)sender {
    NSURL *url = [self performSelector:@selector(baidu)];
    [[UIApplication sharedApplication]openURL:url];
    NSLog(@"%@",url.absoluteString);
}
 /**交换实现*/
- (IBAction)exchangeIMP:(id)sender {
    [self.tableView removeFromSuperview];
    [self.view addSubview:self.tableView];
   
}
- (IBAction)testExchange:(id)sender {
    [HClassExtension classExchangeInstanceMethodIMP:[UITableView class] oneMethod:@selector(_reloadData)  otherMethod:@selector(reloadData)];
    [self.tableView reloadData];
}



#pragma clang diagnostic pop
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
    cell.textLabel.text = self.dataArray[indexPath.row];
    NSLog(@"%@",self.dataArray[indexPath.row]);
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
@end
