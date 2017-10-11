//
//  HDStockSayingViewController.m
//  HDStock
//
//  Created by hd-app02 on 2017/2/15.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "HDStockSayingViewController.h"
#import "HDTimeView.h"
#import "HDStockSayingHistoryCell.h"
#import "HDHeadLineModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ZFPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PSYProgresHUD.h"

static NSString * const plistName = @"audioPlist";

@interface HDStockSayingViewController ()<UITableViewDelegate, UITableViewDataSource, ZFPlayerDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableDictionary * dataDictionary;

@property (nonatomic, assign) BOOL isPlaying;

@property (strong, nonatomic) ZFPlayerView * playerView;

@property (nonatomic, strong) ZFPlayerModel * playerModel;

@property (nonatomic, strong) HDStockSayingHistoryCell * privateCell;

@property (nonatomic, strong) NSString * audioURL;

@property (nonatomic, strong) PSYProgresHUD * hud;

@end

@implementation HDStockSayingViewController

#pragma mark --- 懒加载
- (NSMutableDictionary *)dataDictionary{

    if (!_dataDictionary) {
        
        _dataDictionary = [[NSMutableDictionary alloc]init];
    }

    return _dataDictionary;
}

- (UITableView *)tableView{

    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = COLOR(whiteColor);
        
        [_tableView registerNib:[UINib nibWithNibName:@"HDStockSayingHistoryCell" bundle:nil] forCellReuseIdentifier:@"HDStockSayingHistoryCell"];
        
        _tableView.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
           
            [self requestStockSayingData];
            [self.playerView resetPlayer];
            [self.privateCell.progressView setProgress:0];
            self.privateCell.progressView.hidden = YES;
            self.privateCell = nil;
        }];
    }

    return _tableView;

}

- (ZFPlayerModel *)playerModel
{
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.fatherView       = self.view;
        _playerModel.videoURL         = [NSURL URLWithString:self.audioURL];
    }else{
        _playerModel.videoURL         = [NSURL URLWithString:self.audioURL];
    }
    return _playerModel;
}

#pragma mark --- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNormalBackNav];
    self.title = @"股说";
    [self setUpTableView];
    [self requestStockSayingData];
    [self setUpTopPlayerView];
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self.playerView resetPlayer];
    [self.playerView removeFromSuperview];
    [self.playerView removeObserver:self forKeyPath:@"state"];

}

- (void)setUpTableView{

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.right.left.equalTo(self.view);
        
    }];
    
    self.hud = [[PSYProgresHUD alloc]init];
    self.hud.centerX = self.view.centerX;
    self.hud.centerY = self.view.centerY - NAV_STATUS_HEIGHT;
    [self.view addSubview:self.hud];

}

- (void)setUpTopPlayerView{
    
    self.playerView = [[ZFPlayerView alloc] init];
    self.isPlaying = NO;
    [self.view insertSubview:self.playerView atIndex:0];
    [self.playerView playerControlView:nil playerModel:self.playerModel];
    self.playerView.delegate = self;
    [self.playerView autoPlayTheVideo];
    [self.playerView addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    NSLog(@"%@---%@",keyPath,change);

}

#pragma mark --- zfplayer的delegate

- (void)zf_playerSetProgressForCustomProgressView:(CGFloat)value{

    [self.privateCell.progressView setProgress:value];

}

#pragma mark --- tableView的delegate和datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    NSArray * keysArray = [self getKeysArray];
    
    if(keysArray.count != 0){
    
        NSArray * array = [self.dataDictionary objectForKey:keysArray[section]];
        
        return array.count;
    }else{
    
        return 0;
    
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 65 * FITHEIGHTBASEONIPHONE;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HDStockSayingHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HDStockSayingHistoryCell"];

    HDHeadLineModel * model = [[HDHeadLineModel alloc]init];
    
    NSArray * keysArray = [self getKeysArray];
    
    NSArray * array = [self.dataDictionary objectForKey:keysArray[indexPath.section]];
    
    if (indexPath.section == 0) {
        
        model = array[indexPath.row];
        
    }else if (indexPath.section == 1) {
        
        model = array[indexPath.row];
        
    }else if (indexPath.section == 2) {
        
        model = array[indexPath.row];
        
    }
    
    cell.model = model;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    HDTimeView * view = [[HDTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    
    view.backgroundColor = COLOR(whiteColor);
    
    NSString * timeStr = [self getTimeString:0];
    
    NSArray * keysArray = [self getKeysArray];
    
    if (keysArray.count != 0) {
        
        if ([timeStr isEqualToString:keysArray[0]] && section == 0) {
            
            view.time = @"今日";
        }else{
    
            view.time = keysArray[section];
    
        }
    }else{
    
        view.hidden = YES;
    
    }

    return view;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    
    view.backgroundColor = COLOR(whiteColor);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    HDStockSayingHistoryCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    HDHeadLineModel * model = cell.model;
    
    [self requestData:model.aid];
    
    NSMutableDictionary * muDic = [ZHFactory readPlistWithPlistNameReturnMutableDictionary:plistName];
    
    if (!muDic) {
        
        muDic = @{}.mutableCopy;
    }
    
    [muDic setObject:@"YES" forKey:[NSString stringWithFormat:@"%ld",(long)model.aid]];
    
    [self plistHuanCunWithDic:muDic];
    
    self.audioURL = model.from;
    
    _isPlaying = !_isPlaying;
    if (cell != self.privateCell) {

        [self.playerView resetToPlayNewVideo:self.playerModel];
        self.privateCell.titleLabel.textColor = [UIColor grayColor];
        self.privateCell.progressView.hidden = YES;
        [self.privateCell.progressView setProgress:0];
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"#D42D49"];
        cell.progressView.hidden = NO;
        self.privateCell = cell;
        
        [self.playerView play];
    }else{
    
        if (_isPlaying) {
            
            cell.titleLabel.textColor = [UIColor grayColor];
            [self.playerView pause];
            
        }else{
            
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#D42D49"];
            
            [self.playerView play];
        }
        
    }
    
}

#pragma mark --- 私有方法
- (NSString *)getTimeString:(NSInteger)section{

    NSDate * date = [NSDate date];
    
    NSTimeInterval  oneDay = 24*60*60;  //1天的长度
    
    NSDate * nextDate = [date initWithTimeIntervalSinceNow: - oneDay * section];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString * timeStr = [formatter stringFromDate:nextDate];

    return timeStr;

}

- (void)reSetDataDictionary:(NSMutableDictionary *)dataDic{
    
    for (NSArray * arr in [dataDic allValues]) {
        
        if (arr.count == 0) {
            
            NSString * key = [dataDic allKeysForObject:arr].lastObject;
            
            [dataDic removeObjectForKey:key];
        }
        
    }
    
    NSArray * keyArr = [dataDic allKeys];
    
    NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO]; // 降序
    
    keyArr = [keyArr sortedArrayUsingDescriptors:@[sortDes]];
    [keyArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        if (obj1 > obj2) {
            
            return (NSComparisonResult)NSOrderedDescending;
    
        }
        
        return (NSComparisonResult)NSOrderedAscending;
    }];
    
    int count = 0;
    
    switch (keyArr.count) {
        case 6:
            count = 3;
            break;
        case 5:
            count = 2;
            break;
        case 4:
            count = 1;
            break;
            
        default:
            break;
    }
    
    for (int i = 0; i < count; i ++) {
        NSString * lastKey = keyArr.lastObject;
        
        [dataDic removeObjectForKey:lastKey];
    }
    
}

- (NSArray *)getKeysArray{

    NSArray * keyArr = [self.dataDictionary allKeys];
    
    NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO]; // 降序
    
    keyArr = [keyArr sortedArrayUsingDescriptors:@[sortDes]];
    [keyArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        if (obj1 > obj2) {
            
            return (NSComparisonResult)NSOrderedDescending;
            
        }
        
        return (NSComparisonResult)NSOrderedAscending;
    }];

    return keyArr;

}

//plist缓存
- (void) plistHuanCunWithDic:(NSDictionary *) dic {
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:plistName];
    [dic writeToFile:plistPath atomically:YES];
}

#pragma mark --- 网络请求
- (void)requestStockSayingData{
    
    [_hud showAnimated:YES];
    
    NSString * stockSayingUrl = [NSString stringWithFormat:Home_HeadLineCateNews,1,5,28,@"1",arc4random()%10000];
    WEAK_SELF;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:stockSayingUrl params:nil success:^(id json) {
            
            [self.tableView.mj_header endRefreshing];
    
            NSArray * dataArr = json[@"data"];
            
            NSMutableArray * muArray0 = [[NSMutableArray alloc]init];
            NSMutableArray * muArray1 = [[NSMutableArray alloc]init];
            NSMutableArray * muArray2 = [[NSMutableArray alloc]init];
            NSMutableArray * muArray3 = [[NSMutableArray alloc]init];
            NSMutableArray * muArray4 = [[NSMutableArray alloc]init];
            NSMutableArray * muArray5 = [[NSMutableArray alloc]init];
            
            NSString * timeString0 = [self getTimeString:0];
            NSString * timeString1 = [self getTimeString:1];
            NSString * timeString2 = [self getTimeString:2];
            NSString * timeString3 = [self getTimeString:3];
            NSString * timeString4 = [self getTimeString:4];
            NSString * timeString5 = [self getTimeString:5];
            
            for(int i = 0; i < dataArr.count; i ++){
                
                NSDictionary * dic = [dataArr objectAtIndexCheck:i];
                
                HDHeadLineModel * headlinemodel = [HDHeadLineModel yy_modelWithDictionary:dic];
                
                if ([headlinemodel.MonthAndDayTime isEqualToString:timeString0]) {
                    
                    [muArray0 addObject:headlinemodel];
                }else if ([headlinemodel.MonthAndDayTime isEqualToString:timeString1]) {
                    
                    [muArray1 addObject:headlinemodel];
                }else if ([headlinemodel.MonthAndDayTime isEqualToString:timeString2]) {
                    
                    [muArray2 addObject:headlinemodel];
                }else if ([headlinemodel.MonthAndDayTime isEqualToString:timeString3]) {
                    
                    [muArray3 addObject:headlinemodel];
                }else if ([headlinemodel.MonthAndDayTime isEqualToString:timeString4]) {
                    
                    [muArray4 addObject:headlinemodel];
                }else if ([headlinemodel.MonthAndDayTime isEqualToString:timeString5]) {
                    
                    [muArray5 addObject:headlinemodel];
                }
            }
            [strongSelf.dataDictionary setValuesForKeysWithDictionary:@{timeString0:muArray0,timeString1:muArray1,timeString2:muArray2,timeString3:muArray3,timeString4:muArray4,timeString5:muArray5}];

            [strongSelf reSetDataDictionary:strongSelf.dataDictionary];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [strongSelf.tableView reloadData];
                
                [_hud hideAnimated:YES];
                
            });
            
            
        } failure:^(NSError *error) {
            
            [_hud hideAnimated:YES];
        }];
        
    });
    
}

- (void)requestData:(NSInteger)aid{
    
    NSString * url = [NSString stringWithFormat:NewsDetails,aid,arc4random()%10000];
    
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {

        } failure:^(NSError *error) {
            
        }];
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
