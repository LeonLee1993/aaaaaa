//
//  myAssetTableViewCell.h
//  YJCard
//
//  Created by paradise_ on 2017/6/29.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomePageModel;
@interface myAssetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *totalLeftMoneyLabel;//账户总余额
@property (weak, nonatomic) IBOutlet UILabel *crashAmountLabel;//现金金额
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;//账户积分



@property (nonatomic,strong) HomePageModel * model;

@end
