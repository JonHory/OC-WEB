//
//  ViewController.m
//  OC-WEB
//
//  Created by rhcf_wujh on 16/7/5.
//  Copyright © 2016年 wjh. All rights reserved.
//

#import "ViewController.h"
#import "RHCFJsModel.h"
#import "NextViewController.h"

@interface ViewController ()<UIWebViewDelegate,RHCFWebDelegate>

@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) JSContext * context;

@end

@implementation ViewController

#define SCREEN [UIScreen mainScreen].bounds.size

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OC-WEB";
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, SCREEN.height)];
    self.webView.delegate = self;
    
//    NSString * urlStr = @"http://192.168.1.125/webview/index.html";
//    NSURL * url = [NSURL URLWithString:urlStr];
//    NSURLRequest * request = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                          ofType:@"html"];
    NSString * htmlStr = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    
    [self.webView loadHTMLString:htmlStr baseURL:baseURL];
    
    [self.view addSubview:self.webView];
}

#pragma mark - WebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title = @"网页加载完毕,待命中";
    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    RHCFJsModel * model = [[RHCFJsModel alloc]init];
    
    //iosModel 是iOS 与 HTML 约定的
    self.context[@"iosModel"] = model;
    model.context = self.context;
    model.webView = self.webView;
   
    //这个代理是为了控制iOS界面跳转
    model.delegate = self;
    
    //js的异常log输出到控制台
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"异常输出%@", exceptionValue);
    };
}

#pragma mark - RHCFWebDelegate
- (void)rhcfWebJump{
    NextViewController * vc = [[NextViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
