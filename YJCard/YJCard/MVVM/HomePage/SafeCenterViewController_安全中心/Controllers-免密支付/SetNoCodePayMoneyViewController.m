//
//  SetNoCodePayMoneyViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/8/4.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "SetNoCodePayMoneyViewController.h"
#import "SelectMoneyView.h"

@interface SetNoCodePayMoneyViewController ()
@property (weak, nonatomic) IBOutlet UIView *TwoHView;//200
@property (weak, nonatomic) IBOutlet UIView *ThreeHView;//300
@property (weak, nonatomic) IBOutlet UIView *EightView;//800
@property (weak, nonatomic) IBOutlet UIView *OneThView;//1000
@property (weak, nonatomic) IBOutlet UIView *TwoThView;//2000

@end

@implementation SetNoCodePayMoneyViewController{
    NSArray * ViewArr;
    NSString * defaultMoneyToPayStr;
}
/*
 1.进来如果有默认的金额就选择默认的金额,没有的话就选择200一笔
 2.在点击的时候做一个本地的沙盒
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    ViewArr = @[self.TwoHView,self.ThreeHView,self.EightView,self.OneThView,self.TwoThView];
    for (UIView *view in ViewArr) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSelect:)];
        [view addGestureRecognizer:tap];
    }
    
    for (SelectMoneyView *view in ViewArr) {
        
        [view hidTheImage];
    
    }
    
    defaultMoneyToPayStr = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultMoneyWithNoCode];
    
}

- (void)tapToSelect:(UITapGestureRecognizer *)sender{
    UIView * NowView = sender.view;
    
    UILabel *nowViewLabel = [NowView viewWithTag:202];
    
    [self setpayNum:nowViewLabel.text];
}

- (IBAction)goBackButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)setpayNum:(NSString *)moneyText{
    NSArray * moneyArr = [moneyText componentsSeparatedByString:@"元"];
    NSString * moneyStr = moneyArr[0];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];//cardno
    [mutDic setObject:@"1" forKey:@"isopened"];//免密是否开启
    [mutDic setObject:moneyStr forKey:@"paymentlimit"];//免密限额
    
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Setmemberpaylimit];
    
   self.mgr = [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            [[NSUserDefaults standardUserDefaults]setObject:moneyText forKey:DefaultMoneyWithNoCode];
            for (SelectMoneyView *view in ViewArr) {
                [view hidTheImage];
            }
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:self.view progressViewText:@"" progressViewType:LYCStateViewLoad ViewController:self];
}



@end
