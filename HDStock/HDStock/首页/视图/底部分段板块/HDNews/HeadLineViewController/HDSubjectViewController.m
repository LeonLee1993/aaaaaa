//
//  HDSubjectViewController.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/29.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDSubjectViewController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import "ZHFactory.h"
#import "HDShareCustom.h"

@interface HDSubjectViewController ()<WKUIDelegate, WKNavigationDelegate, thyShareCustomDlegate>

@property (nonatomic,strong) UIView * shareBlakBgView;//分享时候的黑色遮罩视图
@property (nonatomic,strong) UIView * shareBgView;//分享背景视图
@property (nonatomic,copy) NSArray * shareTitleArr;//分享标题
@property (nonatomic,copy) NSArray * shareIconArr;//分享图片
@property (nonatomic,strong) HDShareCustom * customShare;

@property (nonatomic, strong) WKWebView * webView;//网页>

@property (nonatomic, copy) NSString * shareUrlString;
@property (nonatomic, copy) NSString * shareTitle;
@property (nonatomic, copy) NSString * shareImageUrl;

@end

@implementation HDSubjectViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self setUp];
    self.title = self.controllerTitle;
    [self setNormalBackNav];
    [self setUpTextView];
    [self loadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    
}


#pragma mark - 设置
- (void) setUp {
    
    NSString * urlString = [NSString stringWithFormat:@"http://test.cdtzb.com/portal.php?mod=views&aid=%ld&mobile=2&time=%u",(long)self.aid,arc4random()%1000];
    
    NSString * shareTempURL = [NSString new];
    NSString * shareTempTitle = [NSString new];
    NSString * shareTempImageURL = [NSString new];
    
    if (![self.shareTitle isEqualToString:@""] && self.shareTitle) {
        
        NSLog(@"%@",self.shareTitle);
        
        shareTempTitle = self.shareTitle;
        
    }else{
        
        shareTempTitle = self.tittle;
        
    }
    
    if (![self.shareUrlString isEqualToString:@""] && self.shareUrlString) {
        
        shareTempURL = [self.shareUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
    }else{
        
        shareTempURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    if (![self.shareImageUrl isEqualToString:@""] && self.shareImageUrl) {
        
        shareTempImageURL = [self.shareImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else{
        
        shareTempImageURL = [self.imageUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
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
            [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",shareTempTitle,[NSURL URLWithString:shareTempURL]]
                                                       title:@"股博士资讯"
                                                       image:[NSURL URLWithString:shareTempImageURL]
                                                         url:[NSURL URLWithString:shareTempURL]
                                                    latitude:0
                                                   longitude:0
                                                    objectID:nil
                                                        type:(SSDKContentTypeAuto)];
            [shareParams SSDKEnableUseClientShare];
            [strongSelf.customShare gotoShareWithContent:shareParams];
        }else if (platType == 0 || platType == 3) {//微信好友，QQ
            //1、创建分享参数
            NSArray* imageArray = @[[NSURL URLWithString:shareTempImageURL]];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:shareTempTitle
                                                 images:imageArray
                                                    url:[NSURL URLWithString:shareTempURL]
                                                  title:@"股博士APP"
                                                   type:SSDKContentTypeAuto];
                [strongSelf.customShare gotoShareWithContent:shareParams];
            }
        }else if (platType == 1) {//微信朋友圈
            //1、创建分享参数
            NSArray* imageArray = @[[NSURL URLWithString:shareTempImageURL]];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:shareTempTitle
                                                 images:imageArray
                                                    url:[NSURL URLWithString:shareTempURL]
                                                  title:shareTempTitle
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

- (void)setUpTextView{
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
    
    NSString * urlString = [NSString stringWithFormat:@"http://test.cdtzb.com/portal.php?mod=view&aid=%ld&mobile=2&time=%u",(long)self.aid,arc4random()%1000];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * t = [self subStringFromString:strRequest by:@"t=" to:@"title="];
    
    if (![t isEqualToString:@""]) {
        
        self.shareUrlString = strRequest;
        self.title = t;
    }
    
    NSString * title = [self subStringFromString:strRequest by:@"title=" to:@"img="];
    
    if (![title isEqualToString:@""]) {
        
        self.shareTitle = title;
    }
    
    NSString * imageUrl = [self subStringFromStringtoEnd:strRequest by:@"img="];
    
    if (![imageUrl isEqualToString:@""]) {
        
        self.shareImageUrl = imageUrl;
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self setUp];
    
}

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

@end
