//
//  HDVideoListViewController.m
//  HDStock
//
//  Created by hd-app02 on 2016/11/30.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDVideoListViewController.h"
#import "UIParameter.h"
#import "PSYSegmentControView.h"
#import "HDVideoViewController.h"
#import "HDVideoObservationViewController.h"
#import "HDVideoTecViewController.h"
#import "HDVideoSpecialViewController.h"
#import "HDVideoHistoryViewController.h"

@interface HDVideoListViewController ()<NinaPagerViewDelegate>

@property (nonatomic, strong) PSYSegmentControView *ninaPagerView;

@property (nonatomic, assign) NSInteger curretPageCatId;

@end

@implementation HDVideoListViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    _ninaPagerView.ninaDefaultPage = self.defaultPage;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *titleArray = [self ninaTitleArray];
    NSArray *detailVCsArray = [self ninaDetailVCsArray];
    CGRect pagerRect = CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT - NAV_STATUS_HEIGHT);
    _ninaPagerView = [[PSYSegmentControView alloc] initWithFrame:pagerRect WithTitles:titleArray WithVCs:detailVCsArray];
    _ninaPagerView.ninaPagerStyles = NinaPagerStyleStateNormal;
    _ninaPagerView.unSelectTitleColor = COLOR(blackColor);
    _ninaPagerView.selectTitleColor = MAIN_COLOR;
    _ninaPagerView.titleFont = 16;
    _ninaPagerView.loadWholePages = NO;
    _ninaPagerView.topTabHeight = 40;
    _ninaPagerView.topTabBackGroundColor = BACKGROUNDCOKOR;
    _ninaPagerView.underLineHidden = YES;
    _ninaPagerView.delegate = self;
    
    [self.view addSubview:self.ninaPagerView];
}


#pragma mark - NinaParaArrays
- (NSArray *)ninaTitleArray {
    
    return @[@"推荐", @"财经观察", @"技术教学", @"直播历史"];
    
}

- (NSArray *)ninaDetailVCsArray {
    HDVideoViewController * VideoVC = [[HDVideoViewController alloc] init];
    HDVideoObservationViewController * Vo1VC = [[HDVideoObservationViewController alloc]init];
    Vo1VC.catID = 23;
    HDVideoTecViewController * Vo2VC = [HDVideoTecViewController new];
    Vo2VC.catID = 24;
//    HDVideoSpecialViewController * Vo3VC = [HDVideoSpecialViewController new];
//    Vo3VC.catID = 25;
    HDVideoHistoryViewController * Vo4VC = [HDVideoHistoryViewController new];
    Vo4VC.catID = 30;
//    return @[VideoVC, Vo1VC, Vo2VC, Vo3VC, Vo4VC];
    return @[VideoVC, Vo1VC, Vo2VC, Vo4VC];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
