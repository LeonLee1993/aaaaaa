//
//  fullPageFailLoadView.h
//  HDStock
//
//  Created by liyancheng on 16/12/22.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDFailLoadView.h"
@class fullPageFailLoadView;
@protocol fullPageFailLoadViewDelegate <NSObject>

@optional
- (void)popMenuDidClickRefresh:(fullPageFailLoadView *)popMenu;

@end

@interface fullPageFailLoadView : UIView
@property (nonatomic,strong) HDFailLoadView *fullfailLoad;
@property (nonatomic, weak) id<fullPageFailLoadViewDelegate> delegate;
@property (nonatomic,assign) BOOL firstAddFlag;

- (void)hide;

-(void)showWithAnimation;

-(void)showWithoutAnimation;

@end
