//
//  WXHTopicPictureView.m
//  Best1.0
//
//  Created by 初七 on 2016/11/13.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHTopicPictureView.h"
#import "WXHTopic.h"
#import "UIImageView+load.h"
#import "WXHSeeBigPictureViewController.h"
#import "WXHProgressView.h"
@interface WXHTopicPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;
@property (weak, nonatomic) IBOutlet WXHProgressView *progressView;

@end
@implementation WXHTopicPictureView

-(void)awakeFromNib{
    [super awakeFromNib];
    // 关闭autoresizing
    self.autoresizingMask = UIViewAutoresizingNone;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}
- (void)seeBigPicture
{
    WXHSeeBigPictureViewController *vc = [[WXHSeeBigPictureViewController alloc] init];
    vc.topic = self.topic;
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    
    //    [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void)setTopic:(WXHTopic *)topic{
    _topic = topic;
    
//    self.placeholderImageView.hidden = NO;
    // 立马显示最新的进度值(防止因为网速慢, 导致显示的是其他图片的下载进度)
    [self.progressView setProgress:topic.pictureProgress animated:NO];
    // 设置图片
    [self.imageView wxh_setOriginalImageWithURL:topic.image1 thumbnailImageWithURL:topic.image1 placehoder:nil progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        // 占位图进度
        topic.pictureProgress = receivedSize / expectedSize;
        [self.progressView setProgress:topic.pictureProgress animated:YES];
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.progressView.hidden = YES;
        // 如果么有返回图片,直接return
        if (!image) return;
        self.placeholderImageView.hidden = YES;
        // 处理大图
        if (topic.isBigPicture) {
            CGFloat imageW = topic.frame.size.width;
            CGFloat imageH = imageW * topic.height / topic.width;
            
            // 开启上下文
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            // 绘制图片到上下文中
            [self.imageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            // 取出
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            // 关闭上下文
            UIGraphicsEndImageContext();
        }

    }];
    
    // gif
    self.gifView.hidden = !topic.is_gif;
    // 点击查看大图
    if (topic.isBigPicture) {
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
        
    }else{
        self.seeBigPictureButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
}



@end
