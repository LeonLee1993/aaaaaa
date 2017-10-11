//
//  HDLiveLivingViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/14.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveLivingViewController.h"
#import "AppDelegate.h"
//#import "MBProgressHUD+NH.h"

@interface HDLiveLivingViewController()<WKNavigationDelegate,UIGestureRecognizerDelegate>{
    
    AppDelegate * _appdelegate;
    
    
}

@end
    
@implementation HDLiveLivingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDCOKOR;
    [self createWkWeb];
}

- (void) fitFrame {
    CGRect frame = self.view.frame;
    CGFloat mPlayerViewHeight = SCREEN_SIZE_WIDTH*9.0/16;//视屏高度
    if (iPhone5) {
        mPlayerViewHeight = SCREEN_SIZE_WIDTH*9.0/16-13;
    }
    frame.size.height = SCREEN_HEIGHT-NAV_STATUS_HEIGHT-mPlayerViewHeight-50;
    self.view.frame = frame;
}
- (void) webViewTaped {
    if (self.touchDelegate&&[self.touchDelegate performSelector:@selector(webViewTouchbegin)]) {
        [self.touchDelegate webViewTouchbegin];
    }
}
//必须实现 否则无法触发点击事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

//必须实现
-(void)OnclikeWeb:(UITapGestureRecognizer *)tap
{
    
}

- (void) createWkWeb {
    if (!self.wkWeb) {

        //清除缓存
        [self deleteWebCache];
        
        //创建web
        self.wkWeb = [[WKWebView alloc] initWithFrame:CGRM(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
        _wkWeb.navigationDelegate = self;
        self.wkWeb.scrollView.showsVerticalScrollIndicator = NO;
        _wkWeb.scrollView.showsHorizontalScrollIndicator = NO;
        self.wkWeb.backgroundColor = BACKGROUNDCOKOR;
        _wkWeb.scrollView.backgroundColor = BACKGROUNDCOKOR;
        [self.view addSubview:self.wkWeb];
        [self headerRefresh];

        //下拉刷新
        WEAK_SELF;
        _wkWeb.scrollView.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF;
            [strongSelf headerRefresh];
        }];
        
        //给视频播放视图添加tap手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webViewTaped)];
        tap.delegate = self;
        [_wkWeb addGestureRecognizer:tap];
        
//        self.view.backgroundColor = [UIColor orangeColor];
//        _wkWeb.backgroundColor = [UIColor redColor];
    }
}

- (void) headerRefresh {
    [self.wkWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:LivePageWebUrl]]];

}
//准备加载页面
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
//    [MBProgressHUD showLoadToView:self.wkWeb];
}
//内容开始加载(view的过渡动画可在此方法中加载)
- (void) webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    _appdelegate.isSuccededToConnectLiveWebUrlBool = YES;
    [_wkWeb.scrollView.mj_header endRefreshing];
}

//页面加载完成(view的过渡动画的移除可在此方法中进行)
- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [MBProgressHUD hideHUDForView:self.wkWeb animated:YES];
    _appdelegate.isSuccededToConnectLiveWebUrlBool = YES;
    [_wkWeb.scrollView.mj_header endRefreshing];
    
    NSLog(@"webView加载完成");
}

//页面加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"webView加载失败--%@",error);
//    _appdelegate.isSuccededToConnectLiveWebUrlBool = NO;
    [_wkWeb.scrollView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.wkWeb animated:YES];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"webView加载失败--%@",error);
//    _appdelegate.isSuccededToConnectLiveWebUrlBool = NO;
    [_wkWeb.scrollView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.wkWeb animated:YES];

}
//清除缓存
- (void)deleteWebCache {
    
    if (IOS9) {
        //iOS9 WKWebView新方法：
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                        WKWebsiteDataTypeDiskCache,
                                                        WKWebsiteDataTypeOfflineWebApplicationCache,
                                                        WKWebsiteDataTypeMemoryCache,
                                                        WKWebsiteDataTypeLocalStorage,
                                                        WKWebsiteDataTypeCookies,
                                                        WKWebsiteDataTypeSessionStorage,
                                                        WKWebsiteDataTypeIndexedDBDatabases,
                                                        WKWebsiteDataTypeWebSQLDatabases
                                                        ]];
        //你可以选择性的删除一些你需要删除的文件 or 也可以直接全部删除所有缓存的type
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                                   modifiedSince:dateFrom completionHandler:^{
                                                       // code
                                                   }];
    }else {
        //    但开发app必须要兼容所有iOS版本，可是iOS8，iOS7没有这种直接的方法，那该怎么办呢？
        //    （iOS7.0只有UIWebView， 而iOS8.0是有WKWebView， 但8.0的WKWebView没有删除缓存方法。）
        //    针对与iOS7.0、iOS8.0、iOS9.0 WebView的缓存，我们找到了一个通吃的办法:
        
        NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                                   NSUserDomainMask, YES)[0];
        NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString
                                          stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
        NSString *webKitFolderInCachesfs = [NSString
                                            stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
        NSError *error;
        
        if (SYSTEM_VERSION >= 8.0 && SYSTEM_VERSION < 9.0) {
            
            /* iOS8.0 WebView Cache的存放路径 */
            [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
            [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
            
        }else if (SYSTEM_VERSION >= 7.0 && SYSTEM_VERSION < 8.0) {
            
            /* iOS7.0 WebView Cache的存放路径 */
            [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
        }
    }
}



#pragma mark - foo
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
