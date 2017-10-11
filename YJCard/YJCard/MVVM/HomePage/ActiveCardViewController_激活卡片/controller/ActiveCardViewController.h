//
//  ActiveCardViewController.h
//  YJCard
//
//  Created by paradise_ on 2017/7/6.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCBaseViewController.h"
@class QuikBindCardModel;
@interface ActiveCardViewController : LYCBaseViewController

@property (nonatomic,strong) QuikBindCardModel  * model;

@property (nonatomic,strong) NSString *bindCardNumber;

@property (nonatomic,assign) BOOL alreadyActivity;

@end
