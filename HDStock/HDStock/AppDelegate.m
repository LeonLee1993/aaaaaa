//
//  AppDelegate.m
//  HDStock
//
//  Created by hd-app02 on 16/11/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "AppDelegate.h"

#import "CDAFNetWork.h"

#import "HDLeftMainViewController.h"
#import "HDLeftPersonalViewController.h"

#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import <CommonCrypto/CommonDigest.h>

#define WeiboSDK_KEY @"1699319974"


//JPush
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max 
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<JPUSHRegisterDelegate, HDGuidanceViewControllerDelegate>

@end

@implementation AppDelegate{
    HDLeftPersonalViewController *rootViewController;
}

// 设置一个C函数，用来接收崩溃信息
void UncaughtExceptionHandler(NSException *exception){
    // 可以通过exception对象获取一些崩溃信息，我们就是通过这些崩溃信息来进行解析的，例如下面的symbols数组就是我们的崩溃堆栈。
    NSArray *symbols = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSLog(@"name--%@,reason--%@,symbols--%@",name,reason,symbols);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.netStatu = [CDAFNetWork checkingNetwork];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = COLOR(whiteColor);
    [self setGuidance];
    //[self setLeftPersonalView];
//    [self setIM];
    
    [self setJPushWithLauchOptions:launchOptions];
    
    
    
    
    UILocalNotification *localNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    NSLog(@"%@",localNotification);
    [WeiboSDK registerApp: WeiboSDK_KEY];//weiboSDK
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);

    //注册shareSDK分享
    [HDShareCustom registShareSDK];
    
    return YES;
}

#pragma mark -- JPush
-(void)setJPushWithLauchOptions:(NSDictionary *)launchOptions{
    // Required
    // notice: 3.0.0及以后版本注册可以这样写,也可以继续 旧的注册 式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加 定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService setupWithOption:launchOptions appKey:appkeyOfJpush
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
            
        }
    }];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    [JPUSHService setTags:[NSSet setWithObject:@"股博士1"] alias:nil callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

- (void)tagsAliasCallback:(int)isRecode tags:(NSSet *)tags alias:(NSString *)alias{
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
    }
    else {
        // 判断为本地通知
        
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else {
        // 判断为本地通知
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];

}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {

    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LocalNotification" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    
//    NSDictionary* dic = [[NSDictionary alloc]init];
//    dic = notification.userInfo;
    
}


#pragma mark --- 设置左滑
- (void)setLeftPersonalView{
    //抽屉
    HDLeftMainViewController *leftVc = [[HDLeftMainViewController alloc] init];
    UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *rootTab = [stroyboard instantiateInitialViewController];
    self.mainVc = rootTab;
    self.leftSideVc = [[HDLeftPersonalViewController alloc] initWithLeftViewController:leftVc andMainViewController:self.mainVc];
    self.window.rootViewController = self.leftSideVc;
    //self.window.rootViewController = guide;
    [self.window makeKeyAndVisible];
    
}

////实现分享跳转页面
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    
//    NSLog(@"1url = %@   [url host] = %@",url,[url host]);
//    
//    if (url != nil && [[url host] isEqualToString:@"safepay"]) {
//        //支付宝处理
//        //        [self parse:url application:application];
//        
//        return YES;
//    }
//    else{
////        return [ShareSDK]
//        //第三方分享处理
//        return [ShareSDK handleOpenURL:url wxDelegate:self];
//    }
//}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    NSLog(@"2url = %@   [url host] = %@",url,[url host]);
//    
//    if (url != nil && [[url host] isEqualToString:@"safepay"]) {
//    }
//    else{
//        return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
//    }
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UIApplication *app = [UIApplication sharedApplication];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    [app registerUserNotificationSettings:settings];
    app.applicationIconBadgeNumber = 0;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    UIApplication *app = [UIApplication sharedApplication];
    
    // iOS 8 系统要求设置通知的时候必须经过用户许可。
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    [app registerUserNotificationSettings:settings];
    app.applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - 指定屏幕可旋转
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (_allowRotation == 1) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}
// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    if (_allowRotation == 1) {
        return YES;
    }
    return NO;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"HDStock"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark -- 引导页
- (void)setGuidance{
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSLog(@"第一次启动");
        //引导页
        UIWindow * guideWindow = [[UIWindow alloc]initWithFrame:SCREEN_BOUNDS];
        guideWindow.backgroundColor = COLOR(whiteColor);
        HDGuidanceViewController * guide = [[HDGuidanceViewController alloc]init];
        guide.delegate = self;
        self.window.rootViewController = guide;
        [self.window makeKeyAndVisible];
    }else{
        NSLog(@"不是第一次启动");
        [self setLeftPersonalView];
    }
    
    
    

}

- (void)turnToTabBarController{

    [self setLeftPersonalView];
    


}
@end
