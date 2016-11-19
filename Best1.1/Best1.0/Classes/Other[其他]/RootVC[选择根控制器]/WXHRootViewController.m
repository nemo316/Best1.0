

#import "WXHRootViewController.h"
#import "WXHMainTabBarController.h"
#import "WXHNewFeatureViewController.h"
#import "WXHSaveTool.h"
#import "WXHAddViewController.h"
@interface WXHRootViewController ()

@end

@implementation WXHRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
#define WXHVersion @"version"
+(UIViewController *)chooseRootVC{

    //取出当前version
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    //取出上一个version
    NSString *oldVersion = [WXHSaveTool objectForKey:WXHVersion];
    UIViewController *vC;
    if ([currentVersion isEqualToString:oldVersion]) {
        vC = [[WXHAddViewController alloc] init];
    }else{
        // 推送引导
        vC = [[WXHNewFeatureViewController alloc] init];
        
        //保存当前version
        [WXHSaveTool setObject:currentVersion forKey:WXHVersion];
    }
    return vC;
}

@end
