//
//  TendentMapView.m
//  YJCard
//
//  Created by paradise_ on 2017/8/9.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TendentMapView.h"
#import "RetailersModel.h"
#import "LYCAnnotation.h"
#import "TendentMessageViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "LYCLocationTransform.h"
#import "TQLocationConverter.h"


#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface TendentMapView()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceAndLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *TelLabel;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) NSArray * maps;

@end

@implementation TendentMapView{
    CLLocationCoordinate2D  TempCoodinate;
    NSInteger currentPage;
    NSInteger pageSize;
    RetailersModel * selectedModel;
    BMKAnnotationView * selectedAnnotationView;
    NSMutableArray * presentAnnotations;
}

-(void)setResetFlag:(NSInteger)resetFlag{
    _resetFlag = resetFlag;
    currentPage = 0;
    selectedModel = nil;
    [selectedAnnotationView removeFromSuperview];
    [self.dataArr removeAllObjects];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [presentAnnotations removeAllObjects];
    [self getMoreTendentList];
}

- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    presentAnnotations = @[].mutableCopy;
    pageSize = 20;
    currentPage = 0;
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.zoomLevel = 14.1;
    [self.dataArr removeAllObjects];
//    [self getMoreTendentList];
    _mapView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSeeMessage)];
    [self.messageView addGestureRecognizer:tap];
}

-(void)setRetailersArr:(NSArray *)retailersArr{
    _retailersArr = retailersArr;
    [self.dataArr addObjectsFromArray:retailersArr];
    if(self.dataArr.count>0&&!selectedModel){
        selectedModel = self.dataArr[0];
        [self setMessages];//如果返回的有值,取最近的 给下面的赋值
        TempCoodinate = CLLocationCoordinate2DMake(selectedModel.lat.doubleValue, selectedModel.lng.doubleValue);
        [_mapView setCenterCoordinate:TempCoodinate];
    }
    NSLog(@"%lu",(unsigned long)self.dataArr.count);
    [self setAnnotions];
    
}

- (void)tapToSeeMessage{
    if(selectedModel){
        [MobClick event:@"retailerDetail"];
        TendentMessageViewController * message = [[TendentMessageViewController alloc]init];
        message.model = selectedModel;
        [self.mainVC.navigationController pushViewController:message animated:YES];
    }else{
        NSLog(@"目前没有可选地点");
    }
}


-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

//自定义精度圈
- (void)customLocationAccuracyCircle {
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    param.accuracyCircleStrokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    param.accuracyCircleFillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.3];
    [_mapView updateLocationViewWithParam:param];
    [_mapView setZoomLevel:3];
}

//停止定位
-(IBAction)stopLocation:(id)sender
{
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
}

/**
 *在地图View将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


#pragma mark - 开始导航
- (IBAction)startNaviButton:(id)sender {
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打开[定位服务]来允许[家亲付]确定您的位置" message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置" , nil];
        alertView.delegate = self;
        alertView.tag = 1;
        [alertView show];
    }else{
        [MobClick event:@"guideButtonClick"];
        self.maps = [self getInstalledMapAppWithEndLocation:CLLocationCoordinate2DMake(selectedModel.lat.doubleValue, selectedModel.lng.doubleValue)];
        CLLocationCoordinate2D afterLocation = [TQLocationConverter transformFromBaiduToGCJ:CLLocationCoordinate2DMake(selectedModel.lat.doubleValue, selectedModel.lng.doubleValue)];
        [self alertAmaps:CLLocationCoordinate2DMake(afterLocation.latitude, afterLocation.longitude)];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(id)naviPresentedViewController {
    return self.mainVC;
    
}

#pragma mark - network 
- (void)getMoreTendentList{
    if(currentPage ==0){
        [self.dataArr removeAllObjects];
    }
    currentPage+=1;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:@"0" forKey:@"key"];//搜索词
    [mutDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefault] forKey:@"categoryname"];//商户分类名称(默认0)
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefault]);
    
    [mutDic setObject:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"pageindex"];//第几页
    [mutDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"pagesize"];//每页大小
    [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.longitude] forKey:@"lng"];//当前经度
    [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.latitude] forKey:@"lat"];//当前纬度
    [mutDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCityID] forKey:@"city"];//城市id
    [mutDic setObject:@"0" forKey:@"ismap"];//0.列表 1.地图
    [mutDic setObject:@"2" forKey:@"version"];
    NSMutableDictionary * senderDic = @{}.mutableCopy;
    [senderDic setObject:mutDic forKey:@"SenderInfoKey"];
    // 发送请求
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Getretailers];
    
    [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        
        if([json[@"code"] isEqual:@(100)]){
            
            for (NSDictionary *dic in json[@"data"][@"retailers"]) {
                RetailersModel * model = [RetailersModel yy_modelWithDictionary:dic];
                [self.dataArr addObject:model];
            }
            
            if(self.dataArr.count>0&&!selectedModel){
                selectedModel = self.dataArr[0];
                [self setMessages];//如果返回的有值,取最近的 给下面的赋值
                TempCoodinate = CLLocationCoordinate2DMake(selectedModel.lat.doubleValue, selectedModel.lng.doubleValue);
                
                [_mapView setCenterCoordinate:TempCoodinate];
            }else if (self.dataArr.count==0){
                selectedModel = nil;
                [self setNothingMessages];
            }
            NSLog(@"%lu",(unsigned long)self.dataArr.count);
            [self setAnnotions];
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    } andProgressView:self.mainVC.view progressViewText:@"" progressViewType:LYCStateViewLoad ViewController:nil];
}

- (void)setMessages{
    
    self.titleLabel.text = selectedModel.name;

    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        self.distanceAndLocationLabel.text = [NSString stringWithFormat:@"%@",selectedModel.address];
    }else{
        self.distanceAndLocationLabel.text = [NSString stringWithFormat:@"%@ | %@",selectedModel.distance,selectedModel.address];
    }
    self.TelLabel.text = selectedModel.phone;
}

- (void)setNothingMessages{
    self.titleLabel.text = @"--------";
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        self.distanceAndLocationLabel.text =@"--------";
    }else{
        self.distanceAndLocationLabel.text = @"--------";
    }
    self.TelLabel.text = @"--------";
    
}

#pragma mark - 设置地图上的图标
- (void)setAnnotions{
    
    for (RetailersModel * model in self.dataArr) {
        CLLocationCoordinate2D coredinate = CLLocationCoordinate2DMake(model.lat.doubleValue, model.lng.doubleValue);
        LYCAnnotation *pointAnnotation = [[LYCAnnotation alloc] init];
        pointAnnotation.coordinate = coredinate;
        pointAnnotation.title = model.name;
        pointAnnotation.model = model;
        if(![presentAnnotations containsObject:pointAnnotation.title]){
            [_mapView addAnnotation:pointAnnotation];
            [presentAnnotations addObject:pointAnnotation.title];
        }
    }
}

#pragma mark - mapViewDelegate -- 地图代理
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    selectedAnnotationView.image =  [UIImage imageNamed:@"地图定位icon-蓝色"];
    LYCAnnotation * anotation = view.annotation;
    selectedAnnotationView = view;
    
    if([anotation isKindOfClass:[LYCAnnotation class]]){
        RetailersModel * model = anotation.model;
        [_mapView setCenterCoordinate:anotation.coordinate];
        self.titleLabel.text = model.name;
        selectedModel = model;
        self.distanceAndLocationLabel.text = [NSString stringWithFormat:@"%@ | %@",model.distance,model.address];
        view.image = [UIImage imageNamed:@"地图定位icon-红色"];
        self.TelLabel.text = model.phone;
    }
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]){
        BMKPinAnnotationView *newAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
        newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示

        if((newAnnotationView.annotation.coordinate.latitude == selectedAnnotationView.annotation.coordinate.latitude)&&(newAnnotationView.annotation.coordinate.longitude == selectedAnnotationView.annotation.coordinate.longitude)){
            newAnnotationView.image = [UIImage imageNamed:@"地图定位icon-红色"];
        }else{
            LYCAnnotation *lycanotation = annotation;
            if([lycanotation.model.address isEqualToString:selectedModel.address]){
                 newAnnotationView.image = [UIImage imageNamed:@"地图定位icon-红色"];
                 selectedAnnotationView = newAnnotationView;
            }else{
                 newAnnotationView.image = [UIImage imageNamed:@"地图定位icon-蓝色"];
            }
        }
        return newAnnotationView;
    }
    return nil;
}


- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
//    CLLocationCoordinate2D carLocation = [_mapView convertPoint:self.center toCoordinateFromView:self];
//    BMKReverseGeoCodeOption *optind = [[BMKReverseGeoCodeOption alloc] init];
//    optind.reverseGeoPoint = CLLocationCoordinate2DMake(carLocation.latitude, carLocation.longitude);
//    NSLog(@"%f - %f", optind.reverseGeoPoint.latitude, optind.reverseGeoPoint.longitude);
//    //调用发地址编码方法，让其在代理方法onGetReverseGeoCodeResult中输出
//    [_geoCodeSearch reverseGeoCode:optind];
//    TempCoodinate = optind.reverseGeoPoint;
//    [self getMoreTendentList];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)dealloc {
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    if (_mapView) {
        _mapView = nil;
    }
    NSLog(@"delloc");
}

#pragma mark - 导航方法
- (NSArray *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation
{
    NSMutableArray *maps = [NSMutableArray array];
    //百度转化为GPS
    CLLocationCoordinate2D afterLocation = [TQLocationConverter transformFromBaiduToGCJ:CLLocationCoordinate2DMake(endLocation.latitude, endLocation.longitude)];
    
    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=bd0911",endLocation.latitude,endLocation.longitude,selectedModel.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"导航功能",@"nav123456",afterLocation.latitude,afterLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"导航测试",@"nav123456",afterLocation.latitude, afterLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=%@&coord_type=1&policy=0",afterLocation.latitude, afterLocation.longitude,selectedModel.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    
    return maps;
}


- (void)alertAmaps:(CLLocationCoordinate2D)gps

{
    
    if (self.maps.count == 0) {
        
        return;
        
    }
    
    LYCAlertController *alertVC = [LYCAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < self.maps.count; i++) {
        
        if (i == 0) {
            
            [alertVC addAction:[UIAlertAction actionWithTitle:self.maps[i][@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self navAppleMap:gps];
                
            }]];
            
        }else{
            [alertVC addAction:[UIAlertAction actionWithTitle:self.maps[i][@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self otherMap:i];
            }]];
        }
    }
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self.mainVC presentViewController:alertVC animated:YES completion:nil];
}

///  第三方地图
- (void)otherMap:(NSInteger)index

{
    
    NSDictionary *dic = self.maps[index];
    
    NSString *urlString = dic[@"url"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
}

// 苹果地图

- (void)navAppleMap:(CLLocationCoordinate2D)gps
{
    
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gps addressDictionary:nil]];
    toLocation.name = selectedModel.name;
    NSArray *items = @[currentLoc,toLocation];
    
    NSDictionary *dic = @{
                          
                          MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                          
                          MKLaunchOptionsMapTypeKey: @(MKMapTypeStandard),
                          
                          MKLaunchOptionsShowsTrafficKey: @(YES)
                          
                          };
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}


@end
