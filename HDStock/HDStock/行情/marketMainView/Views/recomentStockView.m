//
//  recomentStockView.m
//  HDStock
//
//  Created by liyancheng on 17/2/14.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "recomentStockView.h"

@implementation recomentStockView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.nameLabel];
    [self addSubview:self.attentionLabel];
    self.backgroundColor = RGBCOLOR(245, 245, 245);
    
}

-(UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, self.frame.size.height/38*16)];
        _nameLabel.text = @"---";
        _nameLabel.textColor = RGBCOLOR(51,51,51);
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

-(UILabel *)attentionLabel{
    if(!_attentionLabel){
        _attentionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height/38*26, SCREEN_WIDTH/3, self.frame.size.height/38*12)];
        _attentionLabel.text = @"---";
        _attentionLabel.textColor = RGBCOLOR(153,153,153);
        _attentionLabel.font = [UIFont systemFontOfSize:12];
        _attentionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _attentionLabel;
}


@end
