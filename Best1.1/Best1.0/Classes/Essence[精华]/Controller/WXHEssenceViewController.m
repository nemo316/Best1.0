//
//  WXHEssenceViewController.m
//  Best1.0
//
//  Created by 初七 on 2016/11/1.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHEssenceViewController.h"
#import "WXHAllViewController.h"
#import "WXHPictureViewController.h"
#import "WXHVideoViewController.h"
#import "WXHVoiceViewController.h"
#import "WXHWordViewController.h"
@interface WXHEssenceViewController ()

@end

@implementation WXHEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    // 设置导航条
    [self setupNavBar];
    
    // 添加自控制器
    [self addAllChildViewControllers];
    
    // 设置样式
    [self setupStytle];
    
}
#pragma mark - 设置导航条
- (void)setupNavBar
{
    
    // 左边按钮
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(gameAction)];
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:nil action:nil];
    
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
}
#pragma mark - 添加子控制器
-(void)addAllChildViewControllers{

    WXHAllViewController *all = [[WXHAllViewController alloc] initWithStyle:UITableViewStylePlain];
    all.title = @"全部";
    [self addChildViewController:all];
    WXHPictureViewController *pic = [[WXHPictureViewController alloc] initWithStyle:UITableViewStylePlain];
    pic.title = @"图片";
    [self addChildViewController:pic];
    WXHVideoViewController *video = [[WXHVideoViewController alloc] initWithStyle:UITableViewStylePlain];
    video.title = @"视频";
    [self addChildViewController:video];
    WXHVoiceViewController *voice = [[WXHVoiceViewController alloc] initWithStyle:UITableViewStylePlain];
    voice.title = @"声音";
    [self addChildViewController:voice];
    WXHWordViewController *word = [[WXHWordViewController alloc] initWithStyle:UITableViewStylePlain];
    word.title = @"段子";
    [self addChildViewController:word];
}
#pragma mark - 设置样式
-(void)setupStytle{

    self.isAddUnderLine = YES;
    self.isTitleFontGrad = YES;
    self.titleOriginalColor = [UIColor blackColor];
    self.titleChangedColor = [UIColor redColor];
    self.titleFont = [UIFont systemFontOfSize:14];
    self.TitleScroolViewBgColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

}
#pragma mark - 监听点击事件
- (void)gameAction
{
    
}

@end
