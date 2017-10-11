//
//  TendentMainViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/8/7.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TendentMainViewController.h"
#import "TendentMainTopView.h"
#import "TendentTableViewCell.h"
#import "TendentCategoryModel.h"
#import "TendentCityModel.h"
#import "TendentListViewController.h"
#import "TendentStateView.h"
#import "TendentPopMenuView.h"
#import "TendentListViewModel.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "RetailersModel.h"
#import "TendentSearchViewController.h"
#import "TendentMessageViewController.h"
#import "AppDelegate.h"

#define pushNewsTableViewHeaderViewHeight ScreenWidth/375*238.5+11.5

@interface TendentMainViewController ()<UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet TendentStateView *cityView;
@property (weak, nonatomic) IBOutlet UIView *goBackView;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (nonatomic,strong) TendentListViewModel * requestViewModel;

@end

@implementation TendentMainViewController{
    NSMutableArray * tendentCategoryArr;
    NSMutableArray * tendentCityArr;
    TendentPopMenuView * pop;
    NSInteger currentPage;
    NSInteger pageSize;
    CLLocationCoordinate2D nowCoordinate;
    NSMutableArray * dataArr;
    LYCStateViews * hud;
}

-(TendentListViewModel *)requestViewModel{
    if (_requestViewModel == nil) {
        _requestViewModel = [[TendentListViewModel alloc] init];
    }
    return _requestViewModel;
    
}

- (void)viewDidLoad {
    currentPage = 0;
    pageSize = 20;
    [super viewDidLoad];
    //请求商户分类信息
    
    self.view.backgroundColor = MainBackViewColor;
    self.mainTableView.backgroundColor = MainBackViewColor;
    tendentCategoryArr = @[].mutableCopy;
    tendentCityArr = @[].mutableCopy;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showThePopView:)];
    self.cityView.isMainView = YES;
    self.cityView.stateViewString = [[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCity];
    [self.cityView addGestureRecognizer:tap];
#pragma mark - 弹出视图逻辑
    
    pop = [[TendentPopMenuView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) menuStartPoint:CGPointMake(0, 0) menuItems:nil selectedAction:^(NSInteger index) {
    }];
    
    __weak typeof(self)weakself = self;
    pop.dissappearBlock = ^{
        weakself.cityView.isOn = NO;
        currentPage = 0;
        [weakself getTendentList];
    };
    
    __weak typeof (self)weakSelf = self;
    pop.selectedItemBlock = ^(NSString * stringValue,NSString *cityID) {
        weakSelf.cityView.stateViewString = stringValue;
        [[NSUserDefaults standardUserDefaults] setObject:stringValue forKey:TendentListDefaultCity];
        [[NSUserDefaults standardUserDefaults] setObject:cityID forKey:TendentListDefaultCityID];
    };
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBack)];
    [self.goBackView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction)];
    [self.searchView addGestureRecognizer:tap2];
    
    dataArr = @[].mutableCopy;
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(dataArr.count==0){
        [self networkAction];
    }
    if(dataArr.count>0){
        [self judgeTheTitleOfViews];
    }
}

- (void)networkAction{
    
    if(whetherHaveNetwork){
//        __weak typeof(self) weakSelf = self;
        
            [self requestInfomation];
            [self getTendentList];
        
    }else{
        [self endRefresh];
        __weak typeof(self) weakSelf = self;
        [self.poorNetWorkView show];
        self.poorNetWorkView.reloadBlock = ^{
            [weakSelf networkAction];
        };
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [pop removeFromSuperview];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud LYCHidStateView];
        });
    
    self.cityView.isOn = NO;
}



- (void)getMoreTendentList{
    if(currentPage==0){
        [dataArr removeAllObjects];
    }
    currentPage+=1;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:@"0" forKey:@"key"];//搜索词
    [mutDic setObject:@"0" forKey:@"categoryname"];//商户分类名称(默认0)
    [mutDic setObject:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"pageindex"];//第几页
    [mutDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"pagesize"];//每页大小
    [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.longitude] forKey:@"lng"];//当前经
    [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.latitude] forKey:@"lat"];//当前纬度
    [mutDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCityID]?[[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCityID]:@"650000" forKey:@"city"];//当前纬度
    [mutDic setObject:@"2" forKey:@"version"];
    [mutDic setObject:@"0" forKey:@"ismap"];//0.列表 1.地图
    NSMutableDictionary * senderDic = @{}.mutableCopy;
    [senderDic setObject:mutDic forKey:@"SenderInfoKey"];
    // 发送请求
    __weak typeof (self) weakSelf = self;
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Getretailers];
    [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        
        if([json[@"code"] isEqual:@(100)]){
            
            for (NSDictionary *dic in json[@"data"][@"retailers"]) {
                RetailersModel * model = [RetailersModel yy_modelWithDictionary:dic];
                [dataArr addObject:model];
            }
            
            if(tendentCityArr.count>0){
                [weakSelf setTableView];
                [weakSelf judgeTheTitleOfViews];
                [weakSelf.mainTableView reloadData];
            }
            
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
        
        if(((NSArray *)json[@"data"][@"retailers"]).count<20){
            
            [weakSelf endRefreshWithNoMoreData];
            
        }else{
        
            [weakSelf endRefresh];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [weakSelf endRefresh];
        [weakSelf getTendentList];
    } andProgressView:nil progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:nil];
}


- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: TendentListDefaultCity];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: TendentListDefaultCityID];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud LYCHidStateView];
    });
    
    [[LYCLocationSigleton LYCLocationManager] startLocation];
}

- (void)searchAction{
    TendentSearchViewController * tendentSearch = [[TendentSearchViewController alloc]init];
    [self.navigationController pushViewController:tendentSearch animated:YES];
}

- (void)showThePopView:(UITapGestureRecognizer *)sender{
    
    TendentStateView *stateView = (TendentStateView *)sender.view;
 
    if(stateView.isOn){
        [pop menuHide];
    }else{
        [pop removeFromSuperview];
        pop.itemsArr = tendentCityArr;
//        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
//        [window addSubview:pop];
        [self.view addSubview:pop];
        [pop showThePopMenu];
    }
    stateView.isOn = !stateView.isOn;
}


#pragma mark - 请求上面的类别
- (void)requestInfomation{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
        [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
        NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
        NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Getretailercategory];
        __weak typeof (self) weakSelf = self;
        [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
            if([json[@"code"] isEqual:@(100)]){
                [tendentCategoryArr removeAllObjects];
                
                for (NSDictionary *dic in json[@"data"][@"retailerCategorys"]) {
                    TendentCategoryModel * model = [TendentCategoryModel yy_modelWithDictionary:dic];
                    [tendentCategoryArr addObject:model];
                }
                
                [tendentCityArr removeAllObjects];
                for (NSDictionary *dic in json[@"data"][@"citys"]) {
                    TendentCityModel * model = [TendentCityModel yy_modelWithDictionary:dic];
                    [tendentCityArr addObject:model];
                }

            }else{
                [MBProgressHUD showWithText:json[@"msg"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        } andProgressView:nil progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:weakSelf];
    });
}


- (void)getTendentList{
    
    
     dispatch_async(dispatch_get_main_queue(), ^{
        hud = [LYCStateViews LYCshowStateViewTo:self.view withState:LYCStateViewFail andTest:@"加载中"];
     });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [hud LYCHidStateView];
        if(currentPage==0){
            [dataArr removeAllObjects];
        }
        currentPage+=1;
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
        [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
        [mutDic setObject:@"0" forKey:@"key"];//搜索词
        [mutDic setObject:@"0" forKey:@"categoryname"];//商户分类名称(默认0)
        [mutDic setObject:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"pageindex"];//第几页
        [mutDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"pagesize"];//每页大小
        [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.longitude] forKey:@"lng"];//当前经
        [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.latitude] forKey:@"lat"];//当前纬度
        [mutDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCityID]?[[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCityID]:@"650100" forKey:@"city"];//当前纬度
        [mutDic setObject:@"2" forKey:@"version"];
        [mutDic setObject:@"0" forKey:@"ismap"];//0.列表 1.地图
        NSMutableDictionary * senderDic = @{}.mutableCopy;
        [senderDic setObject:mutDic forKey:@"SenderInfoKey"];
        // 发送请求
        __weak typeof (self) weakSelf = self;
        NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
        NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Getretailers];
//        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        
        self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
            
            if([json[@"code"] isEqual:@(100)]){
                for (NSDictionary *dic in json[@"data"][@"retailers"]) {
                    RetailersModel * model = [RetailersModel yy_modelWithDictionary:dic];
                    [dataArr addObject:model];
                }
                
                //取得头部筛选列表数据之后设置头部视图的筛选分类
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(dataArr.count>0){
                        [weakSelf setTableView];
                        [weakSelf judgeTheTitleOfViews];
                        [weakSelf.mainTableView reloadData];
                    }else if (dataArr.count==0){
                        [weakSelf setTableView];
                        [weakSelf judgeTheTitleOfViews];
                        [weakSelf.mainTableView reloadData];
                        [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                });

            }else{
                [MBProgressHUD showWithText:json[@"msg"]];
            }
            [weakSelf endRefresh];
            [hud LYCHidStateView];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [weakSelf endRefresh];
            [weakSelf getTendentList];
            [hud LYCHidStateView];
        } andProgressView:nil progressViewText:@"加载中" progressViewType:LYCStateViewLoad ViewController:nil];
    });

}

- (void)setTableView{
    __weak typeof (self) weakSelf = self;
    TendentMainTopView *tendentMian = [TendentMainTopView viewFromXib];
    tendentMian.TendentCategoryArr = tendentCategoryArr;
#pragma mark - topViewLogical
    tendentMian.TendentTopViewClickBlock = ^(NSString * categoryStr) {
        TendentListViewController *list = [[TendentListViewController alloc]init];
        list.listViewCategoryArr = tendentCategoryArr;
        list.listViewCityArr = tendentCityArr;
        list.categoryStr = categoryStr;
        [[NSUserDefaults standardUserDefaults] setObject:categoryStr forKey:TendentListDefault];
        [weakSelf.navigationController pushViewController:list animated:YES];
    };
    tendentMian.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth/375*238.5+11.5);
    
    self.mainTableView.tableHeaderView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth/375*238.5+11.5);
    self.mainTableView.tableHeaderView = tendentMian;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreTendentList];
    }];
    
}

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
        [_mainTableView registerNib:[UINib nibWithNibName:@"TendentTableViewCell" bundle:nil] forCellReuseIdentifier:@"TendentTableViewCelled"];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TendentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TendentTableViewCelled"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = dataArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenWidth*128/375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MobClick event:@"retailerDetail"];
    TendentMessageViewController * message = [[TendentMessageViewController alloc]init];
    message.langStr = [NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.longitude];
    message.lantitudeStr = [NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.latitude];
    message.model = dataArr[indexPath.row];
    [self.navigationController pushViewController:message animated:YES];
}

#pragma mark - 进入页面的时候判断两边title的标题
- (void)judgeTheTitleOfViews{
    
    NSString * defaultListStr = [[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCity];
    
    if(defaultListStr){
        
        self.cityView.stateViewString = defaultListStr;
        
    }else{
     //   城市
        TendentCityModel * CityModel = tendentCityArr[0];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",CityModel.id] forKey:TendentListDefaultCityID];
        [[NSUserDefaults standardUserDefaults] setObject:CityModel.name forKey:TendentListDefaultCity];
        self.cityView.stateViewString = CityModel.name;
    }
}

- (void)endRefresh{
    [self.mainTableView.mj_footer endRefreshing];
}

- (void)endRefreshWithNoMoreData{
    [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
}


@end
