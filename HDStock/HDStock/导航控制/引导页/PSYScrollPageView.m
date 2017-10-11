//
//  PSYScrollPageView.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/27.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PSYScrollPageView.h"

@implementation PSYScrollPageView{

    UIScrollView * myScrollView;
    UIView * pageControlView;
    NSMutableArray * markImages;
    UIView * pageBGView;
    UIImageView * moveMark;
    NSInteger _num;
    UIButton * button;
}

- (instancetype)initWithFrame:(CGRect)frame numberOfItem:(NSInteger)num itemSize:(CGSize)itemsize complete:(blockAllItems)allitems{
 
    if (self = [super initWithFrame:frame]) {
        
        _num = num;
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        myScrollView.scrollsToTop = NO;
        myScrollView.showsHorizontalScrollIndicator = NO;
        myScrollView.delegate = self;
        myScrollView.pagingEnabled = YES;
        [self addSubview:myScrollView];
        
        NSMutableArray * items = [NSMutableArray new];
        for (int i = 0; i < num; i ++) {
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * itemsize.width, 0, itemsize.width, itemsize.height)];
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.userInteractionEnabled = YES;
            if (i == (num - 1)) {
                
                button = [[UIButton alloc]initWithFrame:CGRectZero];
                button.backgroundColor = [UIColor colorWithHexString:@"#209CEA"];
                button.frame = CGRectMake(0, 0, (SCREEN_WIDTH * 150 / 414.0f), (SCREEN_HEIGHT * 40 / 750.0f));
                button.centerX = self.centerX;
                
                button.centerY = SCREEN_HEIGHT - (SCREEN_HEIGHT * 140.0f / 667.0f);
                
                button.layer.masksToBounds = YES;
                button.layer.cornerRadius = 5;
                [button setTitle:@"立即体验" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                if (kScreenIphone4 || kScreenIphone5) {
                    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                }else{
                button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
                }
                [button addTarget:self action:@selector(buttonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [imageView addSubview:button];
                
            }
            [myScrollView addSubview:imageView];
            [items addObject:imageView];
        }
        
        myScrollView.contentSize = CGSizeMake(itemsize.width * num, myScrollView.bounds.size.height);
        
        allitems(items);
        
        markImages = [NSMutableArray array];
        
        pageControlView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - (SCREEN_HEIGHT * 80.0f / 750.0f), self.frame.size.width, 20.0f)];
        [self addSubview:pageControlView];
        
        pageBGView = [[UIView alloc]initWithFrame:CGRectZero];
        [pageControlView addSubview:pageBGView];
        [self loadPageControlSubViews];
    }
    
    return self;
}

- (void)loadPageControlSubViews{

    for (int i = 0; i < _num; i ++) {
        
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectZero];
        [pageBGView addSubview:imageview];
        [markImages addObject:imageview];
        imageview.image = _defaultPageIndicatorImage;
        
        if (_defaultPageIndicatorImage) {
            
            imageview.backgroundColor = [UIColor clearColor];
        }
    }

    moveMark = [[UIImageView alloc]initWithFrame:CGRectZero];
    moveMark.backgroundColor = [UIColor blueColor];
    moveMark.image = _currentPageIndicatorImage;
    
    if (_currentPageIndicatorImage) {
        
        moveMark.backgroundColor = [UIColor clearColor];
        
    }

    [pageBGView addSubview:moveMark];
    
    [self reloadPageViewSize];

}

- (void)reloadPageViewSize{
 
    CGSize pageSize_def = CGSizeMake(11, 11);
    CGSize pageSize_cur = CGSizeMake(11, 11);
    
    if (_defaultPageIndicatorImage) {
        //
        pageSize_def = _defaultPageIndicatorImage.size;
        
    }
    if (_currentPageIndicatorImage) {
        //
        pageSize_cur = _currentPageIndicatorImage.size;
        
    }
    
    CGFloat bg_w = pageSize_def.width*_num+PAGECONTROL_jx*(_num-1);
    CGFloat bg_h = pageSize_def.height;
    
    pageBGView.frame = CGRectMake(CGRectGetMidX(pageControlView.frame)-bg_w * 0.5f, CGRectGetMidY(pageControlView.bounds)-bg_h, bg_w, bg_h);
    
    for (int i = 0; i < markImages.count; i++) {
        UIImageView* imgv = (UIImageView*)markImages[i];
        imgv.frame = CGRectMake(i*(pageSize_def.width+PAGECONTROL_jx), 0, pageSize_def.width, pageSize_def.height);
    }
    
    moveMark.frame = CGRectMake(0, 0, pageSize_cur.width, pageSize_cur.height);
    
    
    
}
- (void)setPagingEnabled:(BOOL)pagingEnabled{
    _pagingEnabled = pagingEnabled;
    myScrollView.pagingEnabled = _pagingEnabled;
}
- (void)setHiddenPageControl:(BOOL)hiddenPageControl{
    _hiddenPageControl = hiddenPageControl;
    pageControlView.hidden = _hiddenPageControl;
    
}

- (void)setDefaultPageIndicatorImage:(UIImage *)defaultPageIndicatorImage{
    _defaultPageIndicatorImage = defaultPageIndicatorImage;
    for (UIImageView* imgv in markImages) {
        //
        imgv.image = defaultPageIndicatorImage;
        imgv.backgroundColor = [UIColor clearColor];
    }
    [self reloadPageViewSize];
}
- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage{
    
    _currentPageIndicatorImage = currentPageIndicatorImage;
    moveMark.image = currentPageIndicatorImage;
    moveMark.backgroundColor = [UIColor clearColor];
    [self reloadPageViewSize];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //
    CGFloat scroll_content_w = myScrollView.contentSize.width-myScrollView.bounds.size.width;
    CGFloat scroll_curr_x = scrollView.contentOffset.x;
    
    CGFloat move_content_w = moveMark.superview.bounds.size.width-moveMark.bounds.size.width;
    
    //求当前滑块的x坐标
    CGFloat move_curr_x = move_content_w*scroll_curr_x/scroll_content_w;
    
    moveMark.frame = CGRectMake(move_curr_x, 0, moveMark.frame.size.width, moveMark.frame.size.height);
    
}

- (void)buttonOnClicked:(UIButton *)button{

    [self.delegate turnToMainScreen];

}

@end
