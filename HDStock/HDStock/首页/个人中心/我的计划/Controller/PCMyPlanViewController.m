//
//  PCMyPlanViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/14.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCMyPlanViewController.h"
#import "MyPlanTableViewCell.h"
#import "fullPageFailLoadView.h"
#import "MyPlanModel.h"
#import "MyPlanDetailViewController.h"
@interface PCMyPlanViewController ()<UITableViewDataSource,UITableViewDelegate,fullPageFailLoadViewDelegate>

@end

@implementation PCMyPlanViewController{
    fullPageFailLoadView * failLoadView;
    NSMutableArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeader:@"投顾计划"];
    [self initScrollView];
    [self setTableViewsWithCellKindsArray:@[@""]];
    [self setTableView];
    
    failLoadView = [[fullPageFailLoadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];;
    failLoadView.delegate = self;
    [self.view addSubview:failLoadView];
    [failLoadView showWithAnimation];
    
    [self loadDataOfMyPlan];
    if(!dataArr){
        dataArr =@[].mutableCopy;
    }
}


- (void)setTableView{
    [self.scrollView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.backgroundColor = BACKGROUNDCOKOR;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"MyPlanTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyPlanTableViewCell"];
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    WEAK_SELF;
    self.tableView1.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
        [dataArr removeAllObjects];
        [weakSelf loadDataOfMyPlan];
    }];
    
    self.tableView1.mj_footer = [PSYRefreshGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataOfMyPlan];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView1){
        MyPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyPlanTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(dataArr.count>0){
            cell.model = dataArr[indexPath.row];
        }
        return cell;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView1) {
        return  283*SCREEN_WIDTH/375+10;
    }else{
        return 0;
    }
}

- (void)loadDataOfMyPlan{
    NSString *url = @"http://gk.cdtzb.com/api/investment/index";
    [dataArr removeAllObjects];
    [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
        if([json[@"data"] isKindOfClass:[NSNull class]]){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"没有更多数据了";
            [hud hideAnimated:YES afterDelay: 1];
            [self endRefresh];
        }else{
            for (NSDictionary *dic in json[@"data"]) {
                MyPlanModel *model = [MyPlanModel yy_modelWithDictionary:dic];
                [dataArr addObject:model];
            }
            [self.tableView1 reloadData];
            [self endRefresh];
        }
        [failLoadView hide];
    } failure:^(NSError *error) {
        [failLoadView showWithoutAnimation];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [failLoadView hide];
}

-(void)endRefresh{
    [self.tableView1.mj_header endRefreshing];
    [self.tableView1.mj_footer endRefreshing];
    [self.tableView2.mj_header endRefreshing];
    [self.tableView2.mj_footer endRefreshing];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyPlanModel *model = dataArr[indexPath.row];
    MyPlanDetailViewController *deltal = [[MyPlanDetailViewController alloc]init];
    deltal.urlStr = model.url;
    [self.navigationController pushViewController:deltal animated:YES];
}

-(void)popMenuDidClickRefresh:(fullPageFailLoadView *)popMenu{
    [popMenu.fullfailLoad hideTheSubViews];
    [self loadDataOfMyPlan];
}



@end
