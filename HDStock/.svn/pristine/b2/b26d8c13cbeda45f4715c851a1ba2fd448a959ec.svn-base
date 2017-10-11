//
//  PSYScrollPageView.h
//  HDStock
//
//  Created by hd-app02 on 2016/12/27.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#define PAGECONTROL_jx  10

#import <UIKit/UIKit.h>

typedef void (^blockAllItems)(NSArray* items);

typedef NS_ENUM(NSInteger, PSYPageShowStyle) {
    PSYPageShowStyleRound = 0,
    PSYPageShowStyleLine
};

@protocol PSYScrollViewDelegate <NSObject>

- (void)turnToMainScreen;

@end

@interface PSYScrollPageView : UIView<UIScrollViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame numberOfItem:(NSInteger)num itemSize:(CGSize)itemsize complete:(blockAllItems)allitems;

@property (nonatomic, assign) BOOL pagingEnabled;   //默认是YES

@property (nonatomic, assign) BOOL hiddenPageControl;   //隐藏页数标识
@property (nonatomic, strong) UIImage* defaultPageIndicatorImage;   //默认page图
@property (nonatomic, strong) UIImage* currentPageIndicatorImage;   //当前page图

@property (nonatomic, assign) NSInteger pages;  //页数,如果赋值将有最高优先级
@property (nonatomic, assign) PSYPageShowStyle showstyle;    //默认随图片风格变化而变化

@property (nonatomic, weak) id <PSYScrollViewDelegate> delegate;
@end
