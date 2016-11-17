

#import "WXHWYViewController.h"
/*
 1. 标题滚动视图
 
 2. 内容滚动视图
 
 3. 添加子控制器(由用户决定,所以在外面添加)
 
 4. 添加标题(需要在viewWillAppear定义)
 
 5. 点击标题
    5.1 选中标题
        标题字体大小,颜色
        标题居中
    5.2 添加子视图
    5.3 内容视图滚动到相应位置
 
 6. 滚动完内容视图,切换内容
 
 7. 滚动内容视图的时候,标题字体大小,颜色渐变
 */
@interface WXHWYViewController ()<UIScrollViewDelegate>
/** titleScrollView*/
@property(nonatomic,weak) UIScrollView *titleScrollView;
/** contentScrollView*/
@property(nonatomic,weak) UIScrollView *contentScrollView;
/** 存放标题按钮的数组*/
@property(nonatomic,strong) NSMutableArray *titleBtns;
/** selectBtn*/
@property(nonatomic,weak) UIButton *selectBtn;
/** 是否已添加所有标题的开关*/
@property(nonatomic,assign) BOOL isInitialize;
/** 下划线*/
@property(nonatomic,weak) UIView *underLine;
/** 移动时间*/
@property(nonatomic,assign) CGFloat duration;
/** 当前偏移量*/
@property(nonatomic,assign) CGFloat contentOffSetX;
/** 之前点击的标题按钮*/
@property(nonatomic,weak) UIButton *previousClickTitleBtn;
/** 视图滚动完毕后对应的索引*/
@property(nonatomic,assign) NSInteger endIndex;
@end

@implementation WXHWYViewController
-(NSMutableArray *)titleBtns{
    if (_titleBtns == nil) {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //内容滚动视图
    [self setupContentScrollView];
    
    //标题滚动视图
    [self setupTitleScroolView];
    //添加子控制器(由用户决定,所以在外面添加)
    
    //添加标题(需要在viewWillAppear定义)

}

#pragma mark - 标题滚动视图
-(void)setupTitleScroolView{

    UIScrollView *titleScrlloView = [[UIScrollView alloc] init];
    titleScrlloView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    //判断是否有导航栏
    CGFloat y = self.navigationController.navigationBarHidden ? 20 : 64;
    titleScrlloView.frame = CGRectMake(0, y, kWidth, 35);
    titleScrlloView.bounces = NO;
    titleScrlloView.showsHorizontalScrollIndicator = NO;
    //取消滚动到顶部
    titleScrlloView.scrollsToTop = NO;
    self.titleScrollView = titleScrlloView;
    [self.view addSubview:titleScrlloView];

}
#pragma mark - 内容滚动视图
-(void)setupContentScrollView{

    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.frame = CGRectMake(0, 0, kWidth, kHeight);
    contentScrollView.bounces = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.pagingEnabled = YES;
    //取消滚动到顶部
    contentScrollView.scrollsToTop = NO;
    self.contentScrollView = contentScrollView;
    contentScrollView.delegate = self;
    [self.view addSubview:contentScrollView];

}
#pragma mark - 添加标题
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.isInitialize == NO) {
        [self setupAllTitles];
        self.isInitialize = YES;
        //默认选中第一个
        UIButton *firstBtn = self.titleScrollView.subviews.firstObject;
        [firstBtn.titleLabel sizeToFit];
//        [self clickTitleAction:firstBtn];
        [self addOneChildController:firstBtn.tag];
        [self selectTitle:firstBtn];
        self.duration = 0.25;
    }
    
    
}
#pragma mark - 添加所有的标题
-(void)setupAllTitles{
    NSInteger count = self.childViewControllers.count;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = kWidth / count;
    CGFloat h = self.titleScrollView.bounds.size.height;
    for (int i = 0; i < count; i ++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        x = i * w;
        titleBtn.frame = CGRectMake(x, y, w, h);
        //设置标题
        UIViewController *vc = self.childViewControllers[i];
        [titleBtn setTitle:vc.title forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.titleOriginalColor forState:UIControlStateNormal];
        titleBtn.titleLabel.font = self.titleFont;
        [self.titleScrollView addSubview:titleBtn];
        titleBtn.tag = i;
        [self.titleBtns addObject:titleBtn];
        [titleBtn addTarget:self action:@selector(clickTitleAction:) forControlEvents:UIControlEventTouchUpInside];
//        //默认选中第一个
//        if (i == 0) {
//            [titleBtn.titleLabel sizeToFit];
//            [self clickTitleAction:titleBtn];
//            self.duration = 0.25;
//        }
    }
    //设置标题滚动视图的滚动范围
    self.titleScrollView.contentSize = CGSizeMake(w * count, 0);
    //设置内容滚动视图的滚动范围
    self.contentScrollView.contentSize = CGSizeMake(kWidth * count, 0);
    // 添加下划线
    if (self.isAddUnderLine) {
        [self addUnderLine];
    }

}
#pragma mark - 添加下划线
-(void)addUnderLine{
    
    UIView *underLine = [[UIView alloc] init];
    self.underLine = underLine;
    underLine.wxh_height = 1;
    underLine.wxh_y = self.titleScrollView.wxh_height - underLine.wxh_height;
    //设置下划线颜色跟按钮标题颜色相同
    underLine.backgroundColor = self.titleChangedColor;
    [self.titleScrollView addSubview:underLine];
}

#pragma  mark - 监听点击事件
-(void)clickTitleAction:(UIButton *)titleBtn{

    NSInteger index = titleBtn.tag;
    //添加子视图
    [self addOneChildController:index];
    
    //选中标题
    [self selectTitle:titleBtn];
    
    // 移动内容
    [self moveContentScrollow:index];
   
    // 重复点击标题刷新
    [self repeatClickToRefresh:titleBtn];
    
}
#pragma mark - 选中标题
-(void)selectTitle:(UIButton *)titleBtn{

    //标题字体大小,颜色
    if (self.isTitleFontGrad) {
        [self setTitleForm:titleBtn];
    }
    //标题居中
    [self setTitleCenter:titleBtn];
    //移动下划线
    [self moveUnderline:titleBtn];
    //点击状态栏滑到顶部(只有一个scrollView的scrollToTop为YES才可以)
    [self setScrollowToTop:titleBtn];
    self.previousClickTitleBtn = titleBtn;
}
#pragma mark - 标题字体大小,颜色
-(void)setTitleForm:(UIButton *)titleBtn{

    [_selectBtn setTitleColor:self.titleOriginalColor forState:UIControlStateNormal];
    _selectBtn.transform = CGAffineTransformIdentity;
    [titleBtn setTitleColor:self.titleChangedColor forState:UIControlStateNormal];
    titleBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.selectBtn = titleBtn;
}
#pragma mark - 标题居中
-(void)setTitleCenter:(UIButton *)titleBtn{

    CGFloat offsetX = titleBtn.center.x - kWidth * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    //最大偏移量
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - kWidth;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, self.titleScrollView.contentOffset.y) animated:YES];
}
#pragma mark - 移动下划线
-(void)moveUnderline:(UIButton *)titleBtn{

    [UIView animateWithDuration:self.duration animations:^{
        //下划线的长度等于字体的长度
        self.underLine.wxh_width = titleBtn.titleLabel.wxh_width + 10;
        //下划线的中点等于按钮的中点,必须先设置width再设置center
        self.underLine.wxh_centerX = titleBtn.wxh_centerX;

    }];
}
#pragma mark - 移动内容视图
-(void)moveContentScrollow:(NSInteger) index{
    //记录当前偏移量
    self.contentOffSetX = self.contentScrollView.wxh_width * index;
    // 移动scrollowView偏移量
    [UIView animateWithDuration:self.duration animations:^{
        self.contentScrollView.contentOffset = CGPointMake(self.contentScrollView.wxh_width * index, self.contentScrollView.contentOffset.y);
         }];
}
#pragma mark - 重复点击刷新
-(void)repeatClickToRefresh:(UIButton *)titleBtn{
    
    if (self.previousClickTitleBtn == titleBtn) {
        //发送通知已经重复点击
        [[NSNotificationCenter defaultCenter] postNotificationName:WXHTitleButtonDidRepeatNotification object:nil];
    }
 
}
#pragma mark - 点击状态栏滑到顶部
-(void)setScrollowToTop:(UIButton *)titleBtn{
    
//    NSInteger index = [self.titleScrollView.subviews indexOfObject:titleBtn];
    NSInteger index = titleBtn.tag;
    NSInteger count = self.childViewControllers.count;
    for (int i = 0; i < count; i ++) {
        UIViewController *vc = self.childViewControllers[i];
        if (![vc isViewLoaded]) continue;
        UIScrollView *scrollow = (UIScrollView *)vc.view;
        if ([scrollow isKindOfClass:[UIScrollView class]]) {
            scrollow.scrollsToTop = (i == index);
        }
    }

}
#pragma mark - 添加子视图
-(void)addOneChildController:(NSInteger)index{
    WXHLOG(@"%ld",index);
    UIViewController *childVC = self.childViewControllers[index];
    CGFloat x = index * self.contentScrollView.bounds.size.width;
    if (childVC.view.superview == nil) {
        
        CGFloat y = 0;
        CGFloat w = self.contentScrollView.bounds.size.width;
        CGFloat h = self.contentScrollView.bounds.size.height;
        childVC.view.frame = CGRectMake(x, y, w, h);
        [self.contentScrollView addSubview:childVC.view];
        
    }
    
}
#pragma mark - UIScrollViewDelegate
#pragma mark - 滚动完内容视图,切换内容
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / self.contentScrollView.wxh_width;
    self.endIndex = index;
    WXHLOG(@"-=-=-=%ld",index);
    UIButton *titleBtn = self.titleBtns[index];
    [self selectTitle:titleBtn];
    [self addOneChildController:index];
}
#pragma mark - 滚动内容视图的时候,标题字体大小,颜色渐变

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //大小渐变
    if (self.isTitleFontGrad) {
        //左边的按钮
        NSInteger leftIndex = scrollView.contentOffset.x / self.contentScrollView.bounds.size.width;
        UIButton *leftTitleBtn = self.titleBtns[leftIndex];
        //右边的按钮
        NSInteger rightIndex = leftIndex + 1;
        NSInteger count = self.titleBtns.count;
        if (rightIndex >= count) {
            rightIndex = count - 1;
        }
        UIButton *rightTitleBtn = self.titleBtns[rightIndex];
        
        // 0 ~ 1 => 1 ~ 1.3
        // 计算缩放比例
        CGFloat scaleR = scrollView.contentOffset.x / self.contentScrollView.bounds.size.width - leftIndex;
        CGFloat scaleL = 1- scaleR;
        //缩放
        rightTitleBtn.transform = CGAffineTransformMakeScale(scaleR * 0.2 + 1, scaleR * 0.2 + 1);
        leftTitleBtn.transform = CGAffineTransformMakeScale(scaleL * 0.2 + 1, scaleL * 0.2 + 1);
        //颜色渐变
        [rightTitleBtn setTitleColor:[UIColor colorWithRed:scaleR green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        [leftTitleBtn setTitleColor:[UIColor colorWithRed:scaleL green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    }
    // 判断是添加左视图还是右视图
    static NSInteger ScrollIndex;
    if (scrollView.contentOffset.x - self.contentOffSetX > 0) {
        ScrollIndex = self.contentScrollView.contentOffset.x / self.contentScrollView.wxh_width + 1;
//        NSInteger count = self.childViewControllers.count;
        ScrollIndex = ScrollIndex == (self.endIndex + 2) ? ScrollIndex - 1 : ScrollIndex;
        WXHLOG(@"-----%ld",ScrollIndex);
       
        [self addOneChildController:ScrollIndex];
    }else if(scrollView.contentOffset.x - self.contentOffSetX < 0){
        WXHLOG(@"%f",self.contentScrollView.contentOffset.x);
        WXHLOG(@"%f",self.contentScrollView.wxh_width);
        ScrollIndex = self.contentScrollView.contentOffset.x / self.contentScrollView.wxh_width;
//        ScrollIndex = ScrollIndex <= 0 ? 0 : ScrollIndex;
        WXHLOG(@"===%ld",ScrollIndex);
        [self addOneChildController:ScrollIndex];
    }
    
}
@end
