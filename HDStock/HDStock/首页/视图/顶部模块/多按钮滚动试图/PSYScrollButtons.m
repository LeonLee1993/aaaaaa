//
//  PSYScrollButtons.m
//  自定义宫格排版按钮
//
//  Created by hd-app02 on 16/11/10.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PSYScrollButtons.h"
#import "PSYButton.h"

#define VIEW_H self.bounds.size.height
#define VIEW_W self.bounds.size.width

@interface PSYScrollButtons()<UIScrollViewDelegate>{

    NSInteger count;
    
    UIPageControl * pageControl;
    
    UIScrollView * scrollview ;

}

@property (nonatomic, strong) NSArray * imageArray;

@property (nonatomic, strong) NSArray * titleArray;

@property (nonatomic, strong) NSMutableArray * buttonArray;

@property (nonatomic, assign) CGFloat BWidth;

@property (nonatomic, assign) CGFloat BHeight;

@property (nonatomic, assign) NSInteger Lines;//列

@property (nonatomic, assign) NSInteger margin;

@end

@implementation PSYScrollButtons

- (NSMutableArray *)buttonArray{

    if (!_buttonArray) {

        _buttonArray = [[NSMutableArray alloc]init];
        
    }

    return _buttonArray;

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _Lines = 4;
        
        _margin = 18;
        
        _titleArray = @[@"资讯",@"自选股",@"股说",@"牛工厂",@"公开课",@"早晚评",@"看直播",@"领金股"];
        
        _imageArray = @[imageNamed(@"home_zixun_icon"),imageNamed(@"home_hangqing_icon"),imageNamed(@"home_gushuo_icon"),imageNamed(@"home_fuwu_icon"),imageNamed(@"home_xuejiqiao_icon"),imageNamed(@"home_zaowanping_icon"),imageNamed(@"home_kanzhibo_icon"),imageNamed(@"home_linjingu_icon")];
        
        count = _titleArray.count;
        
        scrollview = [[UIScrollView alloc]initWithFrame:CGRectZero];
        
        if (count <= 8) {
            
            for (int i = 0; i < count; i ++) {
                
                PSYButton * button = [[PSYButton alloc]init];
    
                [self setButtonProperty:button andTag:i + 1000];
                
                [self addSubview:button];
                
                [self.buttonArray addObject:button];
                
            }
            
        }
        if (count > 8 && count <= 16){
  
            for (int i = 0; i < 8; i ++) {
                
                PSYButton * button = [[PSYButton alloc]init];
                
                [self setButtonProperty:button andTag:i + 1000];
                
                [scrollview addSubview:button];
                
                [self.buttonArray addObject:button];
                
            }
            
            for (int i = 8; i < count; i ++) {
                PSYButton * button = [[PSYButton alloc]init];
                [self setButtonProperty:button andTag:i + 1000];
                
                [scrollview addSubview:button];
                
                [self.buttonArray addObject:button];
            }
            
            pageControl.numberOfPages = 2;
            pageControl.currentPage = 0;
            
            [self addSubview:scrollview];
            pageControl = [[UIPageControl alloc]init];
            
        }

        
    }
    
    return self;

}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self creatButtons];


}


- (void)creatButtons{
    
    _BWidth = (VIEW_W - (_Lines + 1) * _margin)/_Lines;
    
    _BHeight = (VIEW_H - 3 * _margin)/2;
    
    CGFloat HMargin = (VIEW_W - _BWidth * _Lines)/(_Lines + 1);
    
    if (count <= 8) {
        
        for (int i = 0; i < 8; i ++) {
            
            PSYButton * button = _buttonArray[i];
            
            button.frame = CGRectMake((i % _Lines ) * (HMargin + _BWidth) + HMargin, (i / _Lines) * (_BHeight + _margin) + _margin, _BWidth, _BHeight);
            
        }
    }
    
    if (count > 8 && count <= 16) {
        
        
        for (int i = 0; i < 8 ; i ++) {
            
            PSYButton * button = _buttonArray[i];
            button.frame = CGRectMake((i % _Lines ) * (HMargin + _BWidth) + HMargin, (i / _Lines) * (_BHeight + _margin) + _margin, _BWidth, _BHeight);
        }
        for (int i = 8; i < count; i ++) {
            
            int j = i - 8;
            
            PSYButton * button = _buttonArray[i];
            button.frame = CGRectMake((j % _Lines ) * (HMargin + _BWidth) + HMargin + VIEW_W, (j / _Lines) * (_BHeight + _margin) + _margin, _BWidth, _BHeight);
            
        }
        
        scrollview.frame = CGRectMake(0, 0, self.bounds.size.width, VIEW_H);
        
        scrollview.contentSize = CGSizeMake(self.bounds.size.width * 2, VIEW_H);
        
        scrollview.pagingEnabled = YES;
        
        scrollview.showsHorizontalScrollIndicator = NO;
        
        scrollview.delegate = self;
        
        pageControl.center = CGPointMake(self.center.x, self.bounds.size.height - 5);
        
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
       
    }

}

- (void)setButtonProperty:(UIButton *)button andTag:(int)tag{
    
    [button setTitle:[_titleArray objectAtIndex:(tag - 1000)] forState:UIControlStateNormal];
    [button setImage:[_imageArray objectAtIndex:(tag - 1000)] forState:UIControlStateNormal];
    [button setImage:[_imageArray objectAtIndex:(tag - 1000)] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [button setAdjustsImageWhenDisabled:NO];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonOnTouch:(UIButton *)button{

    [self.delegate psySimpleButtonOnTouched:button];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    
    [pageControl setCurrentPage:offset.x / bounds.size.width];
    
}


@end
