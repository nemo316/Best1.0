

#import "UIImageView+load.h"
#import "UIImage+WXHExtension.h"
#import <AFNetworkReachabilityManager.h>
#import <UIImageView+WebCache.h>
@implementation UIImageView (load)

#pragma mark - 加载网络图片
-(void)wxh_loadImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder{
    
    // 使用SDWebImage缓存
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}

#pragma mark - 加载网络图片(带进度)
- (void)wxh_loadImageWithURL:(NSString *)url placeholder:(NSString *)placeholder success:(DownloadSuccessBlock)success failure:(DownloadFailureBlock)failure received:(DownloadProgressBlock)progress{
    
    //    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage wxh_imageClipsWithImage:placeholder] options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageCacheMemoryOnly |    SDWebImageProgressiveDownload | SDWebImageRefreshCached | SDWebImageContinueInBackground | SDWebImageHandleCookies | SDWebImageAllowInvalidSSLCertificates | SDWebImageHighPriority | SDWebImageDelayPlaceholder | SDWebImageTransformAnimatedImage | SDWebImageAvoidAutoSetImage | SDWebImageScaleDownLargeImages progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    //        progress((float)receivedSize/expectedSize);
    //    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    //        if (error) {
    //            failure(error);
    //        }else{
    //            // 如果下载失败,直接返回
    //            if (image == nil) return;
    //            // image是下载好的图片
    //            self.image = image;
    //            success(cacheType, image);
    //        }
    //
    //    }];
    
}

#pragma mark - 不同网络下设置图片
-(void)wxh_setOriginalImageWithURL:(NSString *)originalImageURL thumbnailImageWithURL:(NSString *)thumbnailImageURL placehoder:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completionBlock{
    
    // 根据网络状态来加载图片
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 获得原图（SDWebImage的图片缓存是用图片的url字符串作为key）
    UIImage *originImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originalImageURL];
    if (originImage) { // 原图已经被下载过
        [self sd_setImageWithURL:[NSURL URLWithString:originalImageURL] placeholderImage:placeholder completed:completionBlock];
        
    } else { // 原图并未下载过
        if (mgr.isReachableViaWiFi) {
            [self sd_setImageWithURL:[NSURL URLWithString:originalImageURL] placeholderImage:placeholder completed:completionBlock];
            
        } else if (mgr.isReachableViaWWAN) {
#warning downloadOriginImageWhen3GOr4G配置项的值需要从沙盒里面获取
            // 3G\4G网络下时候要下载原图
            BOOL downloadOriginImageWhen3GOr4G = YES;
            if (downloadOriginImageWhen3GOr4G) {
                [self sd_setImageWithURL:[NSURL URLWithString:originalImageURL] placeholderImage:placeholder completed:completionBlock];
            } else {
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholder completed:completionBlock];
                
            }
        } else { // 没有可用网络
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageURL];
            if (thumbnailImage) { // 缩略图已经被下载过
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholder completed:completionBlock];            } else { // 没有下载过任何图片
                    // 占位图片;
                    [self sd_setImageWithURL:nil placeholderImage:placeholder completed:completionBlock];
                }
            
        }
    }
    
}
#pragma mark - 不同网络下设置图片(带进度)
-(void)wxh_setOriginalImageWithURL:(NSString *)originalImageURL thumbnailImageWithURL:(NSString *)thumbnailImageURL placehoder:(UIImage *)placeholder progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completionBlock{
    
    // 根据网络状态来加载图片
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 获得原图（SDWebImage的图片缓存是用图片的url字符串作为key）
    UIImage *originImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originalImageURL];
    if (originImage) { // 原图已经被下载过
        [self sd_setImageWithURL:[NSURL URLWithString:originalImageURL] placeholderImage:placeholder completed:completionBlock];
        
    } else { // 原图并未下载过
        if (mgr.isReachableViaWiFi) {
            [self sd_setImageWithURL:[NSURL URLWithString:originalImageURL] placeholderImage:placeholder options:0 progress:progressBlock completed:completionBlock];
            
        } else if (mgr.isReachableViaWWAN) {
#warning downloadOriginImageWhen3GOr4G配置项的值需要从沙盒里面获取
            // 3G\4G网络下时候要下载原图
            BOOL downloadOriginImageWhen3GOr4G = YES;
            if (downloadOriginImageWhen3GOr4G) {
                [self sd_setImageWithURL:[NSURL URLWithString:originalImageURL] placeholderImage:placeholder options:0 progress:progressBlock completed:completionBlock];
            } else {
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholder options:0 progress:progressBlock completed:completionBlock];
            }
        } else { // 没有可用网络
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageURL];
            if (thumbnailImage) { // 缩略图已经被下载过
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholder completed:completionBlock];            } else { // 没有下载过任何图片
                    // 占位图片;
                    [self sd_setImageWithURL:nil placeholderImage:placeholder options:0 progress:progressBlock completed:completionBlock];
                }
            
        }
    }
    
}

#pragma mark - 设置头像
- (void)wxh_setHeader:(NSString *)headerUrl
{
    UIImage *placeholder = [UIImage wxh_imageClipsWithImage:@"defaultUserIcon"];
    [self sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 图片下载失败，直接返回，按照它的默认做法
        if (!image) return;
        
        self.image = [image wxh_imageClips];
        
    }];
    
    //    [self sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}
@end
