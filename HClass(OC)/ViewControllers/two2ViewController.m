//
//  two2ViewController.m
//  HClass(OC)
//
//  Created by 朱子豪 on 16/4/6.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

#import "two2ViewController.h"
#import "HClassDocument.h"
@interface two2ViewController()
@property(nonatomic,strong)UITextView *textView;
@end
@implementation two2ViewController
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
    [HClassDocument scanInstanceMethod:self.clazz _super:NO option:^(NSDictionary<NSString *,NSArray<NSString *> *> *dictionary) {
        [dataArray addObject:dictionary];
    }];
    
    NSString *content = [NSString stringWithFormat:@"%@",dataArray];
    self.textView.text = content;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@":" options:0 error:nil];
    NSArray<NSTextCheckingResult *> *array =[regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString  alloc]initWithString:content];
    for (NSTextCheckingResult *result in array) {
        NSRange range = result.range;
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:19] range:range];
    }
    
    self.textView.attributedText = attStr;
}
@end
