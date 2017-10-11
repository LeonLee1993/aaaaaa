//
//  TendentMessageViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/8/9.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TendentMessageViewController.h"
#import "TendentAlbumViewController.h"
//#import "BNaviModel.h"
#import "LYCHelper.h"
#import "RetailersModel.h"
#import "LYCLocationTransform.h"
#import "TQLocationConverter.h"
@interface TendentMessageViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *saleImageView;
@property (weak, nonatomic) IBOutlet UIView *discountView;

@property (weak, nonatomic) IBOutlet UIImageView *tendentMessageImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
//地区
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;

@property (nonatomic,strong) NSArray * maps;

    
    
@end

@implementation TendentMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSeeTheAlbum)];
    [self.tendentMessageImageView addGestureRecognizer:tap];
    
    CGSize size1 ;
    CGSize size2 = [LYCHelper getsizeOfString:self.model.name andAttribute:nil andLineSpace:3 andBorderSpace:38 fontSize:16];
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        size1 = [LYCHelper getsizeOfString:[NSString stringWithFormat:@"%@",self.model.address] andAttribute:nil andLineSpace:3 andBorderSpace:96 fontSize:12];
    }else{
       size1 = [LYCHelper getsizeOfString:[NSString stringWithFormat:@"%@ | %@",self.model.distance,self.model.address] andAttribute:nil andLineSpace:3 andBorderSpace:96 fontSize:12];
    }
    
    self.messageViewHeight.constant = size1.height +size2.height +60;
    [self setModel:self.model];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToContanctUSWithTelNum:)];
    [self.telLabel addGestureRecognizer:tap1];
}


-(void)tapToContanctUSWithTelNum:(NSString *)teleNum{
    
    if(_model.phone.length>0){
        
        NSArray * arr = [_model.phone componentsSeparatedByString:@"-"];
        NSMutableString *mutStr = [NSMutableString string];
        for (NSString *str in arr) {
            [mutStr appendString:str];
        }
        
        teleNum = mutStr;
        LYCAlertController * alertView = [LYCAlertController alertControllerWithTitle:@"确认拨打电话联系客服?" message:nil preferredStyle:0];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:_model.phone style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *telNumber = [NSString stringWithFormat:@"tel:%@", teleNum];
            NSURL *aURL = [NSURL URLWithString:telNumber];
            if ([[UIApplication sharedApplication] canOpenURL:aURL]) {
                [[UIApplication sharedApplication] openURL:aURL];
            }
        }];
        
        [alertView addAction:OKAction];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertView addAction:cancleAction];
        [self presentViewController:alertView animated:YES completion:nil];
        
    }else{
        
        
    }
    
}

- (void)tapToSeeTheAlbum{
    
    if([_model.imgCount isEqual:@(0)]){
        
        LYCAlertController * alertC = [LYCAlertController alertControllerWithTitle:@"该商户没有图片可以展示" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:YES completion:nil];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertC addAction:action];
        
    }else{
        
        TendentAlbumViewController * tendentAlbum = [[TendentAlbumViewController alloc]init];
        tendentAlbum.idStr = [NSString stringWithFormat:@"%@",_model.id];
        [self.navigationController pushViewController:tendentAlbum animated:YES];
        
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(id)naviPresentedViewController {
    return self;
}

- (IBAction)guideButtonClicked:(id)sender {
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打开[定位服务]来允许[家亲付]确定您的位置" message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置" , nil];
        alertView.delegate = self;
        alertView.tag = 1;
        [alertView show];
    }else{
        [MobClick event:@"guideButtonClick"];
        self.maps = [self getInstalledMapAppWithEndLocation:CLLocationCoordinate2DMake(self.model.lat.doubleValue, self.model.lng.doubleValue)];
        
        CLLocationCoordinate2D afterLocation = [TQLocationConverter transformFromBaiduToGCJ:CLLocationCoordinate2DMake(self.model.lat.doubleValue, self.model.lng.doubleValue)];
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
#pragma mark - 设置数据,因为是上个界面传来的
-(void)setModel:(RetailersModel *)model{
    _model = model;
    self.titleLabel.text = model.name;
    
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        self.locationLabel.text =[NSString stringWithFormat:@"%@",model.address];
    }else{
        self.locationLabel.text =[NSString stringWithFormat:@"%@ | %@",model.distance,model.address];
    }
    NSString *telStr = [NSString stringWithFormat:@"电话: %@",model.phone];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:telStr];
    [attribute addAttribute:NSForegroundColorAttributeName value:MainColor range:[telStr rangeOfString:model.phone]];
    
    self.telLabel.attributedText = attribute;
    self.categoryLabel.text = [NSString stringWithFormat:@"类别: %@",model.category];
    self.zoneLabel.text = [NSString stringWithFormat:@"地区: %@",model.city];
    self.saleLabel.text = [NSString stringWithFormat:@"%@",model.discount];
    self.imageCountLabel.text = [NSString stringWithFormat:@"%@张",model.imgCount];
    
    if(self.model.discount.length>0&&[self.model.isShowRebate isEqual:@(1)]){
       
    }else{
        self.saleLabel.hidden = YES;
        self.saleImageView.hidden = YES;
        self.discountView.hidden = YES;
    }
    CGSize size = [LYCHelper getsizeOfString:self.model.discount andAttribute:nil andLineSpace:3 andBorderSpace:45 fontSize:12];
    if(size.height > 13){
        self.bottomConstraint.constant = - (size.height - 13);
    }

    [self.tendentMessageImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"商户-无图"]];
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
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=bd0911",endLocation.latitude,endLocation.longitude,_model.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=%@&coord_type=1&policy=0",afterLocation.latitude, afterLocation.longitude,_model.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
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
    toLocation.name = _model.name;
    NSArray *items = @[currentLoc,toLocation];
    
    NSDictionary *dic = @{
                          
                          MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                          
                          MKLaunchOptionsMapTypeKey: @(MKMapTypeStandard),
                          
                          MKLaunchOptionsShowsTrafficKey: @(YES)
                          
                          };
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
    
}


@end
