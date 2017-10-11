//
//  PCRegisterTelViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/5.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCSignInViewController.h"
#import "PCForgetPWViewController.h"
#import "PCRegisterTelPushViewController.h"
#import "PCRegisterButton.h"

#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "PCSignInEyeButton.h"


@interface PCSignInViewController ()<WeiBoDelegate>
{
    AppDelegate *delgate;
}
@property (weak, nonatomic) IBOutlet PCSignInEyeButton *eyeButton;

@end

@implementation PCSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeader:@""];
    [_firstTF becomeFirstResponder];
    _secondTF.secureTextEntry = !_eyeButton.selected;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)forgetPWButton:(id)sender {
    PCForgetPWViewController *forgetVC = [[PCForgetPWViewController alloc]init];
    WEAK_SELF;
    forgetVC.blocked = ^{
        weakSelf.blockd();
    };
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (IBAction)registerButton:(id)sender {
    PCRegisterTelPushViewController *RGTelVC = [[PCRegisterTelPushViewController alloc]init];
    WEAK_SELF;
    RGTelVC.block = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self.navigationController pushViewController:RGTelVC animated:YES];
}

- (void)setHeader:(NSString *)titleStr{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    headView.backgroundColor = MAIN_COLOR;
    [self.view addSubview:headView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 34, 200, 18)];
    [headView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = titleStr;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *backToView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 100, 44)];
    backToView.backgroundColor = [UIColor clearColor];
    [headView addSubview:backToView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToPresentView)];
    UIImageView * backImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 12, 19)];
    backImage.image = [UIImage imageNamed:@"back_icon"];
    [backToView addSubview:backImage];
    [backToView addGestureRecognizer:tap];
    
}

- (void)backToPresentView{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_firstTF resignFirstResponder];
}


#pragma mark --weiboSDK
-(void)weiboLoginByResponse:(WBBaseResponse *)response{
    NSDictionary *dic = (NSDictionary *) response.requestUserInfo;
    NSLog(@"userinfo %@",dic);
}

- (IBAction)weiboSignInButtonClicked:(PCRegisterButton *)sender {
    
    delgate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delgate.weiboDelegate = self;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    //回调地址与 新浪微博开放平台中 我的应用  --- 应用信息 -----高级应用    -----授权设置 ---应用回调中的url保持一致就好了
    request.redirectURI =@"http://www.sina.com";
    //SCOPE 授权说明参考  http://open.weibo.com/wiki/
    request.scope = @"all";
    request.userInfo = nil;
    [WeiboSDK sendRequest:request];
    
}
- (IBAction)signInButtonClicked:(UIButton *)sender {
    [self signInAction];
}

- (void)signInAction{
        
    NSString *url = loginStr;
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    NSData *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    [mutDic setObject:_firstTF.text forKey:@"username"];
    [mutDic setObject:_secondTF.text forKey:@"password"];
    if(deviceToken!=nil){
        [mutDic setObject:deviceToken forKey:@"deviceToken"];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [manager POST:url parameters:mutDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject[@"code"] isEqual:@(1)]){
            
            NSMutableDictionary *infoDic = @{}.mutableCopy;
            [infoDic setObject:responseObject[@"msg"] forKey:PCUserState];
            [infoDic setObject:responseObject[@"data"][@"token"] forKey:PCUserToken];
            [infoDic setObject:responseObject[@"data"][@"username"] forKey:PCUserName];
            [infoDic setObject:_firstTF.text forKey:PCUserPhone];
            [infoDic setObject:_secondTF.text forKey:PCUserPassword];
            [[LYCUserManager informationDefaultUser] loginWithDictionary:infoDic];
            [[LYCUserManager informationDefaultUser] getUserInformation];
            
            NSDictionary *dic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
            NSString *avatarStr = [NSString stringWithFormat:@"%@%@&%u",getAvatar,dic[PCUserToken],arc4random()%10000];
            NSMutableDictionary *mutDic = @{}.mutableCopy;
            [mutDic setObject:dic[PCUserToken] forKey:@"token"];
            [[CDAFNetWork sharedMyManager] get:avatarStr params:mutDic success:^(id json) {
                NSString * avatarStr = [NSString stringWithFormat:@"http://%@",json[@"data"][@"file_path"]];
                NSDictionary *dic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [mutDic setObject:avatarStr forKey:PCUserAvatar];
                [[LYCUserManager informationDefaultUser] loginWithDictionary:mutDic];
                [[LYCUserManager informationDefaultUser] setAvatar:avatarStr];
            } failure:^(NSError *error) {
                
            }];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = responseObject[@"msg"];
            [hud hideAnimated:YES afterDelay:1];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

-(void)weiboShareSuccessCode:(NSInteger)shareResultCode{
    
}

- (IBAction)eyeButtonClicke:(PCSignInEyeButton *)sender {
    sender.selected = !sender.selected;
    _secondTF.secureTextEntry = !sender.selected;
}

@end
