//
//  MyOrderTableViewCell.h
//  HDStock
//
//  Created by liyancheng on 16/12/12.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderList.h"

typedef void(^goToBuyBlock)(NSString *price,NSString *productId);
@interface MyOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UIButton *byButton;
@property (weak, nonatomic) IBOutlet UIImageView *byStateImage;
@property (weak, nonatomic) IBOutlet UIImageView *buiedImage;
@property (nonatomic,strong)MyOrderList *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (nonatomic,copy)goToBuyBlock block;
@end
