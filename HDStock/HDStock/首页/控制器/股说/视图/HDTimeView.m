//
//  HDTimeView.m
//  HDStock
//
//  Created by hd-app02 on 2017/2/15.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "HDTimeView.h"

@interface HDTimeView()

@property (nonatomic, strong) UILabel * timeLabel;

@end

@implementation HDTimeView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        
        UIView * viewOne = [[UIView alloc]initWithFrame:CGRectZero];
        UIView * viewTwo = [[UIView alloc]initWithFrame:CGRectZero];
        viewOne.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
        viewTwo.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
        
        [self addSubview:self.timeLabel];
        [self addSubview:viewOne];
        [self addSubview:viewTwo];
        
        [viewOne mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self);
            make.right.equalTo(self.timeLabel.mas_left);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(@1);
            
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.center.equalTo(self);
            make.width.mas_equalTo(self.width/5.0f);
            
        }];
        
        [viewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.timeLabel.mas_right);
            make.right.equalTo(self);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(@1);
            
        }];
    }

    return self;
}

- (void)setTime:(NSString *)time{

    _time = time;
    
    self.timeLabel.text = time;

}

@end
