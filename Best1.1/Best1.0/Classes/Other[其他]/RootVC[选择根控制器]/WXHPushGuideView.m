//
//  WXHPushGuideView.m
//  Best1.0
//
//  Created by 初七 on 2016/11/19.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHPushGuideView.h"
#import "WXHSaveTool.h"
#define WXHVersion @"pushGuideVersion"
@implementation WXHPushGuideView

+(instancetype)pushGuide{

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (IBAction)removeAction:(UIButton *)sender {
    [self removeFromSuperview];
}
#pragma mark - 推送展示
+(void)show{

    // 取出当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    // 取出之前的版本号
    NSString *oldVersion = [WXHSaveTool objectForKey:WXHVersion];
    if (![currentVersion isEqualToString:oldVersion]) {
        WXHPushGuideView *pushGuideView = [WXHPushGuideView pushGuide];
        pushGuideView.frame = [UIScreen mainScreen].bounds;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:pushGuideView];
        
        // 保存当前版本号
        [WXHSaveTool setObject:currentVersion forKey:WXHVersion];
    }

}
@end
