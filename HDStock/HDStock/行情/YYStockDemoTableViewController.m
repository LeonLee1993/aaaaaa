 //
//  YYStockDemoTableViewController.m
//  YYStockDemo
//
//  Created by yate1996 on 16/10/17.
//  Copyright © 2016年 yate1996. All rights reserved.
//

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

@interface YYStockDemoTableViewController ()<YYStockDataSource>

/**
 K线数据源
 */
@property (strong, nonatomic) NSMutableDictionary *stockDatadict;
@property (copy, nonatomic) NSArray *stockDataKeyArray;
@property (copy, nonatomic) NSArray *stockTopBarTitleArray;
@property (strong, nonatomic) YYFiveRecordModel *fiveRecordModel;

@property (strong, nonatomic) YYStock *stock;
@property (nonatomic, assign) NSString *stockId;
@property (weak, nonatomic) UIView *fullScreenView;
@property (strong, nonatomic) IBOutlet UIView *stockContainerView;

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


@implementation YYStockDemoTableViewController

- (instancetype)initWithStockId:(NSString *)stockId title:(NSString *)title isShowFiveRecord:(BOOL)isShowFiveRecord {
    self = [super init];
    if(self) {
        _isShowFiveRecord = isShowFiveRecord;
        _stockId = @"88888888";
        self.navigationItem.title = @"YY股(88888888)";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //测试数据
    {
        _isShowFiveRecord = NO;
        _stockId = @"88888888";
        self.navigationItem.title = @"YY股(88888888)";
    }
    
    [self initStockView];
    [self fetchData];
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
    
    [self.stock.containerView.subviews setValue:@0 forKey:@"userInteractionEnabled"];
}

/*******************************************股票数据源获取更新*********************************************/
/**
 网络获取K线数据
 */
- (void)fetchData {
    
//    [AppServer Get:@"five" params:nil success:^(NSDictionary *response) {
//        if (self.isShowFiveRecord) {
//            self.fiveRecordModel = [[YYFiveRecordModel alloc]initWithDict:response[@"sshq"]];
//            [self.stock draw];
//        }
//    } fail:^(NSDictionary *info) {
//        
//    }];//右边那个
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [self.globelHud setHidden:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.stock.mainView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"数据加载中";
    hud.backgroundView.alpha = 0.1;
    hud.userInteractionEnabled = NO;
    self.globelHud = hud;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mutStr = [NSString stringWithFormat:@"http://tzb.cndzsp.com/klink/trend.php?securityID=SH000002&type=minute&%u",arc4random()%10000];
        [manager GET:mutStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSMutableArray *array = [NSMutableArray array];
            [responseObject[@"data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YYTimeLineModel *model = [[YYTimeLineModel alloc]initWithDict:obj];
                [array addObject: model];
            }];
            
            [self.stockDatadict setObject:array forKey:@"minutes"];//stockdatakeyarray 的值
            [self.stock draw];
            [self.globelHud setHidden:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    });
    
}
#pragma mark ---- 上面的index改变的时候改变数据
-(void)fetchMoreDataWithIndex:(NSInteger)index{
    [self.globelHud setHidden:YES];
    switch (index) {
        case 0:
        {
            NSString *mutStr1 = [NSString stringWithFormat:@"http://tzb.cndzsp.com/klink/trend.php?securityID=SH000002&type=minute&%u",arc4random()%10000];
             [self getDataWithDataStr:mutStr1 andStoreKey:@"minutes"];
        }
            break;
        case 1:
        {
            NSString *mutStr1 = [NSString stringWithFormat:@"http://tzb.cndzsp.com/klink/trend.php?securityID=SH000002&type=five&%u",arc4random()%10000];
            if([self.stockDatadict objectForKey:@"five"]){
                
            }else{
                [self getDataWithDataStr:mutStr1 andStoreKey:@"five"];
            }
        }
            break;
        case 2:
        {
            NSString *mutStr1 = [NSString stringWithFormat:@"http://tzb.cndzsp.com/klink/trend.php?securityID=SH000002&type=day&%u",arc4random()%10000];
            if([self.stockDatadict objectForKey:@"dayhqs"]){
                
            }else{
                [self getDataWithDataStr:mutStr1 andStoreKey:@"dayhqs"];
            }
        }
            break;
        case 3:
        {
            NSString *mutStr1 = [NSString stringWithFormat:@"http://tzb.cndzsp.com/klink/trend.php?securityID=SH000002&type=week&%u",arc4random()%10000];
            
            if([self.stockDatadict objectForKey:@"week"]){
                
            }else{
                 [self getDataWithDataStr:mutStr1 andStoreKey:@"week"];
            }
        }
            break;
        case 4:
        {
            NSString *mutStr1 = [NSString stringWithFormat:@"http://tzb.cndzsp.com/klink/trend.php?securityID=SH000002&type=month&%u",arc4random()%10000];
            
            if([self.stockDatadict objectForKey:@"month"]){
            
            }else{
            [self getDataWithDataStr:mutStr1 andStoreKey:@"month"];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)getDataWithDataStr:(NSString *)UrlStr andStoreKey:(NSString *)keyName{
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
        [manager GET:UrlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.globelHud setHidden:YES];
            NSMutableArray *array = [NSMutableArray array];
           
                if([keyName isEqualToString:@"minutes"]||[keyName isEqualToString:@"five"]){
                    if([keyName isEqualToString:@"minutes"]){
                         [responseObject[@"data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            YYTimeLineModel *model = [[YYTimeLineModel alloc]initWithDict:obj];
                            [array addObject: model];
                        }];
                        [self.stockDatadict setObject:array forKey:keyName];
                        [self.stock draw];
                    }else{
                        NSMutableArray *keyNameArr = @[].mutableCopy;
                        [((NSDictionary *)responseObject[@"data"])enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            if([obj isKindOfClass:[NSArray class]]){
                                [(NSArray *)obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    YYTimeLineModel *model = [[YYTimeLineModel alloc]initWithDict:obj];
                                    [array addObject: model];
                                }];
                                [keyNameArr insertObject:key atIndex:0];
                            }
                            
                        }];
                        NSLog(@"%@",keyNameArr);
                        [self.stockDatadict setObject:array forKey:keyName];
                        self.stock.fiveDayKeyArr = keyNameArr;
                        [self.stock draw];
                    }
                }else{
                    NSArray* reversedArray = [[(NSArray *)responseObject[@"data"] reverseObjectEnumerator] allObjects];
                    NSLog(@"%@",responseObject);
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [reversedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            YYLineDataModel *model = [[YYLineDataModel alloc]initWithDict:obj];
                            if (model.MA20 > 0) {
                                [array insertObject:model atIndex:0];
                            }
                        }];
                    });
                    [self.stockDatadict setObject:array forKey:keyName];//stockdatakeyarray 的值
                    [self.stock draw];
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
    
    [self.stock.containerView.subviews setValue:@0 forKeyPath:@"userInteractionEnabled"];
    
    UIView *snapView = [self.fullScreenView snapshotViewAfterScreenUpdates:NO];
    [self.fullScreenView addSubview:snapView];
    [snapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.fullScreenView);
    }];
    [self.stockContainerView addSubview:self.stock.mainView];
    [self.stock.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.stockContainerView);
    }];
    [self.stock draw];
    
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
    [self.stock.containerView.subviews setValue:@1 forKeyPath:@"userInteractionEnabled"];
    tap.enabled = NO;
    
    UIView *fullScreenView = [[NSBundle mainBundle] loadNibNamed:@"YYStockFullScreenView" owner:self options:nil].firstObject;
    self.fullScreenView = fullScreenView;
    [self  updateStockFullScreenData];
    fullScreenView.backgroundColor = [UIColor YYStock_bgLineColor];
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
    [self.stock draw];
    
}

/**
 更新全屏顶部数据
 */
- (void)updateStockFullScreenData {
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.stock.mainView animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.label.text = @"数据加载中";
//    hud.userInteractionEnabled = NO;
//    self.globelHud = hud;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mutStr = [NSString stringWithFormat:@"http://tzb.cndzsp.com/klink/getHq.php?securityID=SH000005&%u",arc4random()%10000];
        [manager GET:mutStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if([responseObject[@"code"] isEqual:@(1)]){
                fullScreenDataModel *model = [[fullScreenDataModel alloc]initWithDictionary:responseObject[@"data"]];
                self.stockNameLabel.text = model.Name;
                self.stockIdLabel.text = model.Symbol;
                self.stockLatestPriceLabel.text = model.NewPrice;
                self.stockIncreasePercentLabel.text = [NSString stringWithFormat:@"%@   %@",model.Low,model.High];
                self.stockLatestUpdateTimeLabel.text = [NSString stringWithFormat:@"更新时间：2016-10-17 22:05:05"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
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
