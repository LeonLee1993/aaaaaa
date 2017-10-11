//
//  HDSearchTableViewCell.h
//  HDStock
//
//  Created by liyancheng on 16/11/23.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDSearchViewModel.h"
typedef void(^addBlock)(NSString*);

@interface HDSearchTableViewCell : UITableViewCell
@property (nonatomic,strong) HDSearchViewModel * model;
@property (weak, nonatomic) IBOutlet UIButton *addToMarketButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (nonatomic,copy)addBlock addBlock;
@end
