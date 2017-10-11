//
//  ChangeCardView.h
//  YJCard
//
//  Created by paradise_ on 2017/7/3.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^resetPayNumBlock)();

@interface ChangeCardView : UIView

@property (nonatomic,strong) UITableView *tableView;
+ (instancetype)initWithCards:(NSArray *)cardsArray;
@property (nonatomic,strong) NSArray * payCardsArr;
@property (nonatomic,copy) resetPayNumBlock resetPayNumBlock;
@end
