//
//  HDInfoMationViewController.m
//  HDStock
//
//  Created by hd-app02 on 16/11/14.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDInfoMationViewController.h"

#import "UIParameter.h"
#import "NinaPagerView.h"
#import "HDOnlyFaNewsViewController.h"
#import "HDSearchCenterViewController.h"
#import "HDInformationController.h"
#import "HDVideoDetailsViewController.h"
#import "HDVideoListViewController.h"

@interface HDInfoMationViewController ()<NinaPagerViewDelegate>

@property (nonatomic, strong) NinaPagerView *ninaPagerView;

@property (nonatomic, strong) UIButton * searchButton;

@end

@implementation HDInfoMationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDCOKOR;
    [self setUpNinaPageView];

    //[self setupSearchButton];

}


- (void)setUpNinaPageView{

    if (_ninaPagerView) {
        [_ninaPagerView removeFromSuperview];
    }
    NSArray *titleArray = [self ninaTitleArray];
    NSArray *detailVCsArray = [self ninaDetailVCsArray];
    CGRect pagerRect = CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT);
    _ninaPagerView = [[NinaPagerView alloc] initWithFrame:pagerRect WithTitles:titleArray WithVCs:detailVCsArray];
    _ninaPagerView.ninaPagerStyles = NinaPagerStyleBottomLine;
    _ninaPagerView.unSelectTitleColor = COLOR(whiteColor);
    _ninaPagerView.selectTitleColor = COLOR(whiteColor);
    _ninaPagerView.underlineColor = COLOR(whiteColor);
    _ninaPagerView.titleFont = 18;
    _ninaPagerView.selectBottomLinePer = 0.6;
    _ninaPagerView.loadWholePages = NO;
    _ninaPagerView.topTabHeight = 64;
    _ninaPagerView.topTabBackGroundColor = MAIN_COLOR;
    _ninaPagerView.underLineHidden = YES;
    _ninaPagerView.delegate = self;
    [self.view addSubview:self.ninaPagerView];
    //[self.view bringSubviewToFront:_searchButton];
}

#pragma mark - NinaParaArrays
- (NSArray *)ninaTitleArray {
    
    return @[@"资讯", @"独家", @"视频"];
    
}

- (NSArray *)ninaDetailVCsArray {
    
    HDInformationController * oneVC = [[HDInformationController alloc]init];
    HDOnlyFaNewsViewController *secondVC = [[HDOnlyFaNewsViewController alloc] init];
    HDVideoListViewController * videoVC = [[HDVideoListViewController alloc]init];
    if ([self.fromwhere isEqualToString:@"直播历史"]) {
        
        videoVC.defaultPage = 3;
        videoVC.fromwhere = @"直播历史";
        
    }
    
       return @[oneVC, secondVC, videoVC];
}

- (void)setupSearchButton{

    _searchButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 4 / 5, 20, self.view.frame.size.width / 5, 44)];
    
        [_searchButton setImage:imageNamed(@"search") forState:UIControlStateNormal];
    
        [_searchButton addTarget:self action:@selector(searchButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_searchButton];
    
}

- (void)searchButtonOnClicked:(UIButton *)button{

    HDSearchCenterViewController * vc = [[HDSearchCenterViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:NO];

}

#pragma mark == InfoViewControllerDelegate
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    if ([self.fromwhere isEqualToString:@"资讯"]) {
        
        [self setUpNinaPageView];
        self.ninaPagerView.ninaDefaultPage = self.selectedVC;
    
    }else if ([self.fromwhere isEqualToString:@"学技巧"]) {
        [self setUpNinaPageView];
        self.ninaPagerView.ninaDefaultPage = self.selectedVC;
        
    }else if ([self.fromwhere isEqualToString:@"直播历史"]) {
        [self setUpNinaPageView];
        self.ninaPagerView.ninaDefaultPage = self.selectedVC;
        
    }
    
    [self.view removeGestureRecognizer:self.pan];
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    if ([self.fromwhere isEqualToString:@"资讯"]) {
        self.fromwhere = @"";
        
    }else if ([self.fromwhere isEqualToString:@"学技巧"]) {
        self.fromwhere = @"";
    }else if ([self.fromwhere isEqualToString:@"直播历史"]) {
        
        self.fromwhere = @"";
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
