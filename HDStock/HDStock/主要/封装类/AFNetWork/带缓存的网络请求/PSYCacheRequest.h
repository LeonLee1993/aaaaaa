//
//  PSYCacheRequest.h
//  HDStock
//
//  Created by hd-app02 on 2017/1/6.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SuccessCallBack)     (id responseObject,BOOL succe,NSDictionary *jsonDic);
typedef void (^FailureCallBack)     (NSError *error);

@interface PSYCacheRequest : NSObject

+(void)GET:(NSString *)url CacheTime:(NSInteger)CacheTime success:(SuccessCallBack)success failure:(FailureCallBack)failure;


+ (void)POST:(NSString *)url withParameters:(NSDictionary *)parmas CacheTime:(NSInteger )CacheTime isLoadingView:(NSString *)loadString success:(SuccessCallBack)success failure:(FailureCallBack)failure;

//网络判断
+(BOOL)interStatus;
@end
