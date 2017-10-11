//
//  AffirmMoneyPreView.m
//  YJCard
//
//  Created by paradise_ on 2017/7/25.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "AffirmMoneyPreView.h"

@interface AffirmMoneyPreView()
@property (weak, nonatomic) IBOutlet UIView *payMoneyTypeSelectedView;

@property (weak, nonatomic) IBOutlet UIButton *dissMissView;

@end

@implementation AffirmMoneyPreView


-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.payMoneyTypeSelectedView addGestureRecognizer:tap];
    
    NSString * payCordNO = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultPayCard];
    self.payCardNumberLabel.text = payCordNO;
}
- (IBAction)dissmiss:(id)sender {
    self.selfDissMissBlock();
}

-(void)setRMBNumLabelText:(NSString *)RMBNumLabelText{
    _RMBNumLabelText = RMBNumLabelText;
    self.RMBNumLabel.text = [self moneyTransform:RMBNumLabelText];
}

#pragma mark - 转RMB 
- (NSString *)moneyTransform:(NSString *)origin{
    
    NSArray * comArr = [origin componentsSeparatedByString:@"."];
    NSString * preStr = comArr[0];
    NSInteger dotCount = 0;
    NSInteger preIntValue = preStr.integerValue;
    while (preIntValue>1000) {
        dotCount+=1;
        preIntValue = preIntValue/1000;
    }
    
    NSMutableString * mutStr= [[NSMutableString alloc]initWithString:preStr];
    for (int i=0; i<dotCount; i++) {
        [mutStr insertString:@"," atIndex:mutStr.length-i-3*(i+1)];
    }
    if(comArr.count==2){
        NSString * str = comArr[1];
        if(str.length ==2){//如果两个小数
            [mutStr insertString:[NSString stringWithFormat:@".%@",comArr[1]] atIndex:mutStr.length];
        }else{//如果只有一个小数
            [mutStr insertString:[NSString stringWithFormat:@".%@0",comArr[1]] atIndex:mutStr.length];
        }
    }else{//如果没有小数
        [mutStr insertString:[NSString stringWithFormat:@".00"] atIndex:mutStr.length];
    }
    
    return mutStr;
}

- (IBAction)payMoneyButtonClicked:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    self.payMoneyBlock();
}

- (void)tapAction{
    self.selectcardBlock();
}

@end
