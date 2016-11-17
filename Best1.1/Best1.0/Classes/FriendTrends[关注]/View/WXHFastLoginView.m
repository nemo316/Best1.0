//
//  WXHFastLoginView.m
//  Best1.0
//
//  Created by 初七 on 2016/11/4.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHFastLoginView.h"

@implementation WXHFastLoginView

-(void)awakeFromNib{

    [super awakeFromNib];
    

}
#pragma mark - 创建快速登录视图
+(instancetype)fastLogView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end
