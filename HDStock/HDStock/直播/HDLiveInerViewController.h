//
//  HDLiveInerViewController.h
//  HDStock
//
//  Created by hd-app01 on 16/11/11.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockBaseViewController.h"
#import <AliyunPlayerSDK/AliyunPlayerSDK.h>

@interface HDLiveInerViewController : HDStockBaseViewController<AliVcAccessKeyProtocol>

/** 直播状态：视频直播中1、直播中2，未直播3*/
@property (nonatomic,assign) NSInteger liveStatus;
/**点赞数*/
@property (nonatomic,copy) NSString * zanNumStr;

/**
 *  设置播放的视频地址，需要在试图启动之前设置
 *  参数url为本地地址或网络地址
 *  如果位本地地址，则需要用[NSURL fileURLWithPath:path]初始化NSURL
 *  如果为网络地址则需要用[NSURL URLWithString:path]初始化NSURL
 */
//- (void) SetMoiveSource:(NSURL*)url;

/**直播室id*/
@property (nonatomic,copy) NSString * room_id;



@end
