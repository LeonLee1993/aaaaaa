//
//  PayResultViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/8/15.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "PayResultViewController.h"
#import "LYCBaseTabBarController.h"
#import "AppDelegate.h"
#import "RedPacketView.h"
#import "TradeDetailViewController.h"
@interface PayResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *retailerName;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeTime;
@property (weak, nonatomic) IBOutlet UILabel *tradeNo;
@property (weak, nonatomic) IBOutlet UILabel *tradeMoney;
@property (weak, nonatomic) IBOutlet UILabel *storeName;

@end

@implementation PayResultViewController{
    BOOL needSet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!needSet){//如果查看了交易详情回来了又会加载 所以判断一下
        [self setInfoDiction];
        needSet = YES;
    }
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
}

- (IBAction)goBack:(id)sender {
    LYCBaseTabBarController * rootVc = [[LYCBaseTabBarController alloc] init];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = rootVc;
}

//返回首页
- (IBAction)completeClicked:(id)sender {
    LYCBaseTabBarController * rootVc = [[LYCBaseTabBarController alloc] init];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = rootVc;
}

-(void)setInfoDiction{
    //商户扫用户
    if([self.caseStr isEqualToString:@"payCodeView"]){
        
        self.tradeMoney.text = [NSString stringWithFormat:@"%@元",((NSString *)_infoDic[@"totalAmount"]).length>0?_infoDic[@"totalAmount"]:_infoDic[@"tradeMoney"]];
        self.retailerName.text = _infoDic[@"tradeStation"];
        self.cardNoLabel.text = _infoDic[@"cardNo"];
        self.tradeTime.text = _infoDic[@"tradeDateTime"];
        self.tradeNo.text = _infoDic[@"caseNo"];
        self.storeName.text = @"支付成功";
        [[LYCSignalRTool LYCsignalRTool]paySuccessMerchantToCilentWithCodeString:[[NSUserDefaults standardUserDefaults] objectForKey:@"codeString"] andCaseID:_infoDic[@"caseId"]];
        
        if([_infoDic[@"rewardAmount"] floatValue]>0){
            RedPacketView *redPacket = [RedPacketView installRedPacketView];
            redPacket.returnMoneyStr = _infoDic[@"rewardAmount"];
            redPacket.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            redPacket.seeDetailBlock = ^{
                TradeDetailViewController *quickBind = [[TradeDetailViewController alloc]init];
                [MobClick event:@"tradeRecord"];
                    quickBind.type = LYCTradeDetailTypeConsume;
                quickBind.tradeIdString = [NSString stringWithFormat:@"%@",_infoDic[@"caseId"]];
                [self.navigationController pushViewController:quickBind animated:YES];
            };
            [self.view addSubview:redPacket];
        }
    
    }else{//用户扫商户

        [[LYCSignalRTool LYCsignalRTool]paySuccessMessageToCilentWithCodeString:[[NSUserDefaults standardUserDefaults] objectForKey:@"codeString"] andMoneyCount:_infoDic[@"tradeMoney"]];
        self.tradeMoney.text = [NSString stringWithFormat:@"%@元",_infoDic[@"tradeMoney"]];
        self.retailerName.text = _infoDic[@"tradeStation"];
        self.cardNoLabel.text = _infoDic[@"cardNo"];
        self.storeName.text = @"支付成功";
        self.tradeTime.text = _infoDic[@"tradeDateTime"];
        self.tradeNo.text = _infoDic[@"caseNo"];
        
        if([_infoDic[@"rewardAmount"] floatValue]>0){
            RedPacketView *redPacket = [RedPacketView installRedPacketView];
            redPacket.returnMoneyStr = _infoDic[@"rewardAmount"];
            redPacket.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            redPacket.seeDetailBlock = ^{
                TradeDetailViewController *quickBind = [[TradeDetailViewController alloc]init];
                [MobClick event:@"tradeRecord"];
                quickBind.type = LYCTradeDetailTypeConsume;
                quickBind.tradeIdString = [NSString stringWithFormat:@"%@",_infoDic[@"caseId"]];
                [self.navigationController pushViewController:quickBind animated:YES];
            };
            [self.view addSubview:redPacket];
        }
    }
}

- (NSString *)totalMoneyStr:(NSString *)cashStr andRebetaStr:(NSString *)rebateStr{
    
    NSArray * cashStrArr = [cashStr componentsSeparatedByString:@","];
    NSMutableString * cashMutStr = [[NSMutableString alloc]init];
    for (NSString *str in cashStrArr) {
        [cashMutStr appendString:str];
    }
    
    NSArray * rebateStrArr = [rebateStr componentsSeparatedByString:@","];
    NSMutableString * rebateMutStr = [[NSMutableString alloc]init];
    for (NSString *str in rebateStrArr) {
        [rebateMutStr appendString:str];
    }
    
    CGFloat floatValue = cashMutStr.floatValue + rebateMutStr.floatValue;
    
    NSString * moneyCountStr = [NSString stringWithFormat:@"%.2f",floatValue];
    
    NSArray * comArr = [moneyCountStr componentsSeparatedByString:@"."];
    NSString * preStr = comArr[0];
    NSInteger dotCount = 0;
    NSInteger preIntValue = preStr.integerValue;
    
    while (preIntValue>1000) {
        dotCount+=1;
        preIntValue = preIntValue/1000;
    }
    
    NSMutableString * mutStr= [[NSMutableString alloc]initWithString:preStr];
    
    for (int i=0; i<dotCount; i++) {
        [mutStr insertString:@"," atIndex:mutStr.length-i-3*(i+1)];
    }
    
    if(comArr.count==2){
        NSString * str = comArr[1];
        if(str.length ==2){//如果两个小数
            [mutStr insertString:[NSString stringWithFormat:@".%@",comArr[1]] atIndex:mutStr.length];
        }else{//如果只有一个小数
            [mutStr insertString:[NSString stringWithFormat:@".%@0",comArr[1]] atIndex:mutStr.length];
        }
    }else{//如果没有小数
        [mutStr insertString:[NSString stringWithFormat:@".00"] atIndex:mutStr.length];
    }
    
    return mutStr;
    
}

- (IBAction)shareButtonClicked:(id)sender {
    [LYCHelper helper].selfVC = self;
    [LYCHelper shareBoardBySelfDefined];
}


@end
