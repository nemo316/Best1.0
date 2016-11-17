//
//  WXHTopicViewController.h
//  Best1.0
//
//  Created by 初七 on 2016/11/16.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXHTopic.h"
@interface WXHTopicViewController : UITableViewController
/** 数据模型*/
@property(nonatomic,strong) WXHTopic *topic;

/**
 *  声明type的get方法
 *
 *  @return 
 */
-(WXHTopicType)type;
@end
