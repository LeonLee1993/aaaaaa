//
//  HDAdversementDetailViewController.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDAdversementDetailViewController.h"
#import <WebKit/WebKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "ZHFactory.h"
#import "HDShareCustom.h"

@interface HDAdversementDetailViewController()<WKUIDelegate, WKNavigationDelegate, thyShareCustomDlegate>

@property (nonatomic, strong) WKWebView * webView;//网页>

@property (nonatomic, copy) NSString * shareUrlString;
@property (nonatomic, copy) NSString * shareTitle;
@property (nonatomic, copy) NSString * shareImageUrl;

@property (nonatomic,strong) UIView * shareBlakBgView;//分享时候的黑色遮罩视图
@property (nonatomic,strong) UIView * shareBgView;//分享背景视图
@property (nonatomic,copy) NSArray * shareTitleArr;//分享标题
@property (nonatomic,copy) NSArray * shareIconArr;//分享图片
@property (nonatomic,strong) HDShareCustom * customShare;

@end

@implementation HDAdversementDetailViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self setNormalBackNav];
    [self setUpTextView];
    [self loadData];
    [self setUp];
    
    NSLog(@"%@",self.imageUrlStr);
    NSLog(@"%@",self.url);
    NSLog(@"%@",self.tittle);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}


- (void)setUpTextView{
    
    self.title = self.tittle;
    
    self.webView = [[WKWebView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - NAV_STATUS_HEIGHT)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    [self.view addSubview:self.webView];
    [self setNavBarRightItemWithImage:imageNamed(@"zhuanti_share_icon")];
}

- (void)rightBarImageBtnClciked{
    
    [self.customShare createShareUI];
    
}

#pragma mark - 加载网页
- (void)loadData{
    
    NSString * urlString = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    
//    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSString * t = [self subStringFromString:strRequest by:@"t=" to:@"title="];
//    
//    if (![t isEqualToString:@""]) {
//        
//        self.shareUrlString = strRequest;
//        self.title = t;
//    }
//    
//    NSString * title = [self subStringFromString:strRequest by:@"title=" to:@"img="];
//    
//    if (![title isEqualToString:@""]) {
//        
//        self.shareTitle = title;
//    }
//    
//    NSString * imageUrl = [self subStringFromStringtoEnd:strRequest by:@"img="];
//    
//    if (![imageUrl isEqualToString:@""]) {
//        
//        self.shareImageUrl = imageUrl;
//        
//    }
//    
//    decisionHandler(WKNavigationActionPolicyAllow);
//}
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    
//    [self setUp];
//    
//}

- (NSString *)subStringFromString:(NSString *)string by:(NSString *)subString1 to:(NSString *)subString2{
    
    NSString * tempString = [[NSString alloc]init];
    
    NSRange range1 = [string rangeOfString:subString1];
    NSRange range2 = [string rangeOfString:subString2];
    
    if (range1.location != NSNotFound && range2.location != NSNotFound) {
        
        NSString * subedString = [string getSubstringFrom:range1.location + range1.length to:range2.location - 1];
        
        tempString = subedString;
        
    }
    
    return tempString;
}

- (NSString *)subStringFromStringtoEnd:(NSString *)string by:(NSString *)subString1 {
    
    NSString * tempString = [[NSString alloc]init];
    
    NSRange range1 = [string rangeOfString:subString1];
    
    if (range1.location != NSNotFound) {
        
        NSString * subedString = [string substringFromIndex:range1.location + range1.length];
        
        tempString = subedString;
        
    }
    
    return tempString;
}


#pragma mark - 设置
- (void) setUp {
    
    //分享
    _customShare = [HDShareCustom new];
    _customShare.shareCustomDlegate = self;
    _customShare.comFromIndex = 0;
    WEAK_SELF;
    //判断是否安装了接受分享的设备
    _customShare.isInstalledAlertBlock = ^(NSString * isInstalledStr){
        STRONG_SELF;
        [strongSelf jugeWithStr:isInstalledStr];
    };
    //开始分享
    _customShare.sharePlatBlock = ^(NSInteger platType){
        STRONG_SELF;
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        if (platType == 2){//微博
            
            [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",strongSelf.tittle,[NSURL URLWithString:[strongSelf.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]
                                                       title:@"股博士APP"
                                                       image:[NSURL URLWithString:[strongSelf.imageUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                         url:[NSURL URLWithString:[strongSelf.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                    latitude:0
                                                   longitude:0
                                                    objectID:nil
                                                        type:(SSDKContentTypeAuto)];
            [shareParams SSDKEnableUseClientShare];
            [strongSelf.customShare gotoShareWithContent:shareParams];
        }else if (platType == 0 || platType == 3) {//微信好友，QQ
            //1、创建分享参数
            NSArray* imageArray = @[[NSURL URLWithString:[strongSelf.imageUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:strongSelf.tittle
                                                 images:imageArray
                                                    url:[NSURL URLWithString:[strongSelf.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                  title:@"股博士APP"
                                                   type:SSDKContentTypeAuto];
                [strongSelf.customShare gotoShareWithContent:shareParams];
            }
        }else if (platType == 1) {//微信朋友圈
            //1、创建分享参数
            NSArray* imageArray = @[[NSURL URLWithString:[strongSelf.imageUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:strongSelf.tittle
                                                 images:imageArray
                                                    url:[NSURL URLWithString:[strongSelf.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                  title:strongSelf.tittle
                                                   type:SSDKContentTypeAuto];
                [strongSelf.customShare gotoShareWithContent:shareParams];
            }
        }
        
    };
    
    //分享状态
    self.customShare.shareStatusBlock = ^(NSInteger shareState){
        STRONG_SELF;
        switch (shareState) {
            case SSDKResponseStateSuccess:
            {
                [MBProgressHUD showMessage:@"分享成功" ToView:strongSelf.view RemainTime:2];
            }
                break;
            case SSDKResponseStateFail:
            {
                [MBProgressHUD showMessage:@"分享失败" ToView:strongSelf.view RemainTime:2];
            }
                break;
            case SSDKResponseStateCancel:
            {
                [MBProgressHUD showMessage:@"取消分享" ToView:strongSelf.view RemainTime:2];
                
            }
                break;
            default:
                break;
        }
    };    
}

#pragma mark == 分享代理
- (void) shareBlcakBgViewTaped{}
- (void) shareCustomShareBtnClicked{}
- (void) shareStatus:(NSInteger)shareStatusIndex{}

//判断
- (void)jugeWithStr:(NSString *)alertStr {
    if (IOS8) {
        //执行操作
        WEAK_SELF;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionContinue = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel  handler:nil];
        [alertController addAction:actionContinue];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"", nil];
        [alter show];
    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
