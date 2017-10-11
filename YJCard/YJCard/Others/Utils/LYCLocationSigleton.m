//
//  LYCLocationSigleton.m
//  YJCard
//
//  Created by paradise_ on 2017/8/16.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCLocationSigleton.h"
#import "TendentCityModel.h"
#import "AutomyCityProvenModel.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>


#import<BaiduMapAPI_Search/BMKGeocodeSearch.h>

#import<BaiduMapAPI_Map/BMKMapComponent.h>

#import<BaiduMapAPI_Search/BMKPoiSearchType.h>



@interface LYCLocationSigleton()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic,strong) NSMutableArray * ZoneIDArr;

@end

@implementation LYCLocationSigleton{
    BMKGeoCodeSearch * _geocodesearch; //地理编码主类，用来查询、返回结果信息
    NSMutableArray * tendentCityArr;
    CLGeocoder * geocoder;
}


+ (instancetype)LYCLocationManager{
    
    static LYCLocationSigleton *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        [instance initValues];
    });
    
    return instance;
}


- (void)initValues{
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    tendentCityArr = @[].mutableCopy;
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self;
    [self requestInfomation];
    geocoder = [[CLGeocoder alloc] init];
}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation

{
    
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    //普通态
    
    //以下_mapView为BMKMapView对象
    
//    [_mapView updateLocationData:userLocation]; //更新地图上的位置
//    
//    _mapView.centerCoordinate = userLocation.location.coordinate; //更新当前位置到地图中间
    
    //地理反编码
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    
    [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    
    [geocoder reverseGeocodeLocation:_locService.userLocation.location completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            if (placemark != nil) {
                NSString *city = placemark.locality;
                NSLog(@"当前城市名称------%@",city);
                
                NSString *cityPreStr = [city substringToIndex:city.length-2];
                
                [_locService stopUserLocationService];
                NSInteger flag =0;
                for (TendentCityModel *model in tendentCityArr) {
                    flag ++;
                    if([model.name containsString:cityPreStr]){
                        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",model.id] forKey:TendentListDefaultCityID];
                        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",model.id] forKey:TendentListDefaultCity];
                    }
                    if(flag == tendentCityArr.count){
                        TendentCityModel * model1 = tendentCityArr[0];
                        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",model1.id] forKey:TendentListDefaultCityID];
                        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",model1.name] forKey:TendentListDefaultCity];
                    }
                }
            }
        }
    }];
}


-(void)dealloc{
    [_locService stopUserLocationService];
}

- (void)startLocation{
    [_locService startUserLocationService];
}

-(NSMutableArray *)ZoneIDArr{
    if(!_ZoneIDArr){
        _ZoneIDArr = @[].mutableCopy;
        NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"PandCity.plist" ofType:nil];
        // 2.根据filePath创建JSON数据
        NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:filePath1];
        
        NSArray * arr = dic[@"areas"];
        for (NSDictionary * diced  in arr) {
            AutomyCityProvenModel * model = [AutomyCityProvenModel yy_modelWithDictionary:diced];
            [_ZoneIDArr addObject:model];
        }
    }
    return _ZoneIDArr;
}

#pragma mark - 请求上面的类别
- (void)requestInfomation{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Getretailercategory];
    [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            for (NSDictionary *dic in json[@"data"][@"citys"]) {
                TendentCityModel * model = [TendentCityModel yy_modelWithDictionary:dic];
                [tendentCityArr addObject:model];
            }
        }else{
            NSLog(@"%@",json[@"msg"]);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:nil progressViewText:@"" progressViewType:LYCStateViewLoad ViewController:nil];
}

@end
