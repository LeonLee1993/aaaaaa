//
//  KeyBoardView.m
//  HDStock
//
//  Created by liyancheng on 17/1/6.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "KeyBoardView.h"

@implementation KeyBoardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
    
    }
    return self;
}

+ (instancetype)getKeyBoardView
{
    return [[NSBundle mainBundle] loadNibNamed:@"keyBoardView" owner:nil options:nil][0];
}

- (IBAction)numberButtonClicked:(UIButton *)sender {
    self.block(sender.titleLabel.text);
}

- (IBAction)leftNumberButtonClicked:(UIButton *)sender {
    self.block(sender.titleLabel.text);
}


- (IBAction)deleteOneButtonClick:(UIButton *)sender {
    self.actionBlock(sender.tag);//201 删除
}

- (IBAction)hideButtonClicked:(UIButton *)sender {
    self.actionBlock(sender.tag);//202 隐藏
}

- (IBAction)clearButtonClicked:(UIButton *)sender {
    self.actionBlock(sender.tag);//203 清空
}
- (IBAction)certenButtonClicked:(UIButton *)sender {
    self.actionBlock(sender.tag);//204 确认
}
- (IBAction)ABCClicked:(UIButton *)sender {
    self.actionBlock(sender.tag);//205 ABC
}
- (IBAction)chineseClicked:(UIButton *)sender {
    self.actionBlock(sender.tag);//206 中文
}

@end
