//
//  HDRecommendViewController.m
//  HDStock
//
//  Created by hd-app02 on 2016/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDRecommendViewController.h"

@interface HDRecommendViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) HDFailLoadView * failLoadView;
@property(strong, nonatomic) NSMutableArray * dataArray;

@property (nonatomic, strong) UIButton * backToTopButton;

@end

static NSString * const cellId = @"cellID";
NSString *const hasBeenReloadedNotification = @"hasBeenReloadedNotification";
@implementation HDRecommendViewController{
    NSInteger page;
    NSInteger perpage;
    NSInteger cateId;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods{

    return YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setPageOfData:(NSInteger)pageOfData{

    _pageOfData = pageOfData;
    
    page = _pageOfData;
    
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    page = 1;
    perpage = 20;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - NAV_HEIGHT - NAV_STATUS_TABBAR_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataArray = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tempScrollView.bounces = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HDHeadLineBaseCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineBaseCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDHeadLineSingleViewCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineSingleViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDHeadLineBigViewCellCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineBigViewCellCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDHeadLineThreeViewCellCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineThreeViewCellCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDLoadFailCell" bundle:nil] forCellReuseIdentifier:@"HDLoadFailCell"];
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakself = self;
    
    self.tableView.mj_footer = [PSYRefreshGifFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            typeof(weakself) strongSelf = weakself;
            if (self.dataArray.count != 0) {
                page ++;
            }else{
            
                page = 1;
            }
            
            [strongSelf requestData];
        });
        
        
    }];
    
    [self setUpBackToTopButton];
}

- (void)zj_viewDidAppearForIndex:(NSInteger)index {

    if (self.index == 9000) {
        cateId = 1;//资讯推荐
    }else if (self.index == 9001) {
        cateId = 14;//要闻
    }else if (self.index == 9004) {
        cateId = 18;//板块
    }else if (self.index == 9005) {
        cateId = 19;//国际
    }else if (self.index == 9006) {
        cateId = 16;//个股
    }else if (self.index == 9007) {
        cateId = 15;//大盘
    }
    [self requestData];

    
}

- (void)requestData{
    
    
    [self.failLoadView hideTheSubViews];

    NSString * url = [NSString stringWithFormat:Home_HeadLineCateNews,(long)page,(long)perpage,(long)cateId,@"0",arc4random()%10000];
    
    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //
    //    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            NSArray * dataArr = json[@"data"];
            if (page == 1) {
                if (strongSelf.dataArray.count != 0) {
                    [strongSelf.dataArray removeAllObjects];
                }
            }
            for (NSDictionary * dic in dataArr) {
                HDHeadLineModel * headlinemodel = [HDHeadLineModel yy_modelWithDictionary:dic];
                [strongSelf.dataArray addObject:headlinemodel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:hasBeenReloadedNotification object:nil];
                [strongSelf.tableView.mj_footer endRefreshing];
            });
            
            
        } failure:^(NSError *error) {
           
            [[NSNotificationCenter defaultCenter] postNotificationName:hasBeenReloadedNotification object:nil];
            [strongSelf.tableView.mj_footer endRefreshing];
            [strongSelf.failLoadView showTheSubViews];
            
        }];
        
    });

}

- (void)zj_viewDidDisappearForIndex:(NSInteger)index {
    NSLog(@"已经消失   标题: --- %@  index: -- %ld", self.title, (long)index);

}

- (void)setUpBackToTopButton{
    
    UIImage * back = [UIImage imageNamed:@"backtotop_button"];
    
    CGSize imageSize = back.size;
    //NSLog(@"%@",imageSize);
    
    self.backToTopButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - imageSize.width - 10.0f, SCREEN_HEIGHT - 230.0f, imageSize.width, imageSize.height)];
    
    [self.backToTopButton setBackgroundImage:back forState:UIControlStateNormal];
    
    [self.view addSubview:self.backToTopButton];
    [self.backToTopButton addTarget:self action:@selector(backToTopButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.backToTopButton setHidden:YES];
    
}

#pragma mark- ZJScrollPageViewChildVcDelegate

#pragma mark- UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray.count == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.dataArray.count != 0) {
        
        HDHeadLineModel * headlineModel = self.dataArray[indexPath.row];
        
        HDHeadLineBaseCell * cellBase = [tableView dequeueReusableCellWithIdentifier:@"HDHeadLineBaseCell"];
        
        cellBase.model = headlineModel;
        
        HDHeadLineSingleViewCell * cellSingle = [tableView dequeueReusableCellWithIdentifier:@"HDHeadLineSingleViewCell"];
        
        cellSingle.model = headlineModel;
        
        HDHeadLineBigViewCellCell * cellBig = [tableView dequeueReusableCellWithIdentifier:@"HDHeadLineBigViewCellCell"];
        
        cellBig.model = headlineModel;
        
        HDHeadLineThreeViewCellCell * cellThreeView = [tableView dequeueReusableCellWithIdentifier:@"HDHeadLineThreeViewCellCell"];
        
        cellThreeView.model = headlineModel;
        
        if(headlineModel.pic && headlineModel.pic.length > 1){
            
            if (!headlineModel.countmanypic) {
                
                return cellSingle;
                
            }else{
                
                if (headlineModel.countmanypic == 3) {
                    
                    return cellThreeView;
                    
                }else{
                    
                    return cellSingle;
                    
                }
                
            }
            
        }else{
            
            if (!headlineModel.countmanypic || headlineModel.countmanypic == 0) {
                
                return cellBase;
                
            }else{
                
                if (headlineModel.countmanypic == 3) {
                    
                    return cellThreeView;
                    
                }else{
                    
                    return cellSingle;
                    
                }
                
                
            }
            
            
        }
    }
    
    HDLoadFailCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"HDLoadFailCell"];
    if (!self.failLoadView) {
        
        self.failLoadView = cell.loadFailView;
    }
    [cell.loadFailView.button addTarget:self action:@selector(loadfailButtonOnTouched:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.dataArray.count != 0){
    HDHeadLineModel * model = [self.dataArray objectAtIndexCheck:indexPath.row];
        NSString * tagName = model.tags_name.allValues[0];
        if ([tagName isEqualToString:@"专题"] || [tagName isEqualToString:@"广告"]) {
            
            HDSubjectViewController * vc = [[HDSubjectViewController alloc]init];
            
            vc.aid = model.aid;
            vc.uid = model.uid;
            vc.tittle = model.title;
            vc.imageUrlStr = model.pic;
            if ([tagName isEqualToString:@"专题"]){
                
                vc.controllerTitle = @"专题";
                
            }else{
                
                vc.controllerTitle = @"";
                
            }
            
            [self.navigationController pushViewController:vc animated:NO];
            
        }else{
            //HeadLineViewController * headVC = [[HeadLineViewController alloc]init];
            HDHeadLineDetailViewController * headVC = [[HDHeadLineDetailViewController alloc]init];
            headVC.aid = model.aid;
            headVC.uid = model.uid;
            headVC.tittle = model.title;
            headVC.imageUrlStr = model.pic;
            headVC.hidesBottomBarWhenPushed = YES;
            headVC.controllerTitle = @"资讯";

            [self.navigationController pushViewController:headVC animated:NO];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray.count != 0){
        
        HDHeadLineModel * headlineModel = self.dataArray[indexPath.row];
        
        return headlineModel.cellHeight;
    }
    

    return self.view.size.height;

}

- (void)loadfailButtonOnTouched:(UIButton *)button{
    
    [self.failLoadView hideTheSubViews];
    
    [self requestData];
    
}

#pragma mark -- 滚动视图代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.tempScrollView) {
        self.tempScrollView = scrollView;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewIsScrolling:)]) {
        [self.delegate scrollViewIsScrolling:scrollView];
    }
    
    CGPoint contentOffSet = scrollView.contentOffset;
    if (contentOffSet.y > SCREEN_HEIGHT/2.0f ) {
        
        [self.backToTopButton setHidden:NO];
        
    }else{
        
        [self.backToTopButton setHidden:YES];
        
    }
    
}

- (void)backToTopButtonOnClicked{
    
    [self.tableView scrollToTop];
    
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
