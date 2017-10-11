//
//  buiedProductDetailSecondCellButton.m
//  HDStock
//
//  Created by liyancheng on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "buiedProductDetailThirdCellButton.h"

@implementation buiedProductDetailThirdCellButton

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.stateLabel1 = [[UILabel alloc]init];
        [self addSubview:self.stateLabel1];
        self.stateLabel2 = [[UILabel alloc]init];
        [self addSubview:self.stateLabel2];
        self.bottomLine = [[UIView alloc]init];
        [self addSubview:self.bottomLine];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.stateLabel1 = [[UILabel alloc]init];
    [self addSubview:self.stateLabel1];
    self.stateLabel2 = [[UILabel alloc]init];
    [self addSubview:self.stateLabel2];
    self.bottomLine = [[UIView alloc]init];
    [self addSubview:self.bottomLine];
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 16, CGRectGetWidth(contentRect), 12);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.stateLabel1.font = [UIFont systemFontOfSize:11];
    self.stateLabel1.textAlignment = NSTextAlignmentCenter;
    self.stateLabel1.text = @" 短线 ";
    self.stateLabel1.textColor = [UIColor whiteColor];
    self.stateLabel1.frame = CGRectMake(CGRectGetMidX(self.frame)-40, CGRectGetMaxY(self.titleLabel.frame)+8, 40, 15);
    [self.stateLabel1 sizeToFit];
    
    self.bottomLine.frame = CGRectMake(CGRectGetWidth(self.frame)/8, CGRectGetMaxY(self.frame)-2, CGRectGetWidth(self.frame)/4*3, 2);
    self.bottomLine.backgroundColor = RGBCOLOR(25,121,202);
    
    self.stateLabel2.font = [UIFont systemFontOfSize:11];
    self.stateLabel2.textAlignment = NSTextAlignmentCenter;
    self.stateLabel2.text = @" 操盘中 ";
    self.stateLabel2.textColor = [UIColor whiteColor];
    self.stateLabel2.frame = CGRectMake(CGRectGetMaxX(self.stateLabel1.frame)+5, CGRectGetMaxY(self.titleLabel.frame)+8, 40, 15);
    [self.stateLabel2 sizeToFit];
    
    
    if(self.selected){
        self.titleLabel.textColor = RGBCOLOR(153,153,153);
        self.stateLabel1.backgroundColor = RGBCOLOR(221,221,221);
        self.stateLabel2.backgroundColor = RGBCOLOR(221,221,221);
        self.bottomLine.hidden = YES;
    }else{
        self.titleLabel.textColor = RGBCOLOR(25,121,202);
        self.stateLabel1.backgroundColor = RGBCOLOR(25,121,202);
        self.stateLabel2.backgroundColor = RGBCOLOR(203,53,77);
        self.bottomLine.hidden = NO;
    }
    
}

@end
