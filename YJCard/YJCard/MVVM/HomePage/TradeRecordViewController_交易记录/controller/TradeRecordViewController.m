//
//  TradeRecordViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/6.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TradeRecordViewController.h"
#import "TradeListViewController.h"
#import "GlobelGoBackButton.h"

@interface TradeRecordViewController ()
@property (weak, nonatomic) IBOutlet UIView *recordView;//消费记录
@property (weak, nonatomic) IBOutlet UIView *chargeRecordView;//充值记录
@property (weak, nonatomic) IBOutlet GlobelGoBackButton *button;


@end

@implementation TradeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeDetail:)];
    [self.recordView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeDetail:)];
    
    [self.chargeRecordView addGestureRecognizer:tap2];
    [self setGoBackTitle:self.goBackTitle];
}


- (void)seeDetail:(UIGestureRecognizer *)sender{
    switch (sender.view.tag) {
        case 201:{
            sender.view.alpha = 0.7;
            TradeListViewController *list = [[TradeListViewController alloc]init];
            list.type = LYCTradeListTypeConsume;
            [self.navigationController pushViewController:list animated:YES];
        }
            break;
            
        case 202:{
            sender.view.alpha = 0.7;
            TradeListViewController *list = [[TradeListViewController alloc]init];
            list.type = LYCTradeListTypeCharge;
            [self.navigationController pushViewController:list animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.recordView.alpha = 1;
    self.chargeRecordView.alpha = 1;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)setGoBackTitle:(NSString *)goBackTitle{
    _goBackTitle = goBackTitle;
    if(goBackTitle.length>0){
        [self.button setTitle:goBackTitle forState:UIControlStateNormal];
    }
}


@end
