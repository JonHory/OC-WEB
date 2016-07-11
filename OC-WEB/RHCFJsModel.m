//
//  RHCFJsModel.m
//  OC-WEB
//
//  Created by rhcf_wujh on 16/7/5.
//  Copyright © 2016年 wjh. All rights reserved.
//

#import "RHCFJsModel.h"

@implementation RHCFJsModel

- (void)btn1Click{
    NSLog(@"点击了第一个按钮");
    
    //js调用oc后，oc再调用js
    JSValue * js = self.context[@"btn1Fun"];
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
