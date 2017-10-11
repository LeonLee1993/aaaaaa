//
//  ChargeCardViewButton.m
//  YJCard
//
//  Created by paradise_ on 2017/7/4.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "ChargeCardViewButton.h"

@implementation ChargeCardViewButton{
    CGFloat perPt;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    perPt = self.frame.size.width/100.0;
    [self setTitleColor:MainColor forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        self.saleLabel = [[UILabel alloc]init];
        self.saleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.saleLabel];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 14*perPt,contentRect.size.width, 13*perPt);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 0.75;
    self.layer.borderColor = MainColor.CGColor;
    self.saleLabel.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 10 *perPt);
    self.saleLabel.text = [NSString stringWithFormat:@"售价: %.2f元",self.titleLabel.text.floatValue * 0.98];
    self.saleLabel.textColor = MainColor;
    self.saleLabel.font = [UIFont systemFontOfSize:9.5];
}

-(void)setHighlighted:(BOOL)highlighted{
    if(highlighted){
        self.alpha = 0.5;
    }else{
        self.alpha = 1;
    }
}



@end
