//
//  ChangeCardListTableViewCell.m
//  YJCard
//
//  Created by paradise_ on 2017/7/3.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "ChangeCardListTableViewCell.h"

@implementation ChangeCardListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setPayCardNO:(NSString *)payCardNO{
    
    NSString * defaultPayMoneyCard = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultPayCard];
    _payCardNO = payCardNO;
    
    if([payCardNO isEqualToString:defaultPayMoneyCard]){
        self.gougouView.hidden = NO;
    }else{
        self.gougouView.hidden = YES;
    }
    
    self.CarNumLabel.text = payCardNO;
    
}

@end
