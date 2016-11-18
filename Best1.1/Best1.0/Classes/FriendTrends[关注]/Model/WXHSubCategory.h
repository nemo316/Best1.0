//
//  WXHSubCategory.h
//  Best1.0
//
//  Created by 初七 on 2016/11/18.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXHSubCategory : NSObject
/** 头像 */
@property (nonatomic, copy) NSString *header;
/** 粉丝数(有多少人关注这个用户) */
@property (nonatomic, assign) NSInteger fans_count;
/** 昵称 */
@property (nonatomic, copy) NSString *screen_name;
@end
