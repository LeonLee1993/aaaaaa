//
//  HDPersonalInformationCell.h
//  HDStock
//
//  Created by liyancheng on 16/11/29.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectedDataModel.h"
//我的收藏资讯页面cell

@interface HDPCCollectedInformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,assign) NSInteger flag;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImage;
@property (nonatomic,strong) MyCollectedDataModel *model;
@end
