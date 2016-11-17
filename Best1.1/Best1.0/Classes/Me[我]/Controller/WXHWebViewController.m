//
//  WXHWebViewController.m
//  Best1.0
//
//  Created by 初七 on 2016/11/6.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "WXHWebViewController.h"
#import <WebKit/WebKit.h>
@interface WXHWebViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshItem;
@property(nonatomic,weak)  WKWebView *web;

@end

@implementation WXHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建WKWebView
    [self setupWKWeb];
}

-(void)setupWKWeb{

    WKWebView *web = [[WKWebView alloc] init];
    [self.contentView addSubview:web];
    self.web = web;
    // 加载
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [web loadRequest:request];
    // KVO
    
    [web addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [web addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    [web addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [web addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    self.backItem.enabled = self.web.canGoBack;
    self.goItem.enabled = self.web.canGoForward;
    self.title = self.web.title;
    self.progressView.progress = self.web.estimatedProgress;
    WXHLOG(@"====%f",self.progressView.progress);
    self.progressView.hidden = (self.web.estimatedProgress == 1);
    
}
- (IBAction)backAction:(UIBarButtonItem *)sender {
    [self.web goBack];
}
- (IBAction)goAction:(UIBarButtonItem *)sender {
    [self.web goForward];
}

- (IBAction)refreshAction:(UIBarButtonItem *)sender {
    [self.web reload];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.web.frame = self.contentView.bounds;

}
-(void)dealloc{

    [self.web removeObserver:self forKeyPath:@"canGoBack"];
    [self.web removeObserver:self forKeyPath:@"title"];
    [self.web removeObserver:self forKeyPath:@"canGoForward"];
    [self.web removeObserver:self forKeyPath:@"estimatedProgress"];

}
@end
