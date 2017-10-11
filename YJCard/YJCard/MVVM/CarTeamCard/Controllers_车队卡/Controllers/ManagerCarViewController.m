//
//  ManagerCarViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/26.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "ManagerCarViewController.h"
#import "ManagerCardTableViewCell.h"
#import "MissingReasonViewController.h"
#import "LYCHelper.h"
#import "ChangeCardPayCodeViewController.h"
#import "CarTeamCardManageViewController.h"
@interface ManagerCarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *managerTableView;

@end

@implementation ManagerCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableViewFrame];
}

- (void)setTableViewFrame{
    [self.managerTableView setContentInset:UIEdgeInsetsMake(15, 0, 0, 0)];
    self.managerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.managerTableView.backgroundColor = MainBackViewColor;
    [self.managerTableView registerNib:[UINib nibWithNibName:@"ManagerCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"ManagerCardTableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ManagerCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerCardTableViewCell"];
    if(indexPath.row == 0){
        cell.titleOfManager.text = @"卡片解绑";
        
    }else if(indexPath.row == 1){
       cell.titleOfManager.text = @"卡片挂失";
       
    }else if (indexPath.row == 2){
        cell.titleOfManager.text = @"修改卡片密码";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenWidth/375*50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        //卡片解绑
        [self deleteCard];
        
    }else if (indexPath.row == 1){
        //卡片挂失
        MissingReasonViewController * missingReason = [[MissingReasonViewController alloc]init];
        missingReason.cardNO = self.cardNO;
        missingReason.cardID = self.cardID;
        [self.navigationController pushViewController:missingReason animated:YES];
        
    }else if(indexPath.row == 2){
        //修改支付密码
        ChangeCardPayCodeViewController *change = [[ChangeCardPayCodeViewController alloc]init];
        change.chagePWCardID = self.cardID;
        change.chagePWCardNO = self.cardNO;
        [self.navigationController pushViewController:change animated:YES];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteCard{
    LYCAlertController * alert = [LYCAlertController alertControllerWithTitle:nil message:@"确定解绑?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * certainAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteAction];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:certainAction];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)deleteAction{
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    
    [mutDic setObject:self.cardID forKey:@"cardid"];//卡片id
    
    [mutDic setObject:self.cardNO forKey:@"cardno"];//卡号
    
//    [mutDic setObject:self.lossReasonTF.text forKey:@"note"];//挂失原因
    
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,cardremove];
    self.mgr = [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            [MBProgressHUD showWithText:@"移除成功"];
            [self commitAction];
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:self.view progressViewText:@"移除卡片中" progressViewType:LYCStateViewLoad ViewController:self];
}

- (void)commitAction{
    NSArray *controllArr = self.navigationController.viewControllers;
    NSMutableArray * mutControllArr = [NSMutableArray arrayWithArray:controllArr];
    [mutControllArr removeObjectAtIndex:mutControllArr.count -2];
    self.navigationController.viewControllers = mutControllArr;
    CarTeamCardManageViewController *manager = mutControllArr[mutControllArr.count-2];
    [manager viewDidLoad];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
