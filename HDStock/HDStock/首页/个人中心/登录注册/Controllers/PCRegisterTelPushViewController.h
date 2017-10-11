//
//  PCRegisterTelViewController.h
//  HDStock
//
//  Created by liyancheng on 16/12/5.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "LYCBaseViewController.h"
typedef void (^pushedBlock)();
@interface PCRegisterTelPushViewController : LYCBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *vertifyButton;
@property (weak, nonatomic) IBOutlet UITextField *firstTF;
@property (weak, nonatomic) IBOutlet UITextField *secondTF;
@property (nonatomic,copy) pushedBlock block;
@end
