//
//  buiedProductDetailSecondCell.h
//  HDStock
//
//  Created by liyancheng on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "buiedProductDetailSecondCellButton.h"
#import "buiedProductDetailThirdCellButton.h"
#import "ProductDetailModel.h"

typedef void(^twoButtonBlock)(NSInteger);
@interface buiedProductDetailSecondCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *firstContainView;
@property (weak, nonatomic) IBOutlet buiedProductDetailSecondCellButton *firstButton;
@property (weak, nonatomic) IBOutlet buiedProductDetailSecondCellButton *secondButton;
@property (weak, nonatomic) IBOutlet buiedProductDetailSecondCellButton *thirdButton;
@property (nonatomic,strong) NSString *flagStr;
@property (nonatomic,copy) twoButtonBlock twoButtonBlock;
@property (nonatomic,copy) ProductDetailModel *model;
@property (nonatomic,copy) ProductDetailModel *anothermodel;
//预期收益 从左往右 依次对应
@property (weak, nonatomic) IBOutlet UILabel *firstLable;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *forthLabel;
//止盈止损价 从左往右 依次对应
@property (weak, nonatomic) IBOutlet UILabel *buyPriceOne;
@property (weak, nonatomic) IBOutlet UILabel *buyPriceTwo;
@property (weak, nonatomic) IBOutlet UILabel *winPriceOne;
@property (weak, nonatomic) IBOutlet UILabel *winPriceTwo;
@property (weak, nonatomic) IBOutlet UILabel *lostPriceOne;
@property (weak, nonatomic) IBOutlet UILabel *lostPriceTwo;

//第一买入价 等~~  用于调整字体大小
@property (weak, nonatomic) IBOutlet UILabel *one;
@property (weak, nonatomic) IBOutlet UILabel *oneTwo;
@property (weak, nonatomic) IBOutlet UILabel *two;
@property (weak, nonatomic) IBOutlet UILabel *twotwo;
@property (weak, nonatomic) IBOutlet UILabel *three;
@property (weak, nonatomic) IBOutlet UILabel *threeTwo;


- (void)setSelectedButtonFrame;

- (void)setTwoButtonFrame;

- (void)setThreeButtonFrame;


@end
