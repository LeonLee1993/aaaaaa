//
//  TradeDetailViewController.h
//  YJCard
//
//  Created by paradise_ on 2017/7/26.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCBaseViewController.h"

typedef NS_ENUM(NSInteger, LYCTradeDetailType) {
    LYCTradeDetailTypeConsume,
    LYCTradeDetailTypeCharge,
    LYCTradeDetailTypeSeeDetail
};

@interface TradeDetailViewController : LYCBaseViewController

@property (nonatomic,strong) NSString * tradeIdString;

@property (nonatomic,assign) LYCTradeDetailType type;

@end
