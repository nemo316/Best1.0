//
//  WXHSettingTableViewController.m
//  Best1.0
//
//  Created by 初七 on 2016/11/7.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHSettingTableViewController.h"
#import "WXHFileTool.h"
#import <SVProgressHUD.h>
#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
@interface WXHSettingTableViewController ()
/** 缓存大小*/
@property(nonatomic,assign) NSInteger cacheSize;
@end
static NSString *const ID = @"setting";
@implementation WXHSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [SVProgressHUD showWithStatus:@"正在飞速计算内存..."];
    //获取缓存大小
    [WXHFileTool getFileSize:CachePath completion:^(NSInteger totalSize) {
        self.cacheSize = totalSize;
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    }];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //处理缓存大小
    NSString *cacheSize = [self resolveCacheSize];
    cell.textLabel.text = cacheSize;
    return cell;

}
#pragma mark - 处理缓存大小
-(NSString *)resolveCacheSize{

    NSInteger cacheSize = self.cacheSize;
    NSString *cacheSizeStr = @"清理缓存";
    if (cacheSize > 1000 * 1000) {
        //MB
        cacheSizeStr = [NSString stringWithFormat:@"%@(%.1fMB)",cacheSizeStr,cacheSize / 1000.0 / 1000.0];
    }else if (cacheSize > 1000){
        //KB
        cacheSizeStr = [NSString stringWithFormat:@"%@(%.1fKB)",cacheSizeStr,cacheSize / 1000.0];
    }else if(cacheSize > 0){
        //B
        cacheSizeStr = [NSString stringWithFormat:@"%@(%ldKB)",cacheSizeStr,cacheSize];
    }
    return cacheSizeStr;
}
#pragma mark - 点击清理缓存
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [WXHFileTool removeDirectoryPath:CachePath];
    self.cacheSize = 0;
    [self.tableView reloadData];
    
}
@end
