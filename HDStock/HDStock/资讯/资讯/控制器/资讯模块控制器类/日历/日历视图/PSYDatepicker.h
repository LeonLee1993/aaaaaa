//
//  PSYDatepicker.h
//  PSYDatePicker
//


#import <UIKit/UIKit.h>
#import "PsyhalfImageButton.h"
@interface PSYDatepicker : UIView

#pragma mark -- 日历相关
//选中的日期
@property (nonatomic, strong, readonly) NSDate * selectedDate;

//日历的开始日期
@property (nonatomic, strong, readonly) NSDate * startDate;

//日历的结束日期
@property (nonatomic, strong, readonly) NSDate * endDate;

//设置可以选择的开始和结束日期
- (void)setStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;

#pragma mark -- 定制外观

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@property (nonatomic, strong) UIColor * weekdayBackgroundColor;

//一周每天的名字（例如周一，周二）
@property (nonatomic, strong) NSArray * weekdayTitles;

//标题颜色
@property (nonatomic, strong) UIColor * weekdayTitleColor;

//标题字体
@property (nonatomic, strong) UIFont * weekdayTextFont;

//日期文本颜色
@property (nonatomic, strong) UIColor * dateTextColor;

//日期文本字体
@property (nonatomic, strong) UIFont * dateTextFont;

//在可选日期范围以外的日期文本颜色
@property (nonatomic, strong) UIColor * outOfRangeDateTextColor;
//选中日期的背景图片
@property (nonatomic, strong) UIImage * selectedDateBackgroundImage;


@property (nonatomic, strong) UIColor *selectedDateBackgroundColor;

//选中日期的背景颜色
@property (nonatomic, strong) UIColor * selectedDateTextColor;

#pragma mark -- 辅助功能
//以截取的系统的周名字作为weekday的title，可指定title长度和是否大小写
+ (NSArray *)weekdayTitlesWithLocalIdentifier:(NSString *)localIdentifier length:(NSUInteger)length uppercase:(BOOL)uppercase;



@end
