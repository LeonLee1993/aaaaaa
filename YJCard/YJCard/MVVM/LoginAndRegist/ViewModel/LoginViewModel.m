//
//  LoginViewModel.m
//  YJCard
//
//  Created by paradise_ on 2017/9/1.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LoginViewModel.h"
#import "LYCBaseTabBarController.h"
#import "LYCBaseViewController.h"
#import "UIDevice+IdentifierAddition.h"
#import "AppDelegate.h"
#import <sys/utsname.h>
#import "GPUUIDManager.h"

struct utsname systemInfo;

@implementation LoginViewModel

- (instancetype)init
{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}


// 初始化操作
- (void)setUp
{
//    // 1.处理登录点击的信号
//    _loginEnableSiganl = [RACSignal combineLatest:@[RACObserve(self, account),RACObserve(self, pwd)] reduce:^id(NSString *account,NSString *pwd){
//        return @(account.length && pwd.length);
//    }];
    
    // 2.处理登录点击命令
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // block:执行命令就会调用
        // block作用:事件处理
        // 发送登录请求
//        NSLog(@"发送登录请求");
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 发送数据
                
                // 显示蒙版
                if(self.account.length>0&&self.pwd.length>0){
                    
                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                    NSMutableDictionary * mutDic = @{}.mutableCopy;
                    [mutDic setObject:self.dataString forKey:@"mobileverifyid"];//验证码的data值
                    [mutDic setObject:self.account forKey:@"mobile"];//手机号
                    [mutDic setObject:self.pwd forKey:@"verifycode"];//验证码
//                    [mutDic setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"uuid"];//唯一码
                    [mutDic setObject:[GPUUIDManager getUUID] forKey:@"uuid"];//唯一码

                    [mutDic setObject:[infoDictionary objectForKey:@"CFBundleShortVersionString"] forKey:@"appversion"];//应用版本号
                    [mutDic setObject:[self iphoneType] forKey:@"device"];//设备名称
                    [mutDic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osversion"];//操作系统版本
                    [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.longitude] forKey:@"lng"];//经度
                    [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.latitude] forKey:@"lat"];//纬度
                    NSString *BaiduPushString = [[NSUserDefaults standardUserDefaults] objectForKey:@"BaiduPushDeviceToken"];
                    [mutDic setObject:BaiduPushString.length>0?BaiduPushString:@"" forKey:@"devicetoken"];//纬度
//                    NSLog(@"%@",BaiduPushString);
                    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
                    
                    self.SelfVC.mgr = [[LYCNetworkManager manager]LYC_Post:[NSString stringWithFormat:@"%@%@",GlobelHeader,Login] params:requestStr success:^(id json) {
                        if([json[@"code"] isEqual:@(100)]){
                            
                            if(_needDissmiss){
                                [self.SelfVC.navigationController popViewControllerAnimated:YES];
                            }else{
                                LYCBaseTabBarController * rootVc = [[LYCBaseTabBarController alloc] init];
                                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                delegate.window.rootViewController = rootVc;
                            }
                            
                            NSDictionary * dic = json[@"data"];
                            NSMutableDictionary * mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                            [mutDic setObject:self.account forKey:UserTelNum];
                            [mutDic removeObjectForKey:@"lastTimeDeviceToken"];
                            [[NSUserDefaults standardUserDefaults]setObject:mutDic forKey:UserInfoKey];
                            [subscriber sendNext:@"请求登录的数据"];
                        }else{
                            [MBProgressHUD showWithText:json[@"msg"]];
                        }
                        
                    } failure:^(NSError *error) {
                        NSLog(@"%@",error);
                    } andProgressView:self.SelfVC.view progressViewText:@"登录中" progressViewType:LYCStateViewLoad ViewController:self.SelfVC];
                    
                }else{
                    if(![NSString isMobileNumber:self.account]){
                        [MBProgressHUD showWithText:@"请输入正确电话号码"];
                    }else if (self.pwd==0){
                        [MBProgressHUD showWithText:@"请输入验证码"];
                    }
                }
                
                [subscriber sendCompleted];
            });
            
            return nil;
            
        }];
    }];
    
    // 4.处理登录执行过程
    [[_loginCommand.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
//            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            // 隐藏蒙版 
//            NSLog(@"执行完成");
        }
        
    }];
    
    
}

- (NSString *)iphoneType {
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])   return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])  return @"iPhone Simulator";
    
    return platform;
}




@end
