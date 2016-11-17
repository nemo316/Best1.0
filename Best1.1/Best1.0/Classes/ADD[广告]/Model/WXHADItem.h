//
//  WXHADItem.h
//  Best1.0
//
//  Created by 初七 on 2016/11/2.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXHADItem : NSObject
/*
  w_picurl,ori_curl:跳转到广告界面,w,h
 */

/** 广告图片地址*/
@property(nonatomic,strong) NSString *w_picurl;
/** 广告跳转地址*/
@property(nonatomic,strong) NSString *ori_curl;
/** 广告图片宽*/
@property(nonatomic,assign) CGFloat w;
/** 广告图片高*/
@property(nonatomic,assign) CGFloat h;

@end
