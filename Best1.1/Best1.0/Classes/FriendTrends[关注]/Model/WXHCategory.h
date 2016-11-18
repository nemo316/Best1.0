//
//  WXHCatagory.h
//  Best1.0
//
//  Created by 初七 on 2016/11/18.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXHCategory : NSObject
/** id */
@property (nonatomic, assign) NSInteger id;
/** 总数 */
@property (nonatomic, assign) NSInteger count;
/** 名字 */
@property (nonatomic, copy) NSString *name;

/** 这个类别对应的用户数据 */
@property (nonatomic, strong) NSMutableArray *subCategories;
/** 总数 */
@property (nonatomic, assign) NSInteger total;
/** 当前页码 */
@property (nonatomic, assign) NSInteger currentPage;
@end
