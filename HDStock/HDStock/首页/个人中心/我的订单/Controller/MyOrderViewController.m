//
//  MyOrderViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/12.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderTableViewCell.h"//订单cell//裸168
#import "fullPageFailLoadView.h"
#import "MyOrderList.h"
#import "HDLiveSubmitOrderViewController.h"
#import "nothingContainView.h"//没得东西
@interface MyOrderViewController ()<UITableViewDataSource,UITableViewDelegate,fullPageFailLoadViewDelegate>
@property (nonatomic,strong) nothingContainView * nothingContain;
@end

@implementation MyOrderViewController{
    NSMutableArray *dataArr;
    fullPageFailLoadView *fullFailLoad;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeader:@"我的订阅"];
    [self initScrollView];
    [self setTableViewsWithCellKindsArray:@[@""]];
    [self setTableView];
    fullFailLoad = [[fullPageFailLoadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];;
    fullFailLoad.delegate = self;
    [self.view addSubview:fullFailLoad];
    [fullFailLoad showWithAnimation];
    
//    nothingContain =
    
    [self loadDataOfOrder];
    if(!dataArr){
        dataArr = @[].mutableCopy;
    }
}

-(nothingContainView *)nothingContain{
    if(!_nothingContain){
        _nothingContain =[[nothingContainView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        [self.view addSubview:_nothingContain];
    }
    return _nothingContain;
}

- (void)setTableView{
    [self.scrollView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.backgroundColor = BACKGROUNDCOKOR;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyOrderTableViewCell"];
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    WEAK_SELF;
    self.tableView1.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
        [dataArr removeAllObjects];
        [weakSelf loadDataOfOrder];
    }];
    
    self.tableView1.mj_footer = [PSYRefreshGifFooter footerWithRefreshingBlock:^{
        [dataArr removeAllObjects];
        [weakSelf loadDataOfOrder];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView1){
        MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderTableViewCell"];
        cell.model = dataArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.block = ^(NSString *price,NSString * productId){
            HDLiveSubmitOrderViewController * submitOrder = [[HDLiveSubmitOrderViewController alloc]init];
            submitOrder.needPayMoneyStr = price;
            submitOrder.productId = productId;
            [self.navigationController pushViewController:submitOrder animated:YES];
        };
        return cell;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView1) {
        return  168;
    }else{
        return 0;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

- (void)loadDataOfOrder{
    
    NSDictionary *dic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
    if([dic[PCUserState] isEqualToString:@"success"]){
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        [mutDic setObject:dic[PCUserToken] forKey:@"token"];
//        http://gkc.cdtzb.com/api/order/orderlist/token
        NSString * url = [NSString stringWithFormat:@"%@%@",@"http://gkc.cdtzb.com/api/order/orderlist/",dic[PCUserToken]];
        WEAK_SELF;
        STRONG_SELF;
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            if([json[@"data"] isKindOfClass:[NSNull class]]){
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"没有更多数据了";
                [hud hideAnimated:YES afterDelay: 1];
                [self endRefresh];
            }else{
                for (NSDictionary *dic in json[@"data"]) {
                    MyOrderList *model = [MyOrderList yy_modelWithDictionary:dic];
                    [dataArr addObject:model];
                }
                [self.tableView1 reloadData];
                if(dataArr.count ==0){
                    [self.nothingContain show];
                }else{
                    [self.nothingContain hide];
                }
                [self endRefresh];
            }
            [fullFailLoad hide];
        } failure:^(NSError *error) {
            [fullFailLoad showWithoutAnimation];
        }];
    }
    else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请先登录";
        [hud hideAnimated:YES afterDelay: 1];
    }
    
}

-(void)popMenuDidClickRefresh:(fullPageFailLoadView *)popMenu{
    [popMenu.fullfailLoad hideTheSubViews];
    [self loadDataOfOrder];
}

-(void)endRefresh{
    [self.tableView1.mj_header endRefreshing];
    [self.tableView1.mj_footer endRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [fullFailLoad hide];
    [self.nothingContain hide];
}

@end
