//
//  HDPSYScrollButtonView.m
//  HDStock
//
//  Created by hd-app02 on 16/11/11.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDPSYScrollButtonView.h"
#import "HDMiddleButton.h"

#define VIEW_H self.bounds.size.height
#define VIEW_W self.bounds.size.width

@interface HDPSYScrollButtonView()<UIScrollViewDelegate>{
    
    NSInteger count;
    
    UIScrollView * scrollview ;
    
}

@property (nonatomic, assign) CGFloat BWidth;

@property (nonatomic, assign) CGFloat BHeight;

@property (nonatomic, assign) NSInteger margin;

@property (nonatomic, strong) NSMutableArray * buttonArray;

@end

@implementation HDPSYScrollButtonView

- (NSMutableArray *)buttonArray{

    if (!_buttonArray) {
        
        _buttonArray = [[NSMutableArray alloc]init];
        
    }

    return _buttonArray;

}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {

        _margin = 10;
        
        scrollview = [[UIScrollView alloc]initWithFrame:CGRectZero];
        
        scrollview.showsHorizontalScrollIndicator = NO;
        
        scrollview.delegate = self;

        [self addSubview:scrollview];
        
    }

    return self;

}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    
}

- (void)setSubTitleArray:(NSArray *)subTitleArray{

    _subTitleArray = subTitleArray;


}

- (void)setImageArray:(NSArray *)imageArray{

    _imageArray = imageArray;
    
    count = imageArray.count;
    
    for (int i = 0; i < count; i ++) {
        
        HDMiddleButton * button = [[HDMiddleButton alloc]init];
        
        [scrollview addSubview:button];
        
        [self.buttonArray addObject:button];
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self creatButtons];

}

- (void)creatButtons{
    
    _BWidth = (VIEW_W - 3 * _margin)/2.33;
    
    _BHeight = VIEW_H - 2 * _margin;
    
    scrollview.frame = CGRectMake(0, 0, VIEW_W, VIEW_H);
    
    for (int i = 0; i < self.buttonArray.count; i ++) {
        
        HDMiddleButton * button = self.buttonArray[i];
        
        [self setButtonProperty:button andTag:i + 1100];
        
        button.frame = CGRM(i * _BWidth + (i + 1) * _margin, _margin, _BWidth, _BHeight);
    }
    
    scrollview.contentSize = CGSizeMake(self.buttonArray.count * (_BWidth + _margin) + _margin, VIEW_H);
}

- (void)setButtonProperty:(HDMiddleButton *)button andTag:(int)tag{
    
    button.backgroundColor = COLOR(whiteColor);
    
    [button setTitle:[_titleArray objectAtIndex:(tag - 1100)] forState:UIControlStateNormal];
    button.subTittle.text = [_subTitleArray objectAtIndex:(tag - 1100)];
    
    [button setImage:[_imageArray objectAtIndex:(tag - 1100)] forState:UIControlStateNormal];
    [button setImage:[_imageArray objectAtIndex:(tag - 1100)] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.titleLabel.numberOfLines = 1;
    
    button.subTittle.font = [UIFont systemFontOfSize:12];
    button.subTittle.textColor = [UIColor grayColor];
    button.subTittle.textAlignment = NSTextAlignmentLeft;
    
    [button setAdjustsImageWhenDisabled:NO];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonOnTouch:(UIButton *)button{
    
    [self.delegate psyScrollButtonOnTouched:button];
    
}


@end
