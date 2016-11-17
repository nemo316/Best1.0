//
//  WXHNavigationController.m
//  Best
//
//  Created by 初七 on 2016/11/1.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHMainNavigationController.h"

@interface WXHMainNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation WXHMainNavigationController
+(void)load{

    //设置导航栏特性
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [navBar setTitleTextAttributes:attr];
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置全屏返回手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    // 控制手势什么时候触发,只有非根控制器才需要触发手势
    pan.delegate = self;
    //禁止之前的手势
    self.interactivePopGestureRecognizer.enabled = NO;
}
#pragma mark - UIGestureRecognizerDelegate
// 决定是否触发手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    return self.childViewControllers.count > 1;

}
#pragma mark - 重写push方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.childViewControllers.count > 0) {
        //设置返回样式
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(backAction) title:@"返回"];
        //隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 真正在跳转
    [super pushViewController:viewController animated:animated];

}
-(void)backAction{
    [self popViewControllerAnimated:YES];
}



@end
