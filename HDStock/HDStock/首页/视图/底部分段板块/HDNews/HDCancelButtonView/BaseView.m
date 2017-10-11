//
//  BaseView.m
//  PopoverController
//
//  Created by PSY on 2016/10/15.
//  Copyright © 2016年 彭树勇. All rights reserved.
//

#import "BaseView.h"

#define MAGIN 7

#define HDWIDTH (self.bounds.size.width - MAGIN * 4)/2
#define HDHEIGHT (self.bounds.size.height - MAGIN * 6)/3

@interface BaseView ()

@end

@implementation BaseView{

    UILabel * _titleLabel;

}

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    
    }
    
    return self;

}

- (void)layoutSubviews{

    [self creatTitleLabel];
    
    [self creatButtons];
    
}


- (void)creatTitleLabel{
    
    _titleLabel = [[UILabel alloc]init];
    
    _titleLabel.frame = CGRectMake(MAGIN, MAGIN, self.bounds.size.width/2, HDHEIGHT);
    _titleLabel.text = @"不喜欢？原因是";
    _titleLabel.font = [UIFont systemFontOfSize:10];
    
    [self addSubview:_titleLabel];



}

- (void)creatButtons{

    for (int i = 0; i <= 4; i ++) {
        
        UIButton * button = [[UIButton alloc]init];
        
        CGFloat X = MAGIN;
        
        CGFloat Y = MAGIN;
        
        if (i == 0) {
            
            X = MAGIN * 3 + HDWIDTH;
            [button setTitle:@"不感兴趣" forState:UIControlStateNormal];
            
            button.selected = YES;
            
        }else if (i == 1){
        
            Y = 3 * MAGIN + HDHEIGHT;
            
            [button setTitle:@"旧闻" forState:UIControlStateNormal];
        
        }else if (i == 2){
        
            X = MAGIN * 3 + HDWIDTH;
            
            Y = 3 * MAGIN + HDHEIGHT;
            
            [button setTitle:@"重复" forState:UIControlStateNormal];
        
        }else if(i == 3){
        
            Y = 5 * MAGIN + 2 * HDHEIGHT;
            
            [button setTitle:@"文不对题" forState:UIControlStateNormal];
        
        }else if(i == 4){
        
            X = MAGIN * 3 + HDWIDTH;
            
            Y = 5 * MAGIN + 2 * HDHEIGHT;
            
            [button setTitle:@"没有帮助" forState:UIControlStateNormal];
        
        }
        
        button.frame = CGRectMake(X, Y , HDWIDTH, HDHEIGHT);
        
        button.tag = i + 1000;
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal] ;
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:10]];
        
        UIImage * bgImage = [BaseView imageWithColor:[UIColor whiteColor]];
        
        [button setBackgroundImage:bgImage forState:UIControlStateNormal];
        
        [button setBackgroundImage:bgImage forState:UIControlStateHighlighted];
        
        [button setBackgroundImage:[BaseView imageWithColor:[UIColor redColor]] forState:UIControlStateSelected];
        
        button.layer.masksToBounds = YES;
        
        button.layer.cornerRadius = 5;
        
        if (button.isSelected == YES) {
            
            button.layer.borderWidth = 0;
            
        }else{
            
        button.layer.borderWidth = 0.5;
            
        }
        
        [button addTarget:self action:@selector(buttonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
    }

}


- (void)buttonOnClicked:(UIButton *)sender{
    
    if (sender.tag != 1000) {
        
        sender.selected = !sender.selected;
        
        UIButton * button0 = [self viewWithTag:1000];
        
        UIButton * button1 = [self viewWithTag:1001];
        
        UIButton * button2 = [self viewWithTag:1002];
        
        UIButton * button3 = [self viewWithTag:1003];
        
        UIButton * button4 = [self viewWithTag:1004];
        
        NSInteger num = 1;
        
        if (button1.isSelected == YES || button2.isSelected == YES || button3.isSelected == YES || button4.isSelected == YES ) {
            
            [button0 setTitle:@"确定" forState:UIControlStateNormal];
            
            if ((button1.isSelected == YES && button2.isSelected == YES && button3.isSelected == NO && button4.isSelected == NO) || (button1.isSelected == YES && button2.isSelected == NO && button3.isSelected == YES && button4.isSelected == NO) || (button1.isSelected == YES && button2.isSelected == NO && button3.isSelected == NO && button4.isSelected == YES ) || (button1.isSelected == NO && button2.isSelected == YES && button3.isSelected == YES && button4.isSelected == NO ) || (button1.isSelected == NO && button2.isSelected == YES && button3.isSelected == NO && button4.isSelected == YES ) || (button1.isSelected == NO && button2.isSelected == NO && button3.isSelected == YES && button4.isSelected == YES )) {
                
                num = 2;
            }
            if ((button1.isSelected == YES && button2.isSelected == YES && button3.isSelected == YES && button4.isSelected == NO) || (button1.isSelected == YES && button2.isSelected == YES && button3.isSelected == NO && button4.isSelected == YES) ||(button1.isSelected == YES && button2.isSelected == NO && button3.isSelected == YES && button4.isSelected == YES) || (button1.isSelected == NO && button2.isSelected == YES && button3.isSelected == YES && button4.isSelected == YES )){
            
                num = 3;
            
            }
            if (button1.isSelected == YES && button2.isSelected == YES && button3.isSelected == YES && button4.isSelected == YES ) {
            
                num = 4;
            
            }
            
            _titleLabel.text = [NSString stringWithFormat:@"已选%ld理由",(long)num] ;
            
        }else{
        
            [button0 setTitle:@"不感兴趣" forState:UIControlStateNormal];
            
            _titleLabel.text = @"不喜欢？原因是";
        
        }
        
        if (sender.isSelected == YES) {
            
            sender.layer.borderWidth = 0;
            
        }else{
            
            sender.layer.borderWidth = 0.5;
            
        }
        
    }
    
    [self.delegate popoverBaseviewButtonTouchUpsideDown:sender];

}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f); //宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    
    return image;
}


@end
