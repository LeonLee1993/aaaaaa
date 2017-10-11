//
//  HDSelectedViewController.h
//  HDGolden
//
//  Created by hd-app02 on 16/10/21.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "PopoverView.h"
#import "HDHeadLineModel.h"
#import "HeadLineViewController.h"
#import "HDHeadLineBaseCell.h"
#import "HDHeadLineSingleViewCell.h"
#import "HDHeadLineBigViewCellCell.h"
#import "HDHeadLineThreeViewCellCell.h"


@protocol subTableViewScrollDelegate <NSObject>


@optional

- (void)beginScroll:(BOOL)canScroll;

@end

@interface HDSelectedViewController : UIViewController

@property (nonatomic, weak) id <subTableViewScrollDelegate> delegate;

@property (nonatomic, assign) BOOL canScroll;

@end
