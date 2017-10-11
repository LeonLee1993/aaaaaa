//
//  HDVertionCheckAlertShowView.h
//  HDStock
//
//  Created by hd-app02 on 2017/1/17.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDVertionCheckAlertView.h"

@protocol HDVertionCheckAlertShowViewDelegate <NSObject>

- (void)upDateTheVertion:(UIButton *)button;

@end

@interface HDVertionCheckAlertShowView : UIView

@property (nonatomic, strong) HDVertionCheckAlertView * alertView;

@property (nonatomic, weak) id <HDVertionCheckAlertShowViewDelegate> delegate;

- (void)showAlertView;

- (void)dismissAlertView;

@end
