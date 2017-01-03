//
//  ViewController.m
//  js-oc
//
//  Created by song ximing on 2016/12/29.
//  Copyright © 2016年 song ximing. All rights reserved.
//

#import "ViewController.h"
#import "WebViewJavascriptBridge.h"

@interface ViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) WebViewJavascriptBridge *birdge;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI {
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"html"];
    NSLog(@"--path--%@",path);
    NSString *htmlPath = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSURL *url = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:htmlPath baseURL:url];
    
    self.openBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 50)];
    self.openBtn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.openBtn];
    [self.openBtn addTarget:self action:@selector(openBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [WebViewJavascriptBridge enableLogging]; // 开启日志
    self.birdge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [self.birdge setWebViewDelegate:self];
    
    __weak typeof(self)weakSelf = self;
    [self.birdge registerHandler:@"getBlogNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) { // JS调OC 修改oc按钮颜色
        weakSelf.openBtn.backgroundColor = [UIColor redColor];
    }];
// 循环引用 控制器引用block block内部引用控制器
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openBtnClick:(UIButton *)btn { // oc->js  点击oc按钮 web页面改变,添加一个条目
    [self.birdge callHandler:@"openWebviewBridgeArticle" data:nil];
}

@end
