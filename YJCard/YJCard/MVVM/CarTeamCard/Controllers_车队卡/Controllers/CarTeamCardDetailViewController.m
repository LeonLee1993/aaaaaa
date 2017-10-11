//
//  CarTeamCardDetailViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/10.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "CarTeamCardDetailViewController.h"
#import "TradeRecordViewController.h"
#import "CardDetailModel.h"
#import "ManagerCarViewController.h"
#import "TradeListViewController.h"
#import "AppDelegate.h"

@interface CarTeamCardDetailViewController ()
//@property (weak, nonatomic) IBOutlet UILabel *CarIDLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;

@end

@implementation CarTeamCardDetailViewController{
     NSMutableArray * dataArr;
     CardDetailModel * DetailModel;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([self.detailCardType isEqualToString:@"1"]){//如果是电子卡 就改变背景色
        [self setBackColor];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!DetailModel){
        [self requestInfomation];
    }
}

- (void)setBackColor{
    
    self.topView.backgroundColor = RGBColor(14, 91, 154);
    self.backView.backgroundColor = RGBColor(14, 91, 154);
    self.backView1.backgroundColor = RGBColor(14, 91, 154);
    self.cardBackImageView.image = [UIImage imageNamed:@"卡BG-蓝色"];
    self.chargeRecordButton.backgroundColor = RGBColor(14, 91, 154);
    self.resumeRecordButton.layer.borderColor = RGBColor(14, 91, 154).CGColor;
    [self.resumeRecordButton setTitleColor:RGBColor(14, 91, 154) forState:UIControlStateNormal];
    
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestInfomation{
    //这个地方view的bounds居然是600*600 回来看看要
    [dataArr removeAllObjects];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:_detailCardId forKey:@"cardid"];
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,UserCardDetail];
    
    self.mgr = [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        CardDetailModel * model = [CardDetailModel yy_modelWithDictionary:json[@"data"]];
        DetailModel = model;
        [self setInfoMations];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:delegate.window progressViewText:@"加载详情中" progressViewType:LYCStateViewLoad ViewController:self];
}

- (void)setInfoMations{
    
    NSMutableDictionary * attributeDic = @{}.mutableCopy;
    NSAttributedString * attribute = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",DetailModel.cardNo] attributes:attributeDic];
    self.cardIDLabel.attributedText = attribute;
    
    self.leftMoneyLabel.text = [NSString StransformStringToFloatFormatRMB:DetailModel.cashBalance];
    
    self.rebateLabel.text = DetailModel.rebateBalance;
    
    self.totalPayMoneyLabel.text = [NSString StransformStringToFloatFormatRMB:DetailModel.totalConsumCash];
    
    self.totalRewardMoney.text = DetailModel.totalRewardAmount;
    
    self.totalConsumRebate.text = DetailModel.totalConsumRebate;
    
    self.totalInjectMoneyLabel.text = [NSString StransformStringToFloatFormatRMB:DetailModel.totalPayAmount];
    
    self.cardType.text = [self.detailCardType isEqualToString:@"0"] ? @"实体卡":@"电子卡";
    
    self.settingButton.hidden =[self.detailCardType isEqualToString:@"0"] ? NO:YES;
    
    self.cardStatusLabel.text = self.detailCardStatus;

    NSArray *arr = [self.detailCardData componentsSeparatedByString:@" "];
    self.cardData.text = arr[0];
    
}

- (IBAction)cardRecordButtonClicked:(id)sender {
    TradeListViewController *tradeRecord = [[TradeListViewController alloc]init];
    tradeRecord.type = LYCTradeListTypeCharge;
    tradeRecord.cardID = self.detailCardId;
    [self.navigationController pushViewController:tradeRecord animated:YES];
}
- (IBAction)cosumButtonClicked:(id)sender {
    TradeListViewController *tradeRecord = [[TradeListViewController alloc]init];
    tradeRecord.type = LYCTradeListTypeConsume;
    tradeRecord.cardID = self.detailCardId;
    [self.navigationController pushViewController:tradeRecord animated:YES];
}

- (IBAction)setCarButtonClicked:(UIButton *)sender {
    if(DetailModel.cardNo.length>0){//当加载出来数据的时候才能跳转
        ManagerCarViewController *manager = [[ManagerCarViewController alloc]init];
        manager.cardID = self.detailCardId;
        manager.cardNO = DetailModel.cardNo;
        [self.navigationController pushViewController:manager animated:YES];
    }
    
}

@end
