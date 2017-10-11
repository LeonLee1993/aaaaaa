//
//  HDNewsFlashCell.h
//  HDGolden
//
//  Created by hd-app02 on 16/10/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDFlashNewsModel.h"
@interface HDNewsFlashCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *sigleView;
@property (weak, nonatomic) IBOutlet UILabel *newsLabel;
@property (nonatomic,strong) HDFlashNewsModel * model;
@end
