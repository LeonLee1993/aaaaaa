//
//  CTManagerCollectionViewCell.h
//  YJCard
//
//  Created by paradise_ on 2017/7/7.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CardListModel;
@interface CTManagerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selfImageView;
@property (weak, nonatomic) IBOutlet UIImageView *littleImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLable;

@property (nonatomic,strong) CardListModel *model;
@property (weak, nonatomic) IBOutlet UILabel *cardNOLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;

@end
