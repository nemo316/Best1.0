//
//  WXHTabBarViewController.m
//  Best
//
//  Created by 初七 on 2016/11/1.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHMainTabBarController.h"
#import "WXHMainNavigationController.h"
#import "WXHEssenceViewController.h"
#import "WXHNewViewController.h"
#import "WXHFriendTrendsViewController.h"
#import "WXHMeViewController.h"
#import "WXHTabBar.h"
@interface WXHMainTabBarController ()

@end

@implementation WXHMainTabBarController

+(void)load{

    //设置tabBar特性
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor blackColor];
    [tabBarItem setTitleTextAttributes:attr forState:UIControlStateSelected];
    //更改字体大小必须是normal状态
    NSMutableDictionary *attr2 = [NSMutableDictionary dictionary];
    attr2[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [tabBarItem setTitleTextAttributes:attr2 forState:UIControlStateNormal];
    

}


- (void)viewDidLoad {
    [super viewDidLoad];

    //设置自控制器
    [self setupOneChildViewController:[[WXHEssenceViewController alloc] init] norImgName:@"tabBar_essence_icon" selImgName:@"tabBar_essence_click_icon" title:@"精华"];
    [self setupOneChildViewController:[[WXHNewViewController alloc] init] norImgName:@"tabBar_new_icon" selImgName:@"tabBar_new_click_icon" title:@"新帖"];
    [self setupOneChildViewController:[[WXHFriendTrendsViewController alloc] init] norImgName:@"tabBar_friendTrends_icon" selImgName:@"tabBar_friendTrends_click_icon" title:@"关注"];
    
    [self setupOneChildViewController:[[UIStoryboard storyboardWithName:NSStringFromClass([WXHMeViewController class]) bundle:nil] instantiateInitialViewController] norImgName:@"tabBar_me_icon" selImgName:@"tabBar_me_click_icon" title:@"我"];
    
    //更换tabBar
    [self setValue:[[WXHTabBar alloc] init] forKey:@"tabBar"];
    
}
#pragma mark - 设置子控制器
-(void)setupOneChildViewController:(UIViewController *)vc norImgName:(NSString *)norImgName selImgName:(NSString *)selImgName title:(NSString *)title{

    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:norImgName];
    vc.tabBarItem.selectedImage = [UIImage wxh_imageOriginalWithName:selImgName];
    
    WXHMainNavigationController *nav = [[WXHMainNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}


@end
