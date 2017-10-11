//
//  LYCLocationSigleton.h
//  YJCard
//
//  Created by paradise_ on 2017/8/16.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface LYCLocationSigleton : NSObject
@property (nonatomic,strong) BMKLocationService * locService;
+ (instancetype)LYCLocationManager;
//获取当前定位信息
- (void)startLocation;
@end
