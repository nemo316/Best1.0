//
//  WXHFastLogButton.m
//  Best1.0
//
//  Created by 初七 on 2016/11/4.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHFastLogButton.h"

@implementation WXHFastLogButton

-(void)layoutSubviews{

    [super layoutSubviews];
    //设置图片文字frame
    self.imageView.wxh_y = 0;
    self.imageView.wxh_centerX = self.wxh_width * 0.5;
    
    self.titleLabel.wxh_y = CGRectGetMaxY(self.imageView.frame);
    [self.titleLabel sizeToFit];
    self.titleLabel.wxh_centerX = self.wxh_width * 0.5;
    


}
@end
