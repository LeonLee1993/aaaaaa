//
//  PayMoneyCodeViewController.h
//  YJCard
//
//  Created by paradise_ on 2017/6/30.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCBaseViewController.h"

@interface PayMoneyCodeViewController : LYCBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *payMoneyNumLabel;
//是否以及设置支付码 
@property (nonatomic,assign) BOOL DidSetCode;
@end
