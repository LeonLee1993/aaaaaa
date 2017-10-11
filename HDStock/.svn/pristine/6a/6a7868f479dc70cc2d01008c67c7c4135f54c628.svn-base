//
//  HDLiveLookHistoryLiveListViewController.m
//  HDStock
//  z直播－直播内页－查看历史
//  Created by hd-app01 on 16/11/29.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveLookHistoryLiveListViewController.h"
#import "HDLiveHistoryLiveDetailViewController.h"
#import "ZHLiveLookHistoryListTableViewCell.h"
#import "HDLiveLookHistoryModel.h"

static NSString * const reuseId = @"hdLiveHistoryCell";

@interface HDLiveLookHistoryLiveListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tb;
    
}

@property (nonatomic,strong) NSMutableArray * dataArr;

@end

@implementation HDLiveLookHistoryLiveListViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    [self setNormalBackNav];
    [self createGropedTB];
    
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    
    return _dataArr;
}
- (void) backItemWithCustemViewBtnClicked {
    [super backItemWithCustemViewBtnClicked];
    if (self.pausePlayerWhenPushBlock) {
        self.pausePlayerWhenPushBlock();
    }
}
- (void) setUp {
    self.title = @"历史直播";
}

#pragma mark - 创建表格
- (void ) createGropedTB {
    
    UITableView * tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT-NAV_STATUS_HEIGHT) style:(UITableViewStyleGrouped)];
    tb.tableFooterView = [[UIView alloc] init];
    tb.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tb.bounds.size.width, 0.01f)];
    tb.delegate = self;
    tb.dataSource = self;
    tb.showsVerticalScrollIndicator = NO;
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tb = tb;
    [self.view addSubview:_tb];
    
    [_tb registerNib:[UINib nibWithNibName:@"ZHLiveLookHistoryListTableViewCell" bundle:nil] forCellReuseIdentifier:reuseId];
    
    WEAK_SELF;
    _tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        STRONG_SELF;
        [strongSelf requstOfHistoryList];
    }];
    
//    _tb.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        STRONG_SELF;
//        [strongSelf requstOfHistoryList];
//    }];
    
    [_tb.mj_header beginRefreshing];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArr.count > 0) {
        return self.dataArr.count;
    }
    return 0;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHLiveLookHistoryListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZHLiveLookHistoryListTableViewCell.h" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArr.count > 0) {
        [cell configUIWithModel:self.dataArr[indexPath.section]];
    }
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDLiveHistoryLiveDetailViewController * detailVC = [HDLiveHistoryLiveDetailViewController new];
    HDLiveLookHistoryModel * model = self.dataArr[indexPath.section];
    detailVC.vcTitleStr = model.title;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark -网络请求
- (void) requstOfHistoryList {
    
    [[CDAFNetWork sharedMyManager] get:[NSString stringWithFormat:@"http://test.cdtzb.com/%@",LIVEROOM_HISTORY_URL] params:nil success:^(id json) {
        NSLog(@"%@",json);
        
        if ([json isKindOfClass:[NSDictionary class]] && [json[@"data"] isKindOfClass:[NSArray class]] && [json[@"data"] count]>0) {
            
            for (int i = 0; i < [json[@"data"] count]; i++) {
                NSDictionary * tempDic = json[@"data"][i];
                HDLiveLookHistoryModel * historyModel = [HDLiveLookHistoryModel new];
                [historyModel setValuesForKeysWithDictionary:tempDic];
                [self.dataArr addObject:historyModel];
            }
            
            //[self thyEndrefreshWithArr:json];//结束刷新
            [_tb.mj_header endRefreshing];
            [_tb reloadData];
            
        }else {
            //
            NSLog(@"没数据/后台数据格式改变了");
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [_tb.mj_header endRefreshing];
    }];
}


- (void) thyEndrefreshWithArr:(NSArray*)arr {
//    [_tb.mj_header endRefreshing];
//    if ([arr count] < perPageDataNum) {//没有更多数据
//        [_tb.mj_footer endRefreshingWithNoMoreData];
//    }else {
//        [_tb.mj_footer endRefreshing];
//    }
//    [_tb reloadData];
}


#pragma mark - foo
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
