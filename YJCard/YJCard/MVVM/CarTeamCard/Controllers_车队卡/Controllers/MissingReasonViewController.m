//
//  MissingReasonViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/27.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "MissingReasonViewController.h"
#import "LYCHelper.h"
#import "CarTeamCardDetailViewController.h"
#import "LYCBaseTabBarController.h"
#import "AppDelegate.h"

@interface MissingReasonViewController ()
@property (weak, nonatomic) IBOutlet UITextField *lossReasonTF;

@end

@implementation MissingReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lossReasonTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
- (IBAction)commitButtonClicked:(id)sender {
    
    if(self.lossReasonTF.text.length<= 0){
        
        [MBProgressHUD showWithText:@"请填写挂失原因"];
        
    }else{
        
        [self.lossReasonTF resignFirstResponder];
        
        LYCAlertController * alert = [LYCAlertController alertControllerWithTitle:nil message:@"确定挂失?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction * certainAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self certionAction];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:certainAction];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

- (void)certionAction{

        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
        [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
        
        [mutDic setObject:self.cardID forKey:@"cardid"];//卡片id
        
        [mutDic setObject:self.cardNO forKey:@"cardno"];//卡号
        
        [mutDic setObject:self.lossReasonTF.text forKey:@"note"];//挂失原因
        
        NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
        NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,cardloss];
    
        self.mgr = [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
            if([json[@"code"] isEqual:@(100)]){
                [MBProgressHUD showWithText:@"挂失成功"];
                [self commitAction];
            }else{
                [self commitAction];
                [MBProgressHUD showWithText:json[@"msg"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        } andProgressView:self.view progressViewText:@"卡片挂失中" progressViewType:LYCStateViewLoad ViewController:self];
    
}

- (void)commitAction{
    //跳转到卡片管理页面
    LYCBaseTabBarController * rootVc = [[LYCBaseTabBarController alloc] init];
    rootVc.selectedIndex = 1;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = rootVc;
}

@end
