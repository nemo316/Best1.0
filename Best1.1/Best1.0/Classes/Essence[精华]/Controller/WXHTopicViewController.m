//
//  XMGAllViewController.m
//  BuDeJie
//
//  Created by xiaomage on 16/3/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "WXHTopicViewController.h"
#import <MJRefresh.h>
#import "WXHHttpTool.h"
#import <MJExtension.h>
#import "WXHTopic.h"
#import <SVProgressHUD.h>
#import "WXHTopicCell.h"
#import <SDImageCache.h>
#import "WXHRefreshHeader.h"
@interface WXHTopicViewController ()
/** manager*/
@property(nonatomic,strong) AFHTTPSessionManager *manager;
/** 当前最后一条帖子数据的描述信息，专门用来加载下一页数据*/
@property(nonatomic,strong) NSString *maxtime;
/** 存储数据模型的数组*/
@property(nonatomic,strong) NSMutableArray<WXHTopic *> *topics;
@end
static NSString *const ID = @"all";
@implementation WXHTopicViewController
-(WXHTopicType)type {
    return 0;
}
-(NSMutableArray *)topics{
    
    if (_topics == nil) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}
-(AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    WXHLOG(@"%s",__func__);
    self.view.backgroundColor = WXHGrayColor(206);
    self.tableView.contentInset = UIEdgeInsetsMake(WXHNavBarMaxY + WXHTitlesViewH, 0, WXHTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXHTopicCell class]) bundle:nil] forCellReuseIdentifier:ID];
    // 接收tabBar发来的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarBtnRefreshAction) name:WXHTabBarButtonDidRepeatNotification object:nil];
    // 接收titleButton发来的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBtnRefreshAction) name:WXHTitleButtonDidRepeatNotification object:nil];
    // 添加刷新控件
    [self setupRefreshView];
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

#pragma mark - 添加刷新控件
-(void)setupRefreshView{
    
    // 广告条
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor blackColor];
    label.frame = CGRectMake(0, 0, 0, 30);
    label.textColor = [UIColor whiteColor];
    label.text = @"广告";
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = label;
    self.tableView.mj_header = [WXHRefreshHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    // 刷新
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}
#pragma mark - 刷新
-(void)tabBarBtnRefreshAction{
    
    // 只刷新当前tabBar对应的控制器
    if (self.view.window == nil) return;
    // 只刷新当前tabBar对应的显示的控制器
    if (self.tableView.scrollsToTop == NO) return;
    // 刷新
    [self.tableView.mj_header beginRefreshing];
    
}
-(void)titleBtnRefreshAction{
    
    // 只刷新当前tabBar对应的控制器
    if (self.view.window == nil) return;
    // 只刷新当前tabBar对应的显示的控制器
    if (self.tableView.scrollsToTop == NO) return;
    // 刷新
    [self.tableView.mj_header beginRefreshing];
    
}
#pragma mark - 加载新数据
-(void)loadNewData{
    
    // 取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 请求数据
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    self.manager = [WXHHttpTool get:WXHCommonURL params:parameters success:^(id responseObj) {
        WXHAFNWriteToPlist(hot)
        // 存储maxtime
        self.maxtime = responseObj[@"info"][@"maxtime"];
        // 字典数组转模型数组
        self.topics = [WXHTopic mj_objectArrayWithKeyValuesArray:responseObj[@"list"]];
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        if (error.code != NSURLErrorCancelled) {
            // 并非是取消任务导致的error，其他网络问题导致的error
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
    
}
#pragma mark - 加载更多数据
-(void)loadMoreData{
    
    // 取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    parameters[@"maxtime"] = self.maxtime;
    
    self.manager = [WXHHttpTool get:WXHCommonURL params:parameters success:^(id responseObj) {
        // 存储maxtime
        self.maxtime = responseObj[@"info"][@"maxtime"];
        // 字典数组转模型数组
        NSMutableArray *moreData = [WXHTopic mj_objectArrayWithKeyValuesArray:responseObj[@"list"]];
        // 累加到数组后面
        [self.topics addObjectsFromArray:moreData];
        [self.tableView reloadData];
        // 结束刷新
//        [self.tableView.mj_footer endRefreshing];
        if (self.topics.count >= 60) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        if (error.code != NSURLErrorCancelled) {
            // 并非是取消任务导致的error，其他网络问题导致的error
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXHTopic *topic = self.topics[indexPath.row];
    WXHTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.topic = topic;
    return cell;
}
#pragma mark - cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.topics[indexPath.row].cellHeight;
}
#pragma mark - 滚动清除缓存
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [[SDImageCache sharedImageCache] clearMemory];
}
@end
