//
//  HDMiddleCell.h
//  HDStock
//
//  Created by hd-app02 on 16/11/11.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDPSYScrollButtonView.h"
@interface HDMiddleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet HDPSYScrollButtonView *psyScrollButtonView;

@property (strong, nonatomic) NSArray * titleArray;
@property (strong, nonatomic) NSArray * subTitleArray;

@end
