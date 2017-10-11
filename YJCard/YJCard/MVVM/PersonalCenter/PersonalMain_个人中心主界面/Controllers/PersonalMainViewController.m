//
//  PersonalMainViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/17.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "PersonalMainViewController.h"
#import "TotalAssetViewController.h"
#import "TotalAssetViewController.h"
#import "SafeCenterViewController.h"
#import "TradeRecordViewController.h"
#import "PersonalCenterTableViewCell.h"
#import "PersonalSetttingVController.h"
#import "PersonalMessageViewController.h"

@interface PersonalMainViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UILabel *telNumLabel;

@end

@implementation PersonalMainViewController{
    NSDictionary *personInfoDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    self.telNumLabel.text = dic[UserTelNum];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalCenterTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = MainBackViewColor;
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [LYCRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf netWorkRequests];
//        header.lastUpdatedTimeLabel.hidden = YES;
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if(!personInfoDic){
        [self netWorkRequest];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalCenterTableViewCell"];
    cell.infoDic = personInfoDic;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selfVC = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenWidth/375*485;
}

- (void)netWorkRequest{
    
    if(whetherHaveNetwork){
    
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        
        [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
        [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];//cardno
        
        NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
        NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Getmemberinfo];
        
        self.mgr = [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
            if([json[@"code"] isEqual:@(100)]){
                personInfoDic = json[@"data"];
                self.telLable.text = personInfoDic[@"mobile"];
                
                if([personInfoDic[@"isAuth"] isEqual:@(3)]){
                    self.nameLabel.text = personInfoDic[@"realName"];
                }else if([personInfoDic[@"isAuth"] isEqual:@(1)]){
                    self.nameLabel.text = @"未实名";
                }else if([personInfoDic[@"isAuth"] isEqual:@(2)]){
                    self.nameLabel.text = @"未实名";
                }else{
                    self.nameLabel.text = @"未实名";
                }
                
                if(![personInfoDic[@"headImgUrl"] isKindOfClass:[NSNull class]]){
                    [self.imageView sd_setImageWithURL:[NSURL URLWithString:personInfoDic[@"headImgUrl"]] placeholderImage:nil];
                }
                
            }else{
                [MBProgressHUD showWithText:json[@"msg"]];
            }
            [self.tableView reloadData];
            [self endRefresh];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [self endRefresh];
        } andProgressView:self.view progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:self];
    
    }else{
        [self endRefresh];
        [self.poorNetWorkView show];
        __weak typeof (self) weakSelf = self;
        self.poorNetWorkView.reloadBlock = ^{
            [weakSelf netWorkRequest];
        };
    }
}


- (void)netWorkRequests{
    
    
    if(whetherHaveNetwork){
    
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        
        [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
        [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];//cardno
        
        NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
        NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Getmemberinfo];
        
        self.mgr = [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
            if([json[@"code"] isEqual:@(100)]){
                personInfoDic = json[@"data"];
                self.telLable.text = personInfoDic[@"mobile"];
                
                if([personInfoDic[@"isAuth"] isEqual:@(3)]){
                    self.nameLabel.text = personInfoDic[@"realName"];
                }else if([personInfoDic[@"isAuth"] isEqual:@(1)]){
                    self.nameLabel.text = @"未实名";
                }else if([personInfoDic[@"isAuth"] isEqual:@(2)]){
                    self.nameLabel.text = @"未实名";
                }else{
                    self.nameLabel.text = @"未实名";
                }
                
                if(![personInfoDic[@"headImgUrl"] isKindOfClass:[NSNull class]]){
                    [self.imageView sd_setImageWithURL:[NSURL URLWithString:personInfoDic[@"headImgUrl"]] placeholderImage:nil];
                }
                
            }else{
                [MBProgressHUD showWithText:json[@"msg"]];
            }
            [self.tableView reloadData];
            [self endRefresh];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [self endRefresh];
        } andProgressView:nil progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:self];
    
    }else{
        
        [self endRefresh];
        [self.poorNetWorkView show];
        __weak typeof (self) weakSelf = self;
        self.poorNetWorkView.reloadBlock = ^{
            [weakSelf netWorkRequests];
        };
    }
}

- (IBAction)settingClick:(id)sender {
    PersonalSetttingVController * setting= [[PersonalSetttingVController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)endRefresh{
    [self.tableView.mj_header endRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self endRefresh];
}

@end
