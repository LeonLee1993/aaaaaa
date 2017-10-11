//
//  HDLiveGuPingTableViewCell.h
//  HDStock
//
//  Created by hd-app01 on 16/11/14.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HDLiveGuPingModel.h"

@interface HDLiveGuPingTableViewCell : UITableViewCell
/** 标题*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabl;
/** 来源*/
@property (weak, nonatomic) IBOutlet UILabel *sourceLabl;
/** 时间*/
@property (weak, nonatomic) IBOutlet UILabel *timeLabl;
/** 封面图*/
@property (weak, nonatomic) IBOutlet UIImageView *picIMV;

- (void) configUIWIthModel:(HDLiveGuPingModel*)model;

@end
