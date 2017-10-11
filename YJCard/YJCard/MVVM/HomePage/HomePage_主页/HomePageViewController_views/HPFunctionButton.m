//
//  HPFunctionButton.m
//  YJCard
//
//  Created by paradise_ on 2017/6/29.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "HPFunctionButton.h"
//const CGFloat 0.4 = 0.4;
@implementation HPFunctionButton{
    CGFloat perPt;
    NSMutableArray * colorArr ;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    colorArr = @[].mutableCopy;
    perPt = self.frame.size.height/112.0;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.originColor = [UIColor whiteColor];
    NSArray *arr = [[NSString stringWithFormat:@"%@", self.originColor] componentsSeparatedByString:@" "];
    [colorArr addObjectsFromArray:arr];
    if(IS_IOS_8){
        if(colorArr.count==3){
            [colorArr addObject:@"1"];
        }
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        perPt = self.frame.size.height/112.0;
        colorArr = @[].mutableCopy;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.originColor = [UIColor whiteColor];
        NSArray *arr = [[NSString stringWithFormat:@"%@", self.originColor] componentsSeparatedByString:@" "];
        [colorArr addObjectsFromArray:arr];
        if(IS_IOS_8){
            if(colorArr.count==3){
                [colorArr addObject:@"1"];
            }
        }
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width/2-perPt*16, perPt*25, perPt*32, perPt*32);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, perPt * 70, contentRect.size.width, 14);
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if(highlighted){
        [self setTitleColor:[UIColor colorWithRed:[colorArr[1] floatValue]-0.4 green:[colorArr[2]floatValue]-0.4 blue:[colorArr[2]floatValue]-0.4 alpha:1] forState:UIControlStateHighlighted];
    }else{
        [self setTitleColor:self.originColor forState:UIControlStateNormal];
    }
}

@end
