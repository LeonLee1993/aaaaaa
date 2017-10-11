//
//  ChangeCardListTableViewCell.h
//  YJCard
//
//  Created by paradise_ on 2017/7/3.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeCardListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gougouView;
@property (weak, nonatomic) IBOutlet UILabel *CarNumLabel;
@property (nonatomic,strong) NSString * payCardNO;
@end
