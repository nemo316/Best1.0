//
//  WXHCatagoryCell.m
//  Best1.0
//
//  Created by 初七 on 2016/11/17.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHCategoryCell.h"
#import "WXHCategory.h"
@interface WXHCategoryCell()
@property (weak, nonatomic) IBOutlet UIView *indicatorView;

@end

@implementation WXHCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = WXHGrayColor(244);
    self.indicatorView.backgroundColor = WXHColor(219, 21, 26);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    // 重新调整内部textLabel的frame
    self.textLabel.wxh_y = 2;
    self.textLabel.wxh_height = self.contentView.wxh_height - 2*self.textLabel.wxh_y;
    
}
#pragma mark - 监听cell的选中和取消选中
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.indicatorView.hidden = !selected;
    self.textLabel.textColor = selected ? self.indicatorView.backgroundColor : WXHGrayColor(78);
}
-(void)setCategory:(WXHCategory *)category{

    _category = category;
    self.textLabel.text = category.name;
}
@end
