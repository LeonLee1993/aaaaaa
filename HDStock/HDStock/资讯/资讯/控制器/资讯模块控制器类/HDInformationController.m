//
//  HDInformationController.m
//  HDStock
//
//  Created by hd-app02 on 2016/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDInformationController.h"
#import "HDRecommendViewController.h"
#import <SDCycleScrollView.h>
#import "HDAdvertisementModel.h"
#import "HDAdversementDetailViewController.h"

//#define headViewHeight self.view.bounds.size.width * 95.0 / 207.0

static CGFloat const segmentViewHeight = 44.0;
static CGFloat const naviBarHeight = 64.0;

NSString *const ZJParentTableViewDidLeaveFromTopNotification = @"ZJParentTableViewDidLeaveFromTopNotification";
extern NSString *const hasBeenReloadedNotification;
static NSString * const cellID = @"cellID";
static NSString * const kMyInfoArr = @"myInfoArr";

@interface HDCustomGestureTableView : UITableView

@end

@implementation HDCustomGestureTableView

// 返回YES同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end

@interface HDInformationController ()<ZJScrollPageViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, HDPageViewControllerDelegate, SDCycleScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray<NSString *> *titles;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) ZJScrollSegmentView *segmentView;
@property (strong, nonatomic) ZJContentView *contentView;
@property (strong, nonatomic) UIScrollView *childScrollView;
@property (strong, nonatomic) HDCustomGestureTableView *tableView;

@property (strong, nonatomic) HDRecommendViewController * recVC;
@property (nonatomic, strong) NSMutableArray * bannerImageArray;
@property (nonatomic, strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic, strong) NSMutableArray * bannerDataArray;

@end

@implementation HDInformationController{


    CGFloat headViewHeight;

}

- (NSMutableArray *)bannerImageArray{
    
    if (!_bannerImageArray) {
        _bannerImageArray = [[NSMutableArray alloc]init];
    }
    
    return _bannerImageArray;
}

- (NSMutableArray *)bannerDataArray{
    
    if (!_bannerDataArray) {
        _bannerDataArray = [[NSMutableArray alloc]init];
    }
    
    return _bannerDataArray;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (kScreenIphone5 || kScreenIphone6 ) {
        
        headViewHeight = 173.0f;
        
    }else{
    
        headViewHeight = 190.0f;
    
    }

    [self requestBannerImage];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGRect frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height - NAV_HEIGHT);
    self.tableView = [[HDCustomGestureTableView alloc] initWithFrame:frame style:UITableViewStylePlain];

    self.tableView.backgroundColor = BACKGROUNDCOKOR;
    self.tableView.rowHeight = self.contentView.bounds.size.height;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 设置tableView的sectionHeadHeight为segmentViewHeight
    self.tableView.sectionHeaderHeight = segmentViewHeight;
    self.tableView.showsVerticalScrollIndicator = false;
    //        tableView.alwaysBounceVertical = NO;
    self.tableView.tableHeaderView.userInteractionEnabled = YES;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakself = self;
    
    /// 下拉刷新
    self.tableView.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            typeof(weakself) strongSelf = weakself;
            strongSelf.recVC.pageOfData = 1;
            [strongSelf.recVC requestData];
            [strongSelf requestBannerImage];
            [[NSNotificationCenter defaultCenter] addObserver:strongSelf selector:@selector(endRefresh) name:hasBeenReloadedNotification object:nil];
        });
    }];
    
}

- (void)endRefresh{

    [self.tableView.mj_header endRefreshing];

}

- (void)setUpCycleScrollView{
    
    if (self.cycleScrollView) {
        
        [self.cycleScrollView removeFromSuperview];
    }
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, headViewHeight) delegate:self placeholderImage:[UIImage imageNamed:@"emptypic"]];
    self.cycleScrollView.imageURLStringsGroup = self.bannerImageArray;
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.tableView.tableHeaderView = self.cycleScrollView;

}

#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {

        HDRecommendViewController *vc = [[HDRecommendViewController alloc] init];
        vc.delegate = self;
        if ([self.segmentView.titles[index] isEqualToString:@"推荐"]) {
            vc.index = 9000;
            childVc = vc;
        }else if ([self.segmentView.titles[index] isEqualToString:@"要闻"]) {
            vc.index = 9001;
            childVc = vc;
        }else if ([self.segmentView.titles[index] isEqualToString:@"板块"]) {
            vc.index = 9004;
            childVc = vc;
        }else if ([self.segmentView.titles[index] isEqualToString:@"国际"]) {
            vc.index = 9005;
            childVc = vc;
        }else if ([self.segmentView.titles[index] isEqualToString:@"个股"]) {
            vc.index = 9006;
            childVc = vc;
        }else if ([self.segmentView.titles[index] isEqualToString:@"大盘"]) {
            vc.index = 9007;
            childVc = vc;
        }
    
        }
    
    return childVc;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index{

    if ([childViewController isKindOfClass:[HDRecommendViewController class]]) {
        
        self.recVC = (HDRecommendViewController *)childViewController;
        
    }
}

#pragma mark- ZJPageViewControllerDelegate

- (void)scrollViewIsScrolling:(UIScrollView *)scrollView {
    
    _childScrollView = scrollView;

    if (self.tableView.contentOffset.y < headViewHeight) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    }else {
        self.tableView.contentOffset = CGPointMake(0.0f, headViewHeight);
        scrollView.showsVerticalScrollIndicator = NO;
    }

}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.childScrollView && _childScrollView.contentOffset.y > 0) {
        self.tableView.contentOffset = CGPointMake(0.0f, headViewHeight);
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < headViewHeight) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZJParentTableViewDidLeaveFromTopNotification object:nil];
    }
}

#pragma mark- UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:self.contentView];
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segmentView;
}

#pragma mark- setter getter
- (ZJScrollSegmentView *)segmentView {
    if (_segmentView == nil) {
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
        
        style.autoAdjustTitlesWidth = YES;
        
        //    /** 标题的字体 默认为14 */
        style.titleFont = [UIFont systemFontOfSize:16];
        
        style.selectedTitleColor = MAIN_COLOR;
        
        style.titleMargin = 25;
        
        style.segmentViewBounces = YES;
        
        // 注意: 一定要避免循环引用!!
        __weak typeof(self) weakSelf = self;
        ZJScrollSegmentView *segment = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, naviBarHeight + headViewHeight, self.view.bounds.size.width, segmentViewHeight) segmentStyle:style delegate:self titles:self.titles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
            
        }];
        segment.backgroundColor = BACKGROUNDCOKOR;
        _segmentView = segment;
        
    }
    return _segmentView;
}

- (ZJContentView *)contentView {
    if (_contentView == nil) {
        ZJContentView *content = [[ZJContentView alloc] initWithFrame:self.view.bounds segmentView:self.segmentView parentViewController:self delegate:self];
        _contentView = content;
    }
    return _contentView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

    HDAdvertisementModel * model = [self.bannerDataArray objectAtIndexCheck:index];
    
//    HDAdversementDetailViewController * headVC = [[HDAdversementDetailViewController alloc]init];
//    
//    headVC.hidesBottomBarWhenPushed = YES;
//    
//    headVC.url = model.link;
//    headVC.tittle = model.title;
//    headVC.imageUrlStr = model.url;
//    
//    [self.navigationController pushViewController:headVC animated:NO];
    [self turnToDetailViewController:model];

}

- (NSMutableArray<NSString *> *)titles{

    if (!_titles) {
        
        _titles = [NSMutableArray arrayWithArray:@[@"推荐", @"要闻", @"个股", @"板块", @"大盘", @"国际"]];
    }

    return _titles;

}

- (void)requestBannerImage{
    
    NSString * bannerUrl = [NSString stringWithFormat:Advertisement,2,arc4random()%10000];
    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:bannerUrl params:nil success:^(id json) {
            
            NSArray * array = json[@"data"];
            
            [self.bannerDataArray removeAllObjects];
            [self.bannerImageArray removeAllObjects];
            
            for (NSDictionary * dic in array) {
                HDAdvertisementModel * adModel = [HDAdvertisementModel yy_modelWithDictionary:dic];
                
                [self.bannerDataArray addObject:adModel];
                
                NSString * str = dic[@"url"];
                
                [strongSelf.bannerImageArray addObject:str];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [strongSelf setUpCycleScrollView];
    
            });
            
        } failure:^(NSError *error) {
            
            [strongSelf setUpCycleScrollView];
            
        }];
    });
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
