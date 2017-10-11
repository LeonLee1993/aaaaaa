//
//  HDLiveJinNangModel.h
//  HDStock
//  直播－ 锦囊－model
//  Created by hd-app01 on 16/11/22.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDBaseModel.h"

@interface HDLiveJinNangModel : HDBaseModel

/** 锦囊名称*/
@property (copy, nonatomic)  NSString *jinNangNameStr;
/** 购买按钮*/
@property (copy, nonatomic) NSString *purchaseStatus;
/** 预期收益*/
@property (copy, nonatomic) NSString *expectedIncomeStr;
/** 最高收益*/
@property (copy, nonatomic) NSString *highestIncomeStr;
/** 当前收益*/
@property (copy, nonatomic) NSString *currentIncomeStr;
/** 头像*/
@property (copy, nonatomic) NSString *headPicStr;
/** 昵称*/
@property (copy, nonatomic) NSString *nameStr;
/** 牛散*/
@property (copy, nonatomic) NSString *niuSanStatus;
/** 粉丝数*/
@property (copy, nonatomic) NSString *fansNumberStr;
/** 锦囊成功率*/
@property (copy, nonatomic) NSString *jinNangSuccessRateStr;
/** 发布时间*/
@property (copy, nonatomic) NSString *publishDateStr;
/** 有效交易日*/
@property (copy, nonatomic) NSString *validBusinessDayTimeStr;


@end
