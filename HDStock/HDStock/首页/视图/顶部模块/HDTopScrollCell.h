//
//  HDTopScrollCell.h
//  HDStock
//
//  Created by hd-app02 on 16/11/10.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSYScrollButtons.h"
#import <SDCycleScrollView.h>

@interface HDTopScrollCell : UITableViewCell

@property (strong, nonatomic) IBOutlet SDCycleScrollView *ScrollView;

@property (strong, nonatomic) IBOutlet PSYScrollButtons *topScrollButtons;

@property (strong, nonatomic) NSArray * imageUrlArray;

@end
