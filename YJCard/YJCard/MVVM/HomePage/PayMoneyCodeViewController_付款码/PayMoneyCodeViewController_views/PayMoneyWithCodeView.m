//
//  PayMoneyCodeView.m
//  YJCard
//
//  Created by paradise_ on 2017/7/25.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "PayMoneyWithCodeView.h"
#import "PayMoneyCodeNumButton.h"
#import "PayResultViewController.h"

@interface PayMoneyWithCodeView()
@property (weak, nonatomic) IBOutlet UILabel *firstL;
@property (weak, nonatomic) IBOutlet UILabel *secondL;
@property (weak, nonatomic) IBOutlet UILabel *thirdL;
@property (weak, nonatomic) IBOutlet UILabel *forthL;
@property (weak, nonatomic) IBOutlet UILabel *fifthL;
@property (weak, nonatomic) IBOutlet UILabel *sixthL;
@property (weak, nonatomic) IBOutlet PayMoneyCodeNumButton *back1;
@property (weak, nonatomic) IBOutlet PayMoneyCodeNumButton *back2;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation PayMoneyWithCodeView{
    NSArray * LabelArray;
    NSMutableArray * numArray;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    numArray = @[].mutableCopy;
    LabelArray = @[self.firstL,self.secondL,self.thirdL,self.forthL,self.fifthL,self.sixthL];
    self.back1.backgroundColor = RGBColor(227, 231, 238);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfdisMiss)];
    [self.topView addGestureRecognizer:tap];
}

- (void)selfdisMiss{
    if(self.dissMissBlock){
        self.dissMissBlock();
    }
    [self removeFromSuperview];
}
- (IBAction)forgetButtonClicked:(id)sender {
    self.forgetPWBlock();
}

- (IBAction)ButtonClicked:(UIButton *)sender {
    if(sender.tag==211){
        if(numArray.count>0){
            [numArray removeLastObject];
            [self setLabels];
        }
    }else{
        if(numArray.count<6){
            [numArray addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
            if(numArray.count==6){
                
                if([self.payTypeStr isEqualToString:@"payCodeView"]){
                    [self goToPayMoney1];
                }else{
                     [self goToPayMoney];
                }

            }
            [self setLabels];
        }
    }
    NSLog(@"%lu",(unsigned long)numArray.count);
}

- (void)setLabels{
    
    for (NSInteger i =0; i<numArray.count; i++) {
        ((UILabel *)LabelArray[i]).text = @"●";
    }
    
    for (NSInteger i = numArray.count; i<6; i++) {
        ((UILabel *)LabelArray[i]).text = @"";
    }
    
}

#pragma mark - 去付款
- (void)goToPayMoney{//这里是用户扫商户
    //这里判断支付前的一些信息
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    
    NSMutableString * payCodeStr = [NSMutableString string];
    for (NSString * string in numArray) {
        [payCodeStr appendString:[NSString stringWithFormat:@"%ld",string.integerValue -200]];
    }
    
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:self.payCodeStr forKey:@"paycode"];//付款码
    [mutDic setObject:self.cardNoStr forKey:@"cardno"];//卡号
    [mutDic setObject:self.amountStr forKey:@"amount"];//交易金额
    [mutDic setObject:self.caseSNStr forKey:@"casesn"];//订单序列号
    [mutDic setObject:self.deviceSNStr forKey:@"devicesn"];//设备SN
    [mutDic setObject:[NSString stringWithFormat:@"%@",self.operateID] forKey:@"operatorid"];//操作人ID
    [mutDic setObject:payCodeStr forKey:@"pwd"];//无需密码传0
    
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,PayMoney];
    [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            
            PayResultViewController * payResult = [[PayResultViewController alloc]init];
            NSMutableDictionary * mutDic = [NSMutableDictionary dictionaryWithDictionary:json[@"data"]];
            [mutDic setObject:self.storeName forKey:@"storeName"];
            [mutDic setObject:self.cardNoStr forKey:@"cardNo"];
            payResult.infoDic = mutDic;
            [self.selfVC.navigationController pushViewController:payResult animated:YES];
            
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
            [numArray removeAllObjects];
            [self setLabels];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:self.selfVC.view progressViewText:@"支付中" progressViewType:LYCStateViewLoad ViewController:nil];
}

//商户扫用户
- (void)goToPayMoney1{
    //这里判断支付前的一些信息
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    
    NSMutableString * payCodeStr = [NSMutableString string];
    for (NSString * string in numArray) {
        [payCodeStr appendString:[NSString stringWithFormat:@"%ld",string.integerValue - 200]];
    }
    
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:self.payCodeStr forKey:@"paycode"];//付款码
    [mutDic setObject:payCodeStr forKey:@"pwd"];//无需密码传0
    [mutDic setObject:self.prepaidID forKey:@"prepaidid"];//预付码
    
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,@"memberassemblytransactionelements"];
    [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        
        if([json[@"code"] isEqual:@(100)]){
            PayResultViewController * payResult = [[PayResultViewController alloc]init];
            NSMutableDictionary * mutDic = [NSMutableDictionary dictionaryWithDictionary:json[@"data"]];
            [mutDic setObject:self.storeName forKey:@"storeName"];
            [mutDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:DefaultPayCard] forKey:@"cardNo"];
            payResult.infoDic = mutDic;
            
            payResult.caseStr = self.payTypeStr;
            [self.selfVC.navigationController pushViewController:payResult animated:YES];
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
            [numArray removeAllObjects];
            [self setLabels];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self removeFromSuperview];
    } andProgressView:self.selfVC.view progressViewText:@"支付中" progressViewType:LYCStateViewLoad ViewController:nil];
}


@end
