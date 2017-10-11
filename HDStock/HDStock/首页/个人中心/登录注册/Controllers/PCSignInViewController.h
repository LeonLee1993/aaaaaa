//
//  PCRegisterTelViewController.h
//  HDStock
//
//  Created by liyancheng on 16/12/5.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "LYCBaseViewController.h"
typedef void (^sucBlockk)();
@interface PCSignInViewController : LYCBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *firstTF;
@property (weak, nonatomic) IBOutlet UITextField *secondTF;
@property (nonatomic,copy)sucBlockk blockd;
@end
