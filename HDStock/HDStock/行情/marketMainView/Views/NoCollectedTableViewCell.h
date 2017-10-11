//
//  NoCollectedTableViewCell.h
//  HDStock
//
//  Created by liyancheng on 17/2/14.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^addBlock)(UIButton *);
@interface NoCollectedTableViewCell : UITableViewCell
@property (nonatomic,strong)addBlock block;
@property (weak, nonatomic) IBOutlet UIView *randomStockView;
@property (nonatomic,strong) NSArray * randomStockArr;
@end
