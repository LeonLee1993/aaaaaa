//
//  PSYSegmentControView.h
//  HDStock
//
//  Created by hd-app02 on 2016/11/29.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, NinaPagerStyle) {
    /**<  上侧为下划线   **/
    NinaPagerStyleBottomLine = 0, //Default style
    /**<  上侧为滑块   **/
    NinaPagerStyleSlideBlock = 1,
    /**<  上侧只有文字颜色变化(没有下划线或滑块)   **/
    NinaPagerStyleStateNormal = 2,
};

@protocol NinaPagerViewDelegate <NSObject>
@optional
- (BOOL)deallocVCsIfUnnecessary;
- (void)ninaCurrentPageIndex:(NSString *)currentPage;
@end

@interface PSYSegmentControView : UIView

- (instancetype)initWithFrame:(CGRect)frame WithTitles:(NSArray *)titles WithVCs:(NSArray *)childVCs;

@property (assign, nonatomic) NinaPagerStyle ninaPagerStyles;

@property (strong, nonatomic) UIColor *unSelectTitleColor;

@property (strong, nonatomic) UIColor *selectTitleColor;

@property (strong, nonatomic) UIColor *underlineColor;

@property (strong, nonatomic) UIColor *sliderBlockColor;

@property (strong, nonatomic) UIColor *topTabBackGroundColor;

@property (copy, nonatomic) NSString *PageIndex;

@property (assign, nonatomic) NSInteger ninaDefaultPage;

@property (assign, nonatomic) CGFloat topTabHeight;

@property (assign, nonatomic) CGFloat titleFont;

@property (assign, nonatomic) CGFloat titleScale;

@property (assign, nonatomic) CGFloat selectBottomLinePer;

@property (assign, nonatomic) CGFloat selectBottomLineHeight;

@property (assign, nonatomic) CGFloat sliderHeight;

@property (assign, nonatomic) CGFloat slideBlockCornerRadius;

@property (assign, nonatomic) BOOL nina_navigationBarHidden;

@property (assign, nonatomic) BOOL loadWholePages;

@property (assign, nonatomic) BOOL underLineHidden;

@property (assign, nonatomic) BOOL nina_scrollEnabled;

@property (assign, nonatomic) BOOL nina_autoBottomLineEnable;

@property (assign, nonatomic) BOOL topTabScrollHidden;

@property (strong, nonatomic) NSArray *topTabViews;

@property (strong, nonatomic) NSArray *selectedTopTabViews;

@property (weak, nonatomic) id<NinaPagerViewDelegate>delegate; /**< NinaPagerView代理 **/

@end
