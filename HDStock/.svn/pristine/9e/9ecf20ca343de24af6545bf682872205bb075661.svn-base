//
//  HDOnlyFaViewController.m
//  HDStock
//
//  Created by hd-app02 on 16/11/15.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDOnlyFaViewController.h"
#import "HDOnlyFaNewsViewController.h"
#import "ZJScrollPageView.h"

@interface HDOnlyFaViewController ()<ZJScrollPageViewDelegate>

@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController *> *childVcs;

@end

@implementation HDOnlyFaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       
    [self setUpsegmentView];
    
}

- (void)setUpsegmentView{

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
   
    style.scrollTitle = NO;
    style.selectedTitleColor = MAIN_COLOR;
    style.titleFont = systemFont(17);
    style.titleBigScale = 1.1;
    self.titles = @[@"早晚评", @"观点",@"抓牛股"];
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) segmentStyle:style titles:self.titles parentViewController:self delegate:self];

    scrollPageView.segmentView.backgroundColor = BACKGROUNDCOKOR;
    [self.view addSubview:scrollPageView];

}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    HDOnlyFaNewsViewController<ZJScrollPageViewChildVcDelegate> * childVc = (HDOnlyFaNewsViewController *)reuseViewController;
    
    if (!childVc) {
        childVc = [[HDOnlyFaNewsViewController alloc] init];
        
        if (index == 0) {
            childVc.segmentselected = 0;
        }else if (index == 1){
         childVc.segmentselected = 1;
        }else if (index == 2){
            childVc.segmentselected = 2;
        }
    }
    
    return childVc;
}

- (CGRect)frameOfChildControllerForContainer:(UIView *)containerView{

    return CGRectMake(0, 0, containerView.bounds.size.width, containerView.bounds.size.height - 44);

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
