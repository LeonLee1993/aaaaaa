//
//  HomePageViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/6/28.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "HomePageViewController.h"
#import "ScanCodeViewController.h"
#import "HPTopView.h"
#import "myAssetTableViewCell.h"
#import "OtherInforTableViewCell.h"
#import "HPFunctionButton.h"
#import "TopViewEventViewModel.h"
#import "ThirdImageTableViewCell.h"
#import "PayMoneyCodeViewController.h"//支付码
#import "QueryCardViewController.h"//卡片查询
#import "ChargeCardViewController.h"//卡片充值
#import "HPFunctionLitterButton.h"
#import "QuickBindViewController.h"
#import "TradeRecordViewController.h"
#import "SafeCenterViewController.h"
#import "YJCXStack.h"
#import "HomePageModel.h"
#import "TotalAssetViewController.h"
#import "LastTradeInfoModel.h"
#import "TendentMainViewController.h"
#import "FirstTimeSetCode.h"
#import "ResetCodeWithCertifyViewController.h"
#import "TendentSearchViewController.h"
#import "TradeDetailViewController.h"

//static const CGFloat ScrollViewOriginOffset = -20.0;
#define HPTopViewHeight ScreenWidth*207/375+64
@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) HPTopView * topView;

@end

@implementation HomePageViewController{
    HomePageModel * homeModel;
    LastTradeInfoModel *infoModel;
}

#pragma mark - View's life

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = MainBackViewColor;
    [self setupTableView];
    [self topViewEvents];
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [LYCRefreshHeader headerWithRefreshingBlock:^{
        if(whetherHaveNetwork){
            [weakSelf requestInfomationHeader];
        }else{
            [weakSelf endRefresh];
            [self.poorNetWorkView show];
            self.poorNetWorkView.reloadBlock = ^{
                [weakSelf requestInfomationHeader];
            };
        }
    }];
    [self.tableView.mj_header beginRefreshing];
    [LYCLocationSigleton LYCLocationManager];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf = self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if(!homeModel&&!infoModel){
        if(whetherHaveNetwork){
            [self requestInfomationHeader];
        }else{
            [self endRefresh];
            [self.poorNetWorkView show];
            self.poorNetWorkView.reloadBlock = ^{
                [weakSelf requestInfomationHeader];
            };
        }
    }
}

#pragma mark - UITableViewDelegate&DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(infoModel&&homeModel){
        return 2;
    }else if(homeModel){
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row ==0){
        myAssetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myAssetTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(homeModel){
            cell.model = homeModel;
        }
        return cell;
    }else if(indexPath.row == 1){
        OtherInforTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherInforTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = infoModel;
        return cell;
    }else{
        ThirdImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThirdImageTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return ScreenWidth*200/375+11;
    }else if(indexPath.row == 1){
        return ScreenWidth*160/375+11;
    }else{
        return 177;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        TotalAssetViewController * totalAsset = [[TotalAssetViewController alloc]init];
        [MobClick event:@"totalAsset"];
        [self.navigationController pushViewController:totalAsset animated:YES];
    }else if (indexPath.row ==1){
        TradeDetailViewController *quickBind = [[TradeDetailViewController alloc]init];
        [MobClick event:@"tradeRecord"];
        if([infoModel.tradeType isEqual:@(1)]){
            quickBind.type = LYCTradeDetailTypeConsume;
        }else{
            quickBind.type = LYCTradeDetailTypeCharge;
        }
        quickBind.tradeIdString = [NSString stringWithFormat:@"%@",infoModel.tradeId];
        [self.navigationController pushViewController:quickBind animated:YES];
    }
}

#pragma mark - OtherFuctions
- (void)clickToScsan{
    ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc]init];
    [self.navigationController pushViewController:scanCodeVC animated:YES];
}

- (void)topViewEvents{
    
    __weak typeof(self) weakSelf = self;
    //扫描按键事件
    [[_topView.scanButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [MobClick event:@"scanEvent"];
        [weakSelf judgeByPayCodeStates];
    }];
    
    
    _topView.tapToSearchBlock = ^{
        [MobClick event:@"searchEvent"];
        TendentSearchViewController * tendentSearch = [[TendentSearchViewController alloc]init];
        [weakSelf.navigationController pushViewController:tendentSearch animated:YES];
    };
    /*
     1.之前是否设置过支付密码,如果设置过直接进入,如果没有设置则在付款码页面提示
     2.是否设置过支付密码本地化处理
     */
    [[_topView.payMoneyCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [MobClick event:@"payCodeEvent"];
        [weakSelf judgeByPayCodeState];
    }];
    
    //以前的帮助按钮,现在的商户网点按钮
    [[_topView.offerHelp rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [MobClick event:@"merchantLocation"];
        TendentMainViewController * TMVC = [[TendentMainViewController alloc]init];
        [weakSelf.navigationController pushViewController:TMVC animated:YES];
    }];
    
    [[_topView.queryCardButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [MobClick event:@"merchantLocation"];
        QueryCardViewController *payMoney = [[QueryCardViewController alloc]init];
        [self.navigationController pushViewController:payMoney animated:YES];
    }];
    
    [[_topView.chargeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ChargeCardViewController *payMoney = [[ChargeCardViewController alloc]init];
        [self.navigationController pushViewController:payMoney animated:YES];
    }];
    
    [[_topView.quickBind rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [MobClick event:@"quickBind"];
        QuickBindViewController *quickBind = [[QuickBindViewController alloc]init];
        [self.navigationController pushViewController:quickBind animated:YES];
    }];
    
    [[_topView.saleRecord rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [MobClick event:@"tradeRecord"];
        TradeRecordViewController *quickBind = [[TradeRecordViewController alloc]init];
        [self.navigationController pushViewController:quickBind animated:YES];
    }];
    
    [[_topView.safeCenter rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [MobClick event:@"safeCenter"];
        SafeCenterViewController *quickBind = [[SafeCenterViewController alloc]init];
        [self.navigationController pushViewController:quickBind animated:YES];
    }];
}

#pragma mark - SetUpUI
- (void)setupTableView{
    HPTopView *topView = [HPTopView viewFromXib];
    topView.frame = CGRectMake(0, 0, ScreenWidth, HPTopViewHeight+64);
    _topView = topView;
    [self.view addSubview:topView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame)-44, ScreenWidth, ScreenHeight - HPTopViewHeight -64 -64 - 70)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = MainBackViewColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"myAssetTableViewCell" bundle:nil] forCellReuseIdentifier:@"myAssetTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OtherInforTableViewCell" bundle:nil] forCellReuseIdentifier:@"OtherInforTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ThirdImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ThirdImageTableViewCell"];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    static const CGFloat miniOffset = 72;//头部视图展示的最小距离
//    if(scrollView == self.tableView){
////        NSLog(@"originY:%f",scrollView.frame.origin.y);
//        //向上滑的时候
//        if(scrollView.contentOffset.y>ScrollViewOriginOffset && self.tableView.lyc_y > miniOffset){
//            
//            CGFloat distance = scrollView.contentOffset.y - ScrollViewOriginOffset;
//            CGPoint point = scrollView.contentOffset;
//            point.y = ScrollViewOriginOffset;
//            scrollView.contentOffset = point;
//            
//            self.tableView.lyc_y -= distance;
//            self.topView.lyc_y -= distance;
//            
//            self.tableView.lyc_height += distance;
//            
//            if(self.topView.lyc_y<miniOffset- HPTopViewHeight){
//                self.topView.lyc_y = miniOffset- HPTopViewHeight;
//                self.tableView.lyc_y = miniOffset;
//                self.tableView.lyc_height = ScreenHeight - miniOffset -40;
//            }
//        }
//        
//        //向下滑的时候
//        if(scrollView.contentOffset.y< ScrollViewOriginOffset && self.tableView.lyc_y < HPTopViewHeight){
//            CGFloat distance = scrollView.contentOffset.y - ScrollViewOriginOffset;
//            CGPoint point = scrollView.contentOffset;
//            point.y = ScrollViewOriginOffset;
//            scrollView.contentOffset = point;
//            
//            self.tableView.lyc_y -= distance;
//            self.topView.lyc_y -= distance;
//            self.tableView.lyc_height += distance;
//            
//            if(self.topView.lyc_y>0){
//                self.topView.lyc_y = 0;
//                self.tableView.lyc_y = HPTopViewHeight;
//                self.tableView.lyc_height = ScreenHeight - HPTopViewHeight -40;
//            }
//        }
//    }
}


- (void)judgeByPayCodeState{
    NSString * payCodeStateStr = [[NSUserDefaults standardUserDefaults] objectForKey:PayCodeState];
    if(payCodeStateStr.length>0){
        PayMoneyCodeViewController *payMoney = [[PayMoneyCodeViewController alloc]init];
        if([payCodeStateStr isEqualToString:@"not"]){
            payMoney.DidSetCode = NO;
        }else{
            payMoney.DidSetCode = YES;
        }
        [self.navigationController pushViewController:payMoney animated:YES];
    }else{
        [self getPayCodeStateFromService:@"pay"];
    }
}

- (void)judgeByPayCodeStates{
    NSString * payCodeStateStr = [[NSUserDefaults standardUserDefaults] objectForKey:PayCodeState];
    
    if(![payCodeStateStr isEqualToString:@"set"]){
        [self getPayCodeStateFromService:@""];
    }else{
        ScanCodeViewController *scan = [[ScanCodeViewController alloc]init];
        scan.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scan animated:NO];
    }
}

#pragma mark 获取是否设置支付密码
- (void)getPayCodeStateFromService:(NSString *)pay{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Issetpaypassword];
    self.mgr = [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]&&[json[@"data"] isEqual:@(1)]){
            //在设置了支付密码的时候
            if([pay isEqualToString:@"pay"]){
                PayMoneyCodeViewController *payMoney = [[PayMoneyCodeViewController alloc]init];
                if([json[@"data"] isEqual:@(0)]){
                    payMoney.DidSetCode = NO;
                    [[NSUserDefaults standardUserDefaults] setObject:@"not" forKey:PayCodeState];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:@"set" forKey:PayCodeState];
                    payMoney.DidSetCode = YES;
                }
                
                [self.navigationController pushViewController:payMoney animated:YES];
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setObject:@"set" forKey:PayCodeState];
                ScanCodeViewController *scan = [[ScanCodeViewController alloc]init];
                scan.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:scan animated:NO];
            }
            
        }else{//在没有设置支付密码的时候
            if([pay isEqualToString:@"pay"]){
                
                PayMoneyCodeViewController *payMoney = [[PayMoneyCodeViewController alloc]init];
                if([json[@"data"] isEqual:@(0)]){
                    [[NSUserDefaults standardUserDefaults] setObject:@"not" forKey:PayCodeState];
                    payMoney.DidSetCode = NO;
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:@"set" forKey:PayCodeState];
                    payMoney.DidSetCode = YES;
                }
                [self.navigationController pushViewController:payMoney animated:YES];
                
            }else{
                LYCAlertController * alertC = [LYCAlertController alertControllerWithTitle:@"尚未设置支付密码,请先设置" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertC animated:YES completion:nil];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    FirstTimeSetCode *reset = [[FirstTimeSetCode alloc]init];
                    [self.navigationController pushViewController:reset animated:YES];
                }];
                UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                   
                }];
                [alertC addAction:action];
                [alertC addAction:action1];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:self.view progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:self];
}


#pragma mark - networkRequestion(网络请求)
//- (void)requestInfomation{
//    
//    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
//    NSMutableDictionary *mutDic = @{}.mutableCopy;
//    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
//    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
//    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
//    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,GetHomePageInfo];
//    self.mgr = [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
//        if([json[@"code"] isEqual:@(100)]){
//            
//            HomePageModel *model = [HomePageModel yy_modelWithDictionary:json[@"data"]];
//            homeModel = model;
//            
//            NSMutableDictionary * assetMutDic = @{}.mutableCopy;
//            [assetMutDic setObject:model.totalBalance forKey:UserTotalMoney];
//            [assetMutDic setObject:model.cashBalance forKey:UserTotalCash];
//            [assetMutDic setObject:model.rebateBalance forKey:UserTotalRebate];
//            [[NSUserDefaults standardUserDefaults]setObject:assetMutDic forKey:UserAsset];
//            
//            if([json[@"data"][@"lastTradeInfo"] isKindOfClass:[NSDictionary class]]){
//                LastTradeInfoModel *lastInfo = [LastTradeInfoModel yy_modelWithDictionary:json[@"data"][@"lastTradeInfo"]];
//                infoModel = lastInfo;
//            }
//            
//            [self.tableView reloadData];
//            
//        }else{
//            [MBProgressHUD showWithText:json[@"msg"]];
//        }
//    } failure:^(NSError *error) {
//        
//        NSLog(@"%@",error);
//        
//    } andProgressView:nil progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:self];
//}

- (void)requestInfomationHeader{
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,GetHomePageInfo];
   self.mgr = [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            HomePageModel *model = [HomePageModel yy_modelWithDictionary:json[@"data"]];
            homeModel = model;
            NSMutableDictionary * assetMutDic = @{}.mutableCopy;
            [assetMutDic setObject:model.totalBalance forKey:UserTotalMoney];
            [assetMutDic setObject:model.cashBalance forKey:UserTotalCash];
            [assetMutDic setObject:model.rebateBalance forKey:UserTotalRebate];
            
            [[NSUserDefaults standardUserDefaults]setObject:assetMutDic forKey:UserAsset];
            
            if([json[@"data"][@"lastTradeInfo"] isKindOfClass:[NSDictionary class]]){
                LastTradeInfoModel *lastInfo = [LastTradeInfoModel yy_modelWithDictionary:json[@"data"][@"lastTradeInfo"]];
                infoModel = lastInfo;
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
        [self endRefresh];
    } failure:^(NSError *error) {
        [self endRefresh];
    } andProgressView:nil progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:self];
}

- (void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self endRefresh];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
