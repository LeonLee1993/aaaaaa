//
//  HDStockSayingHistoryCell.h
//  HDStock
//
//  Created by hd-app02 on 2017/2/15.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDHeadLineModel.h"
@interface HDStockSayingHistoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *viewLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) HDHeadLineModel * model;
@end
