//
//  HDMarketMainTableViewCell.h
//  HDStock
//
//  Created by liyancheng on 16/11/22.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "marketListModel.h"
@interface HDMarketMainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *raiseRange;
@property (nonatomic,strong) marketListModel * model;
@end
