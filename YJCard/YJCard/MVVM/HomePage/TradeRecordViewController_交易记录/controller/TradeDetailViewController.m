//
//  TradeDetailViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/26.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TradeDetailViewController.h"

#import <WebKit/WebKit.h>
@interface TradeDetailViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

@property (nonatomic,strong) WKWebView * webView;
@property (nonatomic,strong) UIProgressView * progressView;
@end

@implementation TradeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    if(self.type == LYCTradeDetailTypeSeeDetail){
        NSString *UrlStr1 = [NSString stringWithFormat:@"%@%@",WebViewPreURL,@"memberpaycodeexplain/index"];
        self.titleNameLabel.text = @"付款码详情";
        
        NSURL *webURL = [NSURL URLWithString:UrlStr1];
        //    NSURL *webURL = [NSURL URLWithString:UrlStr];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:webURL]];
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
    }else{
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
        [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
        
        if(self.type == LYCTradeDetailTypeConsume){
            [mutDic setObject:@"1" forKey:@"tradetype"];
        }else{
            [mutDic setObject:@"2" forKey:@"tradetype"];
            self.titleNameLabel.text = @"充值详情";
        }
        [mutDic setObject:@"1" forKey:@"platform"];
        [mutDic setObject:self.tradeIdString forKey:@"tradeid"];
        
        NSString * requestStr = [NSString setWebUrlEncodeStringWithDic:mutDic];
        NSString *UrlStr =[NSString stringWithFormat:@"%@%@",WebViewPreURL,self.type == LYCTradeDetailTypeConsume? consumeDetail:chargeDetail];
        
        NSString *UrlStr1 = [NSString stringWithFormat:@"%@%@",UrlStr,requestStr];
        
        NSURL *webURL = [NSURL URLWithString:UrlStr1];
        //    NSURL *webURL = [NSURL URLWithString:UrlStr];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:webURL]];
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark - webView
- (WKWebView *)webView{
    if(!_webView){
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 65, ScreenWidth, ScreenHeight-65)];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

-(UIProgressView *)progressView{
    if(!_progressView){
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 1)];
        _progressView.trackTintColor = [UIColor whiteColor];
        _progressView.progressTintColor = MainColor;
    }
    return _progressView;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
#pragma clang diagnostic ignored "-Wdeprecated"
    
#pragma clang diagnostic pop
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setAlpha:1.0f];//0.10000000000000001起
        
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress animated:animated];
        
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
                
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end
