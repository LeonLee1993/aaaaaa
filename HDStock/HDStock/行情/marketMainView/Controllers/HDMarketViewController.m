//
//  HDMarketViewController.m
//  HDStock
//
//  Created HD liyancheng on 16/11/22.
//  Copyright © 2016年 hd-app02. All rights reserved.
//
#import "AppDelegate.h"
#import "HDLeftPersonalViewController.h"
#import "HDMarketViewController.h"
#import "HDSearchCenterViewController.h"
#import "HDMarketSearchTF.h"
#import "HDMarketMainTableViewCell.h"
#import "HDMarketDetailViewController.h"
#import "marketListModel.h"
#import "marketAddSelectedCell.h"
#import "NoCollectedTableViewCell.h"
#import "MyCollectedStockModel.h"
#import "randomStockModel.h"
#define isFirsrLoad @"isFirsrLoad"
#define firstLoadFlag [[[LYCUserManager informationDefaultUser].defaultUser objectForKey:isFirsrLoad] isEqualToString:@"no"]
@interface HDMarketViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) MBProgressHUD *huded;
@property (nonatomic,strong) NSMutableArray *touchPoints;

@end

@implementation HDMarketViewController{
    BOOL hasSelectedStock;
    //添加自选股按钮
    UIButton * addButton;
    NSMutableArray *dataArr;
    NSMutableArray *collectedArr;
    BOOL canEdit;
    UIView *topView;
    NSMutableArray * codeArr;
    NSMutableArray * ContainCodeArr;
    NSMutableArray * myCollectedArr;
    NSMutableArray *randomStockArr;
}


-(NSMutableArray *)touchPoints{
    if(!_touchPoints){
        _touchPoints = @[].mutableCopy;
    }
    return _touchPoints;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setOriginData];
    
    //设置添加自选股按钮
    [self setTopView];
    [self setTableView];
    [self setLongPressDrag];
    self.view.backgroundColor = PCBackColor;
    canEdit = YES;
    
    if(!collectedArr){
        collectedArr = @[].mutableCopy;
    }
    
    if(!codeArr){
        codeArr = @[].mutableCopy;
    }
    
    if(!ContainCodeArr){
        ContainCodeArr = @[].mutableCopy;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([[LYCUserManager informationDefaultUser].defaultUser objectForKey:MarketSearchDataKey]){
        NSArray *tempArr =  [[LYCUserManager informationDefaultUser].defaultUser objectForKey:MarketSearchDataKey];
        collectedArr = [NSMutableArray arrayWithArray:tempArr];
    }
    
    if(collectedArr.count>0){
        self.tableView1.frame = CGRectMake(0, 42, SCREEN_WIDTH, SCREEN_HEIGHT-64-42-49);
        WEAK_SELF;
        self.tableView1.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf loadDataOfProductList];
        }];
        [self.tableView1 reloadData];
        [self.tableView1.mj_header beginRefreshing];
    }else{
        self.tableView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
        self.tableView1.mj_header = nil;
        [self loadRandomStock];
    }
    
    //设置导航条
    [self setNavigation];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    HDLeftPersonalViewController *vc = (HDLeftPersonalViewController*)app.window.rootViewController;
    vc.panGes.enabled = NO;
    
}

- (void)loadRandomStock{
    
    if(!randomStockArr){
        randomStockArr = @[].mutableCopy;
    }
    [randomStockArr removeAllObjects];
    
    [[CDAFNetWork sharedMyManager]post:@"http://gk.cdtzb.com/api/product/randomStock" params:nil success:^(id json) {
        if([json[@"code"] isEqual:@(1)]){
            for (id obj  in json[@"data"]) {
                randomStockModel *model = [randomStockModel yy_modelWithDictionary:obj];
                [randomStockArr addObject:model];
            }
            [self.tableView1 reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setTopView{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
    [self.view addSubview:topView];
    topView.backgroundColor = RGBCOLOR(243, 243, 243);
    NSArray *titleArr = @[@"股票名称",@"最新价",@"涨跌幅"];
    for (int i=0; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 42)];
        [topView addSubview:view];
        UILabel * label = [[UILabel alloc]init];
        label.text = titleArr[i];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = RGBCOLOR(51, 51, 51);
        [label sizeToFit];
        label.tag = 200+i;
        label.center = view.center;
        [topView addSubview:label];
    }
}

- (void)setOriginData{
    hasSelectedStock = NO;//初始化为NO 没有自选股
}


- (void)jumpToSearchView{
    HDSearchCenterViewController * vc = [[HDSearchCenterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setNavigation{
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:MAIN_COLOR]forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_FONT*WIDTH],NSForegroundColorAttributeName:NAV_TITLE_COLOR};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.title = @"行情";
}

- (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//搜索按钮点击时
- (IBAction)searchButtonClicked:(id)sender {
    
    [self jumpToSearchView];
    
}

- (void)setTableView{
    if(!dataArr){
        dataArr = @[].mutableCopy;
    }
    if(!_tableView1){
        _tableView1 = [[UITableView alloc]init];
    }
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.backgroundColor = BACKGROUNDCOKOR;
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"HDMarketMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDMarketMainTableViewCell"];
    [self.tableView1 registerNib:[UINib nibWithNibName:@"marketAddSelectedCell" bundle:nil] forCellReuseIdentifier:@"marketAddSelectedCell"];
    [self.tableView1 registerNib:[UINib nibWithNibName:@"NoCollectedTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoCollectedTableViewCell"];
    
    [self.view addSubview:_tableView1];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(collectedArr.count>0){
        if(section ==0){
            return dataArr.count;
        }else{
            return 1;
        }
    }else{//在没有自选股的时候
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(collectedArr.count>0){
    
        if(indexPath.section==0){
            HDMarketMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDMarketMainTableViewCell"];
            if(dataArr.count>0){
                cell.model = dataArr[indexPath.row];
//                cell.raiseRange.hidden = canEdit;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }else{
            marketAddSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"marketAddSelectedCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.block = ^{
                [self jumpToSearchView];
            };
            return cell;
        }
        
    }else{//没有自选股的时候
        
        NoCollectedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoCollectedTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(randomStockArr.count>0){
            cell.randomStockArr = randomStockArr;
        }
        cell.block = ^(UIButton *sender){
            switch (sender.tag) {
                case 301:
                {
                    [self jumpToSearchView];
                }
                    break;
                case 302:
                {
                    [self refreshRecommend];//刷新推荐
                }
                    break;
                case 303:
                {
                    [self addToCollectedAndRefresh:sender];//添加推荐 刷新ui
                }
                    break;
                    
                default:
                    break;
            }
        };
        return cell;
        
    }
}


#pragma mark -----  刷新推荐
- (void)refreshRecommend{
    [self loadRandomStock];
}

#pragma mark ---- 添加那六个推荐到关注里面
- (void)addToCollectedAndRefresh:(UIButton *)sender{
    [self addToMyCollect:sender];
}

-(void)addToMyCollect:(UIButton *)sender{
    
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *dic = [LYCUserManager informationDefaultUser].getUserInfoDic;
    NSMutableString * mutStr;
    NSMutableArray *temArr= @[].mutableCopy;
    [temArr removeAllObjects];
    if(randomStockArr.count>0){
        [temArr addObjectsFromArray:randomStockArr];
        randomStockModel *firstmodel = randomStockArr[0];
        mutStr = [NSMutableString stringWithFormat:@"%@",firstmodel.symbol];
        [randomStockArr removeFirstObject];
        for (randomStockModel *model in randomStockArr) {
            [mutStr appendString:[NSString stringWithFormat:@",%@",model.symbol]];
        }
    }
    [mutDic setObject:mutStr forKey:@"symbol"];
    [mutDic setObject:(dic==nil)?@"":dic[PCUserToken] forKey:@"token"];
    [mutDic setObject:@"9135A5B6-6E45-46EE-B495-694D4E828AA7" forKey:@"device_number"];
    WEAK_SELF;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [[CDAFNetWork sharedMyManager] post:@"http://gk.cdtzb.com/api/product/addStock" params:mutDic success:^(id json) {
        if([json[@"code"] isEqual:@(1)]){
            [hud setHidden:YES];
            sender.selected = NO;
            NSMutableArray * mutArr = [NSMutableArray arrayWithArray:[[LYCUserManager informationDefaultUser].defaultUser objectForKey:MarketSearchDataKey]];
            for (randomStockModel *model in temArr) {
                [mutArr addObject:model.symbol];
            }
            WEAK_SELF;
            self.tableView1.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
                [weakSelf loadDataOfProductList];
            }];
            [[LYCUserManager informationDefaultUser].defaultUser setObject:mutArr forKey:MarketSearchDataKey];
            NSArray *tempArr =  [[LYCUserManager informationDefaultUser].defaultUser objectForKey:MarketSearchDataKey];
            collectedArr = [NSMutableArray arrayWithArray:tempArr];
            [self loadDataOfProductList];
            [self setNavigation];
        }else{
            [hud setHidden:YES];
            sender.selected = NO;
        }
    } failure:^(NSError *error) {
        [hud setHidden:YES];
        sender.selected = NO;
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(collectedArr.count>0){
        return 60*SCREEN_WIDTH/375;
    }else{
        return self.tableView1.bounds.size.height;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(collectedArr.count>0){
        return 2;
    }else{//没有自选股的时候
        return 1;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectedArr.count>0){
        
            if(dataArr.count>0){
                marketListModel *model =dataArr[indexPath.row];
                HDMarketDetailViewController *detail = [[HDMarketDetailViewController alloc]init];
                detail.codeStr = model.Symbol;
                detail.title = model.Name;
                [self.navigationController pushViewController:detail animated:YES];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"请等待数据加载完成后点击";
                [hud hideAnimated:YES afterDelay: 1];
            }
        
    }else{//在没有自选股的时候
        
    }
}


- (void)loadAttentionList{
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *dic = [LYCUserManager informationDefaultUser].getUserInfoDic;
    [mutDic setObject:(dic==nil)?@"":dic[PCUserToken] forKey:@"token"];
    [mutDic setObject:@"9135A5B6-6E45-46EE-B495-694D4E828AA7" forKey:@"device_number"];
    NSString *urlStr = @"http://gk.cdtzb.com/api/product/followStock";
    if(!myCollectedArr){
        myCollectedArr = @[].mutableCopy;
    }
    [myCollectedArr removeAllObjects];
    
    [[CDAFNetWork sharedMyManager] post:urlStr params:mutDic success:^(id json) {
        if([json[@"code"] isEqual:@(1)]){
            for (id obj in json[@"data"]) {
                MyCollectedStockModel *model = [MyCollectedStockModel yy_modelWithDictionary:obj];
                [myCollectedArr addObject:model];
                [self loadDataOfProductList];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadDataOfProductList{
    
    NSMutableString * url=[NSMutableString stringWithFormat:@"%@",@"http://gk.cdtzb.com/api/product/followStock"];
    [codeArr removeAllObjects];
    [dataArr removeAllObjects];
    if(collectedArr.count>0){
        for (NSString *str in collectedArr) {
            [codeArr addObject:str];
        }
    }
    
    NSMutableString * mutStr;
    if(codeArr.count>0){
        mutStr = [NSMutableString stringWithFormat:@"%@",codeArr[0]];
        [codeArr removeFirstObject];
        for (NSString *str in codeArr) {
            [mutStr appendString:[NSString stringWithFormat:@",%@",str]];
        }
    }
    
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *dic = [LYCUserManager informationDefaultUser].getUserInfoDic;
    [mutDic setObject:(dic==nil)?@"":dic[PCUserToken] forKey:@"token"];
    [mutDic setObject:@"9135A5B6-6E45-46EE-B495-694D4E828AA7" forKey:@"device_number"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[CDAFNetWork sharedMyManager]post:url params:mutDic success:^(id json) {
            if([json[@"code"] isEqual:@(1)]){
                
                for (NSDictionary *dic in json[@"data"]) {
                    marketListModel * model = [marketListModel yy_modelWithDictionary:dic];
                    if([collectedArr containsObject:model.Symbol]){
                        [dataArr addObject:model];
                    }
                }
                for (NSInteger i = collectedArr.count-1; i>=0; i--) {
                    NSString *str = collectedArr[i];
                    for (marketListModel *model in dataArr) {
                        if([model.Symbol isEqualToString:str]){
                            marketListModel *modeled = model;
                            [dataArr removeObject:model];
                            [dataArr insertObject:modeled atIndex:0];
                            break;
                        }
                    }
                }
                self.tableView1.frame = CGRectMake(0, 42, SCREEN_WIDTH, SCREEN_HEIGHT-64-42-49);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView1 reloadData];
                });
                [self endRefresh];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"请求数据失败";
                [hud hideAnimated:YES afterDelay:1];
                [self endRefresh];
            }
        }
         failure:^(NSError *error) {
//            [self endRefresh];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.label.text = @"加载错误";
//            [hud hideAnimated:YES afterDelay:2];
             [self loadDataOfProductList];
        }];
    });
}

-(void)endRefresh{
    [self.tableView1.mj_header endRefreshing];
    [self.tableView1.mj_footer endRefreshing];
}

-  (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
// 
//    if (sourceIndexPath.row == destinationIndexPath.row) return;
//    marketListModel *model = [dataArr objectAtIndex:sourceIndexPath.row];
//    marketListModel *destinationModel = [dataArr objectAtIndex:destinationIndexPath.row];
//    [dataArr removeObjectAtIndex:sourceIndexPath.row];
//    [dataArr insertObject:model atIndex:destinationIndexPath.row];
//    NSInteger collectedArrRow = [collectedArr indexOfObject:model.Symbol];
//    NSInteger destinationIndexPathRow = [collectedArr indexOfObject:destinationModel.Symbol];
//    NSString *str = [collectedArr objectAtIndex:collectedArrRow];
//    [collectedArr removeObjectAtIndex:collectedArrRow];
//    [collectedArr insertObject:str atIndex:destinationIndexPathRow];
//    [[LYCUserManager informationDefaultUser].defaultUser setObject:collectedArr forKey:MarketSearchDataKey];
//    
//}

#pragma mark --- 删除收藏
-(void)delectFromMyCollect:(NSString *)symbolStr andTableView:(UITableView *)tableView andindex:(NSIndexPath *)indexPath{
    [self.huded setHidden:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    self.huded = hud;
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [mutDic setObject:symbolStr forKey:@"symbol"];
    [mutDic setObject:@"9135A5B6-6E45-46EE-B495-694D4E828AA7" forKey:@"device_number"];
    [[CDAFNetWork sharedMyManager] post:@"http://gk.cdtzb.com/api/product/removeStock" params:mutDic success:^(id json) {
        if([json[@"code"] isEqual:@(1)]){

            [hud setHidden:YES];
            [dataArr removeObjectAtIndex:[indexPath row]];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            [collectedArr removeObject:symbolStr];
            [[LYCUserManager informationDefaultUser].defaultUser setObject:collectedArr forKey:MarketSearchDataKey];
            
            if(collectedArr.count ==0){
                [self viewWillAppear:YES];
                [self.tableView1 reloadData];
                [_tableView1 setEditing:NO animated:YES];
                _tableView1.mj_header = nil;
                canEdit = NO;
                self.tableView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
            }
        }else{
            NSLog(@"删除失败");
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSUInteger row = [indexPath row];
        marketListModel *model = dataArr[row];
        [self delectFromMyCollect:model.Symbol andTableView:tableView andindex:indexPath];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    HDLeftPersonalViewController *vc = (HDLeftPersonalViewController*)app.window.rootViewController;
    vc.panGes.enabled = YES;
    [self endRefresh];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)longPressGestureRecognized:(id)sender {
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self.tableView1];
    NSIndexPath *indexPath = [self.tableView1 indexPathForRowAtPoint:location];
    static UIView       *snapshot = nil;
    static NSIndexPath  *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [self.tableView1 cellForRowAtIndexPath:indexPath];
                snapshot = [self customSnapshoFromView:cell];
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView1 addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
            }
            break;
        }
            // 移动过程中
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            NSLog(@"%@", NSStringFromCGRect(snapshot.frame));
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                [dataArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [self.tableView1 moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                marketListModel *model = [dataArr objectAtIndex:sourceIndexPath.row];
                marketListModel *destinationModel = [dataArr objectAtIndex:indexPath.row];
                NSInteger collectedArrRow = [collectedArr indexOfObject:model.Symbol];
                NSInteger destinationIndexPathRow = [collectedArr indexOfObject:destinationModel.Symbol];
                NSString *str = [collectedArr objectAtIndex:collectedArrRow];
                [collectedArr removeObjectAtIndex:collectedArrRow];
                [collectedArr insertObject:str atIndex:destinationIndexPathRow];
                [[LYCUserManager informationDefaultUser].defaultUser setObject:collectedArr forKey:MarketSearchDataKey];
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            UITableViewCell *cell = [self.tableView1 cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
    
}

- (void)setLongPressDrag
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView1 addGestureRecognizer:longPress];
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}





@end
