//
//  buiedProductDetailSecondCell.m
//  HDStock
//
//  Created by liyancheng on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "buiedProductDetailSecondCell.h"

@implementation buiedProductDetailSecondCell


- (IBAction)firstButtonClicked:(buiedProductDetailSecondCellButton *)sender {
    sender.selected = NO;
    UIView *buttonContain = [self.contentView viewWithTag:999];
    for (UIButton *button in buttonContain.subviews) {
        if(button.tag!=sender.tag){
            button.selected = YES;
        }
    }
    self.twoButtonBlock(sender.tag);
}

-(void)setModel:(ProductDetailModel *)model{
    _model = model;
    if(![model.first_price isKindOfClass:[NSNull class]]){
        _buyPriceOne.text = [NSString stringWithFormat:@"%.2f",model.first_price.floatValue];

    }
    
    if(![model.second_price isKindOfClass:[NSNull class]]){
        _buyPriceTwo.text = [NSString stringWithFormat:@"%.2f",model.second_price.floatValue];

    }
    
    if(![model.first_win_price isKindOfClass:[NSNull class]]){
       _winPriceOne.text = [NSString stringWithFormat:@"%.2f",model.first_win_price.floatValue];

    }
    
    if(![model.second_win_price isKindOfClass:[NSNull class]]){
        _winPriceTwo.text = [NSString stringWithFormat:@"%.2f",model.second_win_price.floatValue];

    }
    
    if(![model.first_lose_price isKindOfClass:[NSNull class]]){
        _lostPriceOne.text = [NSString stringWithFormat:@"%.2f",model.first_lose_price.floatValue];

    }
    if(![model.second_lose_price isKindOfClass:[NSNull class]]){
        _lostPriceTwo.text = [NSString stringWithFormat:@"%.2f",model.second_lose_price.floatValue];
    }
    if(![model.expected_return isKindOfClass:[NSNull class]]){
        [self judgeColorByLabel:_firstLable andModelStr:model.expected_return.stringValue];
    }
    if(![model.top_gain isKindOfClass:[NSNull class]]){
        [self judgeColorByLabel:_secondLabel andModelStr:model.top_gain.stringValue];
    }
    if(![model.today_rose isKindOfClass:[NSNull class]]){
        [self judgeColorByLabel:_thirdLabel andModelStr:model.today_rose.stringValue];
    }
    if(![model.now_price isKindOfClass:[NSNull class]]){
        [self judgeColorByLabel:_forthLabel andModelStr:model.now_price];
    }
}


- (void)changeFont{
    _one.font = [UIFont systemFontOfSize:8];
    _oneTwo.font = [UIFont systemFontOfSize:8];
    _two.font = [UIFont systemFontOfSize:8];
    _twotwo.font = [UIFont systemFontOfSize:8];
    _three.font = [UIFont systemFontOfSize:8];
    _threeTwo.font = [UIFont systemFontOfSize:8];
}

- (void)judgeColorByLabel:(UILabel *)label andModelStr:(NSString *)modelStr{
    
    NSString *flagStr = [modelStr substringToIndex:1];
    if([flagStr isEqualToString:@"-"]){
        label.textColor = RGBCOLOR(48,203,128);
        label.text = modelStr;
    }else{
        label.text = [NSString stringWithFormat:@"+%@",modelStr];
    }
}

-(void)setSelectedButtonFrame{// 只有一条股票
    
    CGRect secondButtonRect = self.secondButton.frame;
    secondButtonRect.origin.x= self.contentView.frame.size.width;
    self.secondButton.hidden = YES;
    self.thirdButton.hidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect firstButtonRect = self.firstButton.frame;
        firstButtonRect.size.width= self.contentView.frame.size.width;
        self.firstButton.frame = firstButtonRect;
    });
}

-(void)setTwoButtonFrame{
    CGRect secondButtonRect = self.secondButton.frame;
    secondButtonRect.origin.x= self.contentView.frame.size.width;
    self.thirdButton.hidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect firstButtonRect = self.firstButton.frame;
        firstButtonRect.size.width= self.contentView.frame.size.width/2;
        self.firstButton.frame = firstButtonRect;
        
        CGRect firstButtonRect1 = self.secondButton.frame;
        firstButtonRect1.size.width= self.contentView.frame.size.width/2;
        firstButtonRect1.origin.x =self.contentView.center.x;
        self.secondButton.frame = firstButtonRect1;
    });
}

-(void)setThreeButtonFrame{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect firstButtonRect = self.firstButton.frame;
        firstButtonRect.size.width= self.contentView.frame.size.width/3;
        self.firstButton.frame = firstButtonRect;
        
        CGRect firstButtonRect1 = self.secondButton.frame;
        firstButtonRect1.size.width= self.firstContainView.frame.size.width/3;
        firstButtonRect1.origin.x =self.firstContainView.frame.size.width/3;
        self.secondButton.frame = firstButtonRect1;
     
        CGRect firstButtonRect2 = self.thirdButton.frame;
        firstButtonRect2.size.width= self.firstContainView.frame.size.width/3;
        firstButtonRect2.origin.x =self.firstContainView.frame.size.width/3*2;
        self.thirdButton.frame = firstButtonRect2;
    });
}






@end
