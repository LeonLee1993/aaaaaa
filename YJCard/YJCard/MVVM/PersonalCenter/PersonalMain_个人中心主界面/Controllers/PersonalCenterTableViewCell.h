//
//  PersonalCenterTableViewCell.h
//  YJCard
//
//  Created by paradise_ on 2017/8/14.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYCBaseViewController;
@interface PersonalCenterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *shimingView;//实名认证
@property (weak, nonatomic) IBOutlet UIView *personalMessageView;//个人信息
@property (weak, nonatomic) IBOutlet UIView *tradeRecord;//交易记录
@property (weak, nonatomic) IBOutlet UIView *totalAsset;//总资产
@property (weak, nonatomic) IBOutlet UIView *paySet;//支付设置
@property (weak, nonatomic) IBOutlet UIView *safeCenter;//安全中心
@property (weak, nonatomic) IBOutlet UIView *AboutUS;//关于我们
@property (weak, nonatomic) IBOutlet UIView *contactUs;//联系我们
@property (weak, nonatomic) IBOutlet UILabel *cerifyStateLable;

@property (weak, nonatomic) IBOutlet UIImageView *redCircle;
@property (nonatomic,strong) NSDictionary * infoDic;

@property (nonatomic,strong) LYCBaseViewController * selfVC;

@end
