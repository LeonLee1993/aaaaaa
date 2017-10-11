//
//  ResetCodeWithCertifyViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/6.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "ResetCodeWithCertifyViewController.h"
#import "CertifyCodeTF.h"
#import "FirstTimeSetCode.h"
#import <IQKeyboardManager.h>

@interface ResetCodeWithCertifyViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *touchView;
@property (weak, nonatomic) IBOutlet CertifyCodeTF *firstCode;
@property (weak, nonatomic) IBOutlet CertifyCodeTF *secondCode;
@property (weak, nonatomic) IBOutlet CertifyCodeTF *thirdCode;
@property (weak, nonatomic) IBOutlet CertifyCodeTF *forthCode;
@property (weak, nonatomic) IBOutlet CertifyCodeTF *fifthCode;
@property (weak, nonatomic) IBOutlet CertifyCodeTF *sixthCode;
@property (nonatomic, strong) NSMutableArray * textFields;
@property (weak, nonatomic) IBOutlet UITextField *testTF;
@property (weak, nonatomic) IBOutlet UIButton *sender;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) NSTimer *Timer;//倒计时
@property (weak, nonatomic) IBOutlet UILabel *userTelNumLabel;
@property (nonatomic, assign) int countdown;
@end

@implementation ResetCodeWithCertifyViewController{
    CertifyCodeTF * tempCodeTF;
    NSString * userTelNumberStr;
    NSString * verifyCodeReturnStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.firstCode becomeFirstResponder];
    [[self.sender rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self sendCodeToUser];
        [self setButtonMinAction];
    }];
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    userTelNumberStr = userInfoDic[UserTelNum];
    
    NSString *preStr = [userTelNumberStr substringToIndex:3];
    NSString *subStr = [userTelNumberStr substringFromIndex:userTelNumberStr.length-2];
    self.userTelNumLabel.text = [NSString stringWithFormat:@"%@******%@",preStr,subStr];
    
    [self setButtonMinAction];
    NSMutableAttributedString * mutStr = [[NSMutableAttributedString alloc]initWithString:@"我们已发送 验证码 到您的手机"];
    NSString * messageStr =  @"我们已发送 验证码 到您的手机";
    NSRange rangeOfMs = [messageStr rangeOfString:@"我们已发送"];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:rangeOfMs];
    
    NSRange rangeOfMs1 = [messageStr rangeOfString:@"验证码"];
    [mutStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangeOfMs1];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:rangeOfMs1];
    
    NSRange rangeOfMs2 = [messageStr rangeOfString:@"到您的手机"];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:rangeOfMs2];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tempCodeTFRespond)];
    [self.touchView addGestureRecognizer:tap];
    
    self.messageLabel.attributedText = mutStr;
    
    self.textFields = @[].mutableCopy;
    
    tempCodeTF = self.firstCode;
    [[self.firstCode rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
        if(self.firstCode.text.length >=1){
            [self.secondCode becomeFirstResponder];
            tempCodeTF = self.secondCode;
        }
    }];
    
    [[self.secondCode rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
        if(self.secondCode.text.length >=1){
            [self.thirdCode becomeFirstResponder];
            tempCodeTF = self.thirdCode;
          
        }else if(self.secondCode.text.length == 0){
            [self.firstCode becomeFirstResponder];
            tempCodeTF = self.firstCode;
        }
    }];
    
    [[self.thirdCode rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
        if(self.thirdCode.text.length >=1){
            [self.forthCode becomeFirstResponder];
            tempCodeTF = self.forthCode;
        
        }else if(self.thirdCode.text.length == 0){
            [self.secondCode becomeFirstResponder];
            tempCodeTF = self.secondCode;
        }
    }];
    
    [[self.forthCode rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
        if(self.forthCode.text.length >=1){
            [self.fifthCode becomeFirstResponder];
            tempCodeTF = self.fifthCode;
        }else if(self.forthCode.text.length == 0){
            [self.thirdCode becomeFirstResponder];
              tempCodeTF = self.thirdCode;
        }
    }];
    
    [[self.fifthCode rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
        if(self.fifthCode.text.length >=1){
            [self.sixthCode becomeFirstResponder];
            tempCodeTF = self.sixthCode;
        }else if(self.fifthCode.text.length == 0){
            [self.forthCode becomeFirstResponder];
            tempCodeTF = self.sixthCode;
        }
    }];
    
    [[self.sixthCode rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
        if(self.sixthCode.text.length >=1){
            [self.sixthCode resignFirstResponder];
            tempCodeTF = self.sixthCode;
            [self verifyCode];
        }else if(self.sixthCode.text.length == 0){
            [self.fifthCode becomeFirstResponder];
            tempCodeTF = self.fifthCode;
        }
    }];
    
    self.fifthCode.delegate = self;
    self.secondCode.delegate = self;
    self.thirdCode.delegate = self;
    self.forthCode.delegate = self;
    self.fifthCode.delegate = self;
    self.sixthCode.delegate = self;
    
    [self sendCodeToUser];
    
    
    
}

- (void)tempCodeTFRespond{
    [tempCodeTF becomeFirstResponder];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    //    keyboardManager.toolbarManageBehaviour = IQAutoToolbarByTag;
    keyboardManager.enableAutoToolbar = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enableAutoToolbar = YES;
}

- (void)setButtonMinAction{
    
    _countdown = 60;
    self.sender.userInteractionEnabled = NO;
    self.sender.layer.borderColor = [UIColor grayColor].CGColor;
    [self.sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.sender.titleLabel.text =[NSString stringWithFormat:@"60秒后重发"];
    [self.sender setTitle:@"60秒后重发" forState:UIControlStateNormal];
    _Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
}

-(void)textFieldDidDeleteBackward:(UITextField *)textField{
    if(textField.tag>201){
        CertifyCodeTF *tf = [self.view viewWithTag:textField.tag-1];
        [tf becomeFirstResponder];
        tf.text =@"";
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)countDown{
    _countdown --;
    _sender.titleLabel.text =[NSString stringWithFormat:@"%d秒后重发",_countdown];
    [_sender setTitle:[NSString stringWithFormat:@"%d秒后重发",_countdown] forState:UIControlStateNormal];
    if (_countdown == 0) {
        [_Timer invalidate];
        _Timer = nil;
        [_sender setTitle:@"获取验证码" forState:UIControlStateNormal];
        _sender.userInteractionEnabled = YES;
        [_sender setTitleColor:MainColor forState:UIControlStateNormal];
    }
}

-(void)dealloc{
    [self.Timer invalidate];
    self.Timer = nil;
}

- (void)sendCodeToUser{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:dic[UserTelNum] forKey:@"mobile"];
    NSString * testStr = [NSString setUrlEncodeStringWithDic:mutDic];
    self.mgr =[[LYCNetworkManager manager]LYC_Post:[NSString stringWithFormat:@"%@%@",GlobelHeader,Getresetpwdverfycode] params:testStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            verifyCodeReturnStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            [[NSUserDefaults standardUserDefaults]setObject:verifyCodeReturnStr forKey:@"resetVerifyCodeReturnStr"];//将返回的idStr保存本地,防止用户有其他操作的时候丢失掉这个量
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    } andProgressView:nil progressViewText:@"" progressViewType:LYCStateViewLoad ViewController:self];
}

#pragma mark - 验证验证码 - 网络请求
- (void)verifyCode{
    
    NSString * codeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",self.firstCode.text,self.secondCode.text,self.thirdCode.text,self.forthCode.text,self.fifthCode.text,self.sixthCode.text];
    NSArray * codeStrArr = [codeStr componentsSeparatedByString:@" "];
    NSMutableString *RealCodeStr = [[NSMutableString alloc]init];
    for (NSString * str in codeStrArr) {
        if(str.length){
            [RealCodeStr appendString:str];
        }
    }

    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:dic[UserTelNum] forKey:@"mobile"];
    [mutDic setObject: [[NSUserDefaults standardUserDefaults]objectForKey:@"resetVerifyCodeReturnStr"] forKey:@"mobileverifyid"];
    [mutDic setObject:RealCodeStr forKey:@"verifycode"];
    NSString * testStr = [NSString setUrlEncodeStringWithDic:mutDic];
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",GlobelHeader,Checkverifycode];
   self.mgr = [[LYCNetworkManager manager]LYC_Post:[NSString stringWithFormat:@"%@%@",GlobelHeader,Checkverifycode] params:testStr success:^(id json) {
        
        if([json[@"code"] isEqual:@(100)]){
            FirstTimeSetCode *firstCodeVC = [[FirstTimeSetCode alloc]init];
            [self.navigationController pushViewController:firstCodeVC animated:YES];
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:self.view progressViewText:@"验证用户数据中" progressViewType:LYCStateViewLoad ViewController:self];
    
}

@end
