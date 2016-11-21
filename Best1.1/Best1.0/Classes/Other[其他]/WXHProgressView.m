//
//  WXHProgressView.m
//  Best1.0
//
//  Created by 初七 on 2016/11/20.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHProgressView.h"

@implementation WXHProgressView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundRingWidth = 0;
    self.progressRingWidth = 10;
    self.showPercentage = YES;
    self.primaryColor = [UIColor whiteColor];
}

@end
