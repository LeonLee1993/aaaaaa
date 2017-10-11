//
//  activityCardWithCodeVC.m
//  YJCard
//
//  Created by paradise_ on 2017/7/10.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "activityCardWithCodeVC.h"
#import "QuikBindCardModel.h"
#import "LYCBaseTabBarController.h"
#import "AppDelegate.h"
@interface activityCardWithCodeVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *messageLable;

@end

@implementation activityCardWithCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(self.alreadyActivity){
        self.passwordTF.placeholder = @"请输入卡片现有密码";
        self.messageLable.text = @"卡片已激活，请输入卡片现有密码";
    }
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTF.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTF.delegate = self;
    self.codeTF.delegate = self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)requestInfomation{
    
//    NSString * image64Base  = [self image2DataURL:self.editedImageView.image];
    //    if(self.passWordTF.text.length==6)
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:self.model.cardPwd forKey:@"cardpwd"];
    [mutDic setObject:self.model.cardStatus forKey:@"cardstatus"];
    [mutDic setObject:self.model.isNeedVerifyCode.stringValue forKey:@"isneedverifycode"];
    [mutDic setObject:self.codeTF.text forKey:@"verifycode"];
    [mutDic setObject:self.passwordTF.text forKey:@"cardinputpwd"];
    [mutDic setObject:self.bindCardNumber forKey:@"cardno"];
    [mutDic setObject:@"" forKey:@"imagebase64string"];
    
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,submitBindCard];
    self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            //移除上一层控制器
            LYCBaseTabBarController * rootVc = [[LYCBaseTabBarController alloc] init];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = rootVc;
            
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:self.view progressViewText:@"卡片激活中" progressViewType:LYCStateViewLoad ViewController:self];
}

- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *) image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
}

- (IBAction)commitButtonClicked:(id)sender {
    [self requestInfomation];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   
        if ([string length]==1) {
            if ([textField.text length]>5)
                return NO;
            if([self validateNumber:string]){
                return YES;
            }else{
                return NO;
            }
        }
        
        //获得当前输入框内的字符串
        NSMutableString *fieldText=[NSMutableString stringWithString:textField.text];
        //完成输入动作，包括输入字符，粘贴替换字符
        [fieldText replaceCharactersInRange:range withString:string];
        NSString *finalText=[fieldText copy];

        if ([finalText length]>6) {
            textField.text=[finalText substringToIndex:6];
            return NO;
        }
        return YES;
  
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}

@end
