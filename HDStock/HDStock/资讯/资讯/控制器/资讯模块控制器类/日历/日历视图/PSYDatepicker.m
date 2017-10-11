//
//  PSYDatepicker.m
//  PSYDatePicker
//

#import "PSYDatepicker.h"
//默认的内边距
static const UIEdgeInsets kDefaultInsets = {0,5.0f,0,5.0f};
//默认的星期label高度
//static const CGFloat kWeekdayLabelHeight = 36.5f;

@interface PSYDatepicker ()<UIScrollViewDelegate>{

    //系统日历类
    NSCalendar * _calendar;

    //对外只读，对内可读写
    //NSArray * _weekdayTitles;

    //显示星期几的label
    NSMutableArray * _weekdayLabels;

    //可拖动的日期视图
    UIScrollView * _datesScrollView;
    
    //日期列表每一格的宽度
    CGFloat _daysW;
    
    CGFloat _daysH;
    
    //日期视图开始的偏移量
    CGFloat _scrollStartOffsetX;

    NSMutableArray * _days;
    
    //最后点击的日期按钮
    PsyhalfImageButton * _lastSelectedDate;
    
    UIView * _weekdayBackgroudView;
    
}

//显示的日期
@property (nonatomic, strong) NSDate * selectedDate;

@end

@implementation PSYDatepicker

- (void)initPsyDatePicker{

    //欧洲日历，现用的公历
    _calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    _edgeInsets = kDefaultInsets;

    //初始化日期列表
    _datesScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    _datesScrollView.showsHorizontalScrollIndicator = NO;
    _datesScrollView.pagingEnabled = YES;
    _datesScrollView.delegate = self;
    _datesScrollView.backgroundColor = [UIColor colorWithRed:0.952941 green:0.952941 blue:0.952941 alpha:1];

    [self addSubview:_datesScrollView];
    
    _weekdayBackgroudView = [[UIView alloc]initWithFrame:CGRectZero];

    [self addSubview:_weekdayBackgroudView];
    
    _weekdayLabels = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectZero];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        [_weekdayLabels addObject:label];
        [_weekdayBackgroudView addSubview:label];
    }
    
    //[NSDate date]返回当前时间
    _selectedDate = [self dateWithOutTimeFromDate:[NSDate date]];
    
    self.weekdayTitles = [PSYDatepicker weekdayTitlesWithLocalIdentifier:nil length:2 uppercase:YES];

    self.selectedDateBackgroundImage = [PSYDatepicker imageWithColor:[UIColor redColor]];
    
    //选中日期的文本颜色为白色
    self.selectedDateTextColor = [UIColor whiteColor];
    
    self.dateTextColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
    
    self.outOfRangeDateTextColor = [UIColor colorWithWhite:0.8f alpha:1];
    
    self.dateTextFont = [UIFont systemFontOfSize:14];
    
    self.weekdayTextFont = [UIFont systemFontOfSize:14];
    
    self.weekdayTitleColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
    
}

#pragma mark -- 重写属性的set方法
- (void)setSelectedDateBackgroundColor:(UIColor *)selectedDateBackgroundColor {
    
    _selectedDateBackgroundColor = selectedDateBackgroundColor;
    self.selectedDateBackgroundImage = [PSYDatepicker imageWithColor:selectedDateBackgroundColor];
}

- (void)setSelectedDateBackgroundImage:(UIImage *)selectedDateBackgroundImage {
    _selectedDateBackgroundImage = selectedDateBackgroundImage;
    
    //setNeedsLayout会默认调用layoutSubViews，处理子视图中的一些数据
    [self setNeedsLayout];
}

//设个日历选择器的边缘内边距
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets{

    _edgeInsets = edgeInsets;
    [self setNeedsLayout];
}

- (void)setWeekdayBackgroundColor:(UIColor *)weekdayBackgroundColor{

    _weekdayBackgroundColor = weekdayBackgroundColor;
    
    _weekdayBackgroudView.backgroundColor = _weekdayBackgroundColor;
}

- (void)setWeekdayTitleColor:(UIColor *)weekdayTitleColor{

    _weekdayTitleColor = weekdayTitleColor;
    for (int i = 0; i < 7; i++) {
        ((UILabel *)_weekdayLabels[i]).textColor = _weekdayTitleColor;
    }

}

- (void)setWeekdayTitles:(NSArray *)weekdayTitles{

    //这个宏用于确认一个 Objective-C 的方法的有效性。简单提供参数作为条件就行。该宏评估这个参数，如果为 false ，它就打印一个错误日志信息，该信息包含了参数并且抛出一个异常。
    NSParameterAssert(weekdayTitles.count == 7);
    
    _weekdayTitles = weekdayTitles;
    for (int i = 0; i < 7; i++) {
        ((UILabel *)_weekdayLabels[i]).text = _weekdayTitles[i];
    }

}

- (void)setWeekdayTextFont:(UIFont *)weekdayTextFont{

    _weekdayTextFont = weekdayTextFont;
    for (int i=0;i<7;i++) {
        
        ((UILabel*)_weekdayLabels[i]).font = _weekdayTextFont;
        
    }

}

#pragma mark -- life circle

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initPsyDatePicker];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self initPsyDatePicker];
    }
    return self;
}

- (void)layoutSubviews{

    _daysH = self.frame.size.height/2.0f;
    
    _datesScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    _daysW = (self.frame.size.width - (_edgeInsets.left + _edgeInsets.right)) / 7.0f;

    _weekdayBackgroudView.frame = CGRectMake(0, _daysH, self.frame.size.width, _daysH);
    
    for (int i = 0; i < 7; i++) {
        
        UILabel * label = _weekdayLabels[i];
        
        label.frame = CGRectMake(_edgeInsets.left + _daysW * i, 0, _daysW, _daysH);
    }
    
    [self recenter];

}

//界面显示的日期
- (void)recenter{

    for (UIView * view in _datesScrollView.subviews) {
        
        [view removeFromSuperview];
    }

    //存放要获取的一个时间段
    _days = [NSMutableArray array];
    
    //要显示的日期前一周
    NSInteger fromIndex = -1;
    
    //要显示的日期后一周
    NSInteger toIndex = 1;

    //如果定义了开始日期
    if (_startDate) {
        
        //初始化一个components对象，一个NSDateComponents对象本身是毫无意义的;你需要知道它是针对什么日历解释，你需要知道它的值是否是正整数和值是多少。NSDateComponents的实例不负责回答关于一个日期以外的信息，它是需要先初始化的。例如，如果你初始化一个对象为2004年5月6日，其星期几NSUndefinedDateComponent，不是星期四。要得到正确的星期几，你必须创建一个NSCalendar日历实例，创建一个NSDate对象并使用dateFromComponents：方法，然后使用components:fromDate:检索平周几
        NSDateComponents * components = [[NSDateComponents alloc]init];
        
        components.weekOfYear = -1;
        
        //拿到当前日期前一周的日期
        NSDate * prevDate = [_calendar dateByAddingComponents:components toDate:_selectedDate options:0];

        //如果这个日期和开始日期相比较，这个日期小于起始日期,就将这个日期所在周设定为当前显示周，否则忽略
        if ([prevDate compare:_startDate] == NSOrderedAscending) {
            //将开始下标设为0，表示日历选择器从选中日期所在这一周开始
            fromIndex = 0;
        }
        
    }
    //如果定义了结束日期
    if (_endDate) {
        
        NSDateComponents * components = [[NSDateComponents alloc]init];
        components.weekOfYear = 1;
        NSDate * nextDate = [_calendar dateByAddingComponents:components toDate:_selectedDate options:0];

        if ([nextDate compare:_endDate] == NSOrderedDescending) {

            toIndex = 0;
        }
    }

    //下标总是从-1到1，如果从-1开始，证明前面还有整周（不包含起始日），将其加进来，如果从0开始，表示前面还有一周（包含起始日）
    for (NSInteger i = fromIndex; i <= toIndex; i ++) {
        
        //获得要显示的所有的日期数
        NSArray * days = [self daysForWeekAtIndex:i];
        
        //循环遍历数组中的日期，创建按钮
        for (NSUInteger j = 0; j < days.count; j++) {
            
            PsyhalfImageButton * button = [self buttonForDate:days[j] index:_days.count];
            
            [_days addObject:days[j]];
            button.frame = CGRectMake(_edgeInsets.left + (i - fromIndex) * self.frame.size.width + j * _daysW , 0 , _daysW, _daysH + 20);
        
            if (button.selected) {
                
                _lastSelectedDate = button;
            }
            
            [_datesScrollView addSubview:button];
            
        }
    }
    
    NSInteger pages = (toIndex - fromIndex) + 1;
    
    _datesScrollView.contentSize = CGSizeMake(pages * self.frame.size.width, self.frame.size.height);
    
    _datesScrollView.contentOffset = CGPointMake(fromIndex != 0 ? self.frame.size.width : 0, 0);
    
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

    scrollView.userInteractionEnabled = NO;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSInteger dir = 0;
    
    //scrollView偏移量的变化值
    CGFloat dW = scrollView.contentOffset.x - _scrollStartOffsetX;
    
    //如果为正值，表示向后翻页
    if (dW > 0) {
        
        dir = 1;
        
    }else if(dW < 0){
    
        dir = -1;
    
    }
    
    
    if (dir != 0) {
        
        NSDateComponents * components = [[NSDateComponents alloc]init];
        components.weekOfYear = dir;
        
        //如果dir不等于0，取到选中日期之前或之后一周的日期
        NSDate * date = [_calendar dateByAddingComponents:components toDate:_selectedDate options:0];
        
        if (_startDate && [date compare:_startDate] == NSOrderedAscending) {
            
            date = _startDate;
            
        }else if (_endDate && [date compare:_endDate] == NSOrderedDescending){
        
            date = _endDate;
        
        }
        
        self.selectedDate = date;

        [self recenter];
                  
    }

    scrollView.userInteractionEnabled = YES;

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    _scrollStartOffsetX = scrollView.contentOffset.x;

}

#pragma mark -- setting
- (void)setStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate{

    NSCParameterAssert(!startDate || !endDate || [endDate compare:startDate] != NSOrderedAscending);
    
    _startDate = [self dateWithOutTimeFromDate:startDate];
    _endDate = [self dateWithOutTimeFromDate:endDate];
    
    [self setNeedsLayout];
    

}

//返回一个只有年月日的日期
- (NSDate *)dateWithOutTimeFromDate:(NSDate *)date{
    
    if (!date) {
        
        return nil;
    }
    
    //获取date中这天的年月日
    NSDateComponents * components = [_calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    //返回一个只有年月日的日期
    return [_calendar dateFromComponents:components];
    
}


- (PsyhalfImageButton *)buttonForDate:(NSDate *)date index:(NSUInteger)index{

    PsyhalfImageButton * button = [PsyhalfImageButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:self.outOfRangeDateTextColor forState:UIControlStateDisabled];
    [button setTitleColor:self.dateTextColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectedDateTextColor forState:UIControlStateSelected];
    
    [button setImage:[UIImage imageNamed:@"circular"] forState:UIControlStateSelected];
    
    [button.titleLabel setFont:self.dateTextFont];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];

    NSDateComponents *dateComponent1 = [calendar components:unitFlags fromDate:date];
    
    if ([dateComponent1 month] == [dateComponent month]&&[dateComponent1 day] == [dateComponent day]) {
        
        [button setImage:[UIImage imageNamed:@"side"] forState:UIControlStateNormal];

    }

    //如果传入的日期为选中的日期，将button设为选中状态
    button.selected = [date isEqualToDate:_selectedDate];
    
    //如果设置了起始和结束日期，并且传入的日期和其比较，设置为不能选中状态
    if ((_startDate && [date compare:_startDate] == NSOrderedAscending) || (_endDate && [date compare:_endDate] == NSOrderedDescending)) {
        
        button.enabled = NO;
    }
    button.tag = index;
    
    //拿到传入日期的号数
    NSDateComponents * components = [_calendar components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:date];

    [button setTitle:[NSString stringWithFormat:@"%ld",(long)components.day] forState:UIControlStateNormal];
    //[button setTitle:[NSString stringWithFormat:@"%ld.%ld",components.month,components.day] forState:UIControlStateNormal];

    [button addTarget:self action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)dayButtonPressed:(PsyhalfImageButton *)sender{

    _lastSelectedDate.selected = NO;
    
    sender.selected = YES;
    
    _lastSelectedDate = sender;
    
    self.selectedDate = _days[sender.tag];
    
}

//获取到下标为index的周的天数（index只能为-1，0，1，-1表示前一周，0表示当前周，1表示后一周）
- (NSArray *)daysForWeekAtIndex:(NSInteger)index{

    NSDateComponents * components = [[NSDateComponents alloc]init];
    
    //设置这个周为哪个周，当前日期所在周的前1周还是后1周
    components.weekOfYear = index;
    
    //获取到选中显示日期前后一周的日期，目的为获取当前日期所在周
    NSDate * date = [_calendar dateByAddingComponents:components toDate:_selectedDate options:0];
    
    //获取到这个日期是星期几（体统返回值周一到周日分别对应：2，3，4，5，6，7，1）
    NSDateComponents * components1 = [_calendar components:NSCalendarUnitWeekday fromDate:date];
    
    //定义这个星期几的前面在这一周有几天(对应的数字减2)
    NSInteger beforeDays = components1.weekday - 2;
    
    //如果小于0，证明为星期天，那么之前就有-1+7=6天
    if (beforeDays < 0) beforeDays = beforeDays + 7;
    
    //这个日期之后有多少天
    NSInteger afterDays = 6 - beforeDays;
    
    //定义一个结果数组，用来存储整个周的日期
    NSMutableArray * result = [NSMutableArray array];
    
    //循环取得当前日期之前的日期
    for (NSUInteger i = beforeDays; i > 0; i --) {
        NSDateComponents * days = [[NSDateComponents alloc]init];
        
        days.day = -1 * i;
        
        //获取当前日期之前几天的日期存到结果数组中
        [result addObject:[_calendar dateByAddingComponents:days toDate:date options:0]];
    }
    
    //将当前日期存到结果数组中
    [result addObject:date];
    
    //循环取得当前日期之后还有几天的日期，将日期存到结果数组中
    for (NSUInteger i = 0;i < afterDays;i ++) {
        NSDateComponents *days = [[NSDateComponents alloc] init];
        days.day = i + 1;
        [result addObject:[_calendar dateByAddingComponents:days toDate:date options:0]];
    }
    
    return result;

}

//将填充的颜色以图片形式返回
+ (UIImage *)imageWithColor:(UIColor *)color{

    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    //创建一个基于位图的上下文（context）,并将其设置为当前上下文(context),对图片放大缩小
    UIGraphicsBeginImageContext(rect.size);
    
    //获取当前的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //制定颜色
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //填充指定的矩形
    CGContextFillRect(context, rect);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (NSArray *)weekdayTitlesWithLocalIdentifier:(NSString *)localIdentifier length:(NSUInteger)length uppercase:(BOOL)uppercase{

    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    //时间格式的区域设置，如果有设置的即选设置的，没有设置的即选首选语言的区域
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:localIdentifier ? localIdentifier : [[NSLocale preferredLanguages]firstObject]];
    
    NSMutableArray * weekdayTitles = [NSMutableArray array];
    
    //获取到系统的星期几短标识
    for (NSString * str in dateFormatter.shortWeekdaySymbols) {
        
        //截取开始的一定长度的字符
        NSString * clipStr = [str substringWithRange:NSMakeRange(0, MIN(length, str.length))];
        
        //设置是否设置为大写字母
        if(uppercase){
        
            //以区域的语言来切换大小写
            clipStr = [clipStr uppercaseStringWithLocale:dateFormatter.locale];
        }
        
        [weekdayTitles addObject:clipStr];
    }
    
    //如果要将星期一作设置为一周的第一天，就需要改变数组中元素的顺序
    return [[weekdayTitles subarrayWithRange:NSMakeRange(1, 6)] arrayByAddingObjectsFromArray:[weekdayTitles subarrayWithRange:NSMakeRange(0,1)]];

    //return weekdayTitles;

}

@end
