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
#import "UncaughtExceptionHandler.h"
#define WeiboSDK_KEY @"1699319974"


//JPush
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max 
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/AdSupport.h>
#import "HDGuidanceViewController.h"

#import "PSYPopOutView.h"
#import "HDGetGoldenStock.h"
#import "buiedProductListViewController.h"
#import "PCMyPlanViewController.h"
#import "buiedProductListPresentViewController.h"



@interface AppDelegate ()<JPUSHRegisterDelegate, HDGuidanceViewControllerDelegate>

@end

@implementation AppDelegate{
    HDLeftPersonalViewController *rootViewController;
}

// 设置一个C函数，用来接收崩溃信息
//void UncaughtExceptionHandler(NSException *exception){
//    // 可以通过exception对象获取一些崩溃信息，我们就是通过这些崩溃信息来进行解析的，例如下面的symbols数组就是我们的崩溃堆栈。
//    NSArray *symbols = [exception callStackSymbols];
//    NSString *reason = [exception reason];
//    NSString *name = [exception name];
//    NSLog(@"name--%@,reason--%@,symbols--%@",name,reason,symbols);
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"idfv:%@",idfv);
    
    
    [self checkVersions];
    
    self.normalScreenWidth = SCREEN_WIDTH;
    self.normalScreenHeight = SCREEN_HEIGHT;
    
    self.netStatu = [CDAFNetWork checkingNetwork];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    

    //[self setLeftPersonalView];
//    [self setIM];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = COLOR(whiteColor);
    [self setUpGuidance];
    
    
    [self setJPushWithLauchOptions:launchOptions];
    
    
    
    
    UILocalNotification *localNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    NSLog(@"%@",localNotification);
    [WeiboSDK registerApp: WeiboSDK_KEY];//weiboSDK
    //NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);

    //注册shareSDK分享
    [HDShareCustom registShareSDK];
    
//    //获取全局的域
//    NSDictionary * dic = [[NSUserDefaults standardUserDefaults]persistentDomainForName:NSGlobalDomain];
//    NSMutableDictionary * temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//    [temDic setObject:@"传递的值" forKey:@"应用1"];
//    //重设
//    [[NSUserDefaults standardUserDefaults]setPersistentDomain:temDic forName:NSGlobalDomain];
//    //同步
//    [NSUserDefaults resetStandardUserDefaults];
//    [UIAlertTool titleWithName:@"" showMessage:[temDic objectForKey:[temDic allKeys][0]] btn1:@"" btn2:@"" actionWithName:^(NSInteger buttonIndex) {
//        NSLog(@"NSUserDefaults－%@",dic);
//
//    }];
    [self localNotification:application didFinishLaunchingWithOptions:launchOptions];
    [UncaughtExceptionHandler installUncaughtExceptionHandler:YES showAlert:YES];
    return YES;
}

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}




#pragma mark  localNotification(本地推送注册)
- (void)localNotification:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) { // iOS8
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:setting];
    }
    
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        // 这里添加处理代码
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            NSLog(@"推送消息==== %@",remoteNotification);
            [self goToMssageViewControllerWith:remoteNotification];
        }
    }
}


#pragma mark
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
            [[NSUserDefaults standardUserDefaults]setObject:registrationID forKey:@"deviceToken"];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    [JPUSHService setTags:[NSSet setWithObject:@"股博士12122222"] alias:nil callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
//    NSLog(@"DeviceToken: {%@}",deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
//    [JPUSHService setBadge:badge.integerValue+1];
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        UIApplication *app = [UIApplication sharedApplication];
        
        // iOS 8 系统要求设置通知的时候必须经过用户许可。
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        
        [app registerUserNotificationSettings:settings];
        
        // 设置应用程序右上角的"通知图标"Badge
        app.applicationIconBadgeNumber +=1;
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        if([userInfo[@"jump"] isEqualToString:@"gold_stock"]){//领金股
            HDGetGoldenStock * pop = [[HDGetGoldenStock alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [self.window addSubview:pop];
        }else if([userInfo[@"jump"] isEqualToString:@"comment"]){//早晚评
            PSYPopOutView * pop = [[PSYPopOutView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [self.window addSubview:pop];
        }else if([userInfo[@"jump"] isEqualToString:@"plan"]){//投顾计划
            PCMyPlanViewController * plan = [[PCMyPlanViewController alloc]init];
            [self.window.rootViewController presentViewController:plan animated:YES completion:nil];
        }
        else if([userInfo[@"jump"] isEqualToString:@"product"]){//产品
           buiedProductListPresentViewController *list = [[buiedProductListPresentViewController alloc]init];
            if([userInfo[@"else"] isEqualToString:@"1"]){
                list.flagStr = @"1";
            }else if([userInfo[@"else"] isEqual:@"2"]){
                list.flagStr = @"2";
            }else if([userInfo[@"else"] isEqual:@"3"]){
                list.flagStr = @"3";
            }else if([userInfo[@"else"] isEqual:@"4"]){
                list.flagStr = @"4";
            }
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:list];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    
    if (application.applicationState == UIApplicationStateActive) {
        
        //这里写APP正在运行时，推送过来消息的处理
//        [self goToMssageViewControllerWith:userInfo];
        
        
    } else if (application.applicationState == UIApplicationStateInactive ) {
        
        //APP在后台运行，推送过来消息的处理
        
        [self goToMssageViewControllerWith:userInfo];
        
        
        
    } else if (application.applicationState == UIApplicationStateBackground) {
        
        //APP没有运行，推送过来消息的处理
        
        [self goToMssageViewControllerWith:userInfo];
        
    }
}

- (void)goToMssageViewControllerWith:(NSDictionary*)msgDic{
    
    //将字段存入本地，在要跳转的页面用它来判断
    
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    
    [pushJudge setObject:@"push"forKey:@"push"];
    
    [pushJudge synchronize];
    
    NSLog(@"%@",msgDic);
  
    NSString * targetStr = [msgDic objectForKey:@"target"];
    if ([targetStr isEqualToString:@"notice"]) {
        
        PSYPopOutView * pop = [[PSYPopOutView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.window addSubview:pop];
        
    }else{
        
        HDGetGoldenStock * pop = [[HDGetGoldenStock alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.window addSubview:pop];
    }
    
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@",userInfo);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
//        UILocalNotification *notification=[[UILocalNotification alloc] init];
//        if (notification!=nil) {
//    
//            NSDate *now=[NSDate new];
//            notification.fireDate=[now dateByAddingTimeInterval:6]; //触发通知的时间
//            notification.repeatInterval=0; //循环次数，kCFCalendarUnitWeekday一周一次
//    
//            notification.timeZone=[NSTimeZone defaultTimeZone];
//            notification.soundName = UILocalNotificationDefaultSoundName;
//            notification.alertBody=@"该去吃晚饭了！";
//    
//            notification.alertAction = @"打开";  //提示框按钮
//            notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
//    
//            notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字
//    
//            //下面设置本地通知发送的消息，这个消息可以接受
//            NSDictionary* infoDic = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
//            notification.userInfo = infoDic;
//            //发送通知
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        }
    
    NSLog(@" application Recieved Notification %@",notification);
    application.applicationIconBadgeNumber = 0;

}


#pragma mark - 设置左滑
- (void)setLeftPersonalView{
    
    HDLeftMainViewController *leftVc = [[HDLeftMainViewController alloc] init];
    UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *rootTab = [stroyboard instantiateInitialViewController];
    self.mainVc = rootTab;
    self.leftSideVc = [[HDLeftPersonalViewController alloc] initWithLeftViewController:leftVc andMainViewController:self.mainVc];
    self.window.rootViewController = self.leftSideVc;
    //self.window.rootViewController = rootTab;
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
    
    // iOS 8 系统要求设置通知的时候必须经过用户许可。
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    
    [app registerUserNotificationSettings:settings];
    
    // 设置应用程序右上角的"通知图标"Badge
    app.applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    UIApplication *app = [UIApplication sharedApplication];
    
    // iOS 8 系统要求设置通知的时候必须经过用户许可。
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    
    [app registerUserNotificationSettings:settings];
    
    // 设置应用程序右上角的"通知图标"Badge
    app.applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];
    
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

 //支持设备自动旋转
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

- (void)setUpGuidance{
    
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"firstStart"];
        [[NSUserDefaults standardUserDefaults] setObject:@"firstLoading" forKey:@"isfirst"];
    }
    NSInteger time = [[NSUserDefaults standardUserDefaults] integerForKey:@"firstStart"];

        if (time > 5 ) {
            HDGuidanceViewController * guide = [[HDGuidanceViewController alloc]init];
            
            guide.delegate = self;
            
            self.window.rootViewController = guide;
            
            [self.window makeKeyAndVisible];
            
            time --;
            
            [[NSUserDefaults standardUserDefaults] setInteger:time forKey:@"firstStart"];
            
        }else if(time <= 5 ){

            [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"firstStart"];

            [self turnToTabBarController];
            
        }
}


- (void)turnToTabBarController{

    [self setLeftPersonalView];

}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDWebImageManager sharedManager].imageCache clearDisk];
}

#pragma mark == 检测版本更新
- (void)checkVersions{

}

@end
