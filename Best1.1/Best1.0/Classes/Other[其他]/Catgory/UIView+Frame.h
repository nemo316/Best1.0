

#import <UIKit/UIKit.h>
/*
 
    写分类:避免跟其他开发者产生冲突,加前缀
 
 */
@interface UIView (Frame)

@property CGFloat wxh_width;
@property CGFloat wxh_height;
@property CGFloat wxh_x;
@property CGFloat wxh_y;
@property CGFloat wxh_centerX;
@property CGFloat wxh_centerY;
//*****************快速从xib中创建view*********************
+(instancetype)viewFromXib;
@end
