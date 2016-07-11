//
//  RHCFJsModel.h
//  OC-WEB
//
//  Created by rhcf_wujh on 16/7/5.
//  Copyright © 2016年 wjh. All rights reserved.
//
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
