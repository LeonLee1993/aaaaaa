//
//  ZHFactory.h
//  TeacherDingDong
//
//  Created by tongrui on 15/11/11.
//  Copyright © 2015年 tongrui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ZHFactory : NSObject

/**修改搜索框背景色*/
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UILabel *) createLabelWithFrame:(CGRect) frame andFont:(UIFont *) font andTitleColor:(UIColor *) titleColor title:(NSString *) title;

+ (UIWindow *) createWindow;

/** 创建图片视图，tag，image*/
+ (UIImageView *) createImageViewWithFrame:(CGRect) frame image:(UIImage *) thyImage tag:(NSInteger) thyTag;

/** 创建文本框，tag，placeHolder，textFont，placeHolderColor*/
+ (UITextField *) creteTextFiledWithFrame:(CGRect) frame tag:(NSInteger) tag textFont:(UIFont *) textFont placeHolderColor:(UIColor *) placeHolderColor placeHolder:(NSString *) placeHolder;


/** title，titleColorNormal,titleColorSelected，titleFont，bgImageNormal,bgImageSelected,thyTag */
+ (UIButton *) createBtnWithFrame:(CGRect)frame title:(NSString *)title titleFont:(UIFont *)font titleCoclorNormal:(UIColor *)titleColorNormal titleCoclorSelected:(UIColor *)titleColorSelected backgroundImageNormal:(UIImage *)bgImageNormal backgroundImageSelected:(UIImage *)bgImageSelected tag:(NSInteger) thyTag;

/**创建按钮：title，titleColor，titleFont，背景色，圆角*/
+ (UIButton *) createBtnWithFrame:(CGRect) frame title:(NSString *)title  titleFont:(UIFont *)font titleCoclor:(UIColor *)titleColor bgColor:(UIColor *) coclor cornerRadius:(CGFloat) r;

/**创建按钮：背景图片，选中图片*/
+ (UIButton *) createBtnWithFrame:(CGRect)frame bgImage:(UIImage *) imageName selectedImage:(UIImage *)selectedImage;

/**创建按钮：title，titleColor，titleFont，背景色，圆角，borderwidth，borderColor，tag*/
+(UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title titleFont:(UIFont *)font titleCoclor:(UIColor *)titleColor bgColor:(UIColor *)bgCoclor cornerRadius:(CGFloat)r borderwidth:(CGFloat) borderwidth borderColor:(UIColor *) borderColor tag:(NSInteger) tag;

/**重置验证按钮*/
+ (void) resetYanZhengBtnWithCheckNum:(NSInteger) timerNum Btn:(UIButton *) sender Timer:(NSTimer *) thyTimer;
/**设置时间格式*/
+ (NSString *) setDateFormatWithDateFormatStr:(NSString *) dateFormatStr;

/**设置电话安全模式137******78*/
+ (NSString *)yinChangPhoneNum:(NSString *)phoneNum;

/**日期格式化*/
+ (NSString *) createDateStrWithString:(NSString *) dateFormateStr;

/**获取当前时间时间戳*/
+(NSString *)getNowTimeCuo;


/**转换字典里的字段，以适应封装的表格取数据*/
+ (NSDictionary *) changeDicContaintWithName:(NSString *) nameStr andCodeStr:(NSString *) codeStr andDic:(NSDictionary *) dic;

//获取图片拼接
+ (NSURL *)getImageUrlWithString:(NSString *)imageStr isYuanTu:(BOOL)isYuantu;

/**字符串asscII码排序*/
+ (NSArray *) sorteCharacterWithArr:(NSArray *) tempArr;

/**计算字符串宽高*/
+(CGSize)strSize:(NSString *)str withMaxSize:(CGSize)size withFont:(UIFont *)font withLineBreakMode:(NSLineBreakMode)mode;

/**数组转字符串*/
+ (NSString *) arrToJsonStr:(NSArray *) arr;

/** 获取当前时间戳*/
+ (NSString *) getCurrentDateStr;

/** 把时间转化成时分秒*/
+ (NSString *) strTransferData:(NSString *)time;

//把时间差转化成时分秒
+ (NSString *)timeFormatted:(int)totalSeconds;

//把时间戳转换成时间格式
+ (NSString *)timeCuoToTimeData:(NSString *)timeCuo;

//把时间戳转换成时间格式
+ (NSString *)timeCuoToTimeDataShort:(NSString *)timeCuo;

/** 时间戳字符串数组排序*/
+ (NSArray *) compareTimeCuoStrWithArr:(NSArray *) originalArray;

+ (NSString *)getRandowFromZimu;

/**清除缓存*/
+ (NSString *)cacheStringWithSDCache:(NSInteger)cacheSize;

//用扬声器播放语音
+ (void)setPlayAVAudioYangShengQi;

/**封装空状态视图PlaceholderImageIndex：0庭审，1我的动态，2活动，3我的瞬间，4查询历史，5成绩管理，6提现记录，7课程表*/
+(UIView *) createDefaultStatusViewWithBgViewFrame:(CGRect) bgViewFrame PlaceholderImageIndex:(NSInteger ) holderImageIndex LabelFont:(NSInteger) font LabelTextColor:(UIColor *) textColor Title:(NSString *) title;

//判断密码格式：字母，数字，特殊字符，不包含中文
+ (BOOL ) checkPasswordStyeWithStr:(NSString *) passwordStr;

/**四舍五入：number:需要处理的数字， position：保留小数点第几位*/
+(NSString *)roundUp:(float)number afterPoint:(int)position;


/**判断各省最高分*/
+ (NSString *) judgeProvinceScoreWithStr:(NSString *) str;
/**判断是否为纯数字*/
+ (BOOL)isPureInt:(NSString*)string;
/**判断分数是否为负数*/
+ (BOOL) judgeScoreIsBelowZeroWithStr:(NSString *) str;

/**清除网页的缓存*/
+ (void) clearWebCookies;

///** 获取字体size*/
//+ (CGSize *) getAttributeSizeWithName:(NSString *) name andFont:(UIFont *) font;

//从本地plist读数据
+ (NSDictionary *) readPlistWithPlistName:(NSString *) plistStr;
+ (NSArray *)readPlistArrayWithPlistName:(NSString *)plistStr ;
+ (NSMutableDictionary *)readPlistWithPlistNameReturnMutableDictionary:(NSString *)plistStr;

+ (NSAttributedString *) getAttriStrWithTitleFont:(UIFont *)font titleColor:(UIColor *)color image:(UIImage *)image titleFontRange:(NSRange)fontRange imageIndex:(NSInteger)imageIndex title:(NSString *)titleStr;

//给按钮画虚线
+ (void) getBtnXuXian:(UIButton *) sender;


/**通过状态栏获取网络状态：1,2,3://@"2G"//@"3G"//@"4G",5:wifi,default:NO-WIFI,代表未知网络*/
+ (NSInteger) checkNetStatusFromStatusBar;

/**通过状态栏获取网络状态:-1:没有网：1:wifi,2：手机自带网*/
+ (void) checkNetStatusFromNetworkingBlock:(void(^)(NSInteger netType)) netTypeBlock;

/** 处理标签字符串中的空格,换行,/t(制表符)等*/
+ (NSString *)replaceStringWithString :(NSString *)str;

@end







