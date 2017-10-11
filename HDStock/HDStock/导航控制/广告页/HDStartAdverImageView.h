//
//  HDStartAdverImageView.h
//  HDStock
//
//  Created by hd-app02 on 2017/1/17.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDAdvertisementModel;
@protocol HDStartAdverDelegate <NSObject>

- (void)passToAnotherController;

- (void)turnIntoDetail:(HDAdvertisementModel *)model;

@end


@interface HDStartAdverImageView : UIImageView<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <HDStartAdverDelegate> delegate;
@property (nonatomic, strong) UIButton * passButton;

@end
