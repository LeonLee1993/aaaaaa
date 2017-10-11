//
//  HDShareCustom.h
//  HDStock
//
//  Created by hd-app01 on 16/12/19.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <Foundation/Foundation.h>
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

@protocol thyShareCustomDlegate <NSObject>

- (void) shareBlcakBgViewTaped;
- (void) shareCustomShareBtnClicked;
/**分享状态*/
//- (void) shareStatus:(NSInteger)shareStatusIndex;

@end

@interface HDShareCustom : NSObject

@property (nonatomic,weak) id <thyShareCustomDlegate> shareCustomDlegate;
/**0：来自股哥直播室，1：来自资讯*/
@property (nonatomic,assign) NSInteger comFromIndex;

/**是否安装了对应的分享软件方法*/
@property (nonatomic,copy) void (^isInstalledAlertBlock) (NSString * thyMsg);
/**0:微信好友，1：微信朋友圈，2：新浪微博，3：QQ好友*/
@property (nonatomic,copy) void (^sharePlatBlock) (NSInteger sharePlatIndex);
/**分享状态：*/
@property (nonatomic,copy) void (^shareStatusBlock) (NSInteger shareStatusIndex);
/**是否已经创建了分享界面*/
@property (nonatomic,assign) BOOL isHasCreatedShareUIBool;
/**是否关闭了分享的界面*/
@property (nonatomic,assign) BOOL isClosedShareUIBool;

+ (void) registShareSDK;//在delegate中注册app
//-(void)shareWithContent:(id)publishContent;//自定义分享界面
- (void)createShareUI;//自定义分享界面
- (void) gotoShareWithContent:(id)publishContent;//自定义界面的分享

- (void)dismiss;

@end
