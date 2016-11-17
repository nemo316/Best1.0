

#import <UIKit/UIKit.h>

@interface WXHWYViewController : UIViewController
/** 是否添加下划线*/
@property(nonatomic,assign) BOOL isAddUnderLine;
/** 是否标题字体大小渐变*/
@property(nonatomic,assign) BOOL isTitleFontGrad;
/** 标题原本颜色*/
@property(nonatomic,strong) UIColor *titleOriginalColor;
/** 标题变后颜色*/
@property(nonatomic,strong) UIColor *titleChangedColor;
/** 标题字体大小*/
@property(nonatomic,strong) UIFont *titleFont;
/** TitleScroolViewBgColor*/
@property(nonatomic,strong) UIColor *TitleScroolViewBgColor;

@end
