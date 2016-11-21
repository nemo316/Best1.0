

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
typedef void (^DownloadSuccessBlock) (SDImageCacheType cacheType, UIImage *image);
typedef void (^DownloadFailureBlock) (NSError *error);
typedef void (^DownloadProgressBlock) (CGFloat progress);
@interface UIImageView (load)
/**
 *  加载网络图片
 *
 *  @param url 图片链接
 */
-(void)wxh_loadImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;


/**
 *  SDWebImage 下载并缓存图片和下载进度
 *
 *  @param url 图片的url
 *
 *  @param place 还未下载成功时的替换图片
 *
 *  @param success 图片下载成功
 *
 *  @param failure 图片下载失败
 *
 *  @param progress 图片下载进度
 */
- (void)wxh_loadImageWithURL:(NSString *)url
                placeholder:(UIImage *)placeholder
              success:(DownloadSuccessBlock)success
              failure:(DownloadFailureBlock)failure
             received:(DownloadProgressBlock)progress;


/**
 *  不同网络连接下设置图片
 *
 *  @param originalImageURL  大图
 *  @param thumbnailImageURL 小图
 *  @param placeholder       占位图
 */
- (void)wxh_setOriginalImageWithURL:(NSString *)originalImageURL thumbnailImageWithURL:(NSString *)thumbnailImageURL placehoder:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completionBlock;
/**
 *  不同网络连接下设置图片(带进度)
 *
 *  @param originalImageURL  大图
 *  @param thumbnailImageURL 小图
 *  @param placeholder       占位图
 *  @param progressBlock     进度
 *  @param completionBlock   
 */
-(void)wxh_setOriginalImageWithURL:(NSString *)originalImageURL thumbnailImageWithURL:(NSString *)thumbnailImageURL placehoder:(UIImage *)placeholder progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completionBlock;
/**
 *  设置头像
 *
 *  @param headerUrl 头像url
 */
- (void)wxh_setHeader:(NSString *)headerUrl;
@end
