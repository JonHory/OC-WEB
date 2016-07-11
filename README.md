#iOS 与 JavaScript 交互

因为要适配7.0，所以使用UIWebView

    @interface ViewController ()<UIWebViewDelegate,RHCFWebDelegate>

    @property (nonatomic, strong) UIWebView * webView;
    @property (nonatomic, strong) JSContext * context;

    @end
    
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
    
主要是在webviewdelegate里面

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
    

关键部分是RHCFJsModel
.h

    #import <UIKit/UIKit.h>
    #import <Foundation/Foundation.h>
    #import <JavaScriptCore/JavaScriptCore.h>

    @protocol JavaScriptObjectiveCDelegate <JSExport>
    //提供给js调用的方法
    - (void)btn1Click;
    - (void)btn2Click;
    - (void)btn3Click;

    @end

    @protocol RHCFWebDelegate <NSObject>

    - (void)rhcfWebJump;

    @end

    @interface RHCFJsModel : NSObject <JavaScriptObjectiveCDelegate>

    @property (nonatomic ,weak) JSContext * context;
    @property (nonatomic ,weak) UIWebView * webView;

    @property (nonatomic ,weak) id<RHCFWebDelegate>delegate;


    @end
    
.m 内实现

    #import "RHCFJsModel.h"

    @implementation RHCFJsModel

    - (void)btn1Click{
        NSLog(@"点击了第一个按钮");
        
        //js调用oc后，oc再调用js
        //这是oc调用js的方法
        JSValue * js = self.context[@"btn1Fun"];
        //这是要传入的参数
        [js callWithArguments:nil];
    }

    - (void)btn2Click{
        NSLog(@"点击了第二个按钮");
        
        //js调用oc后，oc再调用js
        JSValue * js2 = self.context[@"btn2Fun"];
        [js2 callWithArguments:@[@{@"name":@"wujh",@"age":@"18",@"height":@"200"}]];
    }

    - (void)btn3Click{
        NSLog(@"点击了第三个按钮");
        
        if ([_delegate respondsToSelector:@selector(rhcfWebJump)]) {
            [_delegate rhcfWebJump];
        }
    }

    @end

