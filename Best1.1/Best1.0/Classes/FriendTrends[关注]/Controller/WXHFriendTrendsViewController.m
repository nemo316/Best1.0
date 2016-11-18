//
//  WXHFriendTrendsViewController.m
//  Best1.0
//
//  Created by 初七 on 2016/11/1.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHFriendTrendsViewController.h"
#import "WXHLogRegistViewController.h"
#import "WXHRecommendViewController.h"
@interface WXHFriendTrendsViewController ()

@end

@implementation WXHFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题
    self.navigationItem.title = @"我的关注";
    [self setupNavBar];
}

#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 左边按钮
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(friendsRecommentAction)];
    
    // titleView
    self.navigationItem.title = @"我的关注";
    
}

// 推荐关注
- (void)friendsRecommentAction
{
    WXHRecommendViewController *recommend = [[WXHRecommendViewController alloc] init];
    [self.navigationController pushViewController:recommend animated:YES];
}
#pragma mark - 登录注册
- (IBAction)logAndRegistAction:(UIButton *)sender {
    WXHLogRegistViewController *logRes = [[WXHLogRegistViewController alloc] init];
    [self presentViewController:logRes animated:YES completion:nil
     ];
}


@end
