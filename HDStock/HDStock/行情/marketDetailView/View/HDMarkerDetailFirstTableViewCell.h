//
//  HDMarkerDetailFirstTableViewCell.h
//  HDStock
//
//  Created by liyancheng on 16/11/23.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fullScreenDataModel.h"

@interface HDMarkerDetailFirstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jinkai;
@property (weak, nonatomic) IBOutlet UILabel *zuoshou;
@property (weak, nonatomic) IBOutlet UILabel *chengjiaoliang;
@property (weak, nonatomic) IBOutlet UILabel *huanshoulu;
@property (weak, nonatomic) IBOutlet UILabel *zuigao;
@property (weak, nonatomic) IBOutlet UILabel *zuidi;
@property (weak, nonatomic) IBOutlet UILabel *chengjiaoe;
@property (weak, nonatomic) IBOutlet UILabel *shiyinglu;
@property (weak, nonatomic) IBOutlet UILabel *zhenfu;
@property (weak, nonatomic) IBOutlet UILabel *liutongshizhi;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;//现价
@property (weak, nonatomic) IBOutlet UILabel *currentPriceChange;//现价涨跌
@property (weak, nonatomic) IBOutlet UILabel *currentPriceChangeRate;//现价涨跌率
@property (nonatomic,strong)fullScreenDataModel *model;
@end
