//
//  PopoverView.h
//  Embark
//
//  Created by Oliver Rickard on 20/08/2012.
//
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@class PopoverView;

@protocol PopoverViewDelegate <NSObject>

@optional

//Delegate receives this call as soon as the item has been selected
- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index;

//Delegate receives this call once the popover has begun the dismissal animation
- (void)popoverViewDidDismiss:(PopoverView *)popoverView;

- (void)popoverViewDismiss:(CGPoint )arrowPoint;

@end

@interface PopoverView : UIView

@property (nonatomic,assign) CGRect boxFrame;//弹窗大小

@property (nonatomic,assign) CGSize contentSize;//内容大小

@property (nonatomic,assign) CGPoint arrowPoint;//箭头所在的店

@property (nonatomic,assign) BOOL above;//是否在屏幕上半部


@property (nonatomic, retain) UIView *titleView;//标题视图

@property (nonatomic, retain) UIView *contentView;//内容视图

@property (nonatomic, retain) NSArray *subviewsArray;//添加到弹窗上的视图数组

@property (nonatomic, assign) id <PopoverViewDelegate> delegate;

@property (nonatomic, strong) NSArray *dividerRects;//比例区域

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;//活动指示器（进度轮）

//Instance variable that can change at runtime
//是否显示比例区域
@property (nonatomic, assign) BOOL showDividerRects;

#pragma mark - Class Static Showing Methods

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withText:(NSString *)text delegate:(id<PopoverViewDelegate>)delegate;

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withText:(NSString *)text delegate:(id<PopoverViewDelegate>)delegate;

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withViewArray:(NSArray *)viewArray delegate:(id<PopoverViewDelegate>)delegate;

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withViewArray:(NSArray *)viewArray delegate:(id<PopoverViewDelegate>)delegate;

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withStringArray:(NSArray *)stringArray delegate:(id<PopoverViewDelegate>)delegate;

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withStringArray:(NSArray *)stringArray delegate:(id<PopoverViewDelegate>)delegate;

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withContentView:(UIView *)cView delegate:(id<PopoverViewDelegate>)delegate;

+ (PopoverView *)showPopoverAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView delegate:(id<PopoverViewDelegate>)delegate;

#pragma mark - Instance Showing Methods

//Adds/animates in the popover to the top of the view stack with the arrow pointing at the "point"
//within the specified view.  The contentView will be added to the popover, and should have either
//a clear color backgroundColor, or perhaps a rounded corner bg rect (radius 4.f if you're going to
//round).
- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)contentView;

//Calls above method with a UILabel containing the text you deliver to this method.
- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withText:(NSString *)text;

//Calls top method with an array of UIView objects.  This method will stack these views vertically
//with kBoxPadding padding between each view in the y-direction.
//列表式排版添加视图组
- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withViewArray:(NSArray *)viewArray;

//Does same as above, but adds a title label at top of the popover.
- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withViewArray:(NSArray *)viewArray;

//Calls the viewArray method with an array of UILabels created with the strings
//in stringArray.  All contents of stringArray must be NSStrings.
- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withStringArray:(NSArray *)stringArray;

//This method does same as above, but with a title label at the top of the popover.
- (void)showAtPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title withStringArray:(NSArray *)stringArray;

#pragma mark - Dismissal
//Dismisses the view, and removes it from the view stack.
- (void)dismiss;

#pragma mark - Activity Indicator Methods

//Shows the activity indicator, and changes the title (if the title is available, and is a UILabel).
//显示活动指示器，并且替换标题
- (void)showActivityIndicatorWithMessage:(NSString *)msg;

//Hides the activity indicator, and changes the title (if the title is available) to the msg

- (void)hideActivityIndicatorWithMessage:(NSString *)msg;

#pragma mark - Custom Image Showing

//Animate in, and display the image provided here.
- (void)showImage:(UIImage *)image withMessage:(NSString *)msg;

#pragma mark - Error/Success Methods

//Shows (and animates in) an error X in the contentView
- (void)showError;

//Shows (and animates in) a success checkmark in the contentView
- (void)showSuccess;

@end
