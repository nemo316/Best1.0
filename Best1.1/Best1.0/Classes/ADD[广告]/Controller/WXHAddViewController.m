//
//  WXHAddViewController.m
//  Best1.0
//
//  Created by 初七 on 2016/11/1.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHAddViewController.h"
#import "WXHHttpTool.h"
#import <MJExtension.h>
#import "WXHADItem.h"
#import "WXHMainTabBarController.h"
#import "UIImageView+load.h"
#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

@interface WXHAddViewController ()
/** 开机背景图*/
@property (weak, nonatomic) IBOutlet UIImageView *launchImgView;
/** 广告占位图*/
@property (weak, nonatomic) IBOutlet UIView *addContentView;
/** 跳转按钮*/
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;

/** 广告模型*/
@property(nonatomic,strong)  WXHADItem *adItem;
/** 广告页*/
@property(nonatomic,weak) UIImageView *adImgView;
/** 定时器*/
@property(nonatomic,weak)  NSTimer *timer;

@end

@implementation WXHAddViewController
-(UIImageView *)adImgView{

    if (_adImgView == nil) {
        UIImageView *adImgView = [[UIImageView alloc] init];
        [self.addContentView addSubview:adImgView];
        adImgView.userInteractionEnabled = YES;
        //设置点击跳转到广告页的手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToAD)];
        [adImgView addGestureRecognizer:tap];
        _adImgView = adImgView;
    }
    return _adImgView;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    //设置启动图片
    [self setupLaunchImg];
    //加载启动图片
    [self loadLaunchImgData];
    
    //跑秒
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimeAction) userInfo:nil repeats:YES];
}
#pragma mark - 跑秒
-(void)runTimeAction{
    static int time = 3;
    if (time == 0) {
        //跳转
        [self jumpAction:nil];
    }
    time--;
    //改变跳转显示时间
    [self.jumpBtn setTitle:[NSString stringWithFormat:@"跳转(%d)",time] forState:UIControlStateNormal];
}
#pragma mark - 跳转
- (IBAction)jumpAction:(UIButton *)sender {
    //跳转控制器
    [UIApplication sharedApplication].keyWindow.rootViewController = [[WXHMainTabBarController alloc] init];
    //销毁定时器
    [self.timer invalidate];
    
}
#pragma mark - 设置启动图片
-(void)setupLaunchImg{

    // 6p:LaunchImage-800-Portrait-736h@3x.png
    // 6:LaunchImage-800-667h@2x.png
    // 5:LaunchImage-568h@2x.png
    // 4s:LaunchImage@2x.png
    
    if (iPhone6P) {
        self.launchImgView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    }else if(iPhone6){
        self.launchImgView.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
        
    }else if(iPhone5){
        self.launchImgView.image = [UIImage imageNamed:@"LaunchImage-700-568h"];
        
    }else if (iPhone4){
        self.launchImgView.image = [UIImage imageNamed:@"LaunchImage-700"];
    }
}
#pragma mark - 加载启动图片数据
-(void)loadLaunchImgData{

    /*
     http://mobads.baidu.com/cpro/ui/mads.php?code2=phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam
     必选	类型及范围	说明
     unique	false	string	唯一编码
     demo	true	string	1,2,3 获取哪些类型的广告(1,2,3种类型)
     gpsy	false	string	gps坐标系的y值
     gettemp	false	int	一般为1
     uniquetime	false	string	唯一的时间标识
     gpsx	false	string	gps坐标系的x值
     entrytype	true	int	入口类型，返回显示在不同地方的广告，1为开屏广告，21为帖子流类型的广告
     ver1	false	string	1432886227 版本号
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"code2"] = code2;
    params[@"demo"] = @"2";
    params[@"entrytype"] = @(3);
    [WXHHttpTool get:@"http://mobads.baidu.com/cpro/ui/mads.php" params:params success:^(NSDictionary *responseObj) {
        NSDictionary *dict = [responseObj[@"ad"] firstObject];
        //字典转模型
        self.adItem = [WXHADItem mj_objectWithKeyValues:dict];
        //设置广告页尺寸
//        CGFloat h = kWidth / self.adItem.w * self.adItem.h;
        CGFloat h = 667;
        self.adImgView.frame = CGRectMake(0, 0, kWidth, h);
        //加载网络图片
        [self.adImgView wxh_loadImageWithURL:self.adItem.w_picurl placeholderImage:nil];
        
    } failure:^(NSError *error) {
        WXHLOG(@"%@",error);
    }];

}
#pragma mark - 点击跳转手势
-(void)jumpToAD{
    
    NSURL *url = [NSURL URLWithString:self.adItem.ori_curl];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
    
}



@end
