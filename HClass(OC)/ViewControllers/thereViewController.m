//
//  thereViewController.m
//  runtime2
//
//  Created by 朱子豪 on 16/4/6.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

#import "thereViewController.h"
#import "HClassDocument.h"
@implementation thereViewController
- (IBAction)look:(id)sender {
   NSString *content = [HClassDocument scanSubView:self.view frame:NO];
}

@end
