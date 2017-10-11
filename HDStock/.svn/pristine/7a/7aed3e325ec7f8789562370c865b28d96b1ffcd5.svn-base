//
//  HeadLineViewController.m
//  HDGolden
//
//  Created by hd-app02 on 16/10/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HeadLineViewController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import "ZHFactory.h"
#import "HDShareCustom.h"

@interface HeadLineViewController ()<WKUIDelegate, WKNavigationDelegate, thyShareCustomDlegate>

@property (nonatomic,strong) UIView * shareBlakBgView;//分享时候的黑色遮罩视图
@property (nonatomic,strong) UIView * shareBgView;//分享背景视图
@property (nonatomic,copy) NSArray * shareTitleArr;//分享标题
@property (nonatomic,copy) NSArray * shareIconArr;//分享图片
@property (nonatomic,strong) HDShareCustom * customShare;

@property (strong, nonatomic) UIView * bottomView;
@property (strong, nonatomic) UIButton *collectionButton;
@property (strong, nonatomic) UIButton *praiseButton;
@property (assign, nonatomic) NSInteger favid;
@property (nonatomic, copy) NSString * token;

@property (nonatomic, strong) WKWebView * webView;//网页>

@property (nonatomic, copy) NSString * shareUrlString;
@property (nonatomic, copy) NSString * shareTitle;
@property (nonatomic, copy) NSString * shareImageUrl;

@end

@implementation HeadLineViewController

- (void)viewDidLoad{

    [super viewDidLoad];
    self.title = self.controllerTitle;
    [self setNormalBackNav];
    [self setUpTextView];
    [self loadData];
    [self panToPopView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    NSDictionary *dicd = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    self.token = dicd[@"token"];
    NSMutableDictionary * dic = [ZHFactory readPlistWithPlistNameReturnMutableDictionary:self.token];
    NSString * favid = dic[[NSString stringWithFormat:@"%ld",(long)self.aid]];
    NSLog(@"收藏%@",favid);
    NSString * isclicked = dic[[NSString stringWithFormat:@"isClicked%ld",(long)self.aid]];
    if (favid) {

        self.collectionButton.selected = YES;
        
    }else{
    
       self.collectionButton.selected = NO;
    
    }
    if (isclicked) {
        
        self.praiseButton.enabled = NO;
        
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)setUpTextView{
    self.webView = [[WKWebView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - NAV_STATUS_HEIGHT - 50)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    [self.view addSubview:self.webView];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.right.left.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    self.collectionButton = [[UIButton alloc]init];
    [self.collectionButton setImage:imageNamed(@"news_detail_collect_af") forState:UIControlStateNormal];
    [self.collectionButton setImage:imageNamed(@"news_detail_collect__bf") forState:UIControlStateSelected];
    [self.collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectionButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.collectionButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.collectionButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    
    [self.bottomView addSubview:self.collectionButton];
    [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(105, 35));
        make.centerX.equalTo(self.bottomView.mas_right).with.offset(- SCREEN_WIDTH / 4.0f);
        make.centerY.equalTo(self.bottomView);
        
    }];
    
    self.praiseButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.praiseButton setImage:imageNamed(@"news_detail_zan_af") forState:UIControlStateNormal];
    [self.praiseButton setImage:imageNamed(@"news_detail_zan_bf") forState:UIControlStateDisabled];
    [self.praiseButton setTitle:@"点赞" forState:UIControlStateNormal];
    [self.praiseButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.praiseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.praiseButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    [self.bottomView addSubview:self.praiseButton];
    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(105, 35));
        make.centerY.equalTo(self.bottomView);
        make.centerX.equalTo(self.bottomView.mas_left).with.offset(SCREEN_WIDTH / 4.0f);
        
    }];
    
    [self.collectionButton addTarget:self action:@selector(collectionButtonOnTouched:) forControlEvents:UIControlEventTouchUpInside];

    [self.praiseButton addTarget:self action:@selector(praiseButtonOnTouched:) forControlEvents:UIControlEventTouchUpInside];
    
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

#pragma mark == 点击事件

- (void)collectionButtonOnTouched:(UIButton *)button{
    
    if (self.token) {
        if (button.selected == NO) {
            
            [self collectionTheArticle];
            
        }else if(button.selected == YES){
            
            [self cancelCollection];
            
        }
        button.selected = !button.selected;
    }else{
    
        PCSignInViewController * signVC = [[PCSignInViewController alloc]init];
    
        [self presentViewController:signVC animated:YES completion:^{
            
            
        }];
    }
    
}


- (void)praiseButtonOnTouched:(UIButton * )button{
    
    if (!self.token) {
        
        PCSignInViewController * signVC = [[PCSignInViewController alloc]init];
        
        [self presentViewController:signVC animated:YES completion:^{
            
            
        }];
    }else{
    
    NSString * hashString = [NSString stringWithFormat:@"%ld%ld",(long)self.uid,(long)self.aid];
    
    NSString * hashedStr = [self stringToMD5:hashString];
    NSLog(@"加密的%@",hashedStr);
    [self praiseTheArticleToNet:hashedStr];
    }
    
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

#pragma mark == 分享代理
- (void) shareBlcakBgViewTaped{}
- (void) shareCustomShareBtnClicked{}
- (void) shareStatus:(NSInteger)shareStatusIndex{}

#pragma mark == 网络请求
- (void)collectionTheArticle{
    
    WEAK_SELF;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSString * url = [NSString stringWithFormat:CollectionTheArticle,(long)self.aid,(long)self.aid,self.token,arc4random()%1000];
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            NSArray * array = json[@"data"];
            
            NSMutableDictionary * faDic = [ZHFactory readPlistWithPlistNameReturnMutableDictionary:self.token];
            if (!faDic) {
                
                faDic = [NSMutableDictionary dictionary];
                
            }
            if (array.count != 0) {
                NSDictionary * dic = [array objectAtIndexCheck:0];
                NSString * favaid = dic[@"favid"];
                [faDic setValue:favaid forKey:[NSString stringWithFormat:@"%ld",(long)self.aid]];
            }
            
            NSString * code = json[@"code"];
            
            if (code.integerValue == 1) {
                [self plistHuanCunWithDic:faDic];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"收藏成功!";
                hud.label.textColor = MAIN_COLOR;
                [hud hideAnimated:YES afterDelay: 2];
            }else if (code.integerValue == 100){
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"请勿重复收藏!";
                hud.label.textColor = MAIN_COLOR;
                [hud hideAnimated:YES afterDelay: 2];
                
            }
            
        } failure:^(NSError *error) {
            
            
        }];
        
    });
    
    
}

- (void)cancelCollection{
    
    NSMutableDictionary * dic = [ZHFactory readPlistWithPlistNameReturnMutableDictionary:self.token];
    NSString * favid = dic[[NSString stringWithFormat:@"%ld",(long)self.aid]];
    self.favid = favid.integerValue;
    WEAK_SELF;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSString * url = [NSString stringWithFormat:CancelCollection,(long)self.favid,self.token,arc4random()%1000];
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            NSString * code = json[@"code"];
            if (code.integerValue == 2) {
                [dic removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)self.aid]];
                [self plistHuanCunWithDic:dic];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"收藏删除成功!";
                hud.label.textColor = MAIN_COLOR;
                [hud hideAnimated:YES afterDelay: 2];
            }else if (code.integerValue == 101){
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"收藏不存在!";
                hud.label.textColor = MAIN_COLOR;
                [hud hideAnimated:YES afterDelay: 2];
                
            }
            
        } failure:^(NSError *error) {
            
            
        }];
    });
}

- (void)praiseTheArticleToNet:(NSString *)str{

    WEAK_SELF;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSString * url = [NSString stringWithFormat:PraiseArticle,(long)self.aid,str,self.token,arc4random()%1000];
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            NSString * str = json[@"code"];
            NSLog(@"点赞%@",json);
            if (str.integerValue == 1) {
                
                NSMutableDictionary * faDic = [ZHFactory readPlistWithPlistNameReturnMutableDictionary:self.token];
                NSLog(@"读取%@",faDic);
                if (!faDic) {
                    
                    faDic = [NSMutableDictionary dictionary];
                    
                }

                [faDic setValue:@"isclicked" forKey:[NSString stringWithFormat:@"isClicked%ld",(long)self.aid]];
                
                [self plistHuanCunWithDic:faDic];
                self.praiseButton.enabled = NO;
        
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"点赞成功!";
                hud.label.textColor = MAIN_COLOR;
                [hud hideAnimated:YES afterDelay: 2];
                
                }else if (str.integerValue == 405){
            
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"您已点过赞!";
                hud.label.textColor = MAIN_COLOR;
                [hud hideAnimated:YES afterDelay: 2];
            
                self.praiseButton.enabled = NO;
            
                }else if (str.integerValue == 402){
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = @"您没有权限!";
                    hud.label.textColor = MAIN_COLOR;
                    [hud hideAnimated:YES afterDelay: 2];
                    
                    self.praiseButton.enabled = NO;
                    
                }
            
           
            
        } failure:^(NSError *error) {
            
            
        }];
    });
}

#pragma mark -- MD5加密
- (NSString *)stringToMD5:(NSString *)str{
    const char *fooData = [str UTF8String];
  
    unsigned char result[CC_MD5_DIGEST_LENGTH];

    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);

    NSMutableString *saveResult = [NSMutableString string];
   
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    return saveResult;
}

#pragma mark- plist缓存
- (void) plistHuanCunWithDic:(NSDictionary *) dic {
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:self.token];
    [dic writeToFile:plistPath atomically:YES];
}

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

- (void)panToPopView{
    self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:self.pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        CGPoint changedPoint;
//        changedPoint = [pan translationInView:self.view];
//        if((changedPoint.x)>60&&fabs(changedPoint.y)<10){
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    });
    CGPoint changedPoint = [pan translationInView:self.view];
    
    if(changedPoint.x > 0){
    
        [self.navigationController popViewControllerAnimated:YES];
    
    }
}
@end
