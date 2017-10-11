//
//  TendentMessageViewController.h
//  YJCard
//
//  Created by paradise_ on 2017/8/9.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCBaseViewController.h"
@class RetailersModel;
@interface TendentMessageViewController : LYCBaseViewController

@property (nonatomic,strong) NSString * langStr;//经度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic,strong) NSString * lantitudeStr;//纬度

@property (nonatomic,strong) RetailersModel * model;

@end
