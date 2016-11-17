//
//  WXHNewViewController.m
//  Best1.0
//
//  Created by 初七 on 2016/11/1.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHNewViewController.h"
#import "WXHSubTagTableViewController.h"
@interface WXHNewViewController ()

@end

@implementation WXHNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blueColor];
    [self setupNavBar];
}
#pragma mark - 设置导航条
- (void)setupNavBar
{
    
    // 左边按钮
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(tagClickAction)];
    
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
}

#pragma mark - 点击订阅标签调用
- (void)tagClickAction
{
    WXHSubTagTableViewController *subTagVC = [[WXHSubTagTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:subTagVC animated:YES];
}



@end
