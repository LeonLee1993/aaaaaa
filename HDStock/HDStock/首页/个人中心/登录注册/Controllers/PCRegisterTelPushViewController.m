//
//  PCRegisterTelViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/5.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCRegisterTelPushViewController.h"
#import "PCRegisterPwordViewController.h"
#define getCode @"http://test.cdtzb.com/api.php?mod=member&act=note&mobile=%@&type=%@&test=1%d"
@interface PCRegisterTelPushViewController ()
@property (nonatomic, strong) NSTimer *Timer;//倒计时
@property (nonatomic, assign) int countdown;
@end

@implementation PCRegisterTelPushViewController{
    NSString *_vertify;
    NSDictionary *dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_firstTF becomeFirstResponder];
//    [self setNavCustemViewForLeftItemWithImage:imageNamed(@"Live_back") title:@"返回" titleFont:[UIFont systemFontOfSize:(15)] titleCoclor:[UIColor clearColor] custemViewFrame:CGRM(0, 26, 56, 44)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)nextStepButton:(id)sender {
    PCRegisterPwordViewController * PWVC = [[PCRegisterPwordViewController alloc]init];
    if(_vertify.length>0){
        PWVC.codeStr = _vertify;
        PWVC.telStr = _firstTF.text;
        PWVC.dic = dic;
        [self.navigationController pushViewController:PWVC animated:YES];
        WEAK_SELF;
        PWVC.block = ^{
            weakSelf.block();
        };
    }else{
        NSLog(@"请输入验证码");
    }
}
- (IBAction)vertifyButtonClicked:(UIButton *)sender {
    _vertifyButton.userInteractionEnabled = NO;
    _countdown = 30;
    [self requestCode];
    sender.layer.borderColor = [UIColor grayColor].CGColor;
    [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    sender.titleLabel.text =[NSString stringWithFormat:@" 重新获取(30秒) "];
    [sender setTitle:@" 重新获取(30秒) " forState:UIControlStateNormal];
    _Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)requestCode{
    
    NSString * url = [NSString stringWithFormat:getCode,_firstTF.text,@"register",arc4random()%10000];
    
    [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
        
        if([json[@"code"] isEqual:@(1)]){
            dic = json[@"data"][0];
            _vertify = [NSString stringWithFormat:@"%@",dic[@"verify"]];
            _secondTF.text = _vertify;
        }else{
            [_Timer invalidate];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"获取验证码失败";
            [hud hideAnimated:YES afterDelay: 2];
            _vertifyButton.userInteractionEnabled = YES;
            [_vertifyButton setTitle:@" 获取验证码 " forState:UIControlStateNormal];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"您的网络不给力!";
        [hud hideAnimated:YES afterDelay: 2];
    }];
}

- (void)countDown{
    _countdown --;
    _vertifyButton.titleLabel.text =[NSString stringWithFormat:@" 重新获取(%d秒) ",_countdown];
    [_vertifyButton setTitle:[NSString stringWithFormat:@" 重新获取(%d秒) ",_countdown] forState:UIControlStateNormal];
    if (_countdown == 0) {
        [_Timer invalidate];
        [_vertifyButton setTitle:@" 获取验证码 " forState:UIControlStateNormal];
        _vertifyButton.userInteractionEnabled = YES;
        _vertifyButton.layer.borderColor = RGBCOLOR(26, 121, 202).CGColor;
        [_vertifyButton setTitleColor:RGBCOLOR(26, 121, 202) forState:UIControlStateNormal];
    }
}



@end
