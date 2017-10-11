//
//  MarkerSecondTableViewCell.m
//  HDStock
//
//  Created by liyancheng on 16/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "MarkerSecondTableViewCell.h"
#import "YYStockDemoTableViewController.h"
#import "UIColor+YYStockTheme.h"
#import <Masonry/Masonry.h>
#import "YYFiveRecordModel.h"
#import "YYLineDataModel.h"
#import "YYTimeLineModel.h"
#import "AppServer.h"
#import "YYStock.h"
#import <MBProgressHUD.h>
#import "fullScreenDataModel.h"
@interface MarkerSecondTableViewCell()<YYStockDataSource>

@property (strong, nonatomic) NSMutableDictionary *stockDatadict;
@property (copy, nonatomic) NSArray *stockDataKeyArray;
@property (copy, nonatomic) NSArray *stockTopBarTitleArray;
@property (strong, nonatomic) YYFiveRecordModel *fiveRecordModel;

@property (strong, nonatomic) YYStock *stock;
@property (nonatomic, assign) NSString *stockId;
@property (weak, nonatomic) UIView *fullScreenView;
@property (strong, nonatomic)  UIView *stockContainerView;

/**
 是否显示五档图
 */
@property (assign, nonatomic) BOOL isShowFiveRecord;
@property (nonatomic,strong) MBProgressHUD *globelHud;

//全屏K线控件
@property (strong, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockLatestPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockIncreasePercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockLatestUpdateTimeLabel;

@end

@implementation MarkerSecondTableViewCell{
    NSInteger globleIndex;
}

-(void)setSetTableView:(NSString *)setTableView{
    _setTableView = setTableView;
    if(!_stock){
        _stockContainerView = self.contentView;
        [self initStockView];
//        [self fetchData];
    }
}

- (void)initStockView {
    YYStock *stock = [[YYStock alloc]initWithFrame:self.stockContainerView.frame dataSource:self];
    _stock = stock;
    [self.stockContainerView addSubview:stock.mainView];
    [stock.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.stockContainerView);
    }];
    //添加单击监听
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stock_enterFullScreen:)];
    tap.numberOfTapsRequired = 1;
    [self.stock.containerView addGestureRecognizer:tap];
    
//    [self.stock.containerView.subviews setValue:@0 forKey:@"userInteractionEnabled"];
}

/*******************************************股票数据源获取更新*********************************************/
/**
 网络获取K线数据
 */
- (void)fetchData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [self.globelHud setHidden:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.stock.mainView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"数据加载中";
    hud.backgroundView.alpha = 0.1;
    hud.userInteractionEnabled = NO;
    self.globelHud = hud;
    WEAK_SELF;
    if(![self.stockDatadict objectForKey:@"minutes"]){
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mutStr = [NSString stringWithFormat:@"http://gk.cdtzb.com/api/product/trend"];
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        [mutDic setObject:self.stockIdStr forKey:@"securityID"];
        [mutDic setObject:@"min" forKey:@"type"];
        [manager POST:mutStr parameters:mutDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSMutableArray *array = [NSMutableArray array];
            
            if(![responseObject[@"data"] isKindOfClass:[NSDictionary class]]){
                [responseObject[@"data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    YYTimeLineModel *model = [[YYTimeLineModel alloc]initWithDict:obj];
                    [array addObject: model];
                }];
                [self.stockDatadict setObject:array forKey:@"minutes"];//stockdatakeyarray 的值
                [self.stock.stockViewed reDrawWithTimeLineModels:array isShowFiveRecord:NO fiveRecordModel:nil];
                
                [self.globelHud setHidden:YES];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"loadDataFail");
            [weakSelf fetchData];
        }];
//    });
    }
    
}
#pragma mark ---- 上面的index改变的时候改变数据
-(void)fetchMoreDataWithIndex:(NSInteger)index{
    [self.globelHud setHidden:YES];
    globleIndex = index;
    switch (index) {
        case 0:
        {
            NSString *mutStr1 = [NSString stringWithFormat:@"http://gk.cdtzb.com/api/product/trend"];
            NSMutableDictionary *mutDic = @{}.mutableCopy;
            [mutDic setObject:self.stockIdStr forKey:@"securityID"];
            [mutDic setObject:@"min" forKey:@"type"];
            [self getDataWithDataStr:mutStr1 andStoreKey:@"minutes" andDic:mutDic];
        }
            break;
        case 1:
        {
            NSString *mutStr1 = [NSString stringWithFormat:@"http://gk.cdtzb.com/api/product/trend"];
            NSMutableDictionary *mutDic = @{}.mutableCopy;
            [mutDic setObject:self.stockIdStr forKey:@"securityID"];
            [mutDic setObject:@"five" forKey:@"type"];
            if([self.stockDatadict objectForKey:@"five"]){
                
            }else{
                [self getDataWithDataStr:mutStr1 andStoreKey:@"five" andDic:mutDic];
            }
        }
            break;
        case 2:
        {
            NSString *mutStr1 = [NSString stringWithFormat:@"http://gk.cdtzb.com/api/product/trend"];
            NSMutableDictionary *mutDic = @{}.mutableCopy;
            [mutDic setObject:self.stockIdStr forKey:@"securityID"];
            [mutDic setObject:@"day" forKey:@"type"];
            if([self.stockDatadict objectForKey:@"dayhqs"]){
                
            }else{
                [self getDataWithDataStr:mutStr1 andStoreKey:@"dayhqs" andDic:mutDic];
            }
        }
            break;
        case 3:
        {
            NSString *mutStr1 = [NSString stringWithFormat:@"http://gk.cdtzb.com/api/product/trend"];
            NSMutableDictionary *mutDic = @{}.mutableCopy;
            [mutDic setObject:self.stockIdStr forKey:@"securityID"];
            [mutDic setObject:@"week" forKey:@"type"];
            
            if([self.stockDatadict objectForKey:@"week"]){
                
            }else{
                [self getDataWithDataStr:mutStr1 andStoreKey:@"week" andDic:mutDic];
            }
        }
            break;
        case 4:
        {
            NSString *mutStr1 = [NSString stringWithFormat:@"http://gk.cdtzb.com/api/product/trend"];
            NSMutableDictionary *mutDic = @{}.mutableCopy;
            [mutDic setObject:self.stockIdStr forKey:@"securityID"];
            [mutDic setObject:@"month" forKey:@"type"];
            
            if([self.stockDatadict objectForKey:@"month"]){
                
            }else{
                [self getDataWithDataStr:mutStr1 andStoreKey:@"month" andDic:mutDic];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)getDataWithDataStr:(NSString *)UrlStr andStoreKey:(NSString *)keyName andDic:(NSDictionary *)dic{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [self.globelHud setHidden:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.stock.mainView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"数据加载中";
    hud.userInteractionEnabled = NO;
    hud.backgroundView.alpha = 0.1;
    self.globelHud = hud;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [manager POST:UrlStr parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSMutableArray *array = [NSMutableArray array];
            
            if([keyName isEqualToString:@"minutes"]||[keyName isEqualToString:@"five"]){
                 [self.globelHud setHidden:YES];
//                if(![responseObject[@"data"] isKindOfClass:[NSDictionary class]]){
                    if([keyName isEqualToString:@"minutes"]){
                        [responseObject[@"data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            YYTimeLineModel *model = [[YYTimeLineModel alloc]initWithDict:obj];
                            [array addObject: model];
                        }];
                        [self.stockDatadict setObject:array forKey:keyName];
//                        [self.stock.stockViewed reDrawWithTimeLineModels:array isShowFiveRecord:NO fiveRecordModel:nil];
                        [self.stock draw];
                    }else{
                        NSMutableArray *keyNameArr = @[].mutableCopy;
                        [((NSDictionary *)responseObject[@"data"])enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                           [keyNameArr addObject:key];
                        }];
                        
                        [keyNameArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                           return [obj1 compare:obj2];
                        }];
                        
                        for (NSString *str in keyNameArr) {
                            NSArray *obj =responseObject[@"data"][str];
                            [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                
                                YYTimeLineModel *model = [[YYTimeLineModel alloc]initWithDict:obj];
                                [array addObject: model];
                            }];

                        }
                        
                        [self.stockDatadict setObject:array forKey:keyName];
                        self.stock.fiveDayKeyArr = keyNameArr;
                        [self.stock draw];
                    }
                //if(![responseObject[@"errcode"] isKindOfClass:[NSDictionary class]])
//            }
            }else{//日K 周K 月K
                if(![responseObject[@"data"] isKindOfClass:[NSDictionary class]]){
                    NSArray* reversedArrayed = [[(NSArray *)responseObject[@"data"] reverseObjectEnumerator] allObjects];
                    NSMutableArray * reversedArray = @[].mutableCopy;
                    NSArray * downloadDataArray = responseObject[@"data"];
                    for (NSInteger i=downloadDataArray.count; i>0; i--) {
                        [reversedArray addObject:((NSDictionary *)downloadDataArray[i-1])[@"spj"]];
                    }
                   __block NSInteger flagInteger=0;
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                        [reversedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    flagInteger++;
                                    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:reversedArrayed[idx]];
                                    if(idx>=reversedArray.count-5){//前四天
                                        [mutDic setValue:mutDic[@"spj"] forKey:@"ma5"];
                                    }else{
                                        NSArray *arr = [reversedArray subarrayWithRange:NSMakeRange(idx, 5)];
                                        float avgMa5 = [[arr valueForKeyPath:@"@avg.floatValue"] floatValue];
                                        [mutDic setValue:[NSString stringWithFormat:@"%f",avgMa5] forKey:@"ma5"];
                                    }
                                    //MA20
                                    if(idx>=reversedArray.count-20){
                                        [mutDic setValue:mutDic[@"spj"] forKey:@"ma20"];
                                    }else{
                                        NSArray *arr = [reversedArray subarrayWithRange:NSMakeRange(idx, 20)];
                                        float avgMa20 = [[arr valueForKeyPath:@"@avg.floatValue"] floatValue];
                                        [mutDic setValue:[NSString stringWithFormat:@"%f",avgMa20] forKey:@"ma20"];
                                    }
                                    if(idx>=reversedArray.count-10){
                                        [mutDic setValue:mutDic[@"spj"] forKey:@"ma10"];
                                    }else{
                                        NSArray *arr = [reversedArray subarrayWithRange:NSMakeRange(idx, 10)];
                                        float avgMa10 = [[arr valueForKeyPath:@"@avg.floatValue"] floatValue];
                                        [mutDic setValue:[NSString stringWithFormat:@"%f",avgMa10] forKey:@"ma10"];
                                    }
                            
                                    YYLineDataModel *model = [[YYLineDataModel alloc]initWithDict:mutDic];
                                    [array insertObject:model atIndex:0];
                                    [self.stockDatadict setObject:array forKey:keyName];//stockdatakeyarray 的值
                            
                                    if(flagInteger==400||flagInteger == reversedArray.count){
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                [self.globelHud setHidden:YES];
                                                [self.stock draw];
                                                
                                            });
                                        }
                                    }];
                            });
                    
                }
    
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.globelHud setHidden:YES];
            NSLog(@"%@",error);
        }];
    });
}


/*******************************************股票数据源代理*********************************************/

#pragma mark ----  股票数据源代理
-(NSArray <NSString *> *) titleItemsOfStock:(YYStock *)stock {
    return self.stockTopBarTitleArray;
}

-(NSArray *) YYStock:(YYStock *)stock stockDatasOfIndex:(NSInteger)index {
    return index < self.stockDataKeyArray.count ? self.stockDatadict[self.stockDataKeyArray[index]] : nil;
}

-(YYStockType)stockTypeOfIndex:(NSInteger)index {
    //    return index == 0 ? YYStockTypeTimeLine : YYStockTypeLine;
    if(index==0||index==1){
        return YYStockTypeTimeLine;
    }else{
        return YYStockTypeLine;
    }
}

- (id<YYStockFiveRecordProtocol>)fiveRecordModelOfIndex:(NSInteger)index {
    return self.fiveRecordModel;
}

//- (BOOL)isShowfiveRecordModelOfIndex:(NSInteger)index {
//    return self.isShowFiveRecord;
//}

/*******************************************股票全屏*********************************************/
/**
 退出全屏
 */
- (IBAction)stock_exitFullScreen:(id)sender {
    
//    [self.stock.containerView.subviews setValue:@1 forKeyPath:@"userInteractionEnabled"];
    UIView *snapView = [self.fullScreenView snapshotViewAfterScreenUpdates:NO];
    [self.fullScreenView addSubview:snapView];
    [snapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.fullScreenView);
    }];
    [self.stockContainerView addSubview:self.stock.mainView];
    [self.stock.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.stockContainerView);
    }];
   
    
    if(globleIndex == 1){
        NSArray *array =[self.stockDatadict objectForKey:@"five"];
        [self.stock.stockViewed reDrawWithTimeLineModels:array isShowFiveRecord:NO fiveRecordModel:nil];
    }else{
        [self.stock draw];
        [self.stock.stockViewed setNeedsDisplay];
        [self.stock.stockKViewed setNeedsDisplay];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.fullScreenView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.fullScreenView removeFromSuperview];
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.stock.containerView.gestureRecognizers.firstObject setEnabled:YES];
}

/**
 点击进入全屏
 */
- (void)stock_enterFullScreen:(UITapGestureRecognizer *)tap {
    tap.enabled = NO;

    UIView *fullScreenView = [[NSBundle mainBundle] loadNibNamed:@"YYStockFullScreenView" owner:self options:nil].firstObject;
    self.fullScreenView = fullScreenView;
    [self  updateStockFullScreenData];
    fullScreenView.backgroundColor = RGBCOLOR(240, 240, 240);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:fullScreenView];
    
    [fullScreenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(window.mas_height);
        make.height.equalTo(window.mas_width);
        make.center.equalTo(window);
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [fullScreenView addSubview:self.stock.mainView];
    [self.stock.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(fullScreenView);
        make.top.equalTo(fullScreenView).offset(66);
    }];
     fullScreenView.transform = CGAffineTransformMakeRotation(M_PI_2);
//    [@"minutes",@"five",@"dayhqs",@"week",@"month"]
    if(globleIndex ==0){
        NSArray *array =[self.stockDatadict objectForKey:@"minutes"];
        [self.stock.stockViewed reDrawWithTimeLineModels:array isShowFiveRecord:NO fiveRecordModel:nil];
        [self.stock draw];
    }else if(globleIndex ==1){
        NSArray *array =[self.stockDatadict objectForKey:@"five"];
        [self.stock.stockViewed reDrawWithTimeLineModels:array isShowFiveRecord:NO fiveRecordModel:nil];
        [self.stock draw];
    }else{
        [self.stock draw];
    }
}

/**
 更新全屏顶部数据
 */
- (void)updateStockFullScreenData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    WEAK_SELF;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mutStr = [NSString stringWithFormat:@"http://tzb.cndzsp.com/klink/getHq.php?securityID=%@&%u",self.stockIdStr,arc4random()%10000];
        [manager GET:mutStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if([responseObject[@"code"] isEqual:@(1)]){
                fullScreenDataModel *model = [[fullScreenDataModel alloc]initWithDictionary:responseObject[@"data"]];
                self.stockNameLabel.text = model.Name;
                self.stockIdLabel.text = model.Symbol;
                self.stockLatestPriceLabel.text = model.NewPrice;
                
                NSString *tempChangeRate = [NSString stringWithFormat:@"%.2f%%",model.zhangdiefu.floatValue>0?[NSString stringWithFormat:@"%f",model.zhangdiefu.floatValue].floatValue:model.zhangdiefu.floatValue];
                NSString *tempPriceChange =[NSString stringWithFormat:@"%.2f",model.zhangdie.floatValue>0?[NSString stringWithFormat:@"%f",model.zhangdie.floatValue].floatValue:model.zhangdie.floatValue];
                NSString *firsrt = tempPriceChange.floatValue>0?[NSString stringWithFormat:@"+%.2f",tempPriceChange.floatValue]:tempPriceChange;
                NSString *firsr1 = tempChangeRate.floatValue>0? [NSString stringWithFormat:@"+%.2f",tempChangeRate.floatValue]:tempChangeRate;
                self.stockIncreasePercentLabel.text = [NSString stringWithFormat:@"%@   %@",firsrt,firsr1];
                self.stockLatestUpdateTimeLabel.text = [NSString stringWithFormat:@"更新时间：2016-10-17 22:05:05"];
                if(model.zhangdiefu.floatValue>0){
                    self.stockIncreasePercentLabel.textColor = RGBCOLOR(226, 59, 74);
                }else{
                    self.stockIncreasePercentLabel.textColor = RGBCOLOR(10,174,106);
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf updateStockFullScreenData];
        }];
    });
}

/*******************************************getter*********************************************/
- (NSMutableDictionary *)stockDatadict {
    if (!_stockDatadict) {
        _stockDatadict = [NSMutableDictionary dictionary];
    }
    return _stockDatadict;
}

- (NSArray *)stockDataKeyArray {
    if (!_stockDataKeyArray) {
        _stockDataKeyArray = @[@"minutes",@"five",@"dayhqs",@"week",@"month"];
    }
    return _stockDataKeyArray;
}

- (NSArray *)stockTopBarTitleArray {
    if (!_stockTopBarTitleArray) {
        _stockTopBarTitleArray = @[@"分时",@"五日",@"日K",@"周K",@"月K"];
    }
    return _stockTopBarTitleArray;
}

- (NSString *)getToday {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (void)dealloc {
    NSLog(@"DEALLOC");
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
