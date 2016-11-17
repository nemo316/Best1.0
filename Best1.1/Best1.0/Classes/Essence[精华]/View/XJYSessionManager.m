//
//  XJYSessionManager.m//
//  Created by XJY on 16/10/17.
//  Copyright © 2016年 XinJinYing. All rights reserved.
//

#import "XJYSessionManager.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
static int const DEFAULT_REQUEST_TIME_OUT = 20;

@implementation XJYSessionManager


#pragma mark - 实例化Manager
static XJYSessionManager *shareInstance = nil;
+ (XJYSessionManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (shareInstance == nil) {
        shareInstance = [super allocWithZone:zone];
    }
    return shareInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化一些参数
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"application/x-javascript",@"text/plain",@"image/gif",nil];
        self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [[self requestSerializer] setTimeoutInterval:DEFAULT_REQUEST_TIME_OUT];
    }
    return self;
}

#pragma mark - 判断使用什么网络
+ (XJYSessionManager *)haveNetWork
{
    static NSString *const stringURL = @"https://www.baidu.com/";
    NSURL *baseURL = [NSURL URLWithString:stringURL];
    XJYSessionManager *manager = [[XJYSessionManager alloc] initWithBaseURL:baseURL];
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"WWAN");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"WiFi");
                [operationQueue setSuspended:NO];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"无网络");
                if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"亲，您没网啦" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:alertAction];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                    
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，您没网啦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                }
                
            }
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    //开始监控
//    [manager.reachabilityManager startMonitoring];
    return manager;
}



#pragma mark - 解析数据
+ (id)responseConfiguration:(id)responseObject
{
    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}


#pragma mark - GET
+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(XJYResponseSuccess)success fail:(XJYResponseFail)fail
{
    AFHTTPSessionManager *manager = [XJYSessionManager shareInstance];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id dic = [XJYSessionManager responseConfiguration:responseObject];
        success(task, dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task, error);
    }];
}


#pragma mark - POST
+ (void)POST:(NSString *)url params:(NSDictionary *)params success:(XJYResponseSuccess)success fail:(XJYResponseFail)fail
{
    AFHTTPSessionManager *manager = [XJYSessionManager shareInstance];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id dic = [XJYSessionManager responseConfiguration:responseObject];
        success(task, dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task, error);
    }];
}


#pragma mark - 上传
+ (void)uploadWithURL:(NSString *)url params:(NSDictionary *)params fileData:(NSData *)filedata name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(XJYProgress)progress success:(XJYResponseSuccess)success fail:(XJYResponseFail)fail
{
    AFHTTPSessionManager *manager = [XJYSessionManager shareInstance];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id  _Nonnull formData) {
        [formData appendPartWithFileData:filedata name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [XJYSessionManager responseConfiguration:responseObject];
        success(task, dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task, error);
    }];
}

#pragma mark - 下载
+ (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url savePathURL:(NSURL *)fileURL progress:(XJYProgress)progress success:(void (^)(NSURLResponse *, NSURL *))success fail:(void (^)(NSError *))fail
{
    AFHTTPSessionManager *manager = [XJYSessionManager shareInstance];
    
    NSURL *urlPath = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlPath];
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //下载后保存的路径
        return [fileURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            fail(error);
        } else {
            success(response, filePath);
        }
        
    }];
    
    [downLoadTask resume];
    return downLoadTask;
    
}
@end

