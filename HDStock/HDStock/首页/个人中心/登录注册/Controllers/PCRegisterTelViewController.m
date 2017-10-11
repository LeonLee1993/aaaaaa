//
//  PCRegisterTelViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/5.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCRegisterTelViewController.h"
#import "PCRegisterPwordViewController.h"

#define getCode @"http://test.cdtzb.com/api.php?mod=member&act=note&mobile=%@&type=%@&test=1%d"

@interface PCRegisterTelViewController ()
@property (nonatomic, strong) NSTimer *Timer;//倒计时
@property (nonatomic, assign) int countdown;
@end

@implementation PCRegisterTelViewController{
    NSString *_vertify;
    NSDictionary *dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeader:@""];
    [_telNumTF becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (IBAction)nextStepButton:(id)sender {
    PCRegisterPwordViewController * PWVC = [[PCRegisterPwordViewController alloc]init];
    if(_vertify.length>0){
        PWVC.codeStr = _vertify;
        PWVC.telStr = _telNumTF.text;
        PWVC.dic = dic;
        [self.navigationController pushViewController:PWVC animated:YES];
        PWVC.block = ^{
            [self backToPresentView];
        };
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请填写您的信息";
        [hud hideAnimated:YES afterDelay: 1];
    }
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

- (IBAction)getSCodeButtonClicked:(UIButton *)sender {
    _vertifyButton.userInteractionEnabled = NO;
    _countdown = 30;
    if([self isMobileNumber:self.telNumTF.text]){
            [self requestCode];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入正确的手机号码";
        [hud hideAnimated:YES afterDelay: 2];
    }
    
    sender.layer.borderColor = [UIColor grayColor].CGColor;
    [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    sender.titleLabel.text =[NSString stringWithFormat:@" 重新获取(30秒) "];
    [sender setTitle:@" 重新获取(30秒) " forState:UIControlStateNormal];
    _Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];

}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0325-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         *///中国移动:139、138、137、136、135、134、159、158、157、150、151、152、147（数据卡）、188、187、182、183、184、178
    NSString * CM = @"^1(34[0-8]|(78|47|3[5-9]|5[0127-9]|8[23478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         *///中国联通:130、131、132、156、155、186、185、145（数据卡）、176
    NSString * CU = @"^1(3[0-2]|5[256]|8[56]|45|76)\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         *///中国电信:133、153、189、180、181、177、173（待放）虛拟运营商: 1700、1705、1707、1708、1709
    NSString * CT = @"^1((33|53|8[091]|77|73)[0-9][0-9]|349[0-9]|170[05789])\\d{6}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (void)requestCode{

    NSString * url = [NSString stringWithFormat:getCode,_telNumTF.text,@"register",arc4random()%10000];

    [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {

        if([json[@"code"] isEqual:@(1)]){
            dic = json[@"data"][0];
            _vertify = [NSString stringWithFormat:@"%@",dic[@"verify"]];
            NSLog(@"%@",_vertify);
            _SCodeTF.text = _vertify;
        }else{
            [_Timer invalidate];
            _vertifyButton.userInteractionEnabled = YES;
            [_vertifyButton setTitle:@" 获取验证码 " forState:UIControlStateNormal];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"获取验证码失败";
            [hud hideAnimated:YES afterDelay:1];
            _vertifyButton.layer.borderColor = codeColor.CGColor;
            [_vertifyButton setTitleColor:codeColor forState:UIControlStateNormal];
        }
        
    } failure:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"获取验证码失败!";
        [hud hideAnimated:YES afterDelay: 2];
        [self setButtonUseful];
    }];
}

- (void)setButtonUseful{
    [_Timer invalidate];
    [_vertifyButton setTitle:@" 获取验证码 " forState:UIControlStateNormal];
    _vertifyButton.userInteractionEnabled = YES;
    _vertifyButton.layer.borderColor = codeColor.CGColor;
    [_vertifyButton setTitleColor:codeColor forState:UIControlStateNormal];
}


- (void)countDown{
    _countdown --;
    _vertifyButton.titleLabel.text =[NSString stringWithFormat:@" 重新获取(%d秒) ",_countdown];
    [_vertifyButton setTitle:[NSString stringWithFormat:@" 重新获取(%d秒) ",_countdown] forState:UIControlStateNormal];
    if (_countdown == 0) {
        [self setButtonUseful];
    }
}

- (void)backToPresentView{
    self.block();
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
