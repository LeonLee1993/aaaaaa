//
//  LoginViewController.h
//  YJCard
//
//  Created by paradise_ on 2017/6/28.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCBaseViewController.h"

@interface LoginViewController : LYCBaseViewController
@property (nonatomic,assign) BOOL needDissmiss;
- (void)requestCode;
@end
