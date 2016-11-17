//
//  WXHTopicVideoView.m
//  Best1.0
//
//  Created by 初七 on 2016/11/13.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHTopicVideoView.h"
#import "WXHTopic.h"
#import "UIImageView+load.h"
@interface WXHTopicVideoView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;
@end
@implementation WXHTopicVideoView

-(void)awakeFromNib{
    [super awakeFromNib];
    // 关闭autoresizing
    self.autoresizingMask = UIViewAutoresizingNone;
}
-(void)setTopic:(WXHTopic *)topic{
    _topic = topic;
    
    self.placeholderImageView.hidden = NO;
    // 设置图片
    [self.imageView wxh_setOriginalImageWithURL:topic.image1 thumbnailImageWithURL:topic.image0 placehoder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        // 如果么有返回图片,直接return
        if (!image) return;
        self.placeholderImageView.hidden = YES;

    }];
    
    // 播放数量
    if (topic.playcount >= 10000) {
        self.playcountLabel.text = [NSString stringWithFormat:@"%.1f万播放", topic.playcount / 10000.0];
    } else {
        self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    }
    // %04d : 占据4位，多余的空位用0填补
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.videotime / 60, topic.videotime % 60];
    
}

@end
