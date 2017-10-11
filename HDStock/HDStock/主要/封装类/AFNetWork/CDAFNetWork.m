//
//  CDAFNetWork.m
//  Exercise
//
//  Created by 郑克 on 15/12/6.
//  Copyright © 2015年 sanfenqiu. All rights reserved.
//

#import "CDAFNetWork.h"
#import "AppDelegate.h"

@implementation CDAFNetWork
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"CDShareSport" reason:@"no" userInfo:nil];
}
-(instancetype)initInstance{
    if (self = [super init]) {
        
        self.myManager = [AFHTTPSessionManager manager];
        _myManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"image/jpeg", nil];
    }
    
    return self;
}

+ (instancetype)sharedMyManager{
    
    static CDAFNetWork *_shareAFNHttpRequestOPManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _shareAFNHttpRequestOPManager = [[self alloc]initInstance];;

    });
    
    return _shareAFNHttpRequestOPManager;
}

- (void)checkNetWorkStatusSuccess:(void (^)(id))success{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //        AFNetworkReachabilityStatusUnknown          = -1,
        //        AFNetworkReachabilityStatusNotReachable     = 0,
        //        AFNetworkReachabilityStatusReachableViaWWAN = 1,
        //        AFNetworkReachabilityStatusReachableViaWiFi = 2,
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown :
                if (success) {
                    success(@"-1");
                }
                break;
            case AFNetworkReachabilityStatusNotReachable:
                if (success) {
                    success(@"0");
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                if (success) {
                    success(@"1");
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                if (success) {
                    success(@"2");
                }
                break;
        }
    }];
}
/**
 *   监听网络状态的变化
 */
+ (NewNetworkStatus)checkingNetwork{
    
    __block NSInteger statusTag = 0;
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            
            statusTag = NewStatusUnknown;
            [MBProgressHUD showAutoMessage:@"未知网络"];
        }else if (status == AFNetworkReachabilityStatusNotReachable){
            
            statusTag = NewStatusNotReachable;
            [MBProgressHUD showAutoMessage:@"没有网络"];
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            
            statusTag = NewStatusReachableViaWWAN;
            
            [MBProgressHUD showAutoMessage:@"4G网络"];
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            
            statusTag = NewStatusReachableViaWiFi;
            //wifi环境
            //            [MBProgressHUD showAutoMessage:@"wifi已经连接"];
            
        }
        /*通知用户当前连接的是移动数据*/
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORKSTATUE object:self userInfo:@{@"statu":@(statusTag)}];
        
    }];
    return statusTag;
}


- (void)getqrCode:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    // 1.获得请求管理者
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    //    // 2.发送GET请求
    [mgr setSecurityPolicy:policy];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //    [mgr.requestSerializer setValue:@"10" forHTTPHeaderField:VOURLCacheAgeKey];
    //    [mgr.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    //    [mgr.requestSerializer setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
//    
//    if ([[CDCoreDateSql sharedCoreDateSql] pushToken]) {
//        NSString *token = [[CDCoreDateSql sharedCoreDateSql] pushToken];
//        NSLog(@"%@",token);
//        [mgr.requestSerializer setValue:[[CDCoreDateSql sharedCoreDateSql] pushToken] forHTTPHeaderField:apiTokenKey];
//        [mgr.requestSerializer setValue:currentVersion forHTTPHeaderField:Version];
//        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
//        
//    }
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/jpeg", nil];

    
    [mgr GET:url parameters:params
     success:^(NSURLSessionDataTask *operation, id responseObj) {
         if (success) {
             success(responseObj);
         }
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

- (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
//    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];

    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    // 1.获得请求管理者
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
//    // 2.发送GET请求
    [mgr setSecurityPolicy:policy];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //[mgr.requestSerializer setValue:@"10" forHTTPHeaderField:VOURLCacheAgeKey];
    //[mgr.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];

    //[mgr.requestSerializer setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 5.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
//    if ([[CDCoreDateSql sharedCoreDateSql] pushToken]) {
//        NSString *token = [[CDCoreDateSql sharedCoreDateSql] pushToken];
//        NSLog(@"token = %@",token);
//        [mgr.requestSerializer setValue:[[CDCoreDateSql sharedCoreDateSql] pushToken] forHTTPHeaderField:apiTokenKey];
//        [mgr.requestSerializer setValue:currentSystemVersion forHTTPHeaderField:Version];
//        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
//        
//    }
    
    [mgr GET:url parameters:params 
     success:^(NSURLSessionDataTask *operation, id responseObj) {
         if (success) {
             success(responseObj);
         }
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}
- (void)loginpost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = self.myManager;
    [mgr setSecurityPolicy:policy];
    //    [mgr setreq]
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
//    [mgr.requestSerializer setValue:currentSystemVersion forHTTPHeaderField:Version];
//    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"image/jpeg", nil];
    // 2.发送POST请求
    [mgr POST:url parameters:params
      success:^(NSURLSessionDataTask *operation, id responseObj) {
          if (success) {
              success(responseObj);
          }
      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

- (void)changePost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = self.myManager;
    [mgr setSecurityPolicy:policy];
    //    [mgr setreq]
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
//    if ([[CDCoreDateSql sharedCoreDateSql] pushToken]) {
//        NSString *token = [[CDCoreDateSql sharedCoreDateSql] pushToken];
//        NSLog(@"%@",token);
//        [mgr.requestSerializer setValue:[[CDCoreDateSql sharedCoreDateSql] pushToken] forHTTPHeaderField:apiTokenKey];
//        [mgr.requestSerializer setValue:currentSystemVersion forHTTPHeaderField:Version];
//        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
//        
//    }
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"image/jpeg", nil];
    // 2.发送POST请求
    [mgr POST:url parameters:params
      success:^(NSURLSessionDataTask *operation, id responseObj) {
          if (success) {
              success(responseObj);
          }
      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}
- (void)gzipPost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = self.myManager;
    [mgr setSecurityPolicy:policy];
    //    [mgr setreq]
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //[mgr.requestSerializer setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
   // NSLog(@"%@",jsonData);
    [mgr.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    
//    if ([[CDCoreDateSql sharedCoreDateSql] pushToken]) {
//        NSString *token = [[CDCoreDateSql sharedCoreDateSql] pushToken];
//        NSLog(@"%@",token);
//        [mgr.requestSerializer setValue:[[CDCoreDateSql sharedCoreDateSql] pushToken] forHTTPHeaderField:apiTokenKey];
//        [mgr.requestSerializer setValue:currentSystemVersion forHTTPHeaderField:Version];
//        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
//        
//    }
    // 2.发送POST请求
    [mgr POST:url parameters:params
      success:^(NSURLSessionDataTask *operation, id responseObj) {
          if (success) {
              success(responseObj);
          }
      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = self.myManager;
    [mgr setSecurityPolicy:policy];
//    [mgr setreq]
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/html"];
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
    mgr.responseSerializer = jsonResponseSerializer;
    
//    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    mgr.requestSerializer.timeoutInterval = 10.f;
//    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    if ([[CDCoreDateSql sharedCoreDateSql] pushToken]) {
//        NSString *token = [[CDCoreDateSql sharedCoreDateSql] pushToken];
//        NSLog(@"%@",token);
//        [mgr.requestSerializer setValue:[[CDCoreDateSql sharedCoreDateSql] pushToken] forHTTPHeaderField:apiTokenKey];
//        [mgr.requestSerializer setValue:currentSystemVersion forHTTPHeaderField:Version];
//        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
//    }
    // 2.发送POST请求
    [mgr POST:url parameters:params
      success:^(NSURLSessionDataTask *operation, id responseObj) {
          if (success) {
              success(responseObj);
          }
      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}
/**
 *  上传文件请求
 */
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure dataSource:(CDDate *)dataSource{
    
    
    // 1.获得请求管理者
    AFHTTPSessionManager * mgr = self.myManager;
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:dataSource.data name:dataSource.name fileName:dataSource.filename mimeType:dataSource.mimeType];
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
//上传图片
- (void)post:(NSString *)url params:(NSDictionary *)params image:(UIImage *)myImage success:(void (^ )(id responseObject))success failure:(void (^)(NSError * error))failure{

    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = self.myManager;
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr setSecurityPolicy:policy];
    //    [mgr setreq]
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
//    if ([[CDCoreDateSql sharedCoreDateSql] pushToken]) {
//        NSString *token = [[CDCoreDateSql sharedCoreDateSql] pushToken];
//        NSLog(@"%@",token);
//        [mgr.requestSerializer setValue:[[CDCoreDateSql sharedCoreDateSql] pushToken] forHTTPHeaderField:apiTokenKey];
//        [mgr.requestSerializer setValue:currentSystemVersion forHTTPHeaderField:Version];
//        [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%d",DEVICE_TYPE] forHTTPHeaderField:device];
//
//    }
  [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(myImage, 1);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//      if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",WAP_URL,api_myChangePortrait]]) {
//          // 上传图片，以文件流的格式
//          [formData appendPartWithFileData:imageData name:@"portrait" fileName:fileName mimeType:@"image/jpeg"];
//      }else{
//          
//          // 上传图片，以文件流的格式
//          [formData appendPartWithFileData:imageData name:@"portrait" fileName:fileName mimeType:@"image/jpeg"];
//      }
      
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error);
    }];
    
    
}

#pragma mark 取消网络请求

- (void)cancelRequest{
    
    NSLog(@"cancelRequest");
    [[[[self class] sharedManager] operationQueue] cancelAllOperations];
    
}
@end
