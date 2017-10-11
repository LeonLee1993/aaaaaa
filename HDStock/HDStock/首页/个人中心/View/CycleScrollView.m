//
//  CycleScrollView.m
//  PagedScrollView
//
//  Created by 曾勇兵 on 15-3-30.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"

@interface CycleScrollView () <UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;
//@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;

@end

@implementation CycleScrollView{
//    UILabel * tempLabel1;
//    UILabel * tempLabel2;
//    UILabel * tempLabel3;
}

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0) {
        [self configContentViews];
//        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration andTimer:(NSTimer *)timer
{
    if(self = [self initWithFrame:frame]){
        if (animationDuration > 0.0) {
            self.animationTimer = timer;
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
        self.currentPageIndex = 0;
    }
    return self;
}

-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.scrollEnabled = NO;
        _scrollView.autoresizingMask = 0xFF;
        _scrollView.contentMode = UIViewContentModeCenter;
        _scrollView.contentSize = CGSizeMake( CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame)*3);
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(0,CGRectGetWidth(self.scrollView.frame));
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews
{
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
   
//    __block typeof (counter)blockConter = counter;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        [self.scrollView addSubview:contentView];
        CGRect tempRect = contentView.frame;
        tempRect.origin.y =CGRectGetHeight(self.scrollView.frame) * (counter ++);
        contentView.frame = tempRect;
    }
    [_scrollView setContentOffset:CGPointMake(0, _scrollView.frame.size.height)];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
//        tempLabel2 = (UILabel *)self.fetchContentViewAtIndex(_currentPageIndex);
//        tempLabel3 = (UILabel *)self.fetchContentViewAtIndex(rearPageIndex);
//        tempLabel1 = (UILabel *)self.fetchContentViewAtIndex(previousPageIndex);
        [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex)];
    }
}


- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self.animationTimer pauseTimer];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.y;
    if(contentOffsetX >= (2 * CGRectGetHeight(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        if (_totalPageCount > 0) {
            [self configContentViews];
        }
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        if (_totalPageCount > 0) {
            [self configContentViews];
        }
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}


#pragma mark - 响应事件
//- (void)animationTimerDidFired:(NSTimer *)timer
//{
//    CGPoint newOffset = CGPointMake(0,self.scrollView.contentOffset.y + CGRectGetHeight(self.scrollView.frame));
//    [self.scrollView setContentOffset:newOffset animated:YES];
//}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}


@end
