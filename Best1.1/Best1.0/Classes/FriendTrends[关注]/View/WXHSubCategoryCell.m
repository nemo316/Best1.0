//
//  WXHSubCatagoryCell.m
//  Best1.0
//
//  Created by 初七 on 2016/11/17.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHSubCategoryCell.h"
#import "WXHSubCategory.h"
#import "UIImageView+load.h"

@interface WXHSubCategoryCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@end

@implementation WXHSubCategoryCell

-(void)setSubCategory:(WXHSubCategory *)subCategory{

    _subCategory = subCategory;
    
    self.screenNameLabel.text = subCategory.screen_name;
    NSString *fansCount = nil;
    if (subCategory.fans_count < 10000) {
        fansCount = [NSString stringWithFormat:@"%zd人关注",subCategory.fans_count];
    } else { // 大于等于10000
        fansCount = [NSString stringWithFormat:@"%.1f万人关注", subCategory.fans_count / 10000.0];
    }
    self.fansCountLabel.text = fansCount;
    [self.headerImageView wxh_loadImageWithURL:subCategory.header placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];

}


@end
