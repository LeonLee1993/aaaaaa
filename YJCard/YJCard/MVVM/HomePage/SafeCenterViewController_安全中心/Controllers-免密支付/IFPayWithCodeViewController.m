//
//  IFPayWithCodeViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/8/4.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "IFPayWithCodeViewController.h"
#import "SetNoCodePayMoneyViewController.h"
#import "SelectMoneyView.h"

@interface IFPayWithCodeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLeading;//线段距左边的距离

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//免密金额大小label
@property (weak, nonatomic) IBOutlet UISwitch *needCodeSwitch;
@property (weak, nonatomic) IBOutlet UIView *backMainView;
@property (weak, nonatomic) IBOutlet UIView *selectMoneyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopSpaceToNoPWView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
//开通小额免密后，使用手机进行小金额付款，无需输入支付密码。
@end

@implementation IFPayWithCodeViewController{
    CGFloat Perpt;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Perpt = ScreenWidth/375;
    self.needCodeSwitch.transform= CGAffineTransformMakeScale(0.85,0.85);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSelectMoney)];
    [self.selectMoneyView addGestureRecognizer:tap];
//    NSString * switchState = [[NSUserDefaults standardUserDefaults]objectForKey:UserNeedCodeKey];
//    if(!switchState.length){
        [self getPayCodeState];
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString * moneyStr = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultMoneyWithNoCode];
    
    if(moneyStr){
        self.moneyLabel.text = moneyStr;
    }else{
        self.moneyLabel.text = @"200元/笔";
        [[NSUserDefaults standardUserDefaults] setObject:self.moneyLabel.text forKey:DefaultMoneyWithNoCode];
    }

    NSString * switchState = [[NSUserDefaults standardUserDefaults]objectForKey:UserNeedCodeKey];
    if([switchState isEqualToString:@"on"]){
        self.needCodeSwitch.on = YES;
        [self setPageStates];
        self.messageLabel.text = [NSString stringWithFormat:@"付款金额≤%@，无需输入支付密码。",moneyStr];
    }else{
        self.needCodeSwitch.on = NO;
        [self setPageStates];
    }
}

- (void)tapToSelectMoney{
    SetNoCodePayMoneyViewController * MoneyValue = [[SetNoCodePayMoneyViewController alloc]init];
    [self.navigationController pushViewController:MoneyValue animated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (IBAction)switchValueChage:(UISwitch *)sender {
    if(sender.isOn){
        
        self.selectMoneyView.hidden = NO;
        self.messageLabel.hidden = NO;
        self.backMainView.backgroundColor = [UIColor whiteColor];
        self.viewLeading.constant = 9;
        
        NSString * moneyStr = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultMoneyWithNoCode];
        
        if(moneyStr){
            self.moneyLabel.text = moneyStr;
        }else{
            self.moneyLabel.text = @"200元/笔";
            [[NSUserDefaults standardUserDefaults] setObject:self.moneyLabel.text forKey:DefaultMoneyWithNoCode];
        }
        
        self.messageLabel.text = [NSString stringWithFormat:@"付款金额≤%@，无需输入支付密码。",moneyStr];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.TopSpaceToNoPWView.constant = 67.5*Perpt;
            [self.view layoutIfNeeded];
        }];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"on" forKey:UserNeedCodeKey];
        
    }else{
        
        self.selectMoneyView.hidden = YES;
        self.messageLabel.text = [NSString stringWithFormat:@"开通小额免密后，使用手机进行小金额付款，无需输入支付密码。"];
        self.backMainView.backgroundColor = [UIColor clearColor];
        self.viewLeading.constant = 0;
        [UIView animateWithDuration:0.1 animations:^{
            self.TopSpaceToNoPWView.constant = 17.5*Perpt;
            [self.view layoutIfNeeded];
        }];
        [[NSUserDefaults standardUserDefaults]setObject:@"off" forKey:UserNeedCodeKey];
    }
    
    [self setpayNum];
    
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setpayNum{
    
    NSArray * moneyArr = [[[NSUserDefaults standardUserDefaults]objectForKey:DefaultMoneyWithNoCode] componentsSeparatedByString:@"元"];
    NSString * moneyStr = moneyArr[0];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];//cardno
    [mutDic setObject:self.needCodeSwitch.isOn?@"1":@"0" forKey:@"isopened"];//免密是否开启
    [mutDic setObject:moneyStr forKey:@"paymentlimit"];//免密限额
    
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Setmemberpaylimit];
    
    self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            
        }else{
            
            self.needCodeSwitch.on = !self.needCodeSwitch.on;
            [self setPageStates];
            [MBProgressHUD showWithText:json[@"msg"]];
            
        }
    } failure:^(NSError *error) {
        
        self.needCodeSwitch.on = !self.needCodeSwitch.on;
        [self setPageStates];
        
    } andProgressView:self.view progressViewText:@"" progressViewType:LYCStateViewLoad ViewController:self];
    
}

- (void)setPageStates{
    if(self.needCodeSwitch.isOn){
        
        self.messageLabel.hidden = NO;
        self.selectMoneyView.hidden = NO;
        self.backMainView.backgroundColor = [UIColor whiteColor];
        self.viewLeading.constant = 9;
        
        NSString * moneyStr = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultMoneyWithNoCode];
        
        if(moneyStr){
            self.moneyLabel.text = moneyStr;
        }else{
            self.moneyLabel.text = @"200元/笔";
            [[NSUserDefaults standardUserDefaults] setObject:self.moneyLabel.text forKey:DefaultMoneyWithNoCode];
        }
        
        self.messageLabel.text = [NSString stringWithFormat:@"付款金额≤%@，无需输入支付密码。",moneyStr];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.TopSpaceToNoPWView.constant = 67.5*Perpt;
            [self.view layoutIfNeeded];
        }];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"on" forKey:UserNeedCodeKey];
        
    }else{
        
        self.messageLabel.text = [NSString stringWithFormat:@"开通小额免密后，使用手机进行小金额付款，无需输入支付密码。"];
        self.selectMoneyView.hidden = YES;
        self.backMainView.backgroundColor = [UIColor clearColor];
        self.viewLeading.constant = 0;
        [UIView animateWithDuration:0.1 animations:^{
            self.TopSpaceToNoPWView.constant = 17.5*Perpt;
            [self.view layoutIfNeeded];
        }];
        [[NSUserDefaults standardUserDefaults]setObject:@"off" forKey:UserNeedCodeKey];
    }
}

- (void)getPayCodeState{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];//cardno
    
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Getmemberpaylimit];
    
   self.mgr = [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            if([json[@"data"][@"isOpened"] isEqual:@(1)]){
                [[NSUserDefaults standardUserDefaults]setObject:@"on" forKey:UserNeedCodeKey];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@元/笔",json[@"data"][@"paymentLimit"]] forKey:DefaultMoneyWithNoCode];
                [self viewWillAppear:NO];
            }
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    } andProgressView:nil progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:self];
}




@end
