//
//  HDHeadLineBaseCell.h
//  HDGolden
//
//  Created by hd-app02 on 16/10/31.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDHeadLineModel.h"
@interface HDHeadLineBaseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLabel;
@property (strong, nonatomic) IBOutlet UIView *tagBGView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tabBGViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tabBGViewHeight;



@property (nonatomic,strong) HDHeadLineModel * model;

@end
