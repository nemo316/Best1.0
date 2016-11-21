//
//  WXHTabBar.m
//  Best1.0
//
//  Created by 初七 on 2016/11/1.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHTabBar.h"
#import "WXHPublishViewController.h"
@interface WXHTabBar()
/** pubBtn*/
@property(nonatomic,weak) UIButton *pubBtn;
/** 之前点击的tabBarButton*/
@property(nonatomic,weak) UIControl *previousClickTabBarBtn;
@end
@implementation WXHTabBar

-(instancetype)initWithFrame:(CGRect)frame{

    if ([super initWithFrame:frame]) {
        //添加发布按钮
        UIButton *pubBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [pubBtn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [pubBtn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [pubBtn sizeToFit];
        [self addSubview:pubBtn];
        [pubBtn addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
        self.pubBtn = pubBtn;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //设置所有tabBarItem的frame
    CGFloat width = self.wxh_width;
    CGFloat height = self.wxh_height;
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    CGFloat itemW = width / (self.items.count + 1);
    CGFloat itemH = height;
    NSInteger index = 0;
    for (UIView *tabBarBtn in self.subviews) {
        if ([tabBarBtn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            UIControl *clickBtn = (UIControl *)tabBarBtn;
            //赋值
            if (index == 0 && self.previousClickTabBarBtn == nil) {
                self.previousClickTabBarBtn = clickBtn;
            }
            itemX = (index > 1 ? (index + 1) : index) * itemW;
            tabBarBtn.frame = CGRectMake(itemX, itemY, itemW, itemH);
            index ++;
            
            //实现双击tabBarButton刷新
            [clickBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }
    //设置pubBtn的frame
    self.pubBtn.center = CGPointMake(width * 0.5, height * 0.5);

}
#pragma mark - 监听tabBarButton的点击
-(void)clickAction:(UIButton *)btn{

    if (self.previousClickTabBarBtn == btn) {
        //发送通知,点击了该tabBarButton
        [[NSNotificationCenter defaultCenter] postNotificationName:WXHTabBarButtonDidRepeatNotification object:nil];
    }
    self.previousClickTabBarBtn = btn;
}
#pragma mark - 监听发布按钮的点击
-(void)publishAction{
    WXHPublishViewController *pubVC = [[WXHPublishViewController alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pubVC animated:NO completion:nil];

}
@end
