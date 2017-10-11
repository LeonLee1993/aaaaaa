//
//  HDLiveSubmitOrderViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/23.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveSubmitOrderViewController.h"
#import "HDPurcheseMianZeViewController.h"
#import "AppDelegate.h"
@interface HDLiveSubmitOrderViewController ()<UIAlertViewDelegate>{
    NSInteger payTypeIndex;//1微信 2支付宝
    NSString * orderNoStr;//订单号
    NSArray * productTypeArr;
}

@end

@implementation HDLiveSubmitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
}

- (void) setUp {
    self.title = @"提交订单";
    self.weiXinBtn.selected = YES;//默认选中微信支付
    [self.fengXianBtn setBackgroundImage:imageNamed(@"pay_fengxian") forState:(UIControlStateNormal)];
    [self.fengXianBtn setBackgroundImage:imageNamed(@"pay_fengxian_selected") forState:(UIControlStateSelected)];
    [self setNormalBackNav];
    self.payAmountLabl.text = [NSString stringWithFormat:@"¥ %@",self.needPayMoneyStr];
    payTypeIndex = 1;// 默认微信
    productTypeArr = @[@"产品-V6",@"产品-擒牛",@"产品-降龙",@"产品-捉妖"];
    self.payFormLabl.text = productTypeArr[[self.productId integerValue]-1];
    self.weiXinBgView.backgroundColor = [UIColor colorWithHexString:@"afeec7" withAlpha:0.25];
}
#pragma mark - 点击事件
//支付宝按钮点击事件
- (IBAction)zhiFuBaoBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.zhiFuBaoBgView.backgroundColor = [UIColor colorWithHexString:@"afeec7" withAlpha:0.25];
    self.zhiFuBaoSelectedIMV.alpha = 1;

    self.weiXinBtn.selected = NO;
    self.weiXinSelectedIMV.alpha = 0;
    self.weiXinBgView.backgroundColor = COLOR(whiteColor);
    
    payTypeIndex = 2;
}
//微信按钮点击事件
- (IBAction)weiXinBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.weiXinBgView.backgroundColor = [UIColor colorWithHexString:@"afeec7" withAlpha:0.25];
    self.weiXinSelectedIMV.alpha = 1;
    
    self.zhiFuBaoBtn.selected = NO;
    self.zhiFuBaoSelectedIMV.alpha = 0;
    self.zhiFuBaoBgView.backgroundColor = COLOR(whiteColor);
    
    payTypeIndex = 1;

}
//去支付按钮点击事件
- (IBAction)goToPayBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.fengXianBtn.selected) {
        [self requestOfMakeOrder];
    }else {
        [MBProgressHUD showMessage:@"请阅读和接受风险提示书" ToView:self.view RemainTime:1.5];
    }
}

- (IBAction)fengXianBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    
}
- (IBAction)bigFengXianCHeckBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.fengXianBtn.selected = sender.selected;
    if (!sender.selected) {
        _goToPayBtn.userInteractionEnabled = NO;
        _goToPayBtn.backgroundColor = UICOLOR(221, 221, 221, 0.25);
        _goToPayBtn.titleLabel.textColor = UICOLOR(6, 6, 6, 0.25);
    }else {
        _goToPayBtn.userInteractionEnabled = YES;
        _goToPayBtn.backgroundColor = UICOLOR(25, 121, 202, 1);
        _goToPayBtn.titleLabel.textColor = COLOR(whiteColor);
    }
}
//风险揭示书
- (IBAction)fengXianMianZeBtn:(UIButton *)sender {
    HDPurcheseMianZeViewController * vc = [HDPurcheseMianZeViewController new];
    vc.comeFromIndex = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
//会员服务合同
- (IBAction)huiYuanHeTongBtn:(UIButton *)sender {
    HDPurcheseMianZeViewController * vc = [HDPurcheseMianZeViewController new];
    vc.comeFromIndex = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 网络请求
//生成订单
- (void) requestOfMakeOrder {
    
    NSDictionary * dic = [self getMakeOrderDic];
    NSLog(@"requestOfMakeOrder--%@",dic);
    if (dic && [[dic allKeys] count] > 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[CDAFNetWork sharedMyManager] post:[NSString stringWithFormat:@"%@api/order/order",MAKE_ORDER] params:dic success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"json--%@",json);
            
            if ([json isKindOfClass:[NSDictionary class]])
            {
                if ([[json[@"code"] stringValue] isEqualToString:@"1"])
                {//订单生成成功
                    if ([json[@"data"] isKindOfClass:[NSArray class]] && [json[@"data"] count]>0)
                    {
                        orderNoStr = json[@"data"][0][@"order_no"];//订单号
                        NSLog(@"orderNoStr--%@",orderNoStr);
                        [MBProgressHUD showAutoMessage:json[@"msg"] ToView:self.view];
                        [self showBuySuccessAlert];//购买成功的提示
                    }else {
                        NSLog(@"订单生成成功，没数据/后台数据格式改变了");
                    }
                }else {
                    //0：订单生成失败，200:此订单已经购买过，400：未登陆
                    [self showBuyResultAlertWithStr:json[@"msg"]];//订单生成失败的提示
                }
            }else {
                NSLog(@"json返回格式不是dic");
            }
        } failure:^(NSError *error) {
            NSLog(@"error--%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else {
        NSLog(@"没有获取到参数");
    }
}
- (void) showBuyResultAlertWithStr:(NSString *)alertStr {
    if (IOS8) {
        //执行操作
        WEAK_SELF;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionContinue = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel  handler:nil];
        [alertController addAction:actionContinue];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"", nil];
        [alter show];
    }
}
- (void) showBuySuccessAlert {
    if (IOS8) {
        //执行操作
        WEAK_SELF;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"恭喜您，购买成功！" message:@"投顾服务老师将在24小时内与您取得联系开通服务。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionContinue = [UIAlertAction actionWithTitle:@"已阅" style:UIAlertActionStyleCancel  handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF;
            [strongSelf popToProductListVCWithBuyState:[strongSelf.productId integerValue]-1];
        }];
        [alertController addAction:actionContinue];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"恭喜您，购买成功！" message:@"投顾服务老师将在24小时内与您取得联系开通服务。" delegate:self cancelButtonTitle:@"已阅" otherButtonTitles:@"", nil];
        [alter show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self popToProductListVCWithBuyState:[self.productId integerValue]-1];
}
#pragma mark - 辅助信息
- (NSDictionary*) getMakeOrderDic {
    
    NSDictionary * dic;
    
    NSString * priceStr = @"";
    if (self.needPayMoneyStr) {
        priceStr = self.needPayMoneyStr;
    }
    NSString * productIdStr = @"";
    if (self.productId) {
        productIdStr = self.productId;
    }
    NSString * randomStr = [NSString stringWithFormat:@"%d",arc4random()%100];
    
    NSDictionary *tokenDic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    NSLog(@"tokenDic--%@",tokenDic);
    if (tokenDic && [[tokenDic allKeys] count] > 0 && [tokenDic[@"loginState"] isEqualToString:@"success"]) {
        
        dic = @{@"token":tokenDic[@"token"],
                @"product_id":productIdStr,
                @"price":priceStr,
                @"pay_type":[NSString stringWithFormat:@"%ld",payTypeIndex],
                @"device_info":IDENTIFIER_FOR_VENDOR,
                @"out_trade_no":@"123",
                @"attach":@"123",
                @"nonce_str":randomStr,
                @"wx_appid":@"123"};
        
    }else {
        NSLog(@"没登录");
        dic = @{};
    }
    return dic;
}

- (void) popToProductListVCWithBuyState:(NSInteger) buyState{
    
    AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //pop返回任意控制器
    //获取viewControllers
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];

    for (int i = 0; i < array.count; i ++) {
        UIViewController *vc = array[i];
        if ([vc isKindOfClass:[PersonalproductViewController class]]) {
            //如果存在直接跳转
            delegate.buySuccededToRefreshUIBool = YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }else{
            if (i == array.count-1) {
                //如果不存在这个页面，手动添加一个到viewControllers
                PersonalproductViewController *listV = [[PersonalproductViewController alloc] init];
                [array addObject:listV];
                self.navigationController.viewControllers = array;
                delegate.buySuccededToRefreshUIBool = YES;
                [self.navigationController popToViewController:listV animated:YES];
                break;
            }
        }
    }


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
