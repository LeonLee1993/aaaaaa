//
//  HDScrollWordsTableViewCell.h
//  HDStock
//
//  Created by hd-app02 on 2016/12/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>
#import "HDHotNewsModel.h"
@interface HDScrollWordsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet SDCycleScrollView *wordsScorllView;
@property (strong, nonatomic) NSArray * hotNewsArray;
@end
