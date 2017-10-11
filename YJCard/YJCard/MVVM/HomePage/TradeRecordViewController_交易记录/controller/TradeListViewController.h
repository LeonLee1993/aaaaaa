//
//  TradeListViewController.h
//  YJCard
//
//  Created by paradise_ on 2017/7/26.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCBaseViewController.h"
typedef NS_ENUM(NSInteger, LYCTradeListType) {
    LYCTradeListTypeConsume,
    LYCTradeListTypeCharge
};
@interface TradeListViewController : LYCBaseViewController
@property (nonatomic,strong) NSString * cardID;
@property (nonatomic,assign) LYCTradeListType type;

@end
