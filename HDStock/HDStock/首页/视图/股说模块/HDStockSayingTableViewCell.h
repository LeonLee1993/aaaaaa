//
//  HDStockSayingTableViewCell.h
//  HDStock
//
//  Created by hd-app02 on 2016/12/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UAProgressView/UAProgressView.h>
#import "HDHeadLineModel.h"
@interface HDStockSayingTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UAProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIButton *playButton;

@property (strong, nonatomic) IBOutlet UIButton *stockOne;
@property (strong, nonatomic) IBOutlet UIButton *stockTwo;
@property (strong, nonatomic) IBOutlet UIButton *stockThree;
@property (strong, nonatomic) NSArray * urlArray;

@end
