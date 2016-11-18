//
//  WXHRecommendViewController.m
//  Best1.0
//
//  Created by 初七 on 2016/11/17.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHRecommendViewController.h"
#import <SVProgressHUD.h>
#import "WXHHttpTool.h"
#import "WXHCategoryCell.h"
#import "WXHSubCategoryCell.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WXHCategory.h"
#import "WXHSubCategory.h"
#import "WXHRefreshHeader.h"

// 左边选中的cell对应的模型
#define WXHSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]
@interface WXHRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *subCategoryTableView;
/** 左边的类别数据 */
@property (nonatomic, strong) NSArray *categories;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
/** AFN管理者*/
@property(nonatomic,strong) AFHTTPSessionManager *manager;
@end

static NSString *const categoryID = @"category";
static NSString *const subCategoryID = @"subCategory";
@implementation WXHRecommendViewController

-(AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView
    [self setupTableView];
    // 添加刷新控件
    [self setupRefreshView];
    // 加载左侧category数据
    [self loadCategories];
    
}
#pragma mark - 设置tableView
-(void)setupTableView{
    self.title = @"推荐关注";
    self.view.backgroundColor = WXHGrayColor(244);
    // 注册cell
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXHCategoryCell class]) bundle:nil] forCellReuseIdentifier:categoryID];
    [self.subCategoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXHSubCategoryCell class]) bundle:nil] forCellReuseIdentifier:subCategoryID];
    // 设置inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.subCategoryTableView.contentInset = self.categoryTableView.contentInset;
    
    self.subCategoryTableView.rowHeight = 70;

}
#pragma mark - 添加刷新控件
-(void)setupRefreshView{
    
    self.subCategoryTableView.mj_header = [WXHRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDate)];
    self.subCategoryTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDate)];
    self.subCategoryTableView.mj_footer.hidden = YES;

}
#pragma mark - 加载左侧category数据
-(void)loadCategories{
    [SVProgressHUD showWithStatus:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    self.manager = [WXHHttpTool get:WXHCommonURL params:params success:^(id responseObj) {
        [SVProgressHUD dismiss];
        self.categories = [WXHCategory mj_objectArrayWithKeyValuesArray:responseObj[@"list"]];
        WXHLOG(@"========%@",self.categories);
        // 刷新表格
        [self.categoryTableView reloadData];
        // 默认选中首行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        // 刷新
        [self.subCategoryTableView.mj_header beginRefreshing];
    } failure:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"加载失败"];
    }];
    
}
#pragma mark - 加载新数据
-(void)loadNewDate{
    
    WXHCategory *category = WXHSelectedCategory;
    // 当前页码为1
    category.currentPage = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.id);
    params[@"page"] = @(category.currentPage);
    self.params = params;
    // 发送请求给服务器, 加载右侧的数据
    self.manager = [WXHHttpTool get:WXHCommonURL params:params success:^(id responseObj) {
        category.subCategories = [WXHSubCategory mj_objectArrayWithKeyValuesArray:responseObj[@"list"]];
        // 获取总条数
        category.total = [responseObj[@"total"] integerValue];
        // 不是最后一次请求
        if(self.params != params) return;
        // 刷新右边的表格
        [self.subCategoryTableView reloadData];
        // 结束刷新
        [self.subCategoryTableView.mj_header endRefreshing];
        // 判断footer状态
        [self checkFooterState];
    } failure:^(NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        // 结束刷新
        [self.subCategoryTableView.mj_header endRefreshing];
    }];
    
    
}
#pragma mark - 加载更多数据
-(void)loadMoreDate{
    WXHCategory *category = WXHSelectedCategory;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.id);
    params[@"page"] = @(++category.currentPage);
    self.params = params;
    // 发送请求给服务器, 加载右侧的数据
    self.manager = [WXHHttpTool get:WXHCommonURL params:params success:^(id responseObj) {
        NSArray *array = [WXHSubCategory mj_objectArrayWithKeyValuesArray:responseObj[@"list"]];
        [category.subCategories addObjectsFromArray:array];
        // 不是最后一次请求
        if(self.params != params) return;
        // 刷新右边的表格
        [self.subCategoryTableView reloadData];
        // 结束刷新
        [self.subCategoryTableView.mj_header endRefreshing];
        // 判断footer状态
        [self checkFooterState];
    } failure:^(NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        // 结束刷新
        [self.subCategoryTableView.mj_header endRefreshing];
    }];
}
#pragma mark - 监测footer的状态
-(void)checkFooterState{

    WXHCategory *category = WXHSelectedCategory;
    self.subCategoryTableView.mj_footer.hidden = (category.subCategories.count == 0);
    // 判断底部控件结束刷新或全部加载完
    if (category.subCategories.count == category.total) {
        [self.subCategoryTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.subCategoryTableView.mj_footer endRefreshing];
    }
}
#pragma mark - <UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.categoryTableView) return self.categories.count;
    // 判断footer状态
    [self checkFooterState];
    return [WXHSelectedCategory subCategories].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {
        WXHCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryID];
        cell.category = self.categories[indexPath.row];
        return  cell;
    }else{
        WXHSubCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:subCategoryID];
        cell.subCategory = [WXHSelectedCategory subCategories][indexPath.row];
        return cell;
    }
}
#pragma mark - <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    // 结束上拉下拉
    [self.subCategoryTableView.mj_header endRefreshing];
    [self.subCategoryTableView.mj_footer endRefreshing];
    // 判断是否需要下拉刷新
    WXHCategory *category = WXHSelectedCategory;
    if (category.subCategories.count) {
        [self.subCategoryTableView reloadData];
    }else{
        // 刷新表格(为了展示给用户当前的操作)
        [self.subCategoryTableView reloadData];
        // 下拉刷新
        [self.subCategoryTableView.mj_header beginRefreshing];
    }

}
-(void)dealloc{

    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];

}
@end
