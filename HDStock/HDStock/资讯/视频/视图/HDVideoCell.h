//
//  HDVideoCell.h
//  HDStock
//
//  Created by hd-app02 on 16/11/20.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDHeadLineModel.h"
@interface HDVideoCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *lookLabel;

@property (strong, nonatomic) IBOutlet UILabel *tagLabel;
@property (strong, nonatomic) IBOutlet UIView *tagBGView;

@property (nonatomic,strong) HDHeadLineModel * model;
@end
