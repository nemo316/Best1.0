

#import <MBProgressHUD.h>

@interface MBProgressHUD (WXH)

/**
 显示成功信息+图片

 @param success
 @param view
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 显示错误信息+图片

 @param error
 @param view 
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
