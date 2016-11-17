//
//  WXHSquareCollectionViewCell.m
//  Best1.0
//
//  Created by 初七 on 2016/11/6.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHSquareCollectionViewCell.h"
#import "UIImageView+load.h"
#import "WXHSquareItem.h"
@interface WXHSquareCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *label;


@end
@implementation WXHSquareCollectionViewCell

-(void)setItem:(WXHSquareItem *)item{

    _item = item;
    [self.iconImgView wxh_loadImageWithURL:item.icon placeholderImage:nil];
    
    self.label.text = item.name;

}

@end
