

#import "UIImage+WXHExtension.h"
#import "UIImage+Antialias.h"
@implementation UIImage (WXHExtension)

#pragma mark - 图片伸缩
+(instancetype)wxh_imageWithStretch:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5f topCapHeight:image.size.height * 0.5f];
}

#pragma mark - 保持图片不渲染
+ (instancetype)wxh_imageOriginalWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}
#pragma mark - 裁剪图片
-(instancetype)wxh_imageClips{
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    //描述剪裁区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    //设置剪裁区域
    [path addClip];
    
    //画图片
    [self drawAtPoint:CGPointZero];
    
    //取出图片
    UIImage *currentImg = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    //去除锯齿化
    return [currentImg imageAntialias];


}
#pragma mark - 裁剪图片
+(instancetype)wxh_imageClipsWithImage:(NSString *)image{
    
    return [[self imageNamed:image] wxh_imageClips];
}

@end
