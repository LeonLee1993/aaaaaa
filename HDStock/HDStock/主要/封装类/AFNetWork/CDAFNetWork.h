//
//  CDAFNetWork.h
//  Exercise
//
//  Created by 郑克 on 15/12/6.
//  Copyright © 2015年 sanfenqiu. All rights reserved.
//


#import "AFNetworking.h"
#import "CDDate.h"

typedef enum : NSInteger{
    
    NewStatusUnknown = 0,//未知状态
    NewStatusNotReachable,//无网状态
    NewStatusReachableViaWWAN,//手机网络
    NewStatusReachableViaWiFi,//Wifi网络
    
} NewNetworkStatus;

@interface CDAFNetWork : NSObject

@property (nonatomic,strong) AFHTTPSessionManager *myManager;

// *  网络的单例

+ (instancetype)sharedMyManager;

/*
 *brief 检查网络状态
 */

- (void)checkNetWorkStatusSuccess:(void (^)(id str))success;
/**
 *   监听网络状态的变化
 */
+ (NewNetworkStatus)checkingNetwork;


/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
- (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

- (void)changePost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

- (void)loginpost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param dataSource 文件参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure dataSource:(CDDate *)dataSource;
- (void)getqrCode:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
- (void)post:(NSString *)url params:(NSDictionary *)params image:(UIImage *)myImage success:(void (^ )(id responseObject))success failure:(void (^)(NSError * error))failure;
/**
 *  文件上传
 *
 *  @param url     url description
 *  @param params  params description
 *  @param success success description
 *  @param failure failure description
 */
- (void)gzipPost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/*
 *brief 取消网络请求
 */
- (void)cancelRequest;


@end
