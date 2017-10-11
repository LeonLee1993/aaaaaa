//
//  PersonalCenterTableViewCell.m
//  YJCard
//
//  Created by paradise_ on 2017/8/14.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "PersonalCenterTableViewCell.h"
#import "TotalAssetViewController.h"
#import "TradeRecordViewController.h"
#import "SafeCenterViewController.h"
#import "AutonymViewController.h"
#import "AboutUSViewController.h"
#import "PaySetViewController.h"
#import "ResetCodeWithCertifyViewController.h"
#import "LYCBaseViewController.h"
#import "PersonalMessageViewController.h"
#import "FirstTimeSetCode.h"

@implementation PersonalCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray * listArr = @[self.shimingView,self.personalMessageView,self.tradeRecord,self.totalAsset,self.paySet,self.safeCenter,self.AboutUS,self.contactUs];
    for (int i =0; i<listArr.count; i++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToJump:)];
        [listArr[i] addGestureRecognizer:tap];
    }
}

-(void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    if([self.infoDic[@"isAuth"] isEqual:@(0)]){
        self.cerifyStateLable.text = @"未实名";
        self.redCircle.hidden = NO;
    }else if ([self.infoDic[@"isAuth"] isEqual:@(1)]){
        self.cerifyStateLable.text = @"审核中";
        self.redCircle.hidden = YES;
    }else if ([self.infoDic[@"isAuth"] isEqual:@(2)]){
        self.cerifyStateLable.text = @"审核未通过";
        self.redCircle.hidden = YES;
    }else if ([self.infoDic[@"isAuth"] isEqual:@(3)]){
        self.cerifyStateLable.text = @"已实名";
        self.redCircle.hidden = YES;
    }
}

- (void)tapToJump:(UITapGestureRecognizer *)sender{
    switch (sender.view.tag) {
        case 201://实名认证
        {
            
            [MobClick event:@"verify"];
            AutonymViewController *autoView = [[AutonymViewController alloc]init];
            //isAuth:0.未提交认证审核 1.已提交认证审核 2.审核未通过 3.通过审核 4.已提交作废审核 5.已作废
            if([self.infoDic[@"isAuth"] isEqual:@(0)]){
                autoView.LYCAutonmyViewState = LYCAutonmyViewStateDefault;
            }else if ([self.infoDic[@"isAuth"] isEqual:@(1)]||[self.infoDic[@"isAuth"] isEqual:@(3)]){
                autoView.LYCAutonmyViewState = LYCAutonmyViewStateGoOn;
            }else if ([self.infoDic[@"isAuth"] isEqual:@(2)]){
                autoView.LYCAutonmyViewState = LYCAutonmyViewStateFail;
            }
            [self.selfVC.navigationController pushViewController:autoView animated:YES];
            
        }break;
            
        case 202://个人信息
        {
            [MobClick event:@"personalMessage"];
            PersonalMessageViewController *personalMessage = [[PersonalMessageViewController alloc]init];
            personalMessage.infoDic = self.infoDic;
            [self.selfVC.navigationController pushViewController:personalMessage animated:YES];
        }break;
            
        case 203://交易记录
        {
            [MobClick event:@"tradeRecord"];
            TradeRecordViewController *recod = [[TradeRecordViewController alloc]init];
            recod.goBackTitle = @"返回";
            [self.selfVC.navigationController pushViewController:recod animated:YES];
        }break;
            
        case 204://总资产
        {
            [MobClick event:@"totalAsset"];
            TotalAssetViewController *total = [[TotalAssetViewController alloc]init];
            [self.selfVC.navigationController pushViewController:total animated:YES];
        }break;
            
        case 205://支付设置
        {
            [MobClick event:@"paySet"];
            [self judgeByPayCodeState];
        }break;
            
        case 206://安全中心
        {
            [MobClick event:@"safeCenter"];
            SafeCenterViewController *safeCenter = [[SafeCenterViewController alloc]init];
            safeCenter.goBackTitle = @"返回";
            [self.selfVC.navigationController pushViewController:safeCenter animated:YES];
        }break;
            
        case 207://关于
        {
            AboutUSViewController * about = [[AboutUSViewController alloc]init];
            [self.selfVC.navigationController pushViewController:about animated:YES];
        }break;
            
        case 208://联系客服
        {
            
            LYCAlertController * alertView = [LYCAlertController alertControllerWithTitle:@"确认拨打电话联系客服?" message:nil preferredStyle:0];
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"400-600-9610" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *telNumber = [NSString stringWithFormat:@"tel:%@", @"4006009610"];
                NSURL *aURL = [NSURL URLWithString:telNumber];
                if ([[UIApplication sharedApplication] canOpenURL:aURL]) {
                    [[UIApplication sharedApplication] openURL:aURL];
                }
            }];
            [alertView addAction:OKAction];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertView addAction:cancleAction];
            [self.selfVC presentViewController:alertView animated:YES completion:nil];
            
        }break;
            
            
        default:
            break;
    }
}



- (void)judgeByPayCodeState{
    
    NSString * payCodeStateStr = [[NSUserDefaults standardUserDefaults] objectForKey:PayCodeState];
    
    if([payCodeStateStr isEqualToString:@"set"]){
        PaySetViewController * paySet = [[PaySetViewController alloc]init];
        [self.selfVC.navigationController pushViewController:paySet animated:YES];
    }else{
        [self getPayCodeStateFromService:@"pay"];
    }
}

- (void)getPayCodeStateFromService:(NSString *)pay{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Issetpaypassword];
    [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            if([json[@"data"] isEqual:@(0)]){
                LYCAlertController * alertC = [LYCAlertController alertControllerWithTitle:@"尚未设置支付密码,请先设置" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self.selfVC presentViewController:alertC animated:YES completion:nil];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    FirstTimeSetCode *reset = [[FirstTimeSetCode alloc]init];
                    [self.selfVC.navigationController pushViewController:reset animated:YES];
                }];
                [alertC addAction:action];
            }else{
                PaySetViewController * paySet = [[PaySetViewController alloc]init];
                [self.selfVC.navigationController pushViewController:paySet animated:YES];
            }
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:self.selfVC.view progressViewText:@"" progressViewType:LYCStateViewLoad ViewController:self.selfVC];
}


@end
