//
//  QuickBindViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/4.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "QuickBindViewController.h"
#import "ActiveCardViewController.h"
#import "QuikBindCardModel.h"
#import "activityCardWithCodeVC.h"
@interface QuickBindViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cardNoTF;

@end

@implementation QuickBindViewController{
    QuikBindCardModel *bindCardModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cardNoTF.keyboardType = UIKeyboardTypeNumberPad;
    self.cardNoTF.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (IBAction)nextStepButtonClicked:(UIButton *)sender {
        if(self.cardNoTF.text.length==16||self.cardNoTF.text.length==19){
    
            [self requestInfomation];
            
        }else{
            
            LYCAlertController * alertC = [LYCAlertController alertControllerWithTitle:@"卡号应为16位或19位" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertC addAction:action];
            [self presentViewController:alertC animated:YES completion:nil];
            
        }

}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)requestInfomation{

        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
        [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
        [mutDic setObject:self.cardNoTF.text forKey:@"cardno"];
        NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
        NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,QuickBindCardNext];
       self.mgr = [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
            if([json[@"code"] isEqual:@(100)]){
                QuikBindCardModel *model = [QuikBindCardModel yy_modelWithDictionary:json[@"data"]];
                bindCardModel = model;
                
                //判断卡的激活状态 和 是否需要 验证码
                if([bindCardModel.isNeedVerifyCode isEqual:@(0)]){
                    
                    if([bindCardModel.cardStatus isEqualToString:@"未激活"]){
                        ActiveCardViewController *active = [[ActiveCardViewController alloc]init];
                        active.model = bindCardModel;
                        active.bindCardNumber = self.cardNoTF.text;
                        [self.navigationController pushViewController:active animated:YES];
                    }else{
                        ActiveCardViewController *active = [[ActiveCardViewController alloc]init];
                        active.model = bindCardModel;
                        active.alreadyActivity = YES;
                        active.bindCardNumber = self.cardNoTF.text;
                        [self.navigationController pushViewController:active animated:YES];
                    }
                    
                }else{
                    
                    if([bindCardModel.cardStatus isEqualToString:@"未激活"]){
                        activityCardWithCodeVC *active = [[activityCardWithCodeVC alloc]init];
                        active.model = bindCardModel;
                        active.bindCardNumber = self.cardNoTF.text;
                        [self.navigationController pushViewController:active animated:YES];
                    }else{
                        activityCardWithCodeVC *active = [[activityCardWithCodeVC alloc]init];
                        active.model = bindCardModel;
                        active.alreadyActivity = YES;
                        active.bindCardNumber = self.cardNoTF.text;
                        [self.navigationController pushViewController:active animated:YES];
                    }
                }
                
            }else{
                [MBProgressHUD showWithText:json[@"msg"]];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        } andProgressView:self.view progressViewText:@"卡片验证中" progressViewType:LYCStateViewLoad ViewController:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        
        if([self stringContainsEmoji:string]){
            
            return NO;
        }
    
        if ([string length]==1) {
            if ([textField.text length]>18)
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
        if ([finalText length]>19) {
            textField.text=[finalText substringToIndex:19];
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

- (BOOL)stringContainsEmoji:(NSString *)string
{
    NSUInteger len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (len < 3) { // 大于2个字符需要验证Emoji(有些Emoji仅三个字符)
        return NO;
    }
    
    // 仅考虑字节长度为3的字符,大于此范围的全部做Emoji处理
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    Byte *bts = (Byte *)[data bytes];
    Byte bt;
    short v;
    for (NSUInteger i = 0; i < len; i++) {
        bt = bts[i];
        
        if ((bt | 0x7F) == 0x7F) { // 0xxxxxxx ASIIC编码
            continue;
        }
        if ((bt | 0x1F) == 0xDF) { // 110xxxxx 两个字节的字符
            i += 1;
            continue;
        }
        if ((bt | 0x0F) == 0xEF) { // 1110xxxx 三个字节的字符(重点过滤项目)
            // 计算Unicode下标
            v = bt & 0x0F;
            v = v << 6;
            v |= bts[i + 1] & 0x3F;
            v = v << 6;
            v |= bts[i + 2] & 0x3F;
            
            // NSLog(@"%02X%02X", (Byte)(v >> 8), (Byte)(v & 0xFF));
            
            if ([self emojiInSoftBankUnicode:v] || [self emojiInUnicode:v]) {
                return YES;
            }
            
            i += 2;
            continue;
        }
        if ((bt | 0x3F) == 0xBF) { // 10xxxxxx 10开头,为数据字节,直接过滤
            continue;
        }
        
        return YES; // 不是以上情况的字符全部超过三个字节,做Emoji处理
    }
    return NO;
}

- (BOOL)emojiInSoftBankUnicode:(short)code
{
    return ((code >> 8) >= 0xE0 && (code >> 8) <= 0xE5 && (Byte)(code & 0xFF) < 0x60);
}

- (BOOL)emojiInUnicode:(short)code
{
    if (code == 0x0023
        || code == 0x002A
        || (code >= 0x0030 && code <= 0x0039)
        || code == 0x00A9
        || code == 0x00AE
        || code == 0x203C
        || code == 0x2049
        || code == 0x2122
        || code == 0x2139
        || (code >= 0x2194 && code <= 0x2199)
        || code == 0x21A9 || code == 0x21AA
        || code == 0x231A || code == 0x231B
        || code == 0x2328
        || code == 0x23CF
        || (code >= 0x23E9 && code <= 0x23F3)
        || (code >= 0x23F8 && code <= 0x23FA)
        || code == 0x24C2
        || code == 0x25AA || code == 0x25AB
        || code == 0x25B6
        || code == 0x25C0
        || (code >= 0x25FB && code <= 0x25FE)
        || (code >= 0x2600 && code <= 0x2604)
        || code == 0x260E
        || code == 0x2611
        || code == 0x2614 || code == 0x2615
        || code == 0x2618
        || code == 0x261D
        || code == 0x2620
        || code == 0x2622 || code == 0x2623
        || code == 0x2626
        || code == 0x262A
        || code == 0x262E || code == 0x262F
        || (code >= 0x2638 && code <= 0x263A)
        || (code >= 0x2648 && code <= 0x2653)
        || code == 0x2660
        || code == 0x2663
        || code == 0x2665 || code == 0x2666
        || code == 0x2668
        || code == 0x267B
        || code == 0x267F
        || (code >= 0x2692 && code <= 0x2694)
        || code == 0x2696 || code == 0x2697
        || code == 0x2699
        || code == 0x269B || code == 0x269C
        || code == 0x26A0 || code == 0x26A1
        || code == 0x26AA || code == 0x26AB
        || code == 0x26B0 || code == 0x26B1
        || code == 0x26BD || code == 0x26BE
        || code == 0x26C4 || code == 0x26C5
        || code == 0x26C8
        || code == 0x26CE
        || code == 0x26CF
        || code == 0x26D1
        || code == 0x26D3 || code == 0x26D4
        || code == 0x26E9 || code == 0x26EA
        || (code >= 0x26F0 && code <= 0x26F5)
        || (code >= 0x26F7 && code <= 0x26FA)
        || code == 0x26FD
        || code == 0x2702
        || code == 0x2705
        || (code >= 0x2708 && code <= 0x270D)
        || code == 0x270F
        || code == 0x2712
        || code == 0x2714
        || code == 0x2716
        || code == 0x271D
        || code == 0x2721
        || code == 0x2728
        || code == 0x2733 || code == 0x2734
        || code == 0x2744
        || code == 0x2747
        || code == 0x274C
        || code == 0x274E
        || (code >= 0x2753 && code <= 0x2755)
        || code == 0x2757
        || code == 0x2763 || code == 0x2764
        || (code >= 0x2795 && code <= 0x2797)
        || code == 0x27A1
        || code == 0x27B0
        || code == 0x27BF
        || code == 0x2934 || code == 0x2935
        || (code >= 0x2B05 && code <= 0x2B07)
        || code == 0x2B1B || code == 0x2B1C
        || code == 0x2B50
        || code == 0x2B55
        || code == 0x3030
        || code == 0x303D
        || code == 0x3297
        || code == 0x3299
        // 第二段
        || code == 0x23F0) {
        return YES;
    }
    return NO;
}



@end
