//
//  HDTextDetailCell.h
//  HDStock
//
//  Created by hd-app02 on 2017/1/10.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDHeadLineModel.h"

@interface HDTextDetailCell : UITableViewCell

@property (nonatomic, strong) HDHeadLineModel * model;

@property (nonatomic, strong) UIButton * fontButton;

@end
