//
//  HDFailLoadView.h
//  HDStock
//
//  Created by hd-app02 on 2016/12/19.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDFailLoadView;
@protocol HDFailLoadViewDelegate <NSObject>

- (void)showTheSubViews:(HDFailLoadView *)view;

@end

@interface HDFailLoadView : UIView

@property (nonatomic, strong) UIButton * button;

@property (nonatomic, strong) UIImageView * imageview;

@property (nonatomic, strong) UILabel * label;

@property (nonatomic, strong) PSYProgresHUD * hud;

@property (nonatomic, weak) id <HDFailLoadViewDelegate> delegate;

- (void)hideTheSubViews;

- (void)showTheSubViews;

@end
