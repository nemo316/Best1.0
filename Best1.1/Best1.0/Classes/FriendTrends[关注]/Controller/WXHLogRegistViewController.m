//
//  WXHLogRegistViewController.m
//  Best1.0
//
//  Created by 初七 on 2016/11/4.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHLogRegistViewController.h"
#import "WXHLogReisterView.h"
#import "WXHFastLoginView.h"
@interface WXHLogRegistViewController ()
/** 登录注册占位图*/
@property (weak, nonatomic) IBOutlet UIView *middleView;
/** 快速登录占位图*/
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/** middleLeading约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleLeadingConstraint;

@end

@implementation WXHLogRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建登录视图
    UIView *logView = [WXHLogReisterView loginView];
    [self.middleView addSubview:logView];
    
    //创建注册视图
    UIView *regView = [WXHLogReisterView registerView];
    [self.middleView addSubview:regView];
    
    //创建快速登录视图
    UIView *fastLogView = [WXHFastLoginView fastLogView];
    [self.bottomView addSubview:fastLogView];
}

#pragma mark - 关闭登录
- (IBAction)logCloseAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 注册/登录切换
- (IBAction)registerAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    //平移
    self.middleLeadingConstraint.constant = (self.middleLeadingConstraint.constant == 0) ? -self.middleView.wxh_width * 0.5 : 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];

    //设置尺寸
    WXHLogReisterView *logView= [self.middleView.subviews firstObject];
    logView.frame = CGRectMake(0, 0, self.middleView.wxh_width * 0.5, self.middleView.wxh_height * 0.5);
    
    WXHLogReisterView *resView = [self.middleView.subviews lastObject];
    resView.frame = CGRectMake(self.middleView.wxh_width * 0.5, 0, self.middleView.wxh_width * 0.5, self.middleView.wxh_height * 0.5);
    
    WXHFastLoginView *fastLogVIew = [self.bottomView.subviews firstObject];
    fastLogVIew.frame = CGRectMake(0, 0, self.bottomView.wxh_width, self.bottomView.wxh_height);
    

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];

}
@end
