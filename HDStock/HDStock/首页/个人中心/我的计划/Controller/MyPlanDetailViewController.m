//
//  MyPlanDetailViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/26.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "MyPlanDetailViewController.h"
#import <WebKit/WebKit.h>
@interface MyPlanDetailViewController ()
@property (nonatomic,strong) WKWebView * webView;
@end

@implementation MyPlanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setNavCustemViewForLeftItemWithImage:imageNamed(@"Live_back") title:@"返回" titleFont:[UIFont systemFontOfSize:(15)] titleCoclor:[UIColor clearColor] custemViewFrame:CGRM(0, 26, 56, 44)];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
}

-(WKWebView *)webView{
    if(_webView == nil){
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        [self.view addSubview:_webView];
    }
    return _webView;
}

@end
