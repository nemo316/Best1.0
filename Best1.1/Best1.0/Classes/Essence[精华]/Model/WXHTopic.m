//
//  XMGTopic.h
//  BuDeJie
//
//  passTimed by nemo on 16/3/22.
//  Copyright © 2016年 初七. All rights reserved.
//

#import "WXHTopic.h"

@implementation WXHTopic
#pragma mark - 重写cellHeight的get方法
-(CGFloat)cellHeight{

    // 如果计算过了,直接返回
    if (_cellHeight) return _cellHeight;
    // 顶部高度
    _cellHeight += 55;
    // 中间高度
    _cellHeight += [self.text boundingRectWithSize:CGSizeMake(kWidth - 2 * WXHCommonMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + WXHCommonMargin;
    // 中间视图
    if (self.type != WXHTopicTypeWord) { // 不是文字,即视频 音频 图片
        CGFloat middleW = CGSizeMake(kWidth - 2 * WXHCommonMargin * 2, MAXFLOAT).width;
        CGFloat middleH = middleW * self.height / self.width;
        if (middleH >= kHeight) { // 显示的图片高度超过一个屏幕，就是超长图片
            middleH = 200;
            self.bigPicture = YES;
        }
        CGFloat middleX = WXHCommonMargin;
        CGFloat middleY = _cellHeight;
        self.frame = CGRectMake(middleX, middleY, middleW, middleH);
        _cellHeight += middleH + WXHCommonMargin;
    }
    
    // 最热评论高度
    if (self.top_cmt.count) {
        // 标题的高度
        _cellHeight += 20;
        NSDictionary *dict = self.top_cmt.firstObject;
        NSString *name = dict[@"user"][@"username"];
        NSString *comment = dict[@"comment"];
        if (comment.length == 0) { // 语音评论
            comment = @"语音评论";
        }
        NSString *hotStr = [NSString stringWithFormat:@"%@ : %@",name,comment];
        _cellHeight += [hotStr boundingRectWithSize:CGSizeMake(kWidth - 2 * WXHCommonMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height + WXHCommonMargin;
    }
    

    // 底部高度
    _cellHeight += 35 + WXHCommonMargin;
    return _cellHeight;
}

#pragma mark - 修改日期格式
-(NSString *)passtime{

    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *passTime = [fmt dateFromString:_passtime];
    
    if (passTime.isThisYear) { // 今年
        if (passTime.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:passTime];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (passTime.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:passTime];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:passTime];
        }
    } else { // 非今年
        return _passtime;
    }
}
@end
