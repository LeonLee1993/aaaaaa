//
//  HDLiveTimeTableViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/12/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveTimeTableViewController.h"

@interface HDLiveTimeTableViewController ()


@end

@implementation HDLiveTimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(blueColor);
    
//    [self createWkWeb];
//    [self fitFrame];
}

- (void) fitFrame {
    CGRect frame = self.view.frame;
    frame.size.height = SCREEN_HEIGHT-NAV_STATUS_HEIGHT-SCREEN_SIZE_WIDTH*9.0/16-90+1;
    self.view.frame = frame;
}
- (void) createWkWeb {
    
    [self deleteWebCache];
    
    self.wkWeb = [[WKWebView alloc] initWithFrame:CGRM(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    _wkWeb.navigationDelegate = self;
    [self.wkWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test.cdtzb.com/liveroom.php?type=live"]]];
    self.wkWeb.scrollView.showsVerticalScrollIndicator = NO;
    self.wkWeb.backgroundColor = BACKGROUNDCOKOR;
    //    wkWeb.scrollView.backgroundColor = BACKGROUNDCOKOR;
    [self.view addSubview:self.wkWeb];
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    //    [MBProgressHUD showLoadToView:self.view];
}
- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@",error);
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@",error);
}
//清除缓存
- (void)deleteWebCache {
    
    if (SYSTEM_VERSION >= 9.0) {
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
