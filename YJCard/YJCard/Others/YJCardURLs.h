//
//  YJCardURLs.h
//  YJCard
//
//  Created by paradise_ on 2017/7/17.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#ifndef YJCardURLs_h
#define YJCardURLs_h
//#include "YJCXStack.h"
////链接主体
//#define GlobelHeader @"https://xjcard.com.cn/appapi/"
//
////signalR网络前缀
//#define SignalRHeader @"https://xjcard.com.cn/ss/pay"
//
////网页前缀
//#define WebViewPreURL @"https://xjcard.com.cn/appweb/"

////链接主体
//#define GlobelHeader @"https://ykt.szeltec.com/dev/appapi/"
//
////signalR网络前缀
//#define SignalRHeader @"https://ykt.szeltec.com/dev/ss/pay"
//
////网页前缀
//#define WebViewPreURL @"https://ykt.szeltec.com/dev/appweb/"

//链接主体
#define GlobelHeader @"https://ykt.szeltec.com/sit/appapi/"

//signalR网络前缀
#define SignalRHeader @"https://ykt.szeltec.com/sit/ss/pay"

//网页前缀
#define WebViewPreURL @"https://ykt.szeltec.com/sit/appweb/"


//链接分类
#define GetVertifyCode @"getverfycode"

#define Login @"login"

#define GetHomePageInfo @"gethomeinfo"

#define GetCardList @"getchargecardlist"

//商户网点默认城市
#define TendentListDefaultCityID @"TendentListDefaultSelectedCityid"
//商户网点默认城市
#define TendentListDefaultCity @"TendentListDefaultSelectedCity"
//获取商户列表
#define Getretailers @"getretailers"
//设置免密支付
#define Setmemberpaylimit @"setmemberpaylimit"
//获取免密设置
#define Getmemberpaylimit @"getmemberpaylimit"
//提交实名认证
#define Submitauth @"submitauth"
//获取个人信息
#define Getmemberinfo @"getmemberinfo"
//获取实名状态
#define Getauthinfo @"getauthinfo"

//商户网点默认类别
#define TendentListDefault @"TendentListDefaultSelectedCategory"
//用户总资产
#define UserTotalMoney @"UserTotalMoney"
//用户总现金
#define UserTotalCash @"UserTotalCash"
//用户总积分
#define UserTotalRebate @"UserTotalRebate"
//用户资产key
#define UserAsset @"UserAsset"
//用户车队卡详情
#define UserCardDetail @"getcarddetail"
//快速绑卡下一步
#define QuickBindCardNext @"activecheckcard"
//提交绑定卡
#define submitBindCard @"activechargecard"
//卡片挂失
#define cardloss @"cardloss"
//卡片移除
#define cardremove @"cardremove"
//我的付款码/生成/改变 等等
#define generatememberqrcode @"generatememberqrcode"
//扫一扫通过商家二维码进入界面
#define Checkpaycode @"checkpaycode"
//付款之前的判断
#define Beforepaymentcheck @"beforepaymentcheck"
//前往付款
#define PayMoney @"pay"
//是否已经设置过支付密码
#define Issetpaypassword @"issetpaypassword"
//获取免密支付设置
#define Getmemberpaylimit @"getmemberpaylimit"
//设置免密支付
#define Setmemberpaylimit @"setmemberpaylimit"
//
#define Getretailercategory @"getcategorycity"

#define DefaultMoneyWithNoCode @"defaultMoneyWithNoCode"
//用户是否需要支付密码
#define UserNeedCodeKey @"UserNeedCodeKey"

#define UserTelNum @"UserTelNum"

#define Getresetpwdverfycode @"getresetpwdverfycode"

#define Checkverifycode @"checkverifycode"

#define PaypwdedSet @"setpaypwd"
//默认付款卡片号码
#define DefaultPayCard @"defaultPayCard"
//默认付款卡片ID
#define DefaultPayCardID @"defaultPayCardID"
//是否设置支付密码 状态
#define PayCodeState @"PayCodeState"

//消费记录
#define consumeRecord @"trade/consum?para="
//充值记录
#define chargeRecord @"trade/recharge?para="
//消费详情
#define consumeDetail @"trade/consumdetails?para="
//充值详情
#define chargeDetail @"trade/rechargedetails?para="

#endif /* YJCardURLs_h */
