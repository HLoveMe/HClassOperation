//
//  one2ViewController.m
//  runtime2
//
//  Created by 朱子豪 on 16/4/6.
//  Copyright © 2016年 朱子豪. All rights reserved.
//
#import "one2ViewController.h"
#import "HClassDocument.h"
@interface one2ViewController()
@property(nonatomic,strong)UITextView *textView;
@end
@implementation one2ViewController
-(UITextView *)textView{
    if (nil==_textView) {
        CGRect rect = [UIScreen mainScreen].bounds;
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, rect.size.width, rect.size.height-64)];
        _textView.editable = NO;
    }
    return _textView;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:[UIButton new]];
    [self.view addSubview:self.textView];
    self.title = NSStringFromClass(self.clazz);
    NSMutableArray *dataArray = [NSMutableArray array];
    
     /**得到所有属性*/
    [HClassDocument scanProperty:self.clazz _super:NO option:^(NSDictionary<NSString *,NSArray<NSString *> *> *dictionary) {
        [dataArray addObject:dictionary];
    }];
    self.textView.text = [NSString stringWithFormat:@"%@",dataArray];
}
@end
