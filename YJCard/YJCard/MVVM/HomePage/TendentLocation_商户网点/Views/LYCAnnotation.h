//
//  LYCAnnotation.h
//  YJCard
//
//  Created by paradise_ on 2017/8/10.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

//#import "BaiduMapAPI_Map/BaiduMapAPI_Map.h"
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
@class RetailersModel;
@interface LYCAnnotation : BMKPointAnnotation
@property (nonatomic,strong) RetailersModel * model;
@end
