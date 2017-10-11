//
//  HDStockHeader.h
//  HDStock
//
//  Created by hd-app02 on 16/11/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#ifndef HDStockHeader_h
#define HDStockHeader_h

//断点调试打印
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d  \t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//获取屏幕坐标／尺寸
#define CGRM(X,Y,W,H) CGRectMake(X, Y, W, H)
#define CGMAX_X(frame) CGRectGetMaxX(frame)
#define CGMAX_Y(frame) CGRectGetMaxY(frame)
#define CGMID_X(frame) CGRectGetMidX(frame)
#define CGMID_Y(frame) CGRectGetMidY(frame)
#define CGMIN_X(frame) CGRectGetMinX(frame)
#define CGMIN_Y(frame) CGRectGetMinY(frame)
#define CGWIDTH(frame) CGRectGetWidth(frame)
#define CGHEIGHT(frame) CGRectGetHeight(frame)

// 状态栏高度大于20（热点被连接时）
#define STATUS_BAR_BIGGER_THAN_20 [UIApplication sharedApplication].statusBarFrame.size.height > 20

#define BLACK_BGVIEW_ALPHA 0.3
//导航条/分栏条高度
//横屏状态
#define NAV_STATUS_LANDSCAPE_HEIGHT 52.0f
#define NAV_LANDSCAPE_HEIGHT 32.0f
//竖屏状态
#define NAV_STATUS_HEIGHT 64.0f
#define NAV_HEIGHT 44.0f
#define STATUS_HEIGHT 20.0f
#define TABBAR_HEIGHT 49.0f
#define NAV_STATUS_TABBAR_HEIGHT 113.0f

//验证超时时间
#define CHECK_OVERTIME 60

//屏幕尺寸
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_SIZE_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_SIZE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SIZE_WIDTH_HALF [UIScreen mainScreen].bounds.size.width/2

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define FontSize 14.0f
#define Font_Max_Size 17.0f
#define NAV_My 44.0f
#define NAV_FONT 16.0f
#define NAV_TITLE_COLOR [UIColor whiteColor]

//适配
#define FITWIDTHBASEONIPHONEPLUS SCREEN_WIDTH / iphone6p_7p_width
#define FITHEIGHTBASEONIPHONEPLUS SCREEN_HEIGHT / HEIGHT_6p

#define FITWIDTHBASEONIPHONE SCREEN_WIDTH / iphone6_6s_7_7s_width
#define FITHEIGHTBASEONIPHONE SCREEN_HEIGHT / HEIGHT_6s

//字体大小
#define systemFont(thyFont) [UIFont systemFontOfSize:thyFont]
#define boldSystemFont(thyFont) [UIFont boldSystemFontOfSize:thyFont]

#define GolbleFont [UIFont systemFontOfSize:16]

#define arcColor UICOLOR(arc4random()%300, arc4random()%300, arc4random()%300, 1.0)
//颜色
#define COLOR(color) [UIColor color];
/**自定义的灰色字体*/
#define TEXT_GRAY_COLOR UICOLOR(102, 102, 102, 1)
/**自定义的轻灰色字体*/
#define TEXT_LIGHTGRAY_COLOR UICOLOR(153, 153, 153, 1)
//loginCodeColor
#define codeColor RGBCOLOR(26, 121, 202)

/**自定义的黑色字体*/
#define TEXT_COLOR UICOLOR(51, 51, 51, 1.0)
#define BTN_TITLE_COLOR UICOLOR(55, 79, 168, 1)
#define PLACEHOLDER_COLOR UICOLOR(153, 153, 153, 1)
#define BGVIEW_COLOR UICOLOR(245, 245, 245, 1)
#define GRAY_LINE_COLOR UICOLOR(221, 221, 221, 1)
#define MAIN_COLOR UICOLOR(212, 45, 73, 1)

#define BACKGROUNDCOKOR [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]
//导航栏颜色
#define NAVCOLOR  UICOLOR(212, 45, 73, 1)

//黄色
#define YELLOW_COLOR [UIColor colorWithRed:255.0/255.0 green:190.0/255.0 blue:0.0/255.0 alpha:1.0]
//线(灰)
#define LINE_COLOR [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0]
//类似黑色字体
#define BLACK_COLOR [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0]
//三原色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define UICOLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//固定颜色
#define commeTextColor [UIColor colorWithRed:117 / 255.0 green:117 /255.0 blue:117 / 255.0 alpha:1]
#define groupFirstTextColor [UIColor colorWithRed:128 / 255.0 green:128 /255.0 blue:128 / 255.0 alpha:1]
#define commeColor [UIColor colorWithRed:203 / 255.0 green:52 /255.0 blue:0 alpha:1]
#define commeBackgroudColor [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1]

#define commonBlueColor [UIColor colorWithRed:0.094 green:0.706 blue:0.898 alpha:1.00]

#define OrangerColor [UIColor colorWithRed:255 / 255.0 green:63 / 255.0 blue:0 / 255.0 alpha:1.000]
#define Size_lable_color [UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1]
#define TextColor [UIColor colorWithRed:253 / 255.0 green:96 / 255.0 blue:18 / 255.0 alpha:1]
#define SELECTED_COLOR [UIColor colorWithRed:0.125 green:0.545 blue:0.686 alpha:1.00]
#define BACkGROUNDColor [UIColor colorWithWhite:0.965 alpha:1.000]

#define UNSELECTED_COLOR [UIColor colorWithRed:0.161 green:0.710 blue:0.890 alpha:1.00]

#define PCBackColor RGBCOLOR(243, 243, 243)

//图片的渲染
#define imageNamed(imageName) [UIImage imageNamed:imageName]

//UIImageRenderingModeAutomatic  根据图片的使用环境和所处的绘图上下文自动调整渲染模式
#define automaticImageNamed(imageName) [[UIImage imageNamed:imageName] imageWithRenderingMode:(UIImageRenderingModeAutomatic)]
//UIImageRenderingModeAlwaysOriginal 始终绘制图片原始状态，不使用Tint Color
#define originalImageNamed(imageName) [[UIImage imageNamed:imageName] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
//UIImageRenderingModeAlwaysTemplate 始终根据Tint Color绘制图片，忽略图片的颜色
#define templateImageNamed(imageName) [[UIImage imageNamed:imageName] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)]




//根据路径读取图片
#define IMAGE(_NAME) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:_NAME]]

//适配的屏幕以6为基准
#define WIDTH [UIScreen mainScreen].bounds.size.width/375
#define HEIGHT [UIScreen mainScreen].bounds.size.height/568

#define kScreenIphone6p [[UIScreen mainScreen] bounds].size.height>=736
#define kScreenIphone6 [[UIScreen mainScreen] bounds].size.height==667
#define kScreenIphone5 [[UIScreen mainScreen] bounds].size.height==568
#define kScreenIphone4 [[UIScreen mainScreen] bounds].size.height==480

#define HEIGHT_4s 480
#define HEIGHT_5s 568
#define HEIGHT_6s 667
#define HEIGHT_6p 736

#define upsDefaultTipHudSecond      1.5
#define upsDefaultTipHudSecondShort 0.8

#define iphone5_5c_5s_width 320
#define iphone6_6s_7_7s_width 375
#define iphone6p_7p_width 414

// 手机型号
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)


//学生端是1
#define USER_TYPE @"1"
#define DEVICE_TYPE @"1"
//设备UDID
#define IDENTIFIER_FOR_VENDOR [[UIDevice currentDevice].identifierForVendor UUIDString]

//系统版本号
#define IOS7 [[UIDevice currentDevice].systemVersion floatValue] >= 7.0
#define IOS8 [[UIDevice currentDevice].systemVersion floatValue] >= 8.0
#define IOS8_1 [[[UIDevice currentDevice] systemVersion] floatValue] >=8.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 9.0
#define IOS8_2 [[[UIDevice currentDevice] systemVersion] floatValue] >=8.2 && [[[UIDevice currentDevice] systemVersion] floatValue] < 9.0
#define IOS9 [[[UIDevice currentDevice] systemVersion] floatValue] >=9.0

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


//判断是否大于等于某个版本号
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)



/************** 接口宏 切换测试正式环境  ******************/


//测试环境
//#define MY_PLIST [[NSBundle mainBundle] pathForResource:@"config_debug" ofType:@"plist"]
#define MY_PLIST [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"]

//正式环境
//#define MY_PLIST [[NSBundle mainBundle] pathForResource:@"config_release" ofType:@"plist"]


#define GetImageSizeUrl [[NSDictionary alloc] initWithContentsOfFile:MY_PLIST][@"GetImageSizeUrl"]

//从pilist文件取数据

//内网测试网址
#define BASEURL [[NSDictionary alloc] initWithContentsOfFile:MY_PLIST][@"BASEURL"]
//web端测试环境
#define WEB_BASEURL [[NSDictionary alloc] initWithContentsOfFile:MY_PLIST][@"WEB_BASEURL"]
//互动版块内测网基本网址
#define LONGLONG_URL [[NSDictionary alloc] initWithContentsOfFile:MY_PLIST][@"LONGLONG_URL"]
//支付宝回调内网
#define ZHIFUBAO_CALLBACK [[NSDictionary alloc] initWithContentsOfFile:MY_PLIST][@"ZHIFUBAO_CALLBACK"]
//学校logo地址，阿里云上的路径 测试环境
#define SCHOOL_LOGO_URL [[NSDictionary alloc] initWithContentsOfFile:MY_PLIST][@"SCHOOL_LOGO_URL"]
//名师讲堂：视频头部地址
#define MS_VIDEO_BASEURL [[NSDictionary alloc] initWithContentsOfFile:MY_PLIST][@"MS_VIDEO_BASEURL"]
//名师讲堂：图片头部地址
#define MS_IMAGE_BASEURL [[NSDictionary alloc] initWithContentsOfFile:MY_PLIST][@"MS_IMAGE_BASEURL"]


/************** foo  ******************/

#define URLFAILED @"网络请求异常，请稍后再试"
#define LOADING @"加载中..."
#define WAITING @"请稍候..."


#define LOGINSTATE @"loginState"
#define HIDETABLEBAR @"hideTableBar"
#define ADDRESSDETAIL @"addressDetail"

//省市区缓存名
#define SSQ @"ssq1.json"
//省市区缓存状态
#define SSQSTATE @"ssqState1"

//省缓存名
#define SHENG @"sheng1.json"
//省缓存状态
#define SHENGSTATE @"shengState1"

//兼听网络状态
#define NETWORKSTATUE @"extenCheckNetWorkStatus"

/*输出宏*/
#define NSLOg(format, ...) do {                                                                          \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)

//强引用
#define WEAK_SELF       __weak __typeof(self)weakSelf=self
#define STRONG_SELF     __strong __typeof(weakSelf)strongSelf=weakSelf

//DEBUG
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d  \t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//打印当前方法的名称
#define CURRENT_FUNCTION_NAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

//keyWindow
#define CDKeyWindow [UIApplication sharedApplication].keyWindow

// 性别
#define GenderSecret         2
#define GenderMale           0
#define GenderFemale         1

/** 获取一定字号的文字size*/
#define AttributeSizeWithNameAndFont(str,font)    [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];


//获取当前用户状态
#define PCUserName @"userName"
#define PCUserPhone @"phone_number"
#define PCUserPassword @"password"
#define PCUserToken @"token"
#define PCUserState @"loginState"
#define PCUserKey @"standardUser"
#define PCUserAvatar @"avatar"
#define PCUserUid @"uid"
//行情key
#define MarketSearchDataKey @"MarketSearchDataKey"

//直播信息
#define LiveAccessKeyID @"LTAIS7AuusTfn5Lb"
#define LiveAccessKeySecret @"NPnuZnrwWwpeyMyAq6uVzpciESyBBB"

//分享
#define SHARE_APPKEY @"198abe53f60da"
#define SHARE_SECRET @"6870b5ac2be8a55c748339d26b7c3bf3"

//socket的IP和port
extern NSString * const SOCKET_IP;
extern UInt16 const SOCKET_PORT;

//通知标记
extern NSString * const QUOTATION_NOTE;

#endif /* HDStockHeader_h */
