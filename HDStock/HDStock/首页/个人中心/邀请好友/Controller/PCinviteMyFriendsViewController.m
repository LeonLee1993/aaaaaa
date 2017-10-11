//
//  PCinviteMyFriendsViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/12.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCinviteMyFriendsViewController.h"
#import <WebKit/WebKit.h>
#import "HDShareCustom.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
@interface PCinviteMyFriendsViewController ()<thyShareCustomDlegate>
@property (nonatomic,strong) WKWebView * webView;
@property (nonatomic,strong) HDShareCustom * customShare;
@end

@implementation PCinviteMyFriendsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeader:_titelStr];
    _customShare = [[HDShareCustom alloc]init];
//    NSString *urlStr = [NSString stringWithFormat:@"%@",@"http://gk.cdtzb.com/api/download"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    self.backToView1.hidden = NO;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareButtonClicked)];
    self.backToView1.userInteractionEnabled = YES;
    [self.backToView1 addGestureRecognizer:tap1];
}

-(WKWebView *)webView{
    if(_webView == nil){
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        [self.view addSubview:_webView];
    }
    return _webView;
}



- (void)shareButtonClicked{
//    NSArray *shareUrlArr = @[@"http://gk.cdtzb.com/api/product/x6",@"http://gk.cdtzb.com/api/product/qn",@"http://gk.cdtzb.com/api/product/xl",@"http://gk.cdtzb.com/api/product/zy"];
    
    //分享
    [_customShare createShareUI];
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
        NSString * shareUrl = @"http://gk.cdtzb.com/api/download";
        NSString * shareText = @"";
        NSString * shareImage = @"shareIcon";
        if (strongSelf.urlStr) {
            shareUrl = strongSelf.urlStr;
        }
//        if (strongSelf.shareTextStr) {
//            shareText = strongSelf.shareTextStr;
//        }
//        if (strongSelf.shareImageStr) {
//            shareImage = strongSelf.shareImageStr;
//        }
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        if (platType == 2){//微博
            [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",shareText,[NSURL URLWithString:shareUrl] ]
                                                       title:@"炒了20年股我就服他们，炒股的朋友可以看看"
                                                       image:[UIImage imageNamed:shareImage]
                                                         url:[NSURL URLWithString:shareUrl]
                                                    latitude:0
                                                   longitude:0
                                                    objectID:nil
                                                        type:SSDKContentTypeAuto];
            [shareParams SSDKEnableUseClientShare];
            [strongSelf.customShare gotoShareWithContent:shareParams];
        }else if (platType == 0 || platType == 1 || platType == 3) {//微信好友，微信朋友圈，QQ
            //1、创建分享参数
            NSArray* imageArray = @[[UIImage imageNamed:shareImage]];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:shareText
                                                 images:imageArray
                                                    url:[NSURL URLWithString:shareUrl]
                                                  title:@"炒了20年股我就服他们，炒股的朋友可以看看"
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

- (void)jugeWithStr:(NSString *)alertStr {
    if (IOS8) {
        //执行操作
        WEAK_SELF;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionContinue = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel  handler:nil];
        [alertController addAction:actionContinue];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"", nil];
        [alter show];
    }
}

- (void) shareBlcakBgViewTaped{

}
- (void) shareCustomShareBtnClicked{
    
}

@end
