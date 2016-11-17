//
//  WXHTintTextField.m
//  Best1.0
//
//  Created by 初七 on 2016/11/4.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHTintTextField.h"

@implementation WXHTintTextField

-(void)awakeFromNib{

    [super awakeFromNib];
    //设置光标颜色
    self.tintColor = [UIColor whiteColor];
    //设置占位字符默认颜色
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = [UIColor lightGrayColor];
    
    [self addTarget:self action:@selector(beginEdtingAction) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(endEdtingAction) forControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - 开始编辑
-(void)beginEdtingAction{

    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = [UIColor whiteColor];
}
#pragma mark - 结束编辑
-(void)endEdtingAction{
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = [UIColor lightGrayColor];

}
@end
