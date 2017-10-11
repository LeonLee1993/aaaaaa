//
//  buiedProductDetailSecondCellButton.m
//  HDStock
//
//  Created by liyancheng on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "buiedProductDetailSecondCellButton.h"

@implementation buiedProductDetailSecondCellButton

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        self.stateLabel1 = [[UILabel alloc]init];
        self.stateLabel2 = [[UILabel alloc]init];
        self.bottomLine = [[UIView alloc]init];
        [self addSubview:self.bottomLine];
        [self addSubview:self.stateLabel1];
        [self addSubview:self.stateLabel2];
    }
    return self;
}


-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 16, CGRectGetWidth(contentRect), 12);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.bottomLine.frame = CGRectMake(CGRectGetWidth(self.frame)/8, CGRectGetMaxY(self.frame)-2, CGRectGetWidth(self.frame)/4*3, 2);
    self.bottomLine.backgroundColor = RGBCOLOR(212,45,73);
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.stateLabel1.font = [UIFont systemFontOfSize:11];
    self.stateLabel1.textAlignment = NSTextAlignmentCenter;
    self.stateLabel1.text = @" 短线 ";
    self.stateLabel1.textColor = [UIColor whiteColor];
    self.stateLabel1.frame = CGRectMake(CGRectGetWidth(self.frame)/2-40, CGRectGetHeight(self.frame)-28, 40, 15);

    self.stateLabel2.font = [UIFont systemFontOfSize:11];
    self.stateLabel2.textAlignment = NSTextAlignmentCenter;
    self.stateLabel2.text = @" 操盘中 ";
    self.stateLabel2.textColor = [UIColor whiteColor];
    self.stateLabel2.frame = CGRectMake(CGRectGetMaxX(self.stateLabel1.frame)+5, CGRectGetMaxY(self.frame)-28, 40, 15);
    
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
