//
//  ScanCodeToPayMoneyViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/24.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "ScanCodeToPayMoneyViewController.h"
#import "AffirmTheMoneyView.h"
#import "ResetCodeWithCertifyViewController.h"
#import "ScanCodeResultModel.h"


#define NumbersWithDot     @"0123456789.\n"
#define NumbersWithoutDot  @"0123456789\n"

@interface ScanCodeToPayMoneyViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UITextField *moneyCountTF;
//商家名称  -- 向“小草湖加油站”付款
@property (weak, nonatomic) IBOutlet UILabel *salerNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *payMoneyButton;
@property (weak, nonatomic) IBOutlet UITextField *appendReasonTF;

@end

@implementation ScanCodeToPayMoneyViewController{
    NSMutableArray * payCardArr;
//    BOOL cannotSetMoneyCount;//如果为YES,则不可设置金额
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.moneyCountTF becomeFirstResponder];
    payCardArr = @[].mutableCopy;
    [self.moneyCountTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.moneyCountTF.delegate = self;
    self.moneyCountTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.payMoneyButton.userInteractionEnabled = NO;
    [self setViewByModel];
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 通过model的值来设置界面
- (void)setViewByModel{
    if(self.model.amount.floatValue==0||!self.model.amount){
        //正常程序 价格那些都还可以改变
        [payCardArr removeAllObjects];
        for (NSDictionary *dic in self.model.memberPayCards) {
            MemberPayCardsModel * model = [MemberPayCardsModel yy_modelWithDictionary:dic];
            [payCardArr addObject:model];
        }
        self.salerNameLabel.text = [NSString stringWithFormat:@"向\"%@\"付款",self.model.retailerName];
        
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.model.retailerImage] placeholderImage:[UIImage imageNamed:@"商户头像"]];
        
    }else{
        
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.model.retailerImage] placeholderImage:[UIImage imageNamed:@"商户头像"]];
        
        [payCardArr removeAllObjects];
        for (NSDictionary *dic in self.model.memberPayCards) {
            MemberPayCardsModel * model = [MemberPayCardsModel yy_modelWithDictionary:dic];
            [payCardArr addObject:model];
        }
        self.payMoneyButton.backgroundColor = MainColor;
        self.payMoneyButton.userInteractionEnabled = YES;

        self.moneyCountTF.userInteractionEnabled = NO;
        
        self.salerNameLabel.text = [NSString stringWithFormat:@"向\"%@\"付款",self.model.retailerName];
        
        //上面的界面传了RMB来 直接进入确认付款界面 价格不可再改
        self.moneyCountTF.text = self.model.amount;
        AffirmTheMoneyView * affirm = [AffirmTheMoneyView initWithCards:payCardArr];
        affirm.selfVC = self;
        affirm.storeName = self.model.retailerName;
        affirm.moneyNeedToPay = self.model.amount;
        affirm.payCodeStr = self.model.payCode;
        affirm.casesnStr = self.model.caseSN;
        affirm.cardsArray = payCardArr;
        [self.view addSubview:affirm];
        [self.moneyCountTF resignFirstResponder];
        __weak typeof (self)weakSelf = self;
        
        affirm.pushBlock = ^{
            ResetCodeWithCertifyViewController *reset = [[ResetCodeWithCertifyViewController alloc]init];
            [weakSelf.navigationController pushViewController:reset animated:YES];
        };
    }
}

- (IBAction)ClickToPayMoney:(id)sender {
    
    if(self.moneyCountTF.text.floatValue==0){
        
        [MBProgressHUD showWithText:@"付款金额不能为0"];

    }else{
        
        AffirmTheMoneyView * affirm = [AffirmTheMoneyView initWithCards:payCardArr];
        [self.appendReasonTF resignFirstResponder];
        affirm.payCodeStr = self.model.payCode;
        double temp = self.moneyCountTF.text.doubleValue;
        affirm.moneyNeedToPay = [NSString stringWithFormat:@"%.2f",temp];
        affirm.casesnStr = self.model.caseSN;
        affirm.storeName = self.model.retailerName;
        affirm.cardsArray = payCardArr;
        affirm.selfVC = self;
        [self.view addSubview:affirm];
        [self.moneyCountTF resignFirstResponder];

        __weak typeof (self)weakSelf = self;
        affirm.pushBlock = ^{
            ResetCodeWithCertifyViewController *reset = [[ResetCodeWithCertifyViewController alloc]init];
            [weakSelf.navigationController pushViewController:reset animated:YES];
        };
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)textFieldTextChange:(UITextField *)textfield{
    if(textfield.text.length>0){
        
        self.payMoneyButton.backgroundColor = MainColor;
        self.payMoneyButton.userInteractionEnabled = YES;
        
    }else{
        
        self.payMoneyButton.backgroundColor = RGBColor(221, 221, 221);
        [self.payMoneyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.payMoneyButton.userInteractionEnabled = NO;
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
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
            if([string isEqualToString:@"."]){
                NSArray * arr = [textField.text componentsSeparatedByString:@"."];
                if(arr.count>=2){
                    return NO;
                }
            }else{
                return NO;
            }
        }
    
    }
    
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        NSCharacterSet *cs;
        if ([textField isEqual:self.moneyCountTF]) {
            // 小数点在字符串中的位置 第一个数字从0位置开始
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            
            // 判断字符串中是否有小数点，并且小数点不在第一位
            // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
            // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
            if (dotLocation == NSNotFound && range.location != 0) {
                
                // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
                /*
                 [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去
                 
                 在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
                 */
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                if (range.location >= 7) {

                    if ([string isEqualToString:@"."] && range.location == 7) {
                        return YES;
                    }
                    
                    return NO;
                }
            }else {
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
                
                NSArray *tempArr = [self.moneyCountTF.text componentsSeparatedByString:@"."];
                
                NSString *str = tempArr[0];
                if(tempArr.count==2){
                    NSString *str1 = tempArr[1];
                    if(str1.length<2){
                        return YES;
                    }
                }

                if(str.length>6){
                    return NO;
                }
                
            }
            
            // 按cs分离出数组,数组按@""分离出字符串
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basicTest = [string isEqualToString:filtered];
            if (!basicTest) {
                return NO;
            }
            
            if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
                return NO;
            }
  
        }
    }
    
    return YES;
}


@end
