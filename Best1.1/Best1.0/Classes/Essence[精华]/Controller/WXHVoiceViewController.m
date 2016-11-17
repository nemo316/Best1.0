//
//  XMGVoiceViewController.m
//  BuDeJie
//
//  Created by xiaomage on 16/3/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "WXHVoiceViewController.h"

@interface WXHVoiceViewController ()

@end

@implementation WXHVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark - 重写type的get方法
-(WXHTopicType)type{
    return WXHTopicTypeVoice;
}
@end
