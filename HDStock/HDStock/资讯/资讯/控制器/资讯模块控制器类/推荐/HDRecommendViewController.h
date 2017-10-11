//
//  HDRecommendViewController.h
//  HDStock
//
//  Created by hd-app02 on 2016/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockBaseViewController.h"
#import "HDInfoBaseViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "HDHeadLineModel.h"
#import "HDHeadLineBaseCell.h"
#import "HDHeadLineSingleViewCell.h"
#import "HDHeadLineBigViewCellCell.h"
#import "HDHeadLineThreeViewCellCell.h"
#import "HDHeadLineModel.h"
#import "HeadLineViewController.h"
#import "HDLoadFailCell.h"
#import "HDSubjectViewController.h"
#import "HDHeadLineDetailViewController.h"


@interface HDRecommendViewController : HDInfoBaseViewController<ZJScrollPageViewChildVcDelegate>

@property(assign, nonatomic) NSInteger index;

@property (assign, nonatomic) NSInteger pageOfData;

- (void)requestData;

@end
