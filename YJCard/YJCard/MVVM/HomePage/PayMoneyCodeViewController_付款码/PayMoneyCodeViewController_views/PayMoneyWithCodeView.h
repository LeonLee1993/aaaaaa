//
//  PayMoneyCodeView.h
//  YJCard
//
//  Created by paradise_ on 2017/7/25.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^forgetPWBlock)();
typedef void (^dissMissBlock)();

@interface PayMoneyWithCodeView : UIView

@property (nonatomic,copy) forgetPWBlock forgetPWBlock;

@property (nonatomic,copy) dissMissBlock dissMissBlock;

@property (nonatomic,strong) NSString * payCodeStr;//付款码
@property (nonatomic,strong) NSString * cardNoStr;//卡号

@property (nonatomic,strong) NSString * amountStr;//交易金额

@property (nonatomic,strong) NSString * caseSNStr;//订单序列号

@property (nonatomic,strong) NSString * deviceSNStr;//设备SN

@property (nonatomic,strong) NSString * operateID;//操作人ID

@property (nonatomic,strong) NSString * storeName;//商家名称

@property (nonatomic,strong) UIViewController * selfVC;

@property (nonatomic,strong) NSString * payTypeStr;

@property (nonatomic,strong) NSString * prepaidID;

@end
