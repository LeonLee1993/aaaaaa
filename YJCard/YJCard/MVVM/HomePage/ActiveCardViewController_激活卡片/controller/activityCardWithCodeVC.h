//
//  activityCardWithCodeVC.h
//  YJCard
//
//  Created by paradise_ on 2017/7/10.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCBaseViewController.h"
@class QuikBindCardModel;
@interface activityCardWithCodeVC : LYCBaseViewController

@property (nonatomic,strong) QuikBindCardModel  * model;

@property (nonatomic,strong) NSString *bindCardNumber;

@property (nonatomic,assign) BOOL alreadyActivity;

@end
