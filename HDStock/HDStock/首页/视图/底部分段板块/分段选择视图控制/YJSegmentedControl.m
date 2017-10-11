//
//  YJSegmentedControl.m
//  YJButtonLine
//
//  Created by houdage on 15/11/13.
//  Copyright © 2015年 houdage. All rights reserved.
//

#import "YJSegmentedControl.h"

@interface YJSegmentedControl ()<YJSegmentedControlDelegate>{
    CGFloat witdthFloat;
    UIView * buttonDownView;

}


@end

@implementation YJSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.btnTitleSource = [NSMutableArray array];
    }
    return self;
}



+ (YJSegmentedControl *)segmentedControlFrame:(CGRect)frame titleDataSource:(NSArray *)titleDataSouece backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont selectColor:(UIColor *)selectColor buttonDownColor:(UIColor *)buttonDownColor Delegate:(id)delegate selectSeg:(NSInteger)select{
    
    YJSegmentedControl * smc = [[self alloc] initWithFrame:frame];

    smc.backgroundColor = backgroundColor;
    smc.buttonDownColor = buttonDownColor;
   
    smc.selectSeugment = select;
    smc.titleColor = titleColor;
    smc.titleFont = titleFont;
    smc.selectColor = selectColor;
    smc.delegate = delegate;
    [smc AddSegumentArray:titleDataSouece];
    return smc;
}

+ (YJSegmentedControl *)segmentedControlFrame:(CGRect)frame titleDataSource:(NSArray *)titleDataSouece backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont selectColor:(UIColor *)selectColor buttonDownColor:(UIColor *)buttonDownColor Delegate:(id)delegate selectSeg:(NSInteger)select withViewLine:(BOOL)showViewLine {
    
    YJSegmentedControl * smc = [[self alloc] initWithFrame:frame];
    smc.backgroundColor = backgroundColor;
    smc.buttonDownColor = buttonDownColor;
    smc.selectSeugment = select;
    smc.titleColor = titleColor;
    smc.titleFont = titleFont;
    smc.selectColor = selectColor;
    smc.delegate = delegate;
    [smc AddSegumentArrayWithoutViewLine:titleDataSouece];
    return smc;
}

+ (YJSegmentedControl *)segmentedControlFrame:(CGRect)frame titleDataSource:(NSArray *)titleDataSouece backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont selectColor:(UIColor *)selectColor buttonDownColor:(UIColor *)buttonDownColor Delegate:(id)delegate selectSeg:(NSInteger)select withavergWidth:(BOOL)averg{
    
    YJSegmentedControl * smc = [[self alloc] initWithFrame:frame];
    smc.backgroundColor = backgroundColor;
    smc.buttonDownColor = buttonDownColor;
    smc.selectSeugment = select;
    smc.titleColor = titleColor;
    smc.titleFont = titleFont;
    smc.selectColor = selectColor;
    smc.delegate = delegate;
    [smc AddSegumentArrayWithoutViewLineAndAvergWidth:titleDataSouece];
    return smc;
}

- (void)AddSegumentArrayWithoutViewLineAndAvergWidth:(NSArray *)SegumentArray{
    
    // 1.按钮的个数
    NSInteger seugemtNumber = SegumentArray.count;
    
    // 2.按钮的宽度
    witdthFloat = (self.bounds.size.width) / seugemtNumber ;
    // 3.创建按钮
    for (int i = 0; i < SegumentArray.count; i++) {
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i * witdthFloat, 0, witdthFloat, self.bounds.size.height - 2)];
        [btn setTitle:SegumentArray[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:self.titleFont];
        [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
        btn.tag = i + 1200;
        [btn addTarget:self action:@selector(changeSegumentAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        
        [self.btnTitleSource addObject:btn];
    }
    
    [self.btnTitleSource[_selectSeugment] setSelected:YES];
}

- (void)AddSegumentArrayWithoutViewLine:(NSArray *)SegumentArray{
    
    // 1.按钮的个数
    NSInteger seugemtNumber = SegumentArray.count;
    
    // 2.按钮的宽度
    witdthFloat = (self.bounds.size.width) / (seugemtNumber + 2);
    
    // 3.创建按钮
    for (int i = 0; i < SegumentArray.count; i++) {
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake((i + 1) * witdthFloat, 0, witdthFloat, self.bounds.size.height - 2)];
        [btn setTitle:SegumentArray[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:self.titleFont];
        [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
        btn.tag = i + 1200;
        [btn addTarget:self action:@selector(changeSegumentAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    
        [self.btnTitleSource addObject:btn];
    }
    
    [self.btnTitleSource[_selectSeugment] setSelected:YES];
}

- (void)AddSegumentArray:(NSArray *)SegumentArray{
    
    // 1.按钮的个数
    NSInteger seugemtNumber = SegumentArray.count;
    
    // 2.按钮的宽度
    witdthFloat = (self.bounds.size.width) / seugemtNumber;
    
    // 3.创建按钮
    for (int i = 0; i < SegumentArray.count; i++) {
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i * witdthFloat, 0, witdthFloat, self.bounds.size.height - 2)];
        [btn setTitle:SegumentArray[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:self.titleFont];
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:SegumentArray[i] attributes:@{NSFontAttributeName:boldSystemFont(16), NSForegroundColorAttributeName: self.selectColor}];
        
        if (kScreenIphone4 || kScreenIphone5){
            
            [btn setTitle:SegumentArray[i] forState:UIControlStateSelected];
            
        }else{
        
            [btn setAttributedTitle:string forState:UIControlStateSelected];
        
        }
        
        [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
        btn.tag = i + 1200;
        [btn addTarget:self action:@selector(changeSegumentAction:) forControlEvents:UIControlEventTouchUpInside];
//        if (i == 1 || i == 2 || i == 3) {
//            
//            _viewLine = [[UIView alloc]initWithFrame:CGRectMake(i * witdthFloat - 1, self.bounds.size.height/3, 1, self.bounds.size.height/3)];
//            
//            _viewLine.backgroundColor = COLOR(lightGrayColor);
//        }
        
        if (i == self.selectSeugment) {
            buttonDownView =[[UIView alloc]initWithFrame:CGRectMake(i * witdthFloat + witdthFloat / 6, self.bounds.size.height - 3, witdthFloat * 2 / 3, 3)];
            [buttonDownView setBackgroundColor:self.buttonDownColor];
            
            [self addSubview:buttonDownView];
        }
        [self addSubview:btn];
        
        [self addSubview:_viewLine];
        
        [self.btnTitleSource addObject:btn];
    }
    
    [self.btnTitleSource[_selectSeugment] setSelected:YES];
}

- (void)changeSegumentAction:(UIButton *)btn{
    
    NSInteger segument = btn.tag - 1200;
    
    if (_selectSeugment != segument) {
        
        [self.btnTitleSource[_selectSeugment] setSelected:NO];
        [self.btnTitleSource[segument] setSelected:YES];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [buttonDownView setFrame:CGRectMake(segument * witdthFloat,self.bounds.size.height - 2, witdthFloat, 2)];
        }];
        
        _selectSeugment = segument;
        
        [self.delegate segumentSelectionChange:btn];
    }
    
}



@end
