//
//  LYCSignalRTool.h
//  YJCard
//
//  Created by paradise_ on 2017/8/15.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYCSignalRTool : NSObject

+ (instancetype)LYCsignalRTool;

//扫码进入付款界面的时候给商户传消息
- (void)sendMessageToCilentWithCodeString:(NSString *)codeString;
//付款成功后给商户传消息
- (void)paySuccessMessageToCilentWithCodeString:(NSString *)codeString andMoneyCount:(NSString *)moneyCount;

//- (void)payMoneyCodeMessageToCilentWithCodeString:(NSString *)codeString andStateStr:(NSString *)stateStr;

- (void)payCodeViewJoinTheCilentWithCodeString:(NSString *)codeString;
//付款码有密码支付成功
- (void)paySuccessMerchantToCilentWithCodeString:(NSString *)codeString andCaseID:(NSString *)moneyCount;

- (void)userIsInputPassWordWithCodeString:(NSString *)string;

- (void)userDontHaveEnoughMoneyWithString:(NSString *)string;

- (void)userCancelPayActionWithString:(NSString *)string;

- (void)userIsPayingActionWithString:(NSString *)codeString;

@end
