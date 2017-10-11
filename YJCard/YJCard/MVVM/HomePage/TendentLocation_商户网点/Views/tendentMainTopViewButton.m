//
//  tendentMainTopViewButton.m
//  YJCard
//
//  Created by paradise_ on 2017/8/8.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "tendentMainTopViewButton.h"
#import "UIImageView+WebCache.h"
//extern CGFloat const 0.4;
@implementation tendentMainTopViewButton{
    CGFloat perPt;
    NSMutableArray * colorArr;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    colorArr = @[].mutableCopy;
    perPt = self.frame.size.width/93.75;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.originColor = self.titleLabel.textColor;
    NSArray * arr = [[NSString stringWithFormat:@"%@", self.originColor] componentsSeparatedByString:@" "];
    [colorArr addObjectsFromArray:arr];
    if(IS_IOS_8||IS_IOS_11){
        if(colorArr.count==3){
            [colorArr addObject:@"1"];
        }
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        perPt = self.frame.size.width/93.75;
        colorArr = @[].mutableCopy;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.originColor = self.titleLabel.textColor;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        NSArray * arr = [[NSString stringWithFormat:@"%@", self.originColor] componentsSeparatedByString:@" "];
        [colorArr addObjectsFromArray:arr];
        if(IS_IOS_8||IS_IOS_11){
            if(colorArr.count==3){
                [colorArr addObject:@"1"];
            }
        }
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width/2-perPt*20, perPt*20, perPt*40, perPt*40);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, perPt * 65, contentRect.size.width, 14);
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if(highlighted){
        [self setTitleColor:RGBAColor(117, 117, 117,0.4) forState:UIControlStateHighlighted];
    }else{
        [self setTitleColor:self.originColor forState:UIControlStateNormal];
    }
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self  setTitle:titleStr forState:UIControlStateNormal];
}

@end
