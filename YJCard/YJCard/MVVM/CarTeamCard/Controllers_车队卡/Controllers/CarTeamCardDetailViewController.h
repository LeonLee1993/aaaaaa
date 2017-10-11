//
//  CarTeamCardDetailViewController.h
//  YJCard
//
//  Created by paradise_ on 2017/7/10.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCBaseViewController.h"

@interface CarTeamCardDetailViewController : LYCBaseViewController


@property (weak, nonatomic) IBOutlet UILabel *cardIDLabel;//卡号
@property (weak, nonatomic) IBOutlet UILabel *leftMoneyLabel;//余额
@property (weak, nonatomic) IBOutlet UILabel *rebateLabel;//积分
@property (weak, nonatomic) IBOutlet UILabel *totalPayMoneyLabel;//总消费金额
@property (weak, nonatomic) IBOutlet UILabel *totalConsumRebate;//总积分抵扣
@property (weak, nonatomic) IBOutlet UILabel *totalInjectMoneyLabel;//总充值金额
@property (weak, nonatomic) IBOutlet UILabel *totalRewardMoney;//总积分奖励
@property (weak, nonatomic) IBOutlet UILabel *cardStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *cardData;
@property (weak, nonatomic) IBOutlet UIButton *resumeRecordButton;//消费记录
@property (weak, nonatomic) IBOutlet UIButton *chargeRecordButton;//充值记录
@property (weak, nonatomic) IBOutlet UIImageView *cardBackImageView;//卡片背后的图片
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *backView1;

@property (nonatomic,strong) NSString * detailCardId;//卡片ID 上个界面传过来

@property (nonatomic,strong) NSString * detailCardNO;//卡片号码

@property (nonatomic,strong) NSString * detailCardType;//卡片类型


@property (nonatomic,strong) NSString * detailCardData;//卡片ID 上个界面传过来

@property (nonatomic,strong) NSString * detailCardStatus;//卡片状态

@property (nonatomic,assign) BOOL isElectronicCard;

@end
