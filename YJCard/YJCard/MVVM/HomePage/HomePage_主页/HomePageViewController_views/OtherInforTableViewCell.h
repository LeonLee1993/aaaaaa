//
//  OtherInforTableViewCell.h
//  YJCard
//
//  Created by paradise_ on 2017/6/29.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LastTradeInfoModel;

@interface OtherInforTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//交易发生时间
@property (weak, nonatomic) IBOutlet UILabel *tradeMoneyLabel;//交易金额
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;//交易发生地点
@property (nonatomic,strong) LastTradeInfoModel * model;
@end
