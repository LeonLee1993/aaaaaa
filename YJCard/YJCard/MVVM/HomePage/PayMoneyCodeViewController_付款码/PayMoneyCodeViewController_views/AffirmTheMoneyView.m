//
//  AffirmTheMoneyView.m
//  YJCard
//
//  Created by paradise_ on 2017/7/25.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "AffirmTheMoneyView.h"
#import "AffirmMoneyPreView.h"
#import "AffirmMoneySecondView.h"
#import "PayMoneyWithCodeView.h"
#import "MemberPayCardsModel.h"
#import "PayResultViewController.h"

@interface AffirmTheMoneyView (){
    AffirmMoneyPreView * view;
}

@end

@implementation AffirmTheMoneyView

+ (instancetype)initWithCards:(NSArray *)cardsArray{
    static AffirmTheMoneyView *affirmView;
    affirmView = [[self alloc]init];
    affirmView.backgroundColor = RGBAColor(0, 0, 0, 0.6);
    affirmView.frame = [UIScreen mainScreen].bounds;
    affirmView.cardsArray = cardsArray;
    return affirmView;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    
    view = [AffirmMoneyPreView viewFromXib];
    view.RMBNumLabelText = self.moneyNeedToPay;
    view.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/640*337);
    
    [self addSubview:view];
    __weak typeof(self) weakSelf = self;
    
    view.selectcardBlock = ^{
        [weakSelf selectAction];
    };
    
    view.selfDissMissBlock = ^{
        [weakSelf removeFromSuperview];
    };
    
    view.payMoneyBlock = ^{
        [weakSelf beforePayMoneyAction];
    };
    
    [self setCardsArray:self.cardsArray];
}

-(void)didMoveToSuperview{
    [UIView animateWithDuration:0.3 animations:^{
        view.lyc_y = ScreenHeight/640*303;
    }];
}

-(void)setCardsArray:(NSArray *)cardsArray{
    _cardsArray = cardsArray;
    NSString * payCardIDStr = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultPayCardID];
    if(!payCardIDStr){
        MemberPayCardsModel * model = cardsArray[0];
        [[NSUserDefaults standardUserDefaults]setObject:model.cardId forKey:DefaultPayCardID];
        [[NSUserDefaults standardUserDefaults]setObject:model.cardNo forKey:DefaultPayCard];
    }
}

- (void)beforePayMoneyAction{
    //这里判断支付前的一些信息
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    
    NSString * payCardIDStr = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultPayCardID];
    if(!payCardIDStr||payCardIDStr.length==0){
        MemberPayCardsModel * model = self.cardsArray[0];
        payCardIDStr = model.cardId;
    }

    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:self.moneyNeedToPay forKey:@"amount"];//交易金额
    [mutDic setObject:payCardIDStr forKey:@"cardid"];//卡片ID
    [mutDic setObject:self.casesnStr forKey:@"casesn"];//扫描二维码返回的caseSN
    [mutDic setObject:self.payCodeStr forKey:@"paycode"];//付款码
    
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Beforepaymentcheck];
    
    [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
       
        if([json[@"code"] isEqual:@(137)]){//需要密码的时候
            [[LYCSignalRTool LYCsignalRTool]userIsPayingActionWithString:self.payCodeStr];
            [self jumpToPayCodeView:json];
            
        }else if([json[@"code"] isEqual:@(100)]){//不需要密码
            [[LYCSignalRTool LYCsignalRTool]userIsPayingActionWithString:self.payCodeStr];
            [self goToPayMoneyWithCardNo:json[@"data"][@"cardNo"] andDeviceSN:json[@"data"][@"deviceSN"] andOperateID:json[@"data"][@"operatorId"]];
            
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        view.payMoneyButton.userInteractionEnabled = YES;
    } andProgressView:self progressViewText:@"支付中" progressViewType:LYCStateNoUerInterface ViewController:nil];
    
}

- (void)goToPay{
    
}

- (void)jumpToPayCodeView:(NSDictionary *)dic{
    //跳转至输入支付密码的界面 推出方式
    __weak typeof(self) weakSelf = self;
    PayMoneyWithCodeView *CodeView = [PayMoneyWithCodeView viewFromXib];
    CodeView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/640*376);
    CodeView.selfVC = self.selfVC;
    NSDictionary * dataDic = [NSDictionary dictionaryWithDictionary:dic[@"data"]];
    CodeView.storeName = self.storeName;
    CodeView.payCodeStr =self.payCodeStr;
    CodeView.cardNoStr =dataDic[@"cardNo"];
    CodeView.amountStr = self.moneyNeedToPay;
    CodeView.caseSNStr = self.casesnStr;
    CodeView.deviceSNStr=  dataDic[@"deviceSN"];
    CodeView.operateID= dataDic[@"operatorId"];
    [weakSelf addSubview:CodeView];
    [UIView animateWithDuration:0.3 animations:^{
        CodeView.lyc_y = ScreenHeight -  ScreenHeight/640*376;
    } completion:^(BOOL finished) {
         view.payMoneyButton.userInteractionEnabled = YES;
    }];
    CodeView.forgetPWBlock = ^{
        weakSelf.pushBlock();
    };
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(point.y<ScreenHeight/640*298){
        [self removeFromSuperview];
    }
}

#pragma mark 选择卡片从右到左推出
- (void)selectAction{

    AffirmMoneySecondView * secondView = [AffirmMoneySecondView viewFromXib];
    secondView.frame = CGRectMake(ScreenWidth, ScreenHeight/640*298, ScreenWidth, ScreenHeight/640*337);
    secondView.cardsArr = self.cardsArray;
    
    [self addSubview:secondView];

    [UIView animateWithDuration:0.3 animations:^{
        secondView.lyc_x = 0;
        view.lyc_x = -ScreenWidth;
    }];
    
    __weak typeof (secondView)wSecondeView = secondView;
    secondView.backBlock = ^{
        [UIView animateWithDuration:0.3 animations:^{
            wSecondeView.lyc_x = ScreenWidth;
            view.lyc_x = 0;
        }];
        NSString * payCordNO = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultPayCard];
        view.payCardNumberLabel.text = payCordNO;
    };
}

#pragma mark - 去付款
- (void)goToPayMoneyWithCardNo:(NSString *)cardNo andDeviceSN:(NSString *)DeviceSN andOperateID:(NSString *)operateID{
    //这里判断支付前的一些信息
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:self.payCodeStr forKey:@"paycode"];//付款码
    [mutDic setObject:cardNo forKey:@"cardno"];//卡号
    [mutDic setObject:self.moneyNeedToPay forKey:@"amount"];//交易金额
    [mutDic setObject:self.casesnStr forKey:@"casesn"];//订单序列号
    [mutDic setObject:DeviceSN forKey:@"devicesn"];//设备SN
    [mutDic setObject:[NSString stringWithFormat:@"%@",operateID] forKey:@"operatorid"];//操作人ID
    [mutDic setObject:@"0" forKey:@"pwd"];//无需密码传0
    
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,PayMoney];
    [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
    
            PayResultViewController * payResult = [[PayResultViewController alloc]init];
            
            NSMutableDictionary * mutDic = [NSMutableDictionary dictionaryWithDictionary:json[@"data"]];
            [mutDic setObject:self.storeName forKey:@"storeName"];
            [mutDic setObject:cardNo forKey:@"cardNo"];
            payResult.infoDic = mutDic;
            [self.selfVC.navigationController pushViewController:payResult animated:YES];
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:self.selfVC.view progressViewText:@"" progressViewType:LYCStateViewLoad ViewController:nil];
}

@end
