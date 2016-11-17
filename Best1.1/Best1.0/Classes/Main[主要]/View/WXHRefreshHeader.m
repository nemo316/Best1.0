//
//  WXHRefreshHeader.m
//  Best1.0
//
//  Created by 初七 on 2016/11/16.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHRefreshHeader.h"

@implementation WXHRefreshHeader
-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self setSubviews];
    }
    return self;
}
-(void)setSubviews{

    // 自动切换透明度
    self.automaticallyChangeAlpha = YES;
    
}
@end
