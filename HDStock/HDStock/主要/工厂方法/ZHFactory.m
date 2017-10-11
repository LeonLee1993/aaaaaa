//
//  ZHFactory.m
//  TeacherDingDong
//
//  Created by tongrui on 15/11/11.
//  Copyright © 2015年 tongrui. All rights reserved.
//

#import "ZHFactory.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@implementation ZHFactory

//修改搜索框背景色
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma park - label
+ (UILabel *) createLabelWithFrame:(CGRect) frame andFont:(UIFont *) font andTitleColor:(UIColor *) titleColor title:(NSString *) title {
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.text = title;
    titleLabel.font = font;
    titleLabel.textColor = titleColor;
    return titleLabel;
}

+ (UIWindow *)createWindow {
    UIWindow * window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    return window;
}

+ (UIImageView *) createImageViewWithFrame:(CGRect) frame image:(UIImage *) thyImage tag:(NSInteger) thyTag {
    UIImageView * tempImageView= [[UIImageView alloc] initWithFrame:frame];
    tempImageView.image = thyImage;
    tempImageView.tag = thyTag;
    return tempImageView;
}

#pragma mark - 创建文本框，tag，placeHolder，textFont，placeHolderColor
+ (UITextField *) creteTextFiledWithFrame:(CGRect) frame tag:(NSInteger) thyTag textFont:(UIFont *) textFont placeHolderColor:(UIColor *) placeHolderColor placeHolder:(NSString *) placeHolder {
    
    UITextField * tempF = [[UITextField alloc] initWithFrame:frame];
    tempF.tag = thyTag;
    tempF.placeholder = placeHolder;
    tempF.font = textFont;
    [tempF setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    return tempF;
}

#pragma mark - 创建按钮：title，titleColorNormal,titleColorSelected，titleFont，bgImageNormal,bgImageSelected,thyTag
+ (UIButton *) createBtnWithFrame:(CGRect)frame title:(NSString *)title titleFont:(UIFont *)font titleCoclorNormal:(UIColor *)titleColorNormal titleCoclorSelected:(UIColor *)titleColorSelected backgroundImageNormal:(UIImage *)bgImageNormal backgroundImageSelected:(UIImage *)bgImageSelected tag:(NSInteger) thyTag {
    
    UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = frame;
    btn.titleLabel.font = font;
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn setBackgroundImage:bgImageNormal forState:(UIControlStateNormal)];
    [btn setBackgroundImage:bgImageSelected forState:(UIControlStateSelected)];
    [btn setTitleColor:titleColorNormal forState:(UIControlStateNormal)];
    [btn setTitleColor:titleColorSelected forState:(UIControlStateSelected)];
    btn.tag = thyTag;
    return btn;
}

#pragma mark - 创建按钮：title，titleColor，titleFont，背景色，圆角
+(UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title titleFont:(UIFont *)font titleCoclor:(UIColor *)titleColor bgColor:(UIColor *)bgCoclor cornerRadius:(CGFloat)r {
    
    UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = frame;
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn setTitleColor:titleColor forState:(UIControlStateNormal)];
    btn.titleLabel.font = font;
    [btn setBackgroundColor:bgCoclor];
    btn.layer.cornerRadius = r;
    btn.layer.masksToBounds = YES;
    return btn;
}
#pragma mark - 创建按钮：背景图片，选中图片
+ (UIButton *)createBtnWithFrame:(CGRect)frame bgImage:(UIImage *)imageName selectedImage:(UIImage *)selectedImage {
    
    UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = frame;
    [btn setBackgroundImage:imageName forState:(UIControlStateNormal)];
    [btn setBackgroundImage:selectedImage forState:(UIControlStateSelected)];
    return btn;
}
#pragma mark - 创建按钮：title，titleColor，titleFont，背景色，圆角，borderwidth，borderColor，tag
+(UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title titleFont:(UIFont *)font titleCoclor:(UIColor *)titleColor bgColor:(UIColor *)bgCoclor cornerRadius:(CGFloat)r borderwidth:(CGFloat) borderwidth borderColor:(UIColor *) borderColor tag:(NSInteger) thyTag{
    
    UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = frame;
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn setTitleColor:titleColor forState:(UIControlStateNormal)];
    btn.titleLabel.font = font;
    [btn setBackgroundColor:bgCoclor];
    btn.layer.cornerRadius = r;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = borderwidth;
    btn.layer.borderColor = borderColor.CGColor;
    btn.tag  = thyTag;
    return btn;
}

////重置验证按钮
+ (void) resetYanZhengBtnWithCheckNum:(NSInteger) timerNum Btn:(UIButton *) sender Timer:(NSTimer *) thyTimer{
    timerNum = CHECK_OVERTIME;
    [sender setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
    sender.layer.borderColor = NAVCOLOR.CGColor;
    //    sender.titleLabel.textColor = UICOLOR(0, 153, 255, 1.0);
    [sender setTitleColor:NAVCOLOR forState:UIControlStateNormal];
    sender.userInteractionEnabled = YES;
    
    [thyTimer invalidate];
    
}
//设置时间格式
+ (NSString *) setDateFormatWithDateFormatStr:(NSString *) dateFormatStr{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:dateFormatStr];
    NSString * newFormatDate = [dateformat stringFromDate:date];
    return newFormatDate;
}

+ (NSString *)yinChangPhoneNum:(NSString *)phoneNum {
    NSMutableString * str;
    if (phoneNum.length == 11) {
        NSRange range = {3,6};
        str = [NSMutableString stringWithString:phoneNum];
        [str replaceCharactersInRange:range withString:@"******"];
    }
    return str;
}

+ (NSString *) createDateStrWithString:(NSString *) dateFormateStr {
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:dateFormateStr];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    NSLog(@"currentDateStr＝%@",currentDateStr);
    return currentDateStr;
}

+ (NSString *)getNowTimeCuo
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%lf",a];//转为字符型
    if (timeString.length > 10) {
        timeString = [timeString substringToIndex:10];
    }
    return timeString;
}

+ (NSDictionary *) changeDicContaintWithName:(NSString *) nameStr andCodeStr:(NSString *) codeStr andDic:(NSDictionary *) dic{
   
    //修改字典里的字段：
//    NSDictionary * dic = @{
//                           @"A":@[@{@"collegeCode":@"01",@"collegeName":@"a01大学"},@{@"collegeCode":@"02",@"collegeName":@"a02大学"}],
//                           @"B":@[@{@"collegeCode":@"03",@"collegeName":@"b03大学"},@{@"collegeCode":@"04",@"collegeName":@"b04大学"},@{@"collegeCode":@"05",@"collegeName":@"b05大学"}],
//                           @"C":@[@{@"collegeCode":@"06",@"collegeName":@"c06大学"},@{@"collegeCode":@"07",@"collegeName":@"c07大学"},@{@"collegeCode":@"08",@"collegeName":@"c08大学"},@{@"collegeCode":@"09",@"collegeName":@"c09大学"}]
//                           };

    NSMutableDictionary * sectionDic = [[NSMutableDictionary alloc] init];
    
    for (NSString * sectionStr in [dic allKeys]) {
        NSMutableArray * sectionArr = [[NSMutableArray alloc] init];//装每一组数据
        for (NSDictionary * tempDic in dic[sectionStr]) {
            NSMutableDictionary * itemDic = [[NSMutableDictionary alloc] init];
            [itemDic setObject:tempDic[nameStr] forKey:@"SUBNAME"];
            [itemDic setObject:tempDic[codeStr] forKey:@"SUBUUID"];
            [sectionArr addObject:itemDic];
        }
        [sectionDic setObject:sectionArr forKey:sectionStr];
        
    }
//    NSLog(@"%@",sectionDic);
    return [sectionDic copy];
    
}

+ (NSURL *)getImageUrlWithString:(NSString *)imageStr isYuanTu:(BOOL)isYuantu
{
//    NSArray * endPointArr = [endPoint componentsSeparatedByString:@"http://"];
//    NSString *_endPoint = [endPointArr lastObject];
    NSURL * iconUrl;
    if (isYuantu) {
       iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",GetImageSizeUrl,imageStr]];
    }else{
        iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@@80p_60q",GetImageSizeUrl,imageStr]];
    }
    NSLog(@"iconUrl=%@",iconUrl);
    return iconUrl;
}

+ (NSArray *) sorteCharacterWithArr:(NSArray *) tempArr {
    //字符串排序
    NSArray *array = [NSArray arrayWithArray:tempArr];
    NSArray *sortedArray = [array sortedArrayUsingSelector:@selector(compare:)];
    return [sortedArray copy];
}
//
+(CGSize)strSize:(NSString *)str withMaxSize:(CGSize)size withFont:(UIFont *)font withLineBreakMode:(NSLineBreakMode)mode
{//字符串宽高计算
    CGSize s;
    if (IOS7)
    {
        s = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    }
    else
    {
        s = [str sizeWithFont:font constrainedToSize:size lineBreakMode:mode];
    }
    return s;
}
+ (NSString *) arrToJsonStr:(NSArray *) arr{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}

+ (NSString *) getCurrentDateStr {
    //获取时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    int b = a;
    NSString *timeString = [NSString stringWithFormat:@"%d", b];
    
    return timeString;
}

//把时间转化成时分秒
+ (NSString *) strTransferData:(NSString *)time
{
   return [ZHFactory timeFormatted:(int)([[ZHFactory getCurrentDateStr] integerValue] - [time integerValue])];
}

//把时间差转化成时分秒
+ (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

//把时间戳转换成时间格式
+ (NSString *)timeCuoToTimeData:(NSString *)timeCuo
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeCuo integerValue]];
    return [formatter stringFromDate:date];
}

//把时间戳转换成时间格式
+ (NSString *)timeCuoToTimeDataShort:(NSString *)timeCuo
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeCuo integerValue]];
    return [formatter stringFromDate:date];
}

+ (NSArray *) compareTimeCuoStrWithArr:(NSArray *) originalArray {
//    NSArray * originalArray = @[@"123",@"2344",@"12",@"332445",@"21",@"321",@"111"];
    //block比较方法，数组中可以是NSInteger，NSString（需要转换）
    NSComparator finderSort = ^(id string1,id string2){
        
        if ([string1 integerValue] > [string2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }else if ([string1 integerValue] < [string2 integerValue]){
            return (NSComparisonResult)NSOrderedDescending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    
    //数组排序：
    NSArray *resultArray = [originalArray sortedArrayUsingComparator:finderSort];
    NSLog(@"第一种排序结果：%@",resultArray);
    return [resultArray copy];
}


+ (NSString *)getRandowFromZimu
{
    NSArray *arr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableArray *randArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i ++) {
        [randArr addObject:arr[(arc4random()%arr.count)]];
    }
    return [randArr componentsJoinedByString:@""];
}
//清除缓存
+ (NSString *)cacheStringWithSDCache:(NSInteger)cacheSize{
    
    if (cacheSize == 0) {
        return @"暂无缓存";
    }
    
    if (cacheSize > 0 && cacheSize < 1024) {
        return [NSString stringWithFormat:@"%d B",(int)cacheSize];
    }else if (cacheSize < 1024 * 1024){
        return [NSString stringWithFormat:@"%.2f KB",cacheSize / 1024.0];
    }else if (cacheSize < 1024 * 1024 * 1024){
        return [NSString stringWithFormat:@"%.2f MB",cacheSize / (1024.0 * 1024.0)];
    }else{
        return [NSString stringWithFormat:@"%.2f G",cacheSize / (1024.0 * 1024.0 * 1024.0)];
    }
    
    return nil;
}

//扬声器播放语音
+ (void)setPlayAVAudioYangShengQi
{
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
}

///**封装空状态视图PlaceholderImageIndex：0庭审，1我的动态，2活动，3我的瞬间，4查询历史，5成绩管理，6提现记录，7课程表*/
+(UIView *) createDefaultStatusViewWithBgViewFrame:(CGRect) bgViewFrame PlaceholderImageIndex:(NSInteger) holderImageIndex LabelFont:(NSInteger) font LabelTextColor:(UIColor *) textColor Title:(NSString *) title{
    
    UIView * bgView = [[UIView alloc] initWithFrame:bgViewFrame];
    bgView.backgroundColor = [UIColor whiteColor];
    
    NSInteger placeHolderIMVWidth = SCREEN_SIZE_WIDTH-15*WIDTH;
    /**封装空状态视图PlaceholderImageIndex：0庭审，1我的动态，2活动，3我的瞬间，4查询历史，5成绩管理，6提现记录，7课程表*/
    NSArray * placeholderImageArr = @[@"trial",@"dynamics",@"activity",@"instantaneous",@"history",@"achievement",@"withdrawals",@"schedule"];
    UIImageView * placeholderIMV = [[UIImageView alloc] initWithFrame:CGRM(CGRectGetWidth(bgView.frame)/2-placeHolderIMVWidth/2, CGRectGetHeight(bgView.frame)/7, placeHolderIMVWidth, placeHolderIMVWidth*25/32)];
    placeholderIMV.image = imageNamed(placeholderImageArr[holderImageIndex]);
    [bgView addSubview:placeholderIMV];
    
    NSInteger leftSpace = 30;
    NSInteger tishiLabelWidth = CGRectGetWidth(bgView.frame)-leftSpace*2;
    UILabel * tishiLabel = [self createLabelWithFrame:CGRM(leftSpace, CGRectGetMaxY(placeholderIMV.frame)-5, tishiLabelWidth, 40) andFont:[UIFont boldSystemFontOfSize:font] andTitleColor:UICOLOR(212, 212, 212, 1) title:title];
    tishiLabel.font = boldSystemFont(15);
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:tishiLabel];
    
    return bgView;
}

+ (BOOL ) checkPasswordStyeWithStr:(NSString *) passwordStr {
    //判断密码为数字，字母，特殊字符，不包含中文
    NSString *regex = @"^[^\u4e00-\u9fa5]*$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:passwordStr];
    
    return isValid;
}

//number:需要处理的数字， position：保留小数点第几位，
+(NSString *)roundUp:(float)number afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    //    [ouncesDecimal release];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

#pragma mark - 判断各省最高分
+ (NSString *) judgeProvinceScoreWithStr:(NSString *) str {
    
    NSArray * provinceNameArr = @[@"海南",@"江苏",@"上海",@"浙江"];
    NSArray * provinceScoreArr = @[@"900",@"480",@"600",@"810"];
    for (int i = 0 ;i < provinceNameArr.count ;i++) {
        if([str rangeOfString:provinceNameArr[i]].location !=NSNotFound)
        {
            return provinceScoreArr[i];
        }
    }
    return @"750";
}
+ (BOOL)isPureInt:(NSString*)string{
    if (string.length > 0) {
        NSScanner* scan = [NSScanner scannerWithString:string];
        int val;
        return [scan scanInt:&val] && [scan isAtEnd];
    }
    return NO;
}
#pragma mark - 判断分数是否为负数
+ (BOOL) judgeScoreIsBelowZeroWithStr:(NSString *) str {
    
    //    [str :0];
    NSString * rangStr = @"";
    NSRange range = NSMakeRange(0, 1);
    if (str.length > 0) {
        rangStr = [str substringWithRange:range];
    }
    
    if([rangStr rangeOfString:@"-"].location !=NSNotFound)
    {
        return YES;//是负数
    }
    if([rangStr rangeOfString:@"－"].location !=NSNotFound)
    {
        return YES;//是负数
    }
    return NO;
}

+ (void)clearWebCookies {
    //清除缓存
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}

+ (NSDictionary *)readPlistWithPlistName:(NSString *)plistStr {
    //从本地plist读数据
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path1 = [pathArray objectAtIndex:0];
    NSString *myPath = [path1 stringByAppendingPathComponent:plistStr];
    
    NSDictionary *readPlistDic = [[NSDictionary alloc] initWithContentsOfFile:myPath];
    //NSLog(@"从本地读数据readPlistArr == %@",readPlistDic);
    return readPlistDic;
}

+ (NSArray *)readPlistArrayWithPlistName:(NSString *)plistStr {
    //从本地plist读数据
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path1 = [pathArray objectAtIndex:0];
    NSString *myPath = [path1 stringByAppendingPathComponent:plistStr];
    
    NSArray *readPlistDic = [[NSArray alloc] initWithContentsOfFile:myPath];
    NSLog(@"readPlistArr == %@",readPlistDic);
    return readPlistDic;
}

+ (NSMutableDictionary *)readPlistWithPlistNameReturnMutableDictionary:(NSString *)plistStr {
    //从本地plist读数据
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path1 = [pathArray objectAtIndex:0];
    NSString *myPath = [path1 stringByAppendingPathComponent:plistStr];
    
    NSMutableDictionary *readPlistDic = [[NSMutableDictionary alloc] initWithContentsOfFile:myPath];
    //NSLog(@"从本地读数据readPlistArr == %@",readPlistDic);
    return readPlistDic;
}

+ (NSAttributedString *) getAttriStrWithTitleFont:(UIFont *)font titleColor:(UIColor *)color image:(UIImage *)image titleFontRange:(NSRange)fontRange imageIndex:(NSInteger)imageIndex title:(NSString *)titleStr {
    
    //富文本添加图片到label上
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:titleStr];
    
    [attri addAttribute:NSFontAttributeName value:font range:fontRange];
    
    // 添加表情
    NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
    attchImage.image = image;
    attchImage.bounds = CGRectMake(0, 1, 8, 8);// 设置图片大小
    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
    [attri insertAttributedString:stringImage atIndex:imageIndex];

    return [attri copy];
}

//给按钮画虚线
+ (void) getBtnXuXian:(UIButton *) sender {
    
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [UIColor grayColor].CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:sender.bounds].CGPath;
    border.frame = sender.bounds;
    border.lineWidth = 1.f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @3];
    border.cornerRadius = 3;
    border.masksToBounds = YES;
    [sender.layer addSublayer:border];
}


/**通过状态栏获取网络状态：-1:没有网：1:wifi,2：手机自带网*/
+ (NSInteger) checkNetStatusFromStatusBar {
    // 状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    
    NSInteger returnStatus = 0;
    if (type == 5) {
        //wifi
        NSLog(@"ZHFactory - checkNetStatusFromStatusBar - 有wifi");
        returnStatus = 1;
    }else if (type == 1 || type == 2 || type == 3){
        //手机自带网络
        NSLog(@"ZHFactory - checkNetStatusFromStatusBar - 有手机自带网络");
        returnStatus = 2;
    }else {
        NSLog(@"ZHFactory - checkNetStatusFromStatusBar - 没有网");
        returnStatus = 0;
    }
    NSLog(@"returnStatus--%ld",returnStatus);
    return returnStatus;
}
/**通过状态栏获取网络状态:-1:没有网：1:wifi,2：手机自带网*/
+ (void) checkNetStatusFromNetworkingBlock:(void(^)(NSInteger netType)) netTypeBlock {
    __block NSInteger returnStatus;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
//            NSLog(@"有wifi");
            returnStatus = 1;
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
//            NSLog(@"有手机自带网络");
            returnStatus = 2;
        }else {
//            NSLog(@"没有网");
            returnStatus = 0;
        }
        if (netTypeBlock) {
            netTypeBlock(returnStatus);
        }
    }];
    
}

// 处理标签字符串中的空格,换行,/t(制表符)等
+ (NSString *)replaceStringWithString :(NSString *)str
{
    //    \r 是回车，return
    //    \n 是换行，newline
    //    \t(制表符)
    NSString * string = [str mutableCopy];
    NSString *string1 = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""] ;
    NSString *string2 = [string1 stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@"\r" withString:@""] ;
    NSString *string4 = [string3 stringByReplacingOccurrencesOfString:@"\t" withString:@""] ;
    return string4 ;
}

@end





