//
//  WXHSubTagTableViewController.m
//  Best1.0
//
//  Created by 初七 on 2016/11/2.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHSubTagTableViewController.h"
#import "WXHHttpTool.h"
#import <MJExtension.h>
#import "WXHSubTagItem.h"
#import "WXHSubTagTableViewCell.h"
#import <SVProgressHUD.h>
static NSString *const ID = @"subTag";
@interface WXHSubTagTableViewController ()
/** 数据模型数组*/
@property(nonatomic,strong) NSArray *items;

@property (nonatomic, weak) AFHTTPSessionManager *mgr;
@end

@implementation WXHSubTagTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //设置导航栏标题
    self.title = @"推荐标签";
    
    //加载数据
    [self loadData];
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXHSubTagTableViewCell class]) bundle:nil] forCellReuseIdentifier:ID];
    //设置分割线
    // 处理cell分割线 1.自定义分割线 2.系统属性(iOS8才支持) 3.万能方式(重写cell的setFrame) 了解tableView底层实现了解 1.取消系统自带分割线 2.把tableView背景色设置为分割线的背景色 3.重写setFrame
    /*
     设置全段分割线的两种方法:
     1. self.layoutMargins = UIEdgeInsetsZero; cell中调用
       清空tableView分割线内边距 清空cell的约束边缘
     self.tableView.separatorInset = UIEdgeInsetsZero;
     iOS9.0才可以用
     2. 如上
     */
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 220 220 221
    self.tableView.backgroundColor = WXHColor(220, 220, 221);
    
    //提示当前用户正在加载数据
    [SVProgressHUD showWithStatus:@"正在加载ing..."];

}

#pragma mark - 加载数据
-(void)loadData{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"c"] = @"topic";
    params[@"actio"] = @"sub";
    
    self.mgr = [WXHHttpTool get:@"http://api.budejie.com/api/api_open.php" params:params success:^(NSArray * responseObj) {
        
        //隐藏指示器
        [SVProgressHUD dismiss];
        self.items = [WXHSubTagItem mj_objectArrayWithKeyValuesArray:responseObj];
        //刷新表格
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        WXHLOG(@"%@",error);
        //隐藏指示器
        [SVProgressHUD dismiss];
    }];


}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    WXHSubTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WXHSubTagItem *item = self.items[indexPath.row];
    cell.item = item;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 界面将要消失的时候调用
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //销毁指示器
    [SVProgressHUD dismiss];
    //取消之前的请求
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];

}
@end
