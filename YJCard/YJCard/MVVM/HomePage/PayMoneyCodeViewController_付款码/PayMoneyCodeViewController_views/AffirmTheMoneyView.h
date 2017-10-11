//
//  AffirmTheMoneyView.h
//  YJCard
//
//  Created by paradise_ on 2017/7/25.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^pushBlock)();
@interface AffirmTheMoneyView : UIView
@property (nonatomic,strong) UITableView *tableView;
+ (instancetype)initWithCards:(NSArray *)cardsArray;

@property (nonatomic,strong) NSArray * cardsArray;

@property (nonatomic,copy) pushBlock pushBlock;

@property (nonatomic,strong) NSString * moneyNeedToPay;//需要支付的金额

@property (nonatomic,strong) NSString * payCardID;//付款那张卡的ID

@property (nonatomic,strong) NSString * payCodeStr;//付款码

@property (nonatomic,strong) NSString * casesnStr;//付款码

@property (nonatomic,strong) UIViewController * selfVC;

@property (nonatomic,strong) NSString * storeName;//商家名称

@end
