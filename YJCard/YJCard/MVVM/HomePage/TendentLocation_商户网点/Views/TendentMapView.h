//
//  TendentMapView.h
//  YJCard
//
//  Created by paradise_ on 2017/8/9.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>


//#import "BNaviModel.h"
#import "RetailersModel.h"
//
@interface TendentMapView : UIView<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (nonatomic,strong) BMKLocationService * locService;
@property (weak, nonatomic) IBOutlet UIView *messageView;

@property (nonatomic,strong) UIViewController * mainVC;

@property (nonatomic,assign) NSInteger resetFlag;

@property (nonatomic,strong) NSArray * retailersArr;

@end
