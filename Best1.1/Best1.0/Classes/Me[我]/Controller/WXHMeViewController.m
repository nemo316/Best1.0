//
//  WXHMeViewController.m
//  Best1.0
//
//  Created by 初七 on 2016/11/1.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHMeViewController.h"
#import "WXHHttpTool.h"
#import <MJExtension.h>
#import "WXHSquareItem.h"
#import "WXHSquareCollectionViewCell.h"
#import "WXHWebViewController.h"
#import "WXHSettingTableViewController.h"
NSInteger const cols = 4;
#define kItemWH self.view.wxh_width / cols
static NSString *const ID = @"square";
@interface WXHMeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
/** 模型数组*/
@property(nonatomic,strong) NSMutableArray *squareItems;
/** collectionView*/
@property(nonatomic,weak) UICollectionView *collectionView;
@end

@implementation WXHMeViewController
-(NSMutableArray *)squareItems{

    if (_squareItems == nil) {
        _squareItems = [NSMutableArray array];
    }
    return _squareItems;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏
    [self setupNavBar];
    
    // 设置底部分格
    [self setupFootView];
    
    // 加载数据
    [self loadData];
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WXHSquareCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    
    // 处理cell间距,默认tableView分组样式,有额外の头部和尾部间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);//默认39
    self.tableView.backgroundColor = WXHGrayColor(236);
    self.tableView.showsVerticalScrollIndicator = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:WXHTabBarButtonDidRepeatNotification object:nil];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 刷新
-(void)refreshAction{
    
    // 只刷新当前tabBar对应的控制器
    if (self.view.window == nil) return;
    WXHLOG(@"%s",__func__);
    
}

#pragma Mark - 设置导航栏
- (void)setupNavBar
{
    // 左边按钮
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    
    // 设置
    UIBarButtonItem *settingItem =  [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(settingAction)];
    
    // 夜间模型
    UIBarButtonItem *nightItem =  [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(nightAction:)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem,nightItem];
    
    // titleView
    self.navigationItem.title = @"我的";
    
}

- (void)nightAction:(UIButton *)button
{
    button.selected = !button.selected;
    
}

#pragma mark - 设置就会调用
- (void)settingAction
{
    // 跳转到设置界面
    WXHSettingTableViewController *settingVC = [[WXHSettingTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark - 设置底部分格
-(void)setupFootView{

    // 流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //设置流水布局item尺寸及间距
    layout.itemSize = CGSizeMake(kItemWH, kItemWH);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = self.tableView.backgroundColor;
    collectionView.scrollEnabled = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.tableView.tableFooterView = collectionView;
}

#pragma mark - 加载数据
-(void)loadData{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"square";
    params[@"c"] = @"topic";
    [WXHHttpTool get:WXHRequestURL params:params success:^(id responseObj) {
        NSArray *array = responseObj[@"square_list"];
        //字典数组转模型数组
        self.squareItems = [WXHSquareItem mj_objectArrayWithKeyValuesArray:array];
        
        //处理数据(不足的补足)
        [self resolveData];
        
        // 设置collectionView 计算collectionView高度 = rows * itemWH
        // Rows = (count - 1) / cols + 1
        NSInteger count = self.squareItems.count;
        NSInteger rows = (count - 1) / cols + 1;
        self.collectionView.wxh_height = rows * kItemWH;
        self.tableView.tableFooterView = self.collectionView;
        //刷新表格
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark - 处理数据
-(void)resolveData{

    // 判断下缺几个
    // 3 % 4 = 3 cols - 3 = 1
    // 5 % 4 = 1 cols - 1 = 3
    NSInteger count = self.squareItems.count;
    NSInteger extra = count % cols;
    if (extra) {
        extra = cols - extra;
        for (int i = 0; i < extra; i++) {
            WXHSquareItem *item = [[WXHSquareItem alloc] init];
            [self.squareItems addObject:item];
        }
    }

}
#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.squareItems.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    WXHSquareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.item = self.squareItems[indexPath.item];
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    // 获取对应模型
    WXHSquareItem *item = self.squareItems[indexPath.item];
    // 判断是否跳转到网页
    if (![item.url containsString:@"http"]) return;
    // 跳转
    WXHWebViewController *webVC = [[WXHWebViewController alloc] init];
    webVC.url = [NSURL URLWithString:item.url];
    [self.navigationController pushViewController:webVC animated:YES];
}
@end
