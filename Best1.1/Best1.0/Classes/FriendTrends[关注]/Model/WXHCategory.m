//
//  WXHCatagory.m
//  Best1.0
//
//  Created by 初七 on 2016/11/18.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHCategory.h"
@implementation WXHCategory
-(NSMutableArray *)subCategories{

    if (_subCategories == nil) {
        _subCategories = [NSMutableArray array];
    }
    return _subCategories;
}
@end
