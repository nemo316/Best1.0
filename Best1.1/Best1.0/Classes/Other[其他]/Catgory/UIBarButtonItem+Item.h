

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)
// 快速创建UIBarButtonItem
/**
 *  不带标题,高亮
 *
 *  @param image
 *  @param highImage
 *  @param target
 *  @param action
 *
 *  @return
 */
+ (UIBarButtonItem *)itemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;

/**
 *  带标题,高亮
 *
 *  @param image
 *  @param highImage
 *  @param target
 *  @param action
 *  @param title
 *
 *  @return
 */
+ (UIBarButtonItem *)backItemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title;

/**
 *  不带标题,选中
 *
 *  @param image    
 *  @param selImage
 *  @param target
 *  @param action
 *
 *  @return
 */
+ (UIBarButtonItem *)itemWithimage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action;

@end
