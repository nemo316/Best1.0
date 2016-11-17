//
//  XMGTopic.h
//  BuDeJie
//
//  Created by nemo on 16/3/22.
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
@end
