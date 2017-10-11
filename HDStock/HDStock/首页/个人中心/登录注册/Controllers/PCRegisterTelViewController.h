//
//  PCRegisterTelViewController.h
//  HDStock
//
//  Created by liyancheng on 16/12/5.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "personalBaseViewController.h"

typedef void(^resetMessageBlock)();//用户切换 清除原来的message

@interface PCRegisterTelViewController : personalBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *vertifyButton;
@property (weak, nonatomic) IBOutlet UITextField *telNumTF;
@property (weak, nonatomic) IBOutlet UITextField *SCodeTF;

@property (nonatomic,copy) resetMessageBlock block;

@end
