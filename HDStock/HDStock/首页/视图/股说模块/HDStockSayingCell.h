//
//  HDStockSayingCell.h
//  HDStock
//
//  Created by hd-app02 on 2016/12/15.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UAProgressView/UAProgressView.h>
#import "HDHeadLineModel.h"
@interface HDStockSayingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UAProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIButton *playButton;

@property (strong, nonatomic) IBOutlet UIButton *stockOne;
@property (strong, nonatomic) IBOutlet UIButton *stockTwo;
@property (strong, nonatomic) IBOutlet UIButton *stockThree;
@property (strong, nonatomic) NSArray * urlArray;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *toRightDis;

- (void)playerPause;
@end
