//
//  ShareView.m
//  haiyibao
//
//  Created by 曹雪莹 on 2016/11/26.
//  Copyright © 2016年 韩元旭. All rights reserved.
//

#import "ShareView.h"
#import "ImageWithLabel.h"
#import "POP.h"

#define SHAREVIEW_BGCOLOR   [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1]
#define WINDOW_COLOR        [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define ANIMATE_DURATION    0.25f
#define LINE_HEIGHT         74
#define BUTTON_HEIGHT       ScreenWidth/375*56.5+4.5
#define NORMAL_SPACE        7
#define LABEL_HEIGHT		0

@interface ShareView ()

//	所有标题
@property (nonatomic, strong) NSArray  *shareBtnTitleArray;
//	所有图片
@property (nonatomic, strong) NSArray  *shareBtnImageArray;
//	整个底部分享面板的 backgroundView
@property (nonatomic, strong) UIView   *bgView;
//	分享面板取消按钮上部的 View
@property (nonatomic, strong) UIView   *topSheetView;
//	取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
//	头部提示文字Label
@property (nonatomic, strong) UILabel  *proLbl;
//	头部提示文字
@property (nonatomic, copy)   NSString *protext;
//	所有的分享按钮
@property (nonatomic, copy) NSMutableArray *buttons;

@property (nonatomic,strong) UIView *lineView;

@end

@implementation ShareView

- (instancetype)initWithShareHeadOprationWith:(NSArray *)titleArray andImageArry:(NSArray *)imageArray andProTitle:(NSString *)proTitle {
	
	self = [super init];
	if (self) {
		
		_shareBtnTitleArray = titleArray;
		_shareBtnImageArray = imageArray;
		_protext = proTitle;
		
		self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
		//	背景，带灰度
		self.backgroundColor = WINDOW_COLOR;
		//	可点击
		self.userInteractionEnabled = YES;
		//	点击背景，收起底部分享面板，移除本视图
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
		[self addGestureRecognizer:tapGesture];
		
		//	加载分享面板
		[self loadUIConfig];
	}
	return self;
}

-(UIView *)lineView{
    if(!_lineView){
    
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView.frame) - ScreenWidth/375*56.5 -4.5, CGRectGetWidth(_bgView.frame),4.5)];
        _lineView.backgroundColor = RGBColor(222,222,222);
        
    }
    return _lineView;
}

/**
 加载自定义视图，按钮的tag依次为（200 + i）
 */
- (void)loadUIConfig {
	
	[self addSubview:self.bgView];
	[self.bgView addSubview:self.topSheetView];
	[self.bgView addSubview:self.cancelBtn];
    [self.bgView addSubview:self.lineView];
	
	self.proLbl.text = _protext;
	//	按钮
	for (NSInteger i = 0; i < self.shareBtnTitleArray.count; i++) {
		
		CGFloat x = self.bgView.bounds.size.width / 5 * ( i % 5);
		CGFloat y = LABEL_HEIGHT ;
		CGFloat w = self.bgView.bounds.size.width / 5;
		CGFloat h = ScreenWidth/375*120;
		
		CGRect frame =  CGRectMake(x, y, w, h);
		ImageWithLabel *item = [ImageWithLabel imageLabelWithFrame:frame Image:[UIImage imageNamed:self.shareBtnImageArray[i]] LabelText:self.shareBtnTitleArray[i]];
        item.labelOffsetY = 6;
		
		item.tag = 200 + i;
		UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
		[item addGestureRecognizer:tapGes];
		[self.topSheetView addSubview:item];
        
		[self.buttons addObject:item];
	}
    
	//	弹出
	[UIView animateWithDuration:ANIMATE_DURATION animations:^{
		self.bgView.frame = CGRectMake(0, ScreenHeight - BUTTON_HEIGHT-4.5 - ScreenWidth/375*120, ScreenWidth, CGRectGetHeight(self.bgView.frame));
	}];
	
	//	icon 动画
//	[self iconAnimation];
}


/**
 做一个 icon 依次粗线的弹簧动画
 */
- (void)iconAnimation {
	
	CGFloat duration = 0;
	
	for (UIView *icon in self.buttons) {
		CGRect frame = icon.frame;
		CGRect toFrame = icon.frame;
		frame.origin.y += frame.size.height;
		icon.frame = frame;
		
		POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
		animation.toValue = [NSValue valueWithCGRect:toFrame];
		animation.beginTime = CACurrentMediaTime() + duration;
		animation.springBounciness = 10.0f;
		
		[icon pop_addAnimation:animation forKey:kPOPViewFrame];
		
		duration += 0.07;
	}
}

#pragma mark --------------------------- Selector

/**
 点击取消
 */
- (void)tappedCancel {
	
	[UIView animateWithDuration:ANIMATE_DURATION animations:^{
		[self.bgView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 0)];
		self.alpha = 0;
	} completion:^(BOOL finished) {
		if (finished) {
			[self removeFromSuperview];
		}
	}];
}

/**
 按钮点击

 @param tapGes 手势
 */
- (void)itemClick:(UITapGestureRecognizer *)tapGes {
	
	[self tappedCancel];
	if (self.btnClick) {
		
		self.btnClick(tapGes.view.tag - 200);
	}
}

#pragma mark --------------------------- getter

- (UIView *)bgView {
	
	if (_bgView == nil) {
		
		_bgView = [[UIView alloc] init];
		
		_bgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenWidth/375*56.5+4.5 + ScreenWidth/375*120);
	}
	return _bgView;
}

- (UIView *)topSheetView {
	
	if (_topSheetView == nil) {
		
		_topSheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bgView.frame), CGRectGetHeight(_bgView.frame) - BUTTON_HEIGHT-4.5)];
		_topSheetView.backgroundColor = [UIColor whiteColor];
		_topSheetView.alpha = 1;
		//	如果有标题，添加标题
		if (_protext.length) {
			[_topSheetView addSubview:self.proLbl];
		}
	}
	return _topSheetView;
}

- (UILabel *)proLbl
{
	if (_proLbl == nil) {
		_proLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bgView.frame), LABEL_HEIGHT)];
		//	默认标题
		_proLbl.text = @"分享至";
		_proLbl.textColor = [UIColor blackColor];
		_proLbl.backgroundColor = [UIColor whiteColor];
		_proLbl.textAlignment = NSTextAlignmentCenter;
	}
	return _proLbl;
}

- (UIButton *)cancelBtn {
	
	if (_cancelBtn == nil) {
		
		_cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_cancelBtn.frame = CGRectMake(0, CGRectGetHeight(_bgView.frame) - ScreenWidth/375*56.5, CGRectGetWidth(_bgView.frame),ScreenWidth/375*56.5);
		//	取消按钮
		[_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
		_cancelBtn.backgroundColor = [UIColor whiteColor];
		[_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		//	点击按钮，取消，收起面板，移除视图
		[_cancelBtn addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
	}
	return _cancelBtn;
}


- (NSArray *)buttons {
	
	if (!_buttons) {
		_buttons = [NSMutableArray arrayWithCapacity:5];
	}
	return _buttons;
}

#pragma mark --------------------------- User-Defined

- (void)setCancelBtnColor:(UIColor *)cancelBtnColor {
	
	[_cancelBtn setTitleColor:cancelBtnColor forState:UIControlStateNormal];
}

- (void)setProStr:(NSString *)proStr {
	
	_proLbl.text = proStr;
}

- (void)setOtherBtnColor:(UIColor *)otherBtnColor {
	
	for (id res in _bgView.subviews) {
		
		if ([res isKindOfClass:[UIButton class]]) {
			
			UIButton *button = (UIButton *)res;
			[button setTitleColor:otherBtnColor forState:UIControlStateNormal];
		}
	}
}

- (void)setOtherBtnFont:(NSInteger)otherBtnFont {
	
	for (id res in _bgView.subviews) {
		
		if ([res isKindOfClass:[UIButton class]]) {
			
			UIButton *button = (UIButton *)res;
			button.titleLabel.font = [UIFont systemFontOfSize:otherBtnFont];
		}
	}
}

- (void)setProFont:(NSInteger)proFont {
	
	_proLbl.font = [UIFont systemFontOfSize:proFont];
}

- (void)setCancelBtnFont:(NSInteger)cancelBtnFont {
	
	_cancelBtn.titleLabel.font = [UIFont systemFontOfSize:cancelBtnFont];
}

- (void)setDuration:(CGFloat)duration {
	
	self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:duration];
}

@end
