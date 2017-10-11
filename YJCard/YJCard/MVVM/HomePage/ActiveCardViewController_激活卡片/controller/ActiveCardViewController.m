//
//  ActiveCardViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/6.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "ActiveCardViewController.h"
#import "LYCImagePicker.h"
#import <AVFoundation/AVFoundation.h>
#import "QuikBindCardModel.h"
#import "LYCBaseTabBarController.h"
#import "AppDelegate.h"


@interface ActiveCardViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *editedImageView;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) LYCImagePicker *imagePicker;
@end

@implementation ActiveCardViewController
#pragma mark - view's life
- (void)viewDidLoad {
    [super viewDidLoad];
    _passWordTF.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage)];
    [self.editedImageView addGestureRecognizer:tap];
    
    if(_alreadyActivity){
        self.passWordTF.placeholder = @"请输入卡片现有密码";
        self.messageLabel.text = @"卡片已激活，请输入卡片现有密码";
    }
    self.passWordTF.keyboardType = UIKeyboardTypeNumberPad;
    
}

- (void)requestInfomation{

    NSString * image64Base  = [self image2DataURL:self.editedImageView.image];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:self.model.cardPwd forKey:@"cardpwd"];
    [mutDic setObject:self.model.cardStatus forKey:@"cardstatus"];
    [mutDic setObject:self.model.isNeedVerifyCode.stringValue forKey:@"isneedverifycode"];
    [mutDic setObject:@"" forKey:@"verifycode"];
    [mutDic setObject:self.passWordTF.text forKey:@"cardinputpwd"];
    [mutDic setObject:self.bindCardNumber forKey:@"cardno"];
    [mutDic setObject:image64Base forKey:@"imagebase64string"];

    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,submitBindCard];
    self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            [MBProgressHUD showWithText:json[@"msg"]];
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

- (void)selectImage{
    
    LYCAlertController *alerControl = [[LYCAlertController alloc]init];
//    [alerControl setValue:@"UIAlertControllerStyleActionSheet" forKey:@"preferredStyle"];
    UIAlertAction * takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            /// 用户是否允许摄像头使用
            NSString * mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            /// 不允许弹出提示框
            if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
                
                LYCAlertController * alertC = [LYCAlertController alertControllerWithTitle:@"摄像头访问受限" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertC addAction:action];
                [self presentViewController:alertC animated:YES completion:nil];
                
            }else{
                LYCImagePicker *picker = [[LYCImagePicker alloc]init];
                _imagePicker = picker;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:nil];
                picker.delegate = self;
            }
            
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            /// 硬件问题提示
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手机没有摄像头或摄像头已损坏" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
#pragma clang diagnostic pop
        }
        
        
    }];
    
    UIAlertAction * takePhotoLBAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LYCImagePicker *picker = [[LYCImagePicker alloc]init];
        _imagePicker = picker;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
        picker.delegate = self;
    }];
    
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    
    [alerControl addAction:takePhotoAction];
    [alerControl addAction:takePhotoLBAction];
    [alerControl addAction:cancel];
    
    [self presentViewController:alerControl animated:YES completion:nil];
  
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;

}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    self.editedImageView.image = info[@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated

{
    for (UINavigationItem *item in navigationController.navigationBar.subviews) {        
        if ([item isKindOfClass:[UIButton class]]&&([item.title isEqualToString:@"取消"]||[item.title isEqualToString:@"Cancel"]))
        {
            UIButton *button = (UIButton *)item;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

- (NSString *) image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 0.01f);
        mimeType = @"image/jpeg";
    }
    return [NSString stringWithFormat:@"%@",
            [imageData base64EncodedStringWithOptions: 0]];
}

- (IBAction)commitClicked:(id)sender {
    if(self.passWordTF.text.length!=6){
        [MBProgressHUD showWithText:@"请输入密码并且密码长度为6位"];
    }else{
        NSData *data1 = UIImagePNGRepresentation(self.editedImageView.image);
        NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"拍照icon"]);
        if([data isEqual:data1]){
            [MBProgressHUD showWithText:@"请选择或者拍摄卡片"];
        }else{
            [self requestInfomation];
        }
    }
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
    NSUInteger lengthStr = string.length;
    for (NSInteger loopIndex = 0; loopIndex < lengthStr; loopIndex++)
    {
        unichar character = [string characterAtIndex:loopIndex];
        if (loopIndex == 0 && character == 48 && textField.text.length == 0)
        {
            return NO;
        }
        if (character < 48 || character > 57)
        {
            return NO;
        }
    }
    //如果是粘贴来的
    NSMutableString *fieldText=[NSMutableString stringWithString:textField.text];
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
