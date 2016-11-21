//
//  NSDate+XMGExtension.h
//  
//
//  Created by nemo on 15/7/27.
//  Copyright (c) 2015年 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WXHExtension)
/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;
@end
