//
//  HDHomePageViewController.m
//  HDStock
//  flag
//  Created by hd-app02 on 16/11/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDHomePageViewController.h"
#import "AppDelegate.h"
//左视图
#import "HDLeftMainViewController.h"
#import "GCDAsyncSocket.h"
#import "HDStartAdverImageView.h"
#import "HDVertionCheckAlertShowView.h"
#import "HDStockSayingViewController.h"
#import "HDVideoDetailsViewController.h"

@interface HDHomePageViewController ()<UITableViewDataSource,UITableViewDelegate,PSYScrollButtonsDelegate,PSYScrollButtonViewsDelegate, UIApplicationDelegate, SDCycleScrollViewDelegate, GCDAsyncSocketDelegate, UIScrollViewDelegate, HDStartAdverDelegate, HDVertionCheckAlertShowViewDelegate, UITabBarControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIButton *messageCenter;
@property (nonatomic, strong) NSMutableArray * headLinedataArray;
@property (nonatomic, strong) NSMutableArray * bannerImageArray;
@property (nonatomic, strong) NSMutableArray * bannerDataArray;
@property (nonatomic, strong) NSMutableArray * hotNewsArray;
@property (nonatomic, strong) NSMutableArray * stockSayingArray;
@property (nonatomic, strong) NSMutableArray * productArray;

@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) HDFailLoadView * failLoadView;
@property (nonatomic,strong) GCDAsyncSocket * thySocket;
@property (nonatomic, retain) NSTimer        *connectTimer; // 计时器

@property (nonatomic, strong) UIButton * backToTopButton;
@property (nonatomic, strong) HDStartAdverImageView * startImage;
@property (nonatomic, strong) HDVertionCheckAlertShowView * alertShowView;
@property (nonatomic, strong) NSDate *lastDate; //记录上次点击tabbar的时间,用于双击判断

@end

/***************  SOCKET的IP和端口号 *****************/
NSString * const SOCKET_IP = @"123.57.43.69";
UInt16 const SOCKET_PORT = 17171;

NSString * const QUOTATION_NOTE = @"quotation_notification";
static NSString * tok;

static NSString * const HasCache = @"cacheData.plist";

@implementation HDHomePageViewController{

    NSInteger page;

    NSInteger perpage;
    
    NSInteger cateId;

}

#pragma mark ------------------- 生命周期
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setHidden:NO];
    [self requestData];
    
    NSDictionary *dicd = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    
    if (dicd[@"token"]) {
        
        self.token = dicd[@"token"];
        
        NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"isfirst"];
        
        if (![self.token isEqualToString:tok] || [str isEqualToString:@"firstLoading"]) {
            [self requestCollectedArticles];
        }
        
        tok = dicd[@"token"];
        
    }else{
        
        self.token = @"1";
        
    }
    
    [self loadDataOfMessageCenter];
    
    NSArray *arr = [[LYCUserManager informationDefaultUser].defaultUser objectForKey:alreadyBuiedKey];
    
    if (arr.count == 0) {
        
        [self loadDataOfProductList];
        
    }else{
    
        [self.productArray removeAllObjects];
        [self.productArray addObjectsFromArray:arr];
    }

}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];

    if(self.startImage ){
    
        [self.startImage removeFromSuperview];
    
    }
    
    HDStockSayingCell * cell = [self.mainTableView viewWithTag:999];
    [cell playerPause];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate = self;
    [self setupStartAdver];
    //[self checkTheVertionOfAPP];//版本检测
    [self connectSocket];
    
    self.token = @"1";
    
    page = 1;
    
    perpage = 20;
    
    cateId = 1;
    
    [self setUpTableView];
    [self setUpBackToTopButton];
    [self requestBannerImage];
    [self requestHotNewsData];
    [self requestStockSayingData];
   
}

#pragma mark ------------------- 开屏广告

- (void)setupStartAdver{
    
    NSInteger time = [[NSUserDefaults standardUserDefaults] integerForKey:@"firstStart"];
    
    if(time <= 5 ){
        
        self.startImage = [[HDStartAdverImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        
        self.startImage.delegate = self;
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.startImage];
        
    }
}

- (void)passToAnotherController{

    [self.startImage removeFromSuperview];

}

- (void)turnIntoDetail:(HDAdvertisementModel *)model{
    
    [self.startImage removeFromSuperview];
    [self turnToDetailViewController:model];
}

#pragma mark ------------------- 基础配置
- (void)setUpBackToTopButton{
    
    UIImage * back = [UIImage imageNamed:@"backtotop_button"];
    
    CGSize imageSize = back.size;

    self.backToTopButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - imageSize.width - 10.0f, SCREEN_HEIGHT - 180.0f, imageSize.width, imageSize.height)];

    [self.backToTopButton setBackgroundImage:back forState:UIControlStateNormal];
    
    [self.view addSubview:self.backToTopButton];
    [self.backToTopButton addTarget:self action:@selector(backToTopButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.backToTopButton setHidden:YES];

}

- (void)setUpTableView{

    _mainTableView.dataSource = self;
    
    _mainTableView.delegate = self;
    
    _mainTableView.backgroundColor = BACKGROUNDCOKOR;
    
    _mainTableView.allowsSelection = YES;
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"HDTopScrollCell" bundle:nil] forCellReuseIdentifier:@"HDTopScrollCell"];
    [_mainTableView registerNib:[UINib nibWithNibName:@"HDMiddleCell" bundle:nil] forCellReuseIdentifier:@"HDMiddleCell"];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HDHeadLineBaseCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineBaseCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HDHeadLineSingleViewCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineSingleViewCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HDHeadLineBigViewCellCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineBigViewCellCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HDHeadLineThreeViewCellCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineThreeViewCellCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HDScrollWordsTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDScrollWordsTableViewCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HDStockSayingCell" bundle:nil] forCellReuseIdentifier:@"HDStockSayingCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HDLoadFailCell" bundle:nil] forCellReuseIdentifier:@"HDLoadFailCell"];
    
    WEAK_SELF;
    
    self.mainTableView.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
       
        page = 1;
        [weakSelf requestData];
        [weakSelf requestBannerImage];
        [weakSelf requestHotNewsData];
        [weakSelf requestStockSayingData];
        
    }];
    
    self.mainTableView.mj_footer = [PSYRefreshGifFooter footerWithRefreshingBlock:^{
        
        page ++;
        
        [weakSelf requestData];
        
    }];
    
}

#pragma mark ------------------- tableview data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 5;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 4) {
        
        if (self.headLinedataArray.count != 0) {
            
            return self.headLinedataArray.count;
            
        }

    }
    
    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
            return HDTopCellHeight;
            break;
        case 1:
            return HDScrollWordsCellHeight;
            break;
        case 2:
        {
            if (kScreenIphone4 || kScreenIphone5) {
                
                return HDMiddleCellHeight + 40;
                
            }else{
                
                return HDMiddleCellHeight;
                
            }
            
        }
            break;
        case 3:
        {
            if (kScreenIphone4 || kScreenIphone5) {
                
                return HDStockSayingCellHeight + 40;
                
            }else if (kScreenIphone6){
                
                return HDStockSayingCellHeight + 20;
                
            }else{
            
                return HDStockSayingCellHeight;
            
            }
        
        }
            
            break;
        case 4:
            
                if (self.headLinedataArray.count == 0) {
                    
                    return SCREEN_HEIGHT;
                }else{
                
                HDHeadLineModel * model = [self.headLinedataArray objectAtIndexCheck:indexPath.row];
                return model.cellHeight;
                }
                
            break;
            
        default:
            break;
    }
    
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
            
        case 0:{
            
            HDTopScrollCell * cell = [_mainTableView dequeueReusableCellWithIdentifier:@"HDTopScrollCell"];
            
            cell.ScrollView.delegate = self;
            cell.imageUrlArray = self.bannerImageArray;
            cell.topScrollButtons.delegate = self;
            
            return cell;
        }
            break;
        case 1:{
            
            HDScrollWordsTableViewCell * cell = [_mainTableView dequeueReusableCellWithIdentifier:@"HDScrollWordsTableViewCell"];
            cell.wordsScorllView.delegate = self;
            
            NSMutableArray * muArray = [NSMutableArray new];
            
            for (HDHotNewsModel * model in self.hotNewsArray) {
             
            NSString * str = model.title;
                
                [muArray addObject:str];
            }
            
            cell.hotNewsArray = muArray;
            
            return cell;
            
        }
            break;
            
        case 2:{
            
            HDMiddleCell * cell = [_mainTableView dequeueReusableCellWithIdentifier:@"HDMiddleCell"];
            
            cell.psyScrollButtonView.delegate = self;
            
            return cell;
            
        }
            break;
        case 3:{
            
            HDStockSayingCell * cell = [_mainTableView dequeueReusableCellWithIdentifier:@"HDStockSayingCell"];
            cell.tag = 999;
            cell.urlArray = self.stockSayingArray;
            return cell;
            
        }
            break;
        
        case 4:
                
                if (_headLinedataArray.count != 0) {
                
                HDHeadLineModel * headlineModel = [self.headLinedataArray objectAtIndexCheck:indexPath.row];
                
                HDHeadLineBaseCell * cellBase = [tableView dequeueReusableCellWithIdentifier:@"HDHeadLineBaseCell"];
                cellBase.model = headlineModel;
                
                HDHeadLineSingleViewCell * cellSingle = [tableView dequeueReusableCellWithIdentifier:@"HDHeadLineSingleViewCell"];
                cellSingle.model = headlineModel;
                
                
//                HDHeadLineBigViewCellCell * cellBig = [tableView dequeueReusableCellWithIdentifier:@"HDHeadLineBigViewCellCell"];
//                cellBig.model = headlineModel;
                
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
                }else{
                
                    HDLoadFailCell * cell = [_mainTableView dequeueReusableCellWithIdentifier:@"HDLoadFailCell"];
                    
                    self.failLoadView = cell.loadFailView;
                    
                    [cell.loadFailView.button addTarget:self action:@selector(loadfailButtonOnTouched:) forControlEvents:UIControlEventTouchUpInside];
                    
                    return cell;
                    
                
                }        
            break;
        default:
            break;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 4) {
        
        return 40;
        
    }
    return 0;
    
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 4) {
        
        HDHeaderView * view = [[HDHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        return view;
        
    }
    
    return nil;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 4 && self.headLinedataArray.count != 0) {
        return YES;
    }
    
    return NO;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HDHeadLineModel * model = [self.headLinedataArray objectAtIndexCheck:indexPath.row];
    
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
    
        HDHeadLineDetailViewController * headVC = [[HDHeadLineDetailViewController alloc]init];
        headVC.aid = model.aid;
        headVC.uid = model.uid;
        headVC.tittle = model.title;
        headVC.imageUrlStr = model.pic;
        headVC.controllerTitle = @"资讯";
    
        [self.navigationController pushViewController:headVC animated:NO];
        
    }

}

#pragma mark ------------------- 点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    Class class = cycleScrollView.superview.superview.class;
    
    HDAdvertisementModel * model = [self.bannerDataArray objectAtIndexCheck:index];
    HDHotNewsModel * hotModel = [self.hotNewsArray objectAtIndexCheck:index];
    
//    if (class == [HDScrollWordsTableViewCell class] ) {
//        
//        HDHeadLineDetailViewController * vc = [[HDHeadLineDetailViewController alloc]init];
//        
//        vc.aid = hotModel.aid;
//        vc.tittle = hotModel.title;
//        vc.uid = hotModel.uid;
//        vc.imageUrlStr = hotModel.pic;
//        vc.controllerTitle = @"热点投资";
//        
//        [self.navigationController pushViewController:vc animated:NO];
//        
//    }else{
//        HDAdversementDetailViewController * headVC = [[HDAdversementDetailViewController alloc]init];
//        
//        headVC.hidesBottomBarWhenPushed = YES;
//    
//        headVC.url = model.link;
//        headVC.imageUrlStr = model.url;
//        headVC.tittle = model.title;
//        
//        [self.navigationController pushViewController:headVC animated:NO];
//    
//    }

        if (class == [HDScrollWordsTableViewCell class] ) {
    
            HDHeadLineDetailViewController * vc = [[HDHeadLineDetailViewController alloc]init];
    
            vc.aid = hotModel.aid;
            vc.tittle = hotModel.title;
            vc.uid = hotModel.uid;
            vc.imageUrlStr = hotModel.pic;
            vc.controllerTitle = @"热点投资";
    
            [self.navigationController pushViewController:vc animated:NO];
    
        }else{
            
            [self turnToDetailViewController:model];
        
        }
    
}

- (void)psySimpleButtonOnTouched:(UIButton *)button{
    
    HDStockNavigationController * infoNav = self.tabBarController.childViewControllers[2];
    HDStockNavigationController * liveNav = self.tabBarController.childViewControllers[3];
    HDStockNavigationController * hqNav = self.tabBarController.childViewControllers[1];
    HDInfoMationViewController * infoVC = infoNav.childViewControllers[0];
    
    switch (button.tag) {
        case 1000:
            infoVC.selectedVC = 0;
            infoVC.fromwhere = @"资讯";
            [self.tabBarController setSelectedViewController:infoNav];
            break;
        case 1001:
            [self.tabBarController setSelectedViewController:hqNav];
            break;
        case 1002:
        {
        
            HDStockSayingViewController * sayVC = [[HDStockSayingViewController alloc]init];
            
            [self.navigationController pushViewController:sayVC animated:YES];
        
        }
            break;
        case 1003:
        {
            NSString * classStr = NSStringFromClass([PersonalproductViewController class]);
            id targetVC = [[NSClassFromString(classStr) alloc] init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:targetVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 1004:
            
            infoVC.selectedVC = 2;
            infoVC.fromwhere = @"学技巧";
            
            [self.tabBarController setSelectedViewController:infoNav];
            break;
        case 1005:
        {
            PSYPopOutView * pop = [[PSYPopOutView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
           
            [self.view.window addSubview:pop];
            
        }
            break;
        case 1006:
            [self.tabBarController setSelectedViewController:liveNav];
            break;
        case 1007:
        {
            if (self.token && ![self.token isEqualToString:@"1"]) {
                
            
                //HDGetGoldenStock * pop = [[HDGetGoldenStock alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                HDGetGoldenStockSmallScreen * pop = [[HDGetGoldenStockSmallScreen alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                [self.view.window addSubview:pop];
            }else{
            
                PCSignInViewController * signVC = [[PCSignInViewController alloc]init];
                
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:signVC];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
        
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)psyScrollButtonOnTouched:(UIButton *)button{
    
    NSInteger index = button.tag - 1100;
    
    BOOL state1 = false;
    BOOL state2 = false;
    BOOL state3 = false;
    BOOL state4 = false;

    for (NSString * str in self.productArray) {
        
        if ([str isEqualToString:@"1"]){
        
            state1 = YES;
        
        }else if ( [str isEqualToString:@"2"]){
        
            state2 = YES;
        
        }else if ([str isEqualToString:@"3"]){
        
            state3 = YES;
        
        }else if ([str isEqualToString:@"4"]) {
            
            state4 = YES;
            
        }
        
    }
    
    if((index == 0 && state1) || (index == 1 && state2) || (index == 2 && state3) || (index == 3 && state4)){
        
        buiedProductListViewController * bpVC = [[buiedProductListViewController alloc]init];

        bpVC.flagStr = [NSString stringWithFormat:@"%ld",(long)index + 1];

        [self.navigationController pushViewController:bpVC animated:YES];
        
    }else{
        NSArray * picArr = @[@"V6_pic",@"catchcow_pic",@"catchdragon_pic",@"catchmonster_pic"];
        NSArray * textArr = @[@"  VIP尊享版帮您理清市场热点，挖掘潜力龙头，把握大盘方向...",@"  硝烟四起，烽火连天，股市的战场上神牛狂奔，却总被踩踏。何不...",@"  破囚之龙,一飞冲天，欲获龙头，必拥降龙之利器。共振爆点，直指...",@"  山雄伟，海辽阔，经奇幻。股市风云变幻，妖股横行，妖行千里..."];
        ProductDetailViewController *PDVC = [[ProductDetailViewController alloc]init];
        PDVC.shareImageStr = picArr[index];
        PDVC.shareTextStr = textArr[index];
        switch (index) {
            case 0:
                PDVC.title = @"V6尊享版";
                PDVC.urlStr = @"http://gk.cdtzb.com/api/product/x6";
                PDVC.priceStr = @"998";
                PDVC.idStr = @"1";
                break;
            case 1:
                PDVC.title = @"擒牛";
                PDVC.urlStr = @"http://gk.cdtzb.com/api/product/qn";
                PDVC.priceStr = @"1998";
                PDVC.idStr = @"2";
                break;
            case 2:
                PDVC.title = @"降龙";
                PDVC.urlStr = @"http://gk.cdtzb.com/api/product/xl";
                PDVC.priceStr = @"3998";
                PDVC.idStr = @"3";
                break;
            case 3:
                PDVC.title = @"捉妖";
                PDVC.urlStr = @"http://gk.cdtzb.com/api/product/zy";
                PDVC.priceStr = @"5998";
                PDVC.idStr = @"4";
                break;
                
            default:
                break;
        }
        
        [self.navigationController pushViewController:PDVC animated:YES];
    }

}

- (void)loadfailButtonOnTouched:(UIButton *)button{
    
    [self.failLoadView hideTheSubViews];

    [self requestData];
    [self requestBannerImage];
    [self requestHotNewsData];
    [self requestStockSayingData];

}

- (void)backToTopButtonOnClicked{

    [self.mainTableView scrollToTop];

}

#pragma mark ------------------- 网络请求
- (void)requestData{
    
    WEAK_SELF;
    
    EGOCache * cache = [EGOCache globalCache];
    
    [[CDAFNetWork sharedMyManager]checkNetWorkStatusSuccess:^(id str) {
        
        if ([(NSString *)str isEqualToString:@"0"] || [(NSString *)str isEqualToString:@"-1"]) {
            
            if([cache hasCacheForKey:HasCache]){
                
                NSData * responseObject = [cache dataForKey:HasCache];
                
                NSDictionary * dict = [NSKeyedUnarchiver unarchiveObjectWithData:responseObject];
                
                NSArray * dataArr = dict[@"data"];
                
                [weakSelf.headLinedataArray removeAllObjects];
                
                for (NSDictionary * dic in dataArr) {
                    
                    HDHeadLineModel * headlinemodel = [HDHeadLineModel yy_modelWithDictionary:dic];
                    
                    [weakSelf.headLinedataArray addObject:headlinemodel];
                    
                }
                
                [weakSelf.mainTableView reloadData];
                
            };
            
        }else{
            
            [weakSelf.failLoadView hideTheSubViews];
            
            NSString * url = [NSString stringWithFormat:Home_HeadLineCateNews,(long)page,(long)perpage,(long)cateId,self.token,arc4random()%10000];
    
            //1.获取一个全局串行队列
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_async(queue, ^{
                
                STRONG_SELF;
                
                [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
                    
                    NSArray * dataArr = json[@"data"];
                    
                    if (dataArr.count < perpage) {
                        
                        [strongSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
                        
                    }else{
                        
                        [strongSelf endRefresh];
                        
                    }
                    if (1 == page) { // 说明是在重新请求数据.
                        
                        [strongSelf.headLinedataArray removeAllObjects];
                        
                        NSData *jsondata = [NSKeyedArchiver archivedDataWithRootObject:json];
                        
                        [cache setData:jsondata forKey:HasCache];
                    }
                    
                    for (NSDictionary * dic in dataArr) {
                        
                        HDHeadLineModel * headlinemodel = [HDHeadLineModel yy_modelWithDictionary:dic];

                        [strongSelf.headLinedataArray addObject:headlinemodel];
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [strongSelf.mainTableView reloadData];
                        
                    });
                    
                } failure:^(NSError *error) {
                    if([cache hasCacheForKey:HasCache]){
                        
                        NSData * responseObject = [cache dataForKey:HasCache];
                        
                        NSDictionary * dict = [NSKeyedUnarchiver unarchiveObjectWithData:responseObject];
                        
                        NSArray * dataArr = dict[@"data"];
                        
                        [weakSelf.headLinedataArray removeAllObjects];
                        
                        for (NSDictionary * dic in dataArr) {
                            
                            HDHeadLineModel * headlinemodel = [HDHeadLineModel yy_modelWithDictionary:dic];
                            
                            [weakSelf.headLinedataArray addObject:headlinemodel];
                            
                        }
                        
                        [weakSelf.mainTableView reloadData];
                        
                    };
                    
                    [strongSelf endRefresh];
                    //[strongSelf.failLoadView showTheSubViews];

                }];
                
            });
        }
    
    }];
    
}

- (void)requestBannerImage{
    
    EGOCache * cache = [EGOCache globalCache];

    NSString * bannerUrl = [NSString stringWithFormat:Advertisement,1,arc4random()%10000];

    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:bannerUrl params:nil success:^(id json) {
            [self.bannerDataArray removeAllObjects];
             [self.bannerImageArray removeAllObjects];
            NSArray * array = json[@"data"];
            
            for (NSDictionary * dic in array) {
                
                HDAdvertisementModel * adModel = [HDAdvertisementModel yy_modelWithDictionary:dic];
                
                [self.bannerDataArray addObject:adModel];
                
                NSString * str = dic[@"url"];
                [strongSelf.bannerImageArray addObject:str];
            
            }
            
            [cache setObject:self.bannerImageArray forKey:@"Images"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [strongSelf.mainTableView reloadData];
                
            });
            
        } failure:^(NSError *error) {
            
            if([cache hasCacheForKey:HasCache]){
                
                NSArray * dataArr = (NSArray *)[cache objectForKey:@"Images"];;
                
                [self.bannerImageArray removeAllObjects];
                
                [self.bannerImageArray addObjectsFromArray:dataArr];
                
                [self.mainTableView reloadData];
                
            };
            
        }];
        
    });


}

- (void)requestHotNewsData{
    
    NSString * hotNewsUrl = [NSString stringWithFormat:Home_HotNews,arc4random()%10000];
    
    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:hotNewsUrl params:nil success:^(id json) {
            [self.hotNewsArray removeAllObjects];
            NSArray * array = json[@"data"];
            
            for(int i = 0; i < 3; i ++){
            
                NSDictionary * dic = [array objectAtIndexCheck:i];
                
                HDHotNewsModel * adModel = [HDHotNewsModel yy_modelWithDictionary:dic];
                
                [strongSelf.hotNewsArray addObject:adModel];
            
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [strongSelf.mainTableView reloadData];
                
            });
            
        } failure:^(NSError *error) {
            
        }];
        
    });
    
    
}

- (void)requestStockSayingData{
    
    NSString * stockSayingUrl = [NSString stringWithFormat:Home_HeadLineCateNews,1,5,28,self.token,arc4random()%10000];
    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:stockSayingUrl params:nil success:^(id json) {
            
            [self.stockSayingArray removeAllObjects];
            NSArray * dataArr = json[@"data"];
            
            for(int i = 0; i < 3; i ++){
                
                NSDictionary * dic = [dataArr objectAtIndexCheck:i];
                
                HDHeadLineModel * headlinemodel = [HDHeadLineModel yy_modelWithDictionary:dic];
                
                [strongSelf.stockSayingArray addObject:headlinemodel];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [strongSelf.mainTableView reloadData];
                
            });

            
        } failure:^(NSError *error) {
            
        }];
        
    });
    
    
}

- (void)requestCollectedArticles{

    NSString * str = [NSString stringWithFormat:PCMyCollectedURL,(long)1,@"1",arc4random()%10000];
    NSString * str1 = [str stringByAppendingString:@"&token="];
    NSString * CollectedArticlesUrl = [str1 stringByAppendingString:self.token];
    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSMutableDictionary * faDic = [ZHFactory readPlistWithPlistNameReturnMutableDictionary:self.token];
    if (!faDic) {
        
        faDic = [NSMutableDictionary dictionary];
        
    }
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:CollectedArticlesUrl params:nil success:^(id json) {
        
            NSArray * dataArr = [NSArray array];
            if (![json[@"data"] isKindOfClass:[NSNull class]]) {
                dataArr = json[@"data"];

            }
            
            if(dataArr.count != 0){
            for (NSDictionary * dic in dataArr) {
                
                MyCollectedDataModel * headlinemodel = [MyCollectedDataModel yy_modelWithDictionary:dic];
                
                NSString * favaid = dic[@"favid"];
                [faDic setValue:favaid forKey:[NSString stringWithFormat:@"%@",headlinemodel.id]];
                
                [strongSelf plistHuanCunWithDic:faDic];
            }
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isfirst"];
            }
        } failure:^(NSError *error) {

            
        }];
        
    });
    
    NSString * Vstr = [NSString stringWithFormat:PCMyCollectedURL,(long)1,@"2",arc4random()%10000];
    NSString * Vstr1 = [Vstr stringByAppendingString:@"&token="];
    NSString * VCollectedArticlesUrl = [Vstr1 stringByAppendingString:self.token];
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:VCollectedArticlesUrl params:nil success:^(id json) {
            
            NSArray * dataArr = [NSArray array];
            if (![json[@"data"] isKindOfClass:[NSNull class]]) {
                dataArr = json[@"data"];
            }
            
            if(dataArr.count != 0){
                for (NSDictionary * dic in dataArr) {
                    
                    MyCollectedDataModel * headlinemodel = [MyCollectedDataModel yy_modelWithDictionary:dic];
                    
                    NSString * favaid = dic[@"favid"];
                    [faDic setValue:favaid forKey:[NSString stringWithFormat:@"%@",headlinemodel.id]];
                    
                    [strongSelf plistHuanCunWithDic:faDic];
                }
                
            }
        } failure:^(NSError *error) {
            
        }];
        
    });
    
    NSString * Pstr = [NSString new];
    
    if ([self.token isEqualToString:@"1"]) {
        
        Pstr = [NSString stringWithFormat:PrasiedList,@"",arc4random()%10000];
    }else{
    
        Pstr = [NSString stringWithFormat:PrasiedList,self.token,arc4random()%10000];
    
    }
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:Pstr params:nil success:^(id json) {
            
            NSArray * dataArr = [NSArray array];
            if (![json[@"data"] isKindOfClass:[NSNull class]]) {
                dataArr = json[@"data"];
            }
            
            if(dataArr.count != 0){
                for (NSDictionary * dic in dataArr) {
                    
                    NSString * aid = dic[@"id"];
                    
                    [faDic setValue:@"isclicked" forKey:[NSString stringWithFormat:@"isClicked%ld",(long)aid.integerValue]];
                    
                    [strongSelf plistHuanCunWithDic:faDic];
                }
                
            }
        } failure:^(NSError *error) {
            
        }];
        
    });
}

- (void)loadDataOfMessageCenter{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@/type/0",@"http://gkc.cdtzb.com/api/message/count_by_type/token/",self.token];
        [[CDAFNetWork sharedMyManager]get:urlStr params:nil success:^(id json) {
            
            if([json[@"code"] isEqual:@(1)]){
                
                NSArray * array = json[@"data"];
                
                NSDictionary * dic = [array lastObject];
                    
                    NSNumber * num = dic[@"num"];
                    
                    if (![num isEqual:@(0)]) {
                        
                        [self showMessageDot];
                        
                    }else{
                    
                        [self.messageCenter clearBadge];
                    
                    }

            }else{
                NSLog(@"获取失败");
            }
        } failure:^(NSError *error) {

        }];
    });
    
}

- (void)loadDataOfProductList{

    [self.productArray removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",@"http://gkc.cdtzb.com/api/order/productlist/",self.token];
    
    NSArray * arr = [[LYCUserManager informationDefaultUser].defaultUser objectForKey:alreadyBuiedKey];
    
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:arr];
    
    [[CDAFNetWork sharedMyManager]get:urlStr params:nil success:^(id json) {
        
        if([json[@"code"] isEqual:@(1)]){

            NSArray * array = json[@"data"];
            for (int i = 0; i < array.count; i ++) {
                
                NSDictionary *dic = array[i];
                NSString * stateStr = [NSString stringWithFormat:@"%@",dic[@"status"]];
                if ([stateStr isEqualToString:@"1"]) {
                    
                    if(![mutArr containsObject:@(i+1).stringValue]){
                        [mutArr addObject:[NSString stringWithFormat:@"%d",i+1]];
                    }
                    if(![self.productArray containsObject:@(i+1).stringValue]){
                        [self.productArray addObject:[NSString stringWithFormat:@"%d",i+1]];
                    }
                }
            
            }
            [[LYCUserManager informationDefaultUser].defaultUser setObject:mutArr forKey:alreadyBuiedKey];
        }else{
            NSLog(@"获取失败");
        }
    
    } failure:^(NSError *error) {
    }];
}

- (void)checkTheVertionOfAPP{

    NSString * str = @"http://gk.cdtzb.com/api/versions";
    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:str params:nil success:^(id json) {
            
            NSDictionary * data = [NSDictionary dictionary];
            if (![json[@"data"] isKindOfClass:[NSNull class]]) {
                
                data = json[@"data"];
                
                NSString * vertion = data[@"versions"];
                
                if (vertion) {
                    
                    [strongSelf alertVertionUp];
                    
                }
                
            }
            
    
        } failure:^(NSError *error) {
            
            
        }];
        
    });

}

#pragma mark ------------------- 刷新进度条显示
//停止刷新
-(void)endRefresh{
    
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------------- 左视图逻辑

#if 1
- (IBAction)personalCenterButtonOntouched:(UIButton *)sender {
    
    AppDelegate *tempDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (tempDelegate.leftSideVc.sideClosed) {
        [tempDelegate.leftSideVc openLeftView];
    }else {
        [tempDelegate.leftSideVc closeLeftView];
    }
}


- (IBAction)searchItemOntouched:(UIButton *)sender {
    
    NSString * classStr = NSStringFromClass([PCMessageCenterViewController class]);
    id targetVC = [[NSClassFromString(classStr) alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:targetVC];
    [self presentViewController:nav animated:YES completion:^{
        
        
    }];
    
    [self.messageCenter clearBadge];
    
}

#endif

#pragma mark ------------------- socket
- (void) connectSocket {

    [self cutOffSocket];

    [self socketConnectHost];
    
}
//断开
- (void) cutOffSocket {
    [self.thySocket disconnect];
}
//连接
-(void)socketConnectHost{
    
    if (!self.thySocket) {
        self.thySocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    NSError *error = nil;
    BOOL boo = [self.thySocket connectToHost:SOCKET_IP onPort:SOCKET_PORT withTimeout:-1 error:&error];
    NSLog(@"boolResult -- %d",boo);
    
    if(error) {
        NSLog(@"连接错误%@", error);
        return;
    }else{
        NSLog(@"成功");
    }
}
// 心跳
-(void)longConnectToSocket {
    
    NSDictionary *dicd = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    
    //NSLog(@"登录信息%@",dicd);
    //NSString *longConnect = @"aaa";
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"login" forKey:@"type"];
    [dict setValue:dicd[PCUserName] forKey:@"client_name"];
    [dict setValue:dicd[PCUserUid] forKey:@"uid"];
    NSData   *dataStream  = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    //NSData   *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.thySocket writeData:dataStream withTimeout:-1 tag:1];
    
}

#pragma mark ------------------- GCDAsynSocket Delegate
- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(uint16_t)port{
    
    [self.thySocket readDataWithTimeout:-1 tag:0];

    // 每隔30s像服务器发送心跳包
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];// 在longConnectToSocket方法中进行长连接需要向服务器发送的讯息
    
    [self.connectTimer fire];
    //[self longConnectToSocket];
    
}

- (void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag{
    
    NSDictionary * tempDic = [self handleSocketWithData:data];//处理socket数据
//    NSLog(@"%@",tempDic);
    if ([[tempDic allKeys] count] >= 1) {
        
        [self sendSocketData:tempDic];
    }
    
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:10];
//    notification.timeZone=[NSTimeZone defaultTimeZone];
//    NSLog(@"")
//    notification.applicationIconBadgeNumber +=1 ; //设置右上角小圆圈数字为1
//    notification.soundName= UILocalNotificationDefaultSoundName;
//    notification.alertBody = @"推送测试";
//    [[UIApplication sharedApplication]  scheduleLocalNotification:notification];
    
    [self.thySocket readDataWithTimeout:-1 tag:0];
}

- (void) sendSocketData:(NSDictionary *) dic {

    NSDictionary *dict = [NSDictionary dictionaryWithObject:dic forKey:@"socketQuotation"];
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:QUOTATION_NOTE object:nil userInfo:dict];
        
}

- (NSDictionary *) handleSocketWithData:(NSData *) data{
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    return json;
}

- (void) socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"socketDidDisconnect：Socket连接断开的时候调用，无论此时是正常断开还是异常断开。正常断开err为空。err:%@",err);
    
    NSTimer * _timer;
        
    [_timer invalidate];
        
    _timer=nil;
    
    _timer= [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(connectSocket) userInfo:nil repeats:NO];
    
        NSLog(@"socket did reconnection,after 30s try again");
    
}

#pragma mark ------------------- 收到消息
- (void)showMessageDot{
    
    self.messageCenter.badgeCenterOffset = CGPointMake(-3, 3);
    self.messageCenter.badgeBgColor = [UIColor colorWithHexString:@"#f0a358"];
    [self.messageCenter showBadge];
    
}

#pragma mark ------------------- 滚动视图代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint contentOffSet = scrollView.contentOffset;
    if (contentOffSet.y > SCREEN_HEIGHT ) {
        
        [self.backToTopButton setHidden:NO];

        }else{
        
            [self.backToTopButton setHidden:YES];
        
        }

}

#pragma mark ------------------- plist缓存
- (void) plistHuanCunWithDic:(NSDictionary *) dic {
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:self.token];
    [dic writeToFile:plistPath atomically:YES];
}

#pragma mark ------------------- 版本更新提示
- (void)alertVertionUp{

    self.alertShowView = [[HDVertionCheckAlertShowView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.alertShowView.delegate = self;
    
    [self.alertShowView showAlertView];

}

- (void)upDateTheVertion:(UIButton *)button{

    if (button.tag == 1110) {
        
        [self.alertShowView dismissAlertView];
        
    }else{
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/shou-ji-bai-du-bai-du-yi-xia/id382201985?mt=8"]];
    }

}

#pragma mark -- 懒加载
- (NSMutableArray *)headLinedataArray{
    
    if (!_headLinedataArray) {
        
        _headLinedataArray = [[NSMutableArray alloc]init];
    }
    
    return _headLinedataArray;
    
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

- (NSMutableArray *)hotNewsArray{
    
    if (!_hotNewsArray) {
        _hotNewsArray = [[NSMutableArray alloc]init];
    }
    
    return _hotNewsArray;
    
}

- (NSMutableArray *)stockSayingArray{
    
    if (!_stockSayingArray) {
        _stockSayingArray = [[NSMutableArray alloc]init];
    }
    return _stockSayingArray;
    
}

- (NSMutableArray *)productArray{

    if (!_productArray) {
        
        _productArray = [[NSMutableArray alloc]init];
    }

    return _productArray;

}

#pragma mark - UITabBarControllerDelegate刷新当前页面
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    HDStockBaseNavigationController *nc = (HDStockBaseNavigationController *)viewController;
    NSDate *date = [NSDate date];
    if ([self isEqual:nc.topViewController]) {
        //处理双击事件
        if (date.timeIntervalSince1970 - _lastDate.timeIntervalSince1970 < 0.5) {
            _lastDate = [NSDate dateWithTimeIntervalSince1970:0];
            [self refreshCurrentPage];
            return NO;
        }
        _lastDate = date;
    }
    return YES;
}

- (void)refreshCurrentPage{

    PSYRefreshGifHeader * header = (PSYRefreshGifHeader *)self.mainTableView.mj_header;

    [header beginRefreshing];

}


@end
