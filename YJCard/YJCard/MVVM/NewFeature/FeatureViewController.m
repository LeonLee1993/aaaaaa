//
//  FeatureViewController.m
//  meizai
//
//  Created by liyancheng on 16/5/18.
//  Copyright © 2016年 touzibao. All rights reserved.
//

#import "FeatureViewController.h"
#import "AppDelegate.h"
#import "LYCBaseTabBarController.h"
#import "TendentMainPageControl.h"
#import "LoginViewController.h"

@interface FeatureViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) TendentMainPageControl * pageControl;

@end

@implementation FeatureViewController{
    NSInteger flagTime;
    bool getInMZFlag;
    UILabel *timeLable;
    CGFloat historyX;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_scrollView];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self generateNewFeaturePages];
    [self SetPageControl];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    flagTime = 6;
    getInMZFlag = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)generateNewFeaturePages {
    CGFloat w = self.scrollView.frame.size.width;
    CGFloat h = self.scrollView.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(w * 3, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    
    
    for (int i = 10; i < 13; i++) {
        NSString *imgName = [NSString stringWithFormat:@"feature%d",i-9];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(w * (i - 10), 0, w, h)];
        imageView.image = [UIImage imageNamed:imgName];
        [self.scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        if(i==12){
            UIButton *getinBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [getinBtn setTitle:@"立即体验" forState:UIControlStateNormal];
            
            getinBtn.backgroundColor = MainColor;
            [getinBtn setTintColor:[UIColor whiteColor]];
            getinBtn.layer.cornerRadius = 5;
            getinBtn.layer.masksToBounds = YES;
            getinBtn.frame = CGRectMake(0, 0, ScreenWidth/2.5, ScreenWidth/2.5/4);
            getinBtn.center = CGPointMake(CGRectGetWidth(imageView.frame) * 0.5, CGRectGetHeight(imageView.frame) - 85);
            [imageView addSubview:getinBtn];
            [getinBtn addTarget:self action:@selector(getinMeizai) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)getinMeizai
{
    UIView *view = [self.view snapshotViewAfterScreenUpdates:YES];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if([[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey]){
        LYCBaseTabBarController * rootVc = [[LYCBaseTabBarController alloc] init];
        [rootVc.view addSubview:view];
        delegate.window.rootViewController = rootVc;
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [loginVC.view addSubview:view];
        delegate.window.rootViewController = loginVC;
    }

    [UIView animateWithDuration:1 animations:^{
        view.transform = CGAffineTransformMakeScale(2.0, 2.0);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    getInMZFlag = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


- (void)SetPageControl{
    
    _pageControl = [[TendentMainPageControl alloc] init];
    _pageControl.frame = CGRectMake(ScreenWidth/2-20, ScreenHeight/667*600, 40, 20);//指定位置大小
    _pageControl.numberOfPages = 3;//指定页面个数
    _pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    //添加委托方法，当点击小白点就执行此方法
    
    //    _pageControl.pageIndicatorTintColor = [UIColor redColor];// 设置非选中页的圆点颜色
    
    //    _pageControl.currentPageIndicatorTintColor = [UIColor blueColor]; // 设置选中页的圆点颜色
    [_pageControl addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
}

- (void)pageChange{
    int page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(page * ScreenWidth, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 设置页码
    _pageControl.currentPage = page;
    
    if (scrollView.dragging) {//拖拽
        if (scrollView.contentOffset.x < historyX && historyX) {//当前月
            scrollView.scrollEnabled = NO;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    historyX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    scrollView.scrollEnabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    scrollView.scrollEnabled = YES;
}

@end
