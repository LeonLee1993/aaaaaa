//
//  BeingCertionTableViewCell.m
//  YJCard
//
//  Created by paradise_ on 2017/8/11.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "BeingCertionTableViewCell.h"

@implementation BeingCertionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += 20;
    frame.size.height -= 20;
    [super setFrame:frame];
}

//needHeigth ScreenWidth/375*50+20
-(void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    self.cerifyStateLable.text = infoDic[@"status"];
    if([self.cerifyStateLable.text isEqualToString:@"通过审核"]){
        self.cerifyStateLable.textColor = MainColor;
    }
}

@end
