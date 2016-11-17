
#import "WXHSaveTool.h"

@implementation WXHSaveTool
#pragma mark - 封装获取value
+(id)objectForKey:(NSString *)defaultName{

    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}
#pragma mark - 封装保存value
+(void)setObject:(id)value forKey:(NSString *)defaultName{

    //偏好设置key不能为空
    if (defaultName) {
        //保存当前version
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
        //立即执行
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}
@end
