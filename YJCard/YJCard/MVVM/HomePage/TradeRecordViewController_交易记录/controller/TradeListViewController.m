//
//  TradeListViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/26.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TradeListViewController.h"
#import <WebKit/WebKit.h>
#import "TradeDetailViewController.h"
@interface TradeListViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong) WKWebView * webView;
@property (weak, nonatomic) IBOutlet UILabel * titleNameLabel;
@property (nonatomic,strong) UIProgressView * progressView;
@end

@implementation TradeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    
        [self requestWebView];
    
}

- (void) requestWebView{
    
    if(whetherHaveNetwork){
    
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
        [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
        
        if(self.cardID.length>0){
            [mutDic setObject:self.cardID forKey:@"cardid"];
        }else{
            [mutDic setObject:@"0" forKey:@"cardid"];
        }
        NSString *UrlStr;
        if(self.type == LYCTradeListTypeConsume){
            [mutDic setObject:@"1" forKey:@"tradetype"];
            UrlStr=[NSString stringWithFormat:@"%@%@",WebViewPreURL,consumeRecord];
        }else{
            [mutDic setObject:@"2" forKey:@"tradetype"];
            self.titleNameLabel.text = @"充值记录";
            UrlStr=[NSString stringWithFormat:@"%@%@",WebViewPreURL,chargeRecord];
        }
        
        NSString * requestStr = [NSString setWebUrlEncodeStringWithDic:mutDic];
        
        
        NSURL *webURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UrlStr,requestStr]];
        
        [self.webView loadRequest:[[NSURLRequest alloc]initWithURL:webURL cachePolicy:1 timeoutInterval:30.0f]];
        
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
    }else{
        [self.poorNetWorkView show];
        __weak typeof (self)weakSelf = self;
        self.poorNetWorkView.reloadBlock = ^{
            [weakSelf requestWebView];
        };
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
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
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
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
    if([strRequest hasPrefix:@"yktcall://"]){
        NSString * tradeID = [NSString subStringFromString:strRequest by:@"tradeid=" to:@"tradetype"];
        TradeDetailViewController *tradeDetail = [[TradeDetailViewController alloc]init];
        tradeDetail.tradeIdString = tradeID;
        if(self.type == LYCTradeListTypeConsume){
            tradeDetail.type = LYCTradeDetailTypeConsume;
        }else{
            tradeDetail.type = LYCTradeDetailTypeCharge;
        }
        [self.navigationController pushViewController:tradeDetail animated:YES];
    }
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

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

/// 网页加载错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    NSURLRequest *request = webView.request;
//    NSLog(@"didFailLoadWithError-url=%@--%@",[request URL],[request HTTPBody]);
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
//    NSLog(@"urlString=%@---urlComps=%@",urlString,urlComps);
    return YES;
}

@end
