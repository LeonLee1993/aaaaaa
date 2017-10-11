//
//  HDPersonChangeNameViewController.h
//  HDStock
//
//  Created by hd-app01 on 16/11/16.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "LYCBaseViewController.h"

@interface HDPersonChangeNameViewController : LYCBaseViewController
/** 输入框背景*/
@property (weak, nonatomic) IBOutlet UIView *textBgView;
/** 输入框*/
@property (weak, nonatomic) IBOutlet UITextField *nameTextFild;
/** 保存按钮*/
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textBgViewToSelfViewVerSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveBtnToTextBgViewVerSpace;
@property (weak, nonatomic) IBOutlet UIView *goBackView;

/** 修改后的昵称block*/
@property (nonatomic,copy) void(^changNickNameBlock)(NSString * changedNickName);

@end
