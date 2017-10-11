//
//  TendentListViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/8/8.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TendentListViewController.h"
#import "TendentTableViewCell.h"
#import "TendentPopMenuView.h"
#import "TendentStateView.h"
#import "TendentCategoryModel.h"
#import "TendentMapView.h"
#import "TendentMessageViewController.h"
#import "TendentCityModel.h"
#import "RetailersModel.h"
#import "TendentIconButton.h"
#import "TendentNothingView.h"

@interface TendentListViewController ()<UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet TendentStateView *leftListView;
@property (weak, nonatomic) IBOutlet TendentStateView *rightListView;
@property (weak, nonatomic) IBOutlet TendentIconButton *mapButton;
@property (nonatomic,weak) TendentNothingView *tendentNothing;
@property (nonatomic,weak) TendentMapView *mapView;
@property (nonatomic,weak) TendentStateView * selectedView;

@end

@implementation TendentListViewController{
    TendentPopMenuView * pop;
//    TendentStateView * selectedView;
    BOOL isMapView;
//    BMKLocationService * _locService;
    NSInteger currentPage;
    NSInteger pageSize;
    NSMutableArray * dataArr;
    LYCStateViews *hud;
}

-(TendentNothingView *)tendentNothing{
    if(!_tendentNothing){
        _tendentNothing = [TendentNothingView viewFromXib];
        _tendentNothing.frame = CGRectMake(0, 64+ScreenWidth/375*44, ScreenWidth, ScreenHeight - 64 - ScreenWidth/375*44);
        _tendentNothing.mainVC = self;
    }
    return _tendentNothing;
}

-(TendentMapView *)mapView{
    if(!_mapView){
        _mapView = [TendentMapView viewFromXib];
        _mapView.frame = CGRectMake(0, 64+ScreenWidth/375*44, ScreenWidth, ScreenHeight- (64+ScreenWidth/375*44));
        _mapView.mainVC = self;
    }
    return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArr = @[].mutableCopy;
    currentPage = 0;
    pageSize = 20;
    
    [self.mapButton setImage:[UIImage imageNamed:@"地图icon"] forState:UIControlStateNormal];
    
    self.mainTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.mainTableView.backgroundColor = MainBackViewColor;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"TendentTableViewCell" bundle:nil] forCellReuseIdentifier:@"TendentTableViewCelled"];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showThePopView:)];
    [self.leftListView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showThePopView1:)];
    [self.rightListView addGestureRecognizer:tap1];
    
    pop = [[TendentPopMenuView alloc]initWithFrame:CGRectMake(0, 64+ScreenWidth/375*44, ScreenWidth, ScreenHeight-64-ScreenWidth/375*44) menuStartPoint:CGPointMake(0, 0) menuItems:nil selectedAction:^(NSInteger index) {
        
    }];
    
    NSMutableArray * mutArr = @[].mutableCopy;
    for (TendentCityModel  *model in self.listViewCityArr) {
        [mutArr addObject:model.name];
    }
    
    __weak typeof (self)weakSelf = self;
    pop.selectedItemBlock = ^(NSString * stringValue,NSString * cityID) {
        weakSelf.selectedView.stateViewString = stringValue;
        if([mutArr containsObject:stringValue]){
            [[NSUserDefaults standardUserDefaults] setObject:stringValue forKey:TendentListDefaultCity];
            [[NSUserDefaults standardUserDefaults] setObject:cityID forKey:TendentListDefaultCityID];
            
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:stringValue forKey:TendentListDefault];
             weakSelf.categoryStr = stringValue;
            
        }
        currentPage = 0;
        if(isMapView){
//            [self.mapView awakeFromNib];
            self.mapView.resetFlag = 0;
        }else{
            [weakSelf getTendentList];
        }
    };
    
    pop.dissappearBlock = ^{
        weakSelf.selectedView.isOn = NO;
    };
    
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreTendentList];
    }];
    
    self.mainTableView.mj_footer.hidden = YES;
    
    [self judgeTheTitleOfViews];
    
    [self getTendentList];
}

#pragma mark - 进入页面的时候判断两边title的标题
- (void)judgeTheTitleOfViews{
    
    NSString * defaultListStr = [[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefault];
    
    NSString * defaultListStr1 = [[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCity];
    
    if(defaultListStr&&!defaultListStr1){
        
        self.rightListView.stateViewString = defaultListStr;
        //城市
        TendentCityModel * CityModel = self.listViewCityArr[0];
        [[NSUserDefaults standardUserDefaults] setObject:CityModel.name forKey:TendentListDefaultCity];
        
        self.leftListView.stateViewString = CityModel.name;
        
    }else if (defaultListStr1&&!defaultListStr){
        //类别
        TendentCategoryModel * model = self.listViewCategoryArr[0];
        [[NSUserDefaults standardUserDefaults] setObject:model.name forKey:TendentListDefault];
        self.leftListView.stateViewString = defaultListStr1;
        self.rightListView.stateViewString = model.name;
    }else if(defaultListStr1&&defaultListStr){
        self.rightListView.stateViewString = defaultListStr;
        self.leftListView.stateViewString = defaultListStr1;
    }else{
        //类别
        TendentCategoryModel * model = self.listViewCategoryArr[0];
        [[NSUserDefaults standardUserDefaults] setObject:model.name forKey:TendentListDefault];
        //城市
        TendentCityModel * CityModel = self.listViewCityArr[0];
        [[NSUserDefaults standardUserDefaults] setObject:CityModel.name forKey:TendentListDefaultCity];
        
        self.leftListView.stateViewString = CityModel.name;
        self.rightListView.stateViewString = model.name;
    }
}

- (void)showThePopView:(UITapGestureRecognizer *)sender{
    
    TendentStateView *stateView = (TendentStateView *)sender.view;
    if(stateView.isOn){
        [pop menuHide];
    }else{
        [pop removeFromSuperview];
        pop.itemsArr = self.listViewCityArr;
        UIWindow *window = [[UIApplication sharedApplication]keyWindow];
        [window addSubview:pop];
//        [self.view addSubview:pop];
        [pop showThePopMenu];
    }
    if(_selectedView != stateView){
        _selectedView.isOn = NO;
    }
    _selectedView = stateView;
    stateView.isOn = !stateView.isOn;
    
}

- (void)showThePopView1:(UITapGestureRecognizer *)sender{
    
    TendentStateView *stateView = (TendentStateView *)sender.view;
    if(stateView.isOn){
        [pop menuHide];
    }else{
        [pop removeFromSuperview];
        pop.itemsArr = self.listViewCategoryArr;
        UIWindow *window = [[UIApplication sharedApplication]keyWindow];
        [window addSubview:pop];
//        [self.view addSubview:pop];
        [pop showThePopMenu];
    }
    if(_selectedView != stateView){
        _selectedView.isOn = NO;
    }
    _selectedView = stateView;
    stateView.isOn = !stateView.isOn;
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(dataArr.count>0){
        return dataArr.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TendentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TendentTableViewCelled"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(dataArr.count>indexPath.row){
        cell.model = dataArr[indexPath.row];
    }
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

- (IBAction)goBack:(id)sender {
    [_mapView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [pop removeFromSuperview];
    [hud LYCHidStateView];
    [self.tendentNothing hid];
}

-(void)dealloc{
    NSLog(@"delooc");
}

- (IBAction)chageTheViewButtonClicked:(UIButton *)sender {
    if(isMapView){
        [self.mapView removeFromSuperview];
        [self getTendentList];
        [sender setImage:[UIImage imageNamed:@"地图icon"] forState:UIControlStateNormal];
    }else{
        [MobClick event:@"retailerLocationOnMap"];
        [self.view addSubview:self.mapView];
//        self.mapView.resetFlag = 0;
        [self.mapView awakeFromNib];
        self.mapView.retailersArr = dataArr;
        [sender setImage:[UIImage imageNamed:@"列表"] forState:UIControlStateNormal];
    }
    isMapView = !isMapView;
}

#pragma mark - netWork
- (void)getTendentList{
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    [hud LYCHidStateView];
    
    if(currentPage ==0){
        [dataArr removeAllObjects];
    }
    
    currentPage+=1;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:@"0" forKey:@"key"];//搜索词
    [mutDic setObject:self.categoryStr forKey:@"categoryname"];//商户分类名称(默认0)
    [mutDic setObject:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"pageindex"];//第几页
    [mutDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"pagesize"];//每页大小
    [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.longitude] forKey:@"lng"];//当前经度
    [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.latitude] forKey:@"lat"];//当前纬度
    [mutDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCityID] forKey:@"city"];//城市id
    [mutDic setObject:@"2" forKey:@"version"];
    [mutDic setObject:@"0" forKey:@"ismap"];//0.列表 1.地图
    NSMutableDictionary * senderDic = @{}.mutableCopy;
    [senderDic setObject:mutDic forKey:@"SenderInfoKey"];
    // 发送请求
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Getretailers];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    hud = [LYCStateViews LYCshowStateViewTo:window withState:LYCStateViewLoad andTest:@"加载中"];
    self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        
        if([json[@"code"] isEqual:@(100)]){
            for (NSDictionary *dic in json[@"data"][@"retailers"]) {
                RetailersModel * model = [RetailersModel yy_modelWithDictionary:dic];
                [dataArr addObject:model];
            }
            
            if(dataArr.count==0){
                currentPage = 0;
                [self.tendentNothing show];
            }else{
                [self.tendentNothing hid];
            }
            
            self.mainTableView.mj_footer.hidden = NO;
            [self.mainTableView reloadData];
            
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
        if(((NSArray *)json[@"data"][@"retailers"]).count<20 || dataArr.count<20 ){
            
            [self endRefreshWithNoMoreData];
            
        }else{
            
            [self endRefresh];
            
        }
        [hud LYCHidStateView];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self endRefresh];
        [hud LYCHidStateView];
    } andProgressView:nil progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:nil];
    
}

- (void)endRefresh{
    [self.mainTableView.mj_footer endRefreshing];
}

- (void)endRefreshWithNoMoreData{
    [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)getMoreTendentList{
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    if(currentPage ==0){
        [dataArr removeAllObjects];
    }
    currentPage+=1;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:@"0" forKey:@"key"];//搜索词
    [mutDic setObject:self.categoryStr forKey:@"categoryname"];//商户分类名称(默认0)
    [mutDic setObject:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"pageindex"];//第几页
    [mutDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"pagesize"];//每页大小
    [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.longitude] forKey:@"lng"];//当前经度
    [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.latitude] forKey:@"lat"];//当前纬度
    [mutDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCityID] forKey:@"city"];//城市id
    [mutDic setObject:@"2" forKey:@"version"];
    [mutDic setObject:@"0" forKey:@"ismap"];//0.列表 1.地图
    NSMutableDictionary * senderDic = @{}.mutableCopy;
    [senderDic setObject:mutDic forKey:@"SenderInfoKey"];
    // 发送请求
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Getretailers];
    
    self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        
        if([json[@"code"] isEqual:@(100)]){
            for (NSDictionary *dic in json[@"data"][@"retailers"]) {
                RetailersModel * model = [RetailersModel yy_modelWithDictionary:dic];
                [dataArr addObject:model];
            }
            
            if(dataArr.count==0){
                currentPage = 0;
                [self.tendentNothing show];
            }else{
                [self.tendentNothing hid];
            }
            
            
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
        
        if(((NSArray *)json[@"data"][@"retailers"]).count<20 || dataArr.count<20 ){
            
            [self endRefreshWithNoMoreData];
            
        }else{
            
            [self endRefresh];
            
        }
        [self.mainTableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self endRefresh];
    } andProgressView:nil progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:nil];
    
}




@end
