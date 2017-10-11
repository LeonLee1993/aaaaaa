//
//  SafeCenterViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/6.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "SafeCenterViewController.h"
#import "SafeCenterTableViewCell.h"
#import "ResetCodeWithCertifyViewController.h"
#import "DoYouRememberPassWordViewController.h"
#import "PaySetViewController.h"
#import "FirstTimeSetCode.h"
#import "GlobelGoBackButton.h"

@interface SafeCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (weak, nonatomic) IBOutlet GlobelGoBackButton *button;

@end

@implementation SafeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self getPayCodeStateFromService];
    [self setGoBackTitle:self.goBackTitle];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenWidth/375*210, ScreenWidth, self.view.frame.size.height-ScreenWidth/375*210+64+140)];
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"SafeCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"SafeCenterTableViewCell"];
    self.tableView.backgroundColor = RGBColor(243, 243, 243);
    
}

-(void)setGoBackTitle:(NSString *)goBackTitle{
    _goBackTitle = goBackTitle;
    if(goBackTitle.length>0){
        [self.button setTitle:goBackTitle forState:UIControlStateNormal];
    }
}

#pragma mark - uitableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SafeCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SafeCenterTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row ==0){
        cell.titleLabel.text = @"支付设置";
    }else{
        cell.bottonView.hidden = YES;
        cell.titleLabel.text = @"密码设置";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenWidth/375 * 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row ==0){
        [self judgeByPayCodeState];
    }else{
        if([[[NSUserDefaults standardUserDefaults]objectForKey:PayCodeState] isEqualToString:@"not"]){
            FirstTimeSetCode * firstTime = [[FirstTimeSetCode alloc]init];
            [self.navigationController pushViewController:firstTime animated:YES];
        }else{
            DoYouRememberPassWordViewController *reset = [[DoYouRememberPassWordViewController alloc]init];
            [self.navigationController pushViewController:reset animated:YES];
        }
    }
}

#pragma mark 获取是否设置支付密码
- (void)getPayCodeStateFromService{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Issetpaypassword];
    self.mgr = [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]&&[json[@"data"] isEqual:@(1)]){
            
            [[NSUserDefaults standardUserDefaults] setObject:@"set" forKey:PayCodeState];
            
        }else if([json[@"code"] isEqual:@(100)]&&[json[@"data"] isEqual:@(0)]){
            
            [[NSUserDefaults standardUserDefaults] setObject:@"not" forKey:PayCodeState];
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
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:nil progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:self];
}



- (void)judgeByPayCodeState{
    NSString * payCodeStateStr = [[NSUserDefaults standardUserDefaults] objectForKey:PayCodeState];
    if(![payCodeStateStr isEqualToString:@"not"]){
        PaySetViewController * paySet = [[PaySetViewController alloc]init];
        [self.navigationController pushViewController:paySet animated:YES];
    }else{
        [self getPayCodeStateFromService:@"pay"];
    }
}

- (void)getPayCodeStateFromService:(NSString *)pay{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Issetpaypassword];
    self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            if([json[@"data"] isEqual:@(0)]){
                LYCAlertController * alertC = [LYCAlertController alertControllerWithTitle:@"尚未设置支付密码,请先设置" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertC animated:YES completion:nil];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    FirstTimeSetCode *reset = [[FirstTimeSetCode alloc]init];
                    [self.navigationController pushViewController:reset animated:YES];
                }];
                [alertC addAction:action];
            }else{
                PaySetViewController * paySet = [[PaySetViewController alloc]init];
                [self.navigationController pushViewController:paySet animated:YES];
            }
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:self.view progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:self];
}

@end
