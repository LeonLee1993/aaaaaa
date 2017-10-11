//
//  BuiedPruductTableViewCell.h
//  HDStock
//
//  Created by liyancheng on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"
#import "ProductListModel.h"
@interface BuiedPruductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic,copy)ProductDetailModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceCS;
@property (weak, nonatomic) IBOutlet UILabel *bottomAlertLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomAlertImage;
@property (weak, nonatomic) IBOutlet UILabel *alreadyAttentionLabel;
@property (nonatomic,copy)ProductListModel *listModel;
@end
