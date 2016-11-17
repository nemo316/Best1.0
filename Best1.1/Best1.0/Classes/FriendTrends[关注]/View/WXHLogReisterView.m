//
//  WXHLogReisterView.m
//  Best1.0
//
//  Created by 初七 on 2016/11/4.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHLogReisterView.h"
#import "UIImage+WXHExtension.h"
@interface WXHLogReisterView()
/** 登录注册按钮*/
@property (weak, nonatomic) IBOutlet UIButton *logResBtn;

@end

@implementation WXHLogReisterView

-(void)awakeFromNib{
    [super awakeFromNib];
    //伸缩图片
    UIImage *img = self.logResBtn.currentBackgroundImage;
    [self.logResBtn setBackgroundImage:[img stretchableImageWithLeftCapWidth:img.size.width * 0.5 topCapHeight:img.size.height * 0.5] forState:UIControlStateNormal];
}

#pragma mark - 快速创建登录视图
+(instancetype)loginView{

    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
#pragma mark - 快速创建注册视图
+(instancetype)registerView{

    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
@end
