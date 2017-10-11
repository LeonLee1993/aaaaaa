//
//  LYCNetworkManager.h
//  YJCard
//
//  Created by paradise_ on 2017/6/29.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;
@class LYCBaseViewController;
@class LYCPoorNetworkView;
#import "LYCStateViews.h"

typedef void(^reloadDataBlock)();

@interface LYCNetworkManager : NSObject

@property (nonatomic,assign) AFHTTPSessionManager *myManager;
+ (instancetype)manager;

//- (void)LYC_Get:(NSString *)url params:(id)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

-(AFHTTPSessionManager *)LYC_Post:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure andProgressView:(UIView *)progressView progressViewText:(NSString *)text progressViewType:(LYCStateViewState )ViewState  ViewController:(LYCBaseViewController *)controller;

@property (nonatomic,copy)reloadDataBlock reloadDataBlock;



@end
