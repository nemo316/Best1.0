//
//  WXHSubTagTableViewCell.m
//  Best1.0
//
//  Created by 初七 on 2016/11/2.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHSubTagTableViewCell.h"
#import "WXHSubTagItem.h"
#import "UIImageView+load.h"
#import "UIImage+WXHExtension.h"
@interface WXHSubTagTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *tagImgView;
@property (weak, nonatomic) IBOutlet UILabel *tagNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagNumLabel;

@end

@implementation WXHSubTagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置头像圆角,iOS9苹果修复
//        _tagImgView.layer.cornerRadius = 30;
//        _tagImgView.layer.masksToBounds = YES;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    // 才是真正去给cell赋值
    [super setFrame:frame];
}

- (IBAction)subscribe:(UIButton *)sender {
    
}

-(void)setItem:(WXHSubTagItem *)item{
    _item = item;
    //设置名称
    self.tagNameLabel.text = item.theme_name;
    
    //设置关注人数
    [self setupNum];
    
    //设置图片
    [self.tagImgView wxh_setHeader:item.image_list];
}
#pragma mark - 设置关注人数
-(void)setupNum{
    NSInteger count = self.item.sub_number.integerValue;
    NSString *countStr = [NSString stringWithFormat:@"%ld人关注",count];
    if (count > 10000) {
        CGFloat countF = count / 10000.0;
        countStr = [NSString stringWithFormat:@"%.1f万人关注",countF];
        countStr = [countStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    self.tagNumLabel.text = countStr;

}

@end
