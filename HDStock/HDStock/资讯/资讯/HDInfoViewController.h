//
//  HDInfoViewController.h
//  HDStock
//
//  Created by hd-app02 on 16/11/15.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockBaseViewController.h"

#import "HDHeadLineModel.h"
#import "HeadLineViewController.h"
#import "HDHeadLineBaseCell.h"
#import "HDHeadLineSingleViewCell.h"
#import "HDHeadLineBigViewCellCell.h"
#import "HDHeadLineThreeViewCellCell.h"


@protocol HDInfoViewDelegate <NSObject>

- (void)turnToAntherControllerOnClicked:(UIButton *)button toPushToController:(UIViewController *)viewController;

@end

@interface HDInfoViewController : HDStockBaseViewController

@property (nonatomic, weak) id <HDInfoViewDelegate> delegate;

@end
