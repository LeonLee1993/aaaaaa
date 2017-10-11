//
//  AppDelegate.h
//  HDStock
//
//  Created by hd-app02 on 16/11/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HDLeftPersonalViewController.h"
//#import <RongIMKit/RongIMKit.h>

//shareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
#import "HDShareCustom.h"


//JPush
static NSString *appkeyOfJpush = @"2034506829d025666904f25d";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

//weiboSDK

@protocol WeiBoDelegate <NSObject>

-(void)weiboLoginByResponse:(WBBaseResponse *)response;

-(void)weiboShareSuccessCode:(NSInteger)shareResultCode;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (weak  , nonatomic) id<WeiBoDelegate> weiboDelegate;//weiboSDK

/**是否支持屏幕旋转,1可以旋转，其他不可以*/
@property (nonatomic, assign) NSInteger allowRotation;

/**网络状态*/
@property (nonatomic,assign) NSInteger netStatu;


- (void)saveContext;

@property (nonatomic,strong) HDLeftPersonalViewController *leftSideVc;
@property (nonatomic,strong) UITabBarController *mainVc;
/** 直播页面的子控制器的网页是否加载失败了*/
@property (nonatomic,assign) BOOL isSuccededToConnectLiveWebUrlBool;
/** 直播是否静音*/
@property (nonatomic,assign) BOOL isCloseVoiceBool;
/** 直播是否已经有事先缓存*/
@property (nonatomic,assign) BOOL isHaveLivePlayed;

/**购买成功后返回产品列表并刷新界面*/
@property (nonatomic,assign) BOOL buySuccededToRefreshUIBool;

@property (nonatomic,assign) CGFloat normalScreenWidth;//正常情况下屏幕宽
@property (nonatomic,assign) CGFloat normalScreenHeight;//正常情况下屏幕高

@property (nonatomic,assign) NSInteger countN;


@end

