

#import <UIKit/UIKit.h>

@interface UIImage (WXHExtension)
/**
 *  图片伸缩
 *
 *  @param name
 *
 *  @return
 */
+(instancetype)wxh_imageWithStretch:(NSString *)name;
/**
 *  保持图片不渲染
 *
 *  @param imageName
 *
 *  @return
 */
+(instancetype)wxh_imageOriginalWithName:(NSString *)imageName;
/**
 *  裁剪图片
 *
 *  @return
 */
-(instancetype)wxh_imageClips;
/**
 返回一张裁剪图片
 
 @param imageName
 @return
 */
+(instancetype)wxh_imageClipsWithImage:(NSString *)image;


@end
