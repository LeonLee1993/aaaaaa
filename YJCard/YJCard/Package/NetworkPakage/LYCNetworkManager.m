//
//  LYCNetworkManager.m
//  YJCard
//
//  Created by paradise_ on 2017/6/29.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCNetworkManager.h"
#import "LoginViewController.h"
#import "LYCBaseViewController.h"

#define ignoreUrl1 @"https://yktapi.szeltec.com/dev/api/gethomeinfo"

@interface LYCNetworkManager()

@end

@implementation LYCNetworkManager{
    NSString * lastRequestStr;
    NSString * lastRequestDate;
    NSString * lastLogOutDate;
    NSArray * ignoreUrlArr;
}

+ (instancetype)manager{
    
    static LYCNetworkManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc]initInstance];
        
    });
    
    return instance;
}

-(instancetype)initInstance{
    if (self = [super init]) {
        self.myManager = [AFHTTPSessionManager manager];
        _myManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"image/jpeg", nil];
    }
    return self;
}

/*
 text:提示框显示的字
 controller:用于pop
 progressView:显示提示框的view
*/
-(AFHTTPSessionManager *)LYC_Post:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure andProgressView:(UIView *)progressView progressViewText:(NSString *)text progressViewType:(LYCStateViewState )ViewState ViewController:(LYCBaseViewController *)controller{
    
    ignoreUrlArr = @[ignoreUrl1];
    lastRequestStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastRequest"];
    lastRequestDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastRequestDate"];
    NSDate * lastDateFormmate = [self datafromString:lastRequestDate];
    AFHTTPSessionManager *mgr;
    
    if(lastRequestStr.length>0){//上一次请求有值
        if([lastRequestStr isEqualToString:url]){//两次请求相同的时候
            NSDate *dateNow = [NSDate date];
            NSTimeInterval interVal = [dateNow timeIntervalSinceDate:lastDateFormmate];
            if(interVal>10||![ignoreUrlArr containsObject:url]){//请求相同但是间隔已经达到30秒或者请求的URL在忽略的队列中
                //真正加载
                mgr= [self LYC_Posted:url params:params success:success failure:failure andProgressView:progressView progressViewText:text progressViewType:ViewState ViewController:controller];
                lastRequestDate = [self stringFromDate:dateNow];
                [[NSUserDefaults standardUserDefaults]setObject:lastRequestDate forKey:@"lastRequestDate"];
                
            }else{
                //制造加载假象
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSMutableDictionary *mutDic = @{}.mutableCopy;
                    [mutDic setObject:@"" forKey:@"msg"];
                    NSLog(@"10秒内请求了相同的接口,忽略请设置");
                    //此处应等于不为100的字符串
                    [mutDic setObject:@"101" forKey:@"code"];
                    success(mutDic);
                });
            }
        }else{//两次请求不同的时候
            lastRequestStr = url;
            lastRequestDate = [self stringFromDate:[NSDate date]];
            
            [[NSUserDefaults standardUserDefaults]setObject:lastRequestStr forKey:@"lastRequest"];
            [[NSUserDefaults standardUserDefaults]setObject:lastRequestDate forKey:@"lastRequestDate"];

            mgr=[self LYC_Posted:url params:params success:success failure:failure andProgressView:progressView progressViewText:text progressViewType:ViewState ViewController:controller];
        }
    }else{//上一次请求没值得时候初始化所有属性
        lastRequestStr = url;
        lastRequestDate = [self stringFromDate:[NSDate date]];
        [[NSUserDefaults standardUserDefaults]setObject:lastRequestStr forKey:@"lastRequest"];
        [[NSUserDefaults standardUserDefaults]setObject:lastRequestDate forKey:@"lastRequestDate"];
        
        mgr=[self LYC_Posted:url params:params success:success failure:failure andProgressView:progressView progressViewText:text progressViewType:ViewState ViewController:controller];
    }
    return mgr;
}

- (NSDate *)datafromString:(NSString *)string{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *date =[dateFormat dateFromString:string];
    return date;
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSString *currentDateStr = [dateFormat stringFromDate:date];
    
    return currentDateStr;
    
}


- (AFHTTPSessionManager *)LYC_Posted:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure andProgressView:(UIView *)progressView progressViewText:(NSString *)text progressViewType:(LYCStateViewState )ViewState ViewController:(LYCBaseViewController *)controller{
    
    AFHTTPSessionManager *mgr = [self initialmanager];
    
        if(progressView){//需要加载动画的页面
            
            LYCStateViews *hud = [LYCStateViews LYCshowStateViewTo:progressView withState:ViewState andTest:text];
            
            // 2.发送POST请求
            [mgr POST:url parameters:params success:^(NSURLSessionDataTask *operation, id responseObj) {
                
                [hud LYCHidStateView];
                
                if([responseObj[@"code"] isEqual:@(107)]){
                    
                    lastLogOutDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastLogOutDate"];
                    NSDate * lastDateFormmate = [self datafromString:lastLogOutDate];
                    NSDate *dateNow = [NSDate date];
                    NSTimeInterval interVal = [dateNow timeIntervalSinceDate:lastDateFormmate];
                    if(controller){
                        if(interVal>1||!lastDateFormmate){
                            
                            lastLogOutDate = [self stringFromDate:dateNow];
                            [[NSUserDefaults standardUserDefaults]setObject:lastLogOutDate forKey:@"lastLogOutDate"];
                            [MBProgressHUD showWithText:@"您已在其他设备登录,此设备将退出登录"];
                            [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserInfoKey];
                            LoginViewController *login = [[LoginViewController alloc]init];
                            login.needDissmiss = YES;
                            [controller.navigationController pushViewController:login animated:YES];
                        }
                    }
                    
                }else if(success) {
                    success(responseObj);
                }
                
                
                
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                
                [hud LYCHidStateView];
                
                if (failure) {
                    failure(error);
                }

            }];
            
        }else{//不需要加载动画的页面
            
            [mgr POST:url parameters:params success:^(NSURLSessionDataTask *operation, id responseObj) {
                
                if([responseObj[@"code"] isEqual:@(107)]){
                    lastLogOutDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastLogOutDate"];
                    NSDate * lastDateFormmate = [self datafromString:lastLogOutDate];
                    NSDate *dateNow = [NSDate date];
                    NSTimeInterval interVal = [dateNow timeIntervalSinceDate:lastDateFormmate];
                    if(controller){
                        if(interVal>1||!lastDateFormmate){
                            lastLogOutDate = [self stringFromDate:dateNow];
                            [[NSUserDefaults standardUserDefaults]setObject:lastLogOutDate forKey:@"lastLogOutDate"];
                            [MBProgressHUD showWithText:@"您已在其他设备登录,此设备将退出登录"];
                            [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserInfoKey];
                            LoginViewController *login = [[LoginViewController alloc]init];
                            login.needDissmiss = YES;
                            [controller.navigationController pushViewController:login animated:YES];
                        }
                    }
                }else if(success) {
                    success(responseObj);
                }
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                
                if (failure) {
                    failure(error);
                }
            }];
        }

    return mgr;
}


- (AFHTTPSessionManager *)initialmanager{
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr setSecurityPolicy:policy];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    mgr.responseSerializer = response;
    [mgr.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        return parameters;
    }];
    
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/html"];
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
    mgr.responseSerializer = jsonResponseSerializer;
    
    // 证书
    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    //    NSSet * cerSet = [NSSet setWithObjects:cerData, nil];
    NSArray *cerSet = [NSArray arrayWithObject:cerData];
    // https签名验*****br />
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    
    [securityPolicy setPinnedCertificates:cerSet];
    
    [mgr setSecurityPolicy:securityPolicy];
    
    return mgr;
}

@end
