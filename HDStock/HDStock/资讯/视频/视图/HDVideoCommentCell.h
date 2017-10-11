//
//  HDVideoCommentCell.h
//  HDStock
//
//  Created by hd-app02 on 2016/11/28.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDNewsCommentsModel.h"
@interface HDVideoCommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *massageLabel;
@property (strong, nonatomic) IBOutlet UIButton *praiseButton;


@property (nonatomic, strong) HDNewsCommentsModel * model;
@end
