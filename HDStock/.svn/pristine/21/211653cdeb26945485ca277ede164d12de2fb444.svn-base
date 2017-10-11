//
//  HDVertionCheckAlertView.m
//  HDStock
//
//  Created by hd-app02 on 2017/1/17.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "HDVertionCheckAlertView.h"

@interface HDVertionCheckAlertView()

@end

@implementation HDVertionCheckAlertView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.backImageview = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.backImageview.userInteractionEnabled = YES;
        self.backImageview.image = [UIImage imageNamed:@"sys_update"];
        
        self.cancelButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"ignore_button"] forState:UIControlStateNormal];
        [self.cancelButton setTitle:@"忽略" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.cancelButton.tag = 1110;
        
        self.sureButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.sureButton setBackgroundImage:[UIImage imageNamed:@"update_button"] forState:UIControlStateNormal];
        [self.sureButton setTitle:@"更新" forState:UIControlStateNormal];
        [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.sureButton.tag = 1111;
        
        [self addSubview:_backImageview];
        [self addSubview:_cancelButton];
        [self addSubview:_sureButton];
    }

    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.backImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.equalTo(self);
        
    }];

    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(self.width/3.0f, self.height/10.0f));
        make.left.equalTo(self.backImageview.mas_left).offset(self.width/3.0f/4.0f);
        make.bottom.equalTo(self.backImageview.mas_bottom).offset(-self.height/10.0f/2.0f);
        
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.size.mas_equalTo(self.cancelButton);
        
        make.left.equalTo(self.cancelButton.mas_right).offset(self.width/3.0f/2.0f);
        
        make.centerY.equalTo(self.cancelButton);
    
    }];


}
@end
