//
//  WXHTopicVoiceView.m
//  Best1.0
//
//  Created by 初七 on 2016/11/13.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHTopicVoiceView.h"
#import "WXHTopic.h"
#import "UIImageView+load.h"
@interface WXHTopicVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;
@end
@implementation WXHTopicVoiceView

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
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.voicetime / 60, topic.voicetime % 60];

}
@end
