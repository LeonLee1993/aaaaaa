//
//  TendentTableViewCell.h
//  YJCard
//
//  Created by paradise_ on 2017/8/7.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RetailersModel;
@interface TendentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
//名称
@property (weak, nonatomic) IBOutlet UILabel *title;
//职能
@property (weak, nonatomic) IBOutlet UILabel *function;
//电话
@property (weak, nonatomic) IBOutlet UILabel *teleLabel;
//消息
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
//消息图片
@property (weak, nonatomic) IBOutlet UIImageView *messagelabelImage;
//距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (nonatomic,strong) RetailersModel *model;
@end
