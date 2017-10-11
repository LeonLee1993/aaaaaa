//
//  HDViedeoTitleViewCell.h
//  HDStock
//
//  Created by hd-app02 on 2016/11/30.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDViedeoTitleViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lookLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLabel;
@property (strong, nonatomic) IBOutlet UIView *tagBGView;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@end
