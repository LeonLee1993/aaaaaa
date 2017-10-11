//
//  HDMarketDetailViewController.m
//  HDStock
//
//  Created by liyancheng on 16/11/23.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDMarketDetailViewController.h"
#import "HDMarkerDetailFirstTableViewCell.h"
#import "MarkerSecondTableViewCell.h"
#import "MarketThirdTableViewCell.h"
#import "bottonImageButton.h"
#import <WebKit/WebKit.h>
#import "HDLeftPersonalViewController.h"
#import "AppDelegate.h"
#import "fullScreenDataModel.h"
#import "fullPageFailLoadView.h"
//#import "MarketRefreshButton.h"
#import "RefreshButtonOfMarket.h"

#define realWidth [[UIScreen mainScreen] bounds].size.width
#define realHeight [[UIScreen mainScreen] bounds].size.height
@interface HDMarketDetailViewController ()<UITableViewDelegate,UITableViewDataSource,fullPageFailLoadViewDelegate>
@property (nonatomic,copy) UITableView * tableView;
@property (nonatomic,strong) WKWebView * webView;
@end
typedef enum {
    RotateStateStop,
    RotateStateRunning,
}RotateState;
@implementation HDMarketDetailViewController{
    UIView * navView;
    NSMutableArray *dataArr;
    fullPageFailLoadView * fullFailLoad;
    UIButton *refreshButtonG;
    
    ///旋转角度
    CGFloat imageviewAngle;
    ///旋转ImageView
    UIImageView *imageView;
    ///旋转状态
    RotateState rotateState;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    HDLeftPersonalViewController *vc = (HDLeftPersonalViewController*)app.window.rootViewController;
    vc.panGes.enabled = NO;
    self.pan.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",@"http://tzb.cndzsp.com/klink_m2/?securityID=",_codeStr];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    [self buildBarButtonItem];
    
    [self setUpTableView];
    fullFailLoad = [[fullPageFailLoadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];;
    fullFailLoad.delegate = self;
    [self.view addSubview:fullFailLoad];
    [fullFailLoad showWithAnimation];
    
    [self updateStockFullScreenData];
}

- (void)refreshButtonClicked:(UIButton *)sender{
//    sender.selected = YES;
    refreshButtonG.selected = YES;
    [self updateStockFullScreenDataed];
}

-(WKWebView *)webView{
    if(_webView == nil){
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)setBottomView{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, realHeight-45, realWidth, 45)];
    bottomView.backgroundColor = RGBCOLOR(221, 221, 221);
    bottonImageButton * button = [[bottonImageButton alloc]initWithFrame:CGRectMake(0, 0, realWidth/3-1, 41)];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), 9, 1, 23)];
    [button setTitle:@"问股" forState:UIControlStateNormal];
    lineView.backgroundColor = RGBCOLOR(204, 204, 204);
    [bottomView addSubview:button];
    [bottomView addSubview:lineView];
    
    bottonImageButton * button1 = [[bottonImageButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame), 0, realWidth/3-1, 41)];
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button1.frame), 9, 1, 23)];
    [button1 setTitle:@"提醒" forState:UIControlStateNormal];
    lineView1.backgroundColor = RGBCOLOR(204, 204, 204);
    [bottomView addSubview:button1];
    [bottomView addSubview:lineView1];
    
    bottonImageButton * button2 = [[bottonImageButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame), 0, realWidth/3, 41)];
    [bottomView addSubview:button2];
    [button2 setTitle:@"加入自选" forState:UIControlStateNormal];
    [self.view addSubview:bottomView];
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, realWidth, realHeight-45)];
    _tableView.backgroundColor = BACKGROUNDCOKOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"HDMarkerDetailFirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDMarkerDetailFirstTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MarkerSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"MarkerSecondTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MarketThirdTableViewCell" bundle:nil] forCellReuseIdentifier:@"MarketThirdTableViewCell"];
    [self.view addSubview:_tableView];
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0||section==1){
        return 1;
    }else{
        return 10;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0){
        HDMarkerDetailFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDMarkerDetailFirstTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(dataArr.count>0){
            cell.model = dataArr[0];
        }
        return cell;
    }else if (indexPath.section ==1){
        MarkerSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarkerSecondTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.stockIdStr = self.codeStr;
        cell.setTableView = @"setTableView";
//        if(dataArr.count>0){
            [cell fetchData];
//        }
        return cell;
    }else if (indexPath.section ==2){
        MarketThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarketThirdTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tempFlag = @"股评天下:炒高送转题材要避免4个误区";
        return cell;
    }
    else
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 200;
    }
    else if (indexPath.section == 1){
        return 300;
    }
    else if (indexPath.section == 2){
        return 49*realWidth/375;
    }
    else{
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 2){
        return 41;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, realWidth, 43)];
    //    tableHeadView.backgroundColor = UICOLOR(102, 102, 102, 1);
    tableHeadView.backgroundColor = BACKGROUNDCOKOR;
    UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 100, 15)];
    titleLable.textColor = UICOLOR(51, 51, 51, 1);
    titleLable.font = [UIFont systemFontOfSize:15];
    titleLable.text = @"新闻";
    titleLable.textAlignment = NSTextAlignmentLeft;
    [tableHeadView addSubview:titleLable];
    return tableHeadView;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [navView removeFromSuperview];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    HDLeftPersonalViewController *vc = (HDLeftPersonalViewController*)app.window.rootViewController;
    vc.panGes.enabled = YES;
}

- (void)updateStockFullScreenData {
    [self.tableView reloadData];
//    if(!dataArr){
//        dataArr = @[].mutableCopy;
//    }
//    [dataArr removeAllObjects];
//    WEAK_SELF;
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
////    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        NSString *mutStr = [NSString stringWithFormat:@"http://tzb.cndzsp.com/klink/getHq.php?securityID=%@&%u",self.codeStr,arc4random()%10000];
//        [manager GET:mutStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            
//            if([responseObject[@"code"] isEqual:@(1)]){
//                fullScreenDataModel *model = [[fullScreenDataModel alloc]initWithDictionary:responseObject[@"data"]];
//                [dataArr addObject:model];
                [fullFailLoad hide];
//            }
//                [self.tableView reloadData];
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [weakSelf updateStockFullScreenData];
//        }];
//    });
}

- (void)updateStockFullScreenDataed {
    
    if(!dataArr){
        dataArr = @[].mutableCopy;
    }
    [dataArr removeAllObjects];
    WEAK_SELF;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    NSString *mutStr = [NSString stringWithFormat:@"http://tzb.cndzsp.com/klink/getHq.php?securityID=%@&%u",self.codeStr,arc4random()%10000];
    [manager GET:mutStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if([responseObject[@"code"] isEqual:@(1)]){
            fullScreenDataModel *model = [[fullScreenDataModel alloc]initWithDictionary:responseObject[@"data"]];
            [dataArr addObject:model];
        }
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
        refreshButtonG.selected = NO;
        rotateState = RotateStateStop;
        [self rotateAnimate];
        refreshButtonG.userInteractionEnabled = YES;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"已刷新";
        [hud hideAnimated:YES afterDelay: 1];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf updateStockFullScreenDataed];
    }];
}

-(void)popMenuDidClickRefresh:(fullPageFailLoadView *)popMenu{
    [popMenu.fullfailLoad hideTheSubViews];
    [self updateStockFullScreenData];
}

-(void)buildBarButtonItem{
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh"]];
    imageView.autoresizingMask = UIViewAutoresizingNone;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.bounds=CGRectMake(0, 0, 20, 20);
    //设置视图为圆形
    imageView.layer.masksToBounds=YES;
//    imageView.layer.cornerRadius=20.f;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButtonG = button;
    button.frame = CGRectMake(0, 0, 20, 20);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(animate) forControlEvents:UIControlEventTouchUpInside];
    imageView.center = button.center;
    //设置RightBarButtonItem
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barItem;
}
#pragma mark 点击 RightBarButtonItem
- (void)animate {
    //改变ImageView旋转状态
    refreshButtonG.userInteractionEnabled = NO;
    rotateState = RotateStateRunning;
    [self rotateAnimate];
    [self updateStockFullScreenDataed];
}
#pragma mark 旋转动画
-(void)rotateAnimate{
    if(rotateState==RotateStateRunning){
        CABasicAnimation *anim = [CABasicAnimation animation];
        anim.keyPath = @"transform.rotation.z";
        anim.toValue = @(M_PI*2);
        anim.repeatCount = MAXFLOAT;
        anim.duration = 1;
        [imageView.layer addAnimation:anim forKey:nil];
    }else{
        [imageView.layer removeAllAnimations];
    }
}

-(void)dealloc{
    NSLog(@"dealloc");
}


@end
