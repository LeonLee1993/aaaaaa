//
//  HDLiveHistoryLiveDetailViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/29.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveHistoryLiveDetailViewController.h"
#import "HDLiveHistoryDetailModel.h"
#import "HDLiveHistoryDetailTableViewCell.h"

static NSString * const reuseId = @"HDLiveHistoryDetailTableViewCell";

@interface HDLiveHistoryLiveDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    UITableView*_tb;
    NSInteger perPageDataNum;//一页多少个数据
    NSInteger currentPageIndex;//当前页数
}
@property (nonatomic,strong) NSMutableArray * dataArr;

@end

@implementation HDLiveHistoryLiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self createGropedTB];
    
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (void) setNav {
     self.title = self.vcTitleStr;
    [self setNormalBackNav];
    self.view.backgroundColor = UICOLOR(239, 238, 244, 1);
    perPageDataNum = 20;
}

- (void ) createGropedTB {
    
    UITableView * tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT - NAV_STATUS_HEIGHT-46) style:(UITableViewStyleGrouped)];
    tb.tableFooterView = [[UIView alloc] init];
    tb.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tb.bounds.size.width, 0.01f)];
    tb.tableHeaderView.backgroundColor = UICOLOR(239, 238, 244, 1);
    tb.delegate = self;
    tb.dataSource = self;
    tb.showsVerticalScrollIndicator = NO;
    tb.separatorStyle = UITableViewCellSelectionStyleNone;
    _tb = tb;
    [self.view addSubview:_tb];
    
    //注册cell
//    [_tb registerNib:[UINib nibWithNibName:@"HDLiveHistoryDetailTableViewCell" bundle:nil] forCellReuseIdentifier:reuseId];
    
    [_tb registerClass:NSClassFromString(@"HDLiveHistoryDetailTableViewCell") forCellReuseIdentifier:reuseId];
    //加载数据
    WEAK_SELF;
    _tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestOfLiveHistoryDetailWithFresh:YES];
    }];
//    _tb.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf requestOfLiveHistoryDetailWithFresh:NO];
//    }];
    [_tb.mj_header beginRefreshing];
    
//    [self requestOfLiveHistoryDetail];
    
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArr.count>0) {
        return self.dataArr.count;
    }
    return 0;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArr.count > 0) {
        HDLiveHistoryDetailModel * model = (HDLiveHistoryDetailModel*)self.dataArr[indexPath.section];
        return model.cellHeight;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 20;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDLiveHistoryDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[HDLiveHistoryDetailTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseId];
    }
    cell.contentView.backgroundColor = UICOLOR(239, 238, 244, 1);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count > 0) {
        HDLiveHistoryDetailModel * model = (HDLiveHistoryDetailModel *)self.dataArr[indexPath.section];
        [cell configUIWithModel:model];
    }
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDLiveHistoryDetailModel * model = (HDLiveHistoryDetailModel*)self.dataArr[indexPath.section];
    [model setCellMaxHeight];
    HDLiveHistoryDetailTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.bgView.frame = model.bgViewFrame;
    cell.titleLabl.frame = model.titleLablFrame;
    [self.dataArr replaceObjectAtIndex:indexPath.section withObject:model];
    [tableView reloadRow:0 inSection:indexPath.section withRowAnimation:(UITableViewRowAnimationNone)];
//    [tableView reloadr]
}

#pragma mark- 网络请求
- (void) requestOfLiveHistoryDetailWithFresh:(BOOL)isRefresh {
//    NSDictionary * dic = @{
//                           @"time":@"10:49",
//                           @"title":@"提示：大盘大跌，国元证券逆势飙涨吸睛。",
//                           };
//    NSDictionary * dic2 = @{@"time":@"10:48",
//                            @"title":@"这一波恐慌性的杀跌，我希望大家不要跟着恐慌啦, 七公个人建议大家手里的黄金可以去砸盘，获利出 了这一波恐慌性的杀跌，我希望大家不要跟着恐慌啦, 七公个人建议大家手里的黄金可以去砸盘，获利出 了这一波恐慌性的杀跌，我希望大家不要跟着恐慌啦, 七公个人建议大家手里的黄金可以去砸盘，获利出 了"};
//    NSDictionary * dic3 = @{@"time":@"10:47",
//                            @"title":@"哇塞，300175 竟然这样拉升，之前我们操作的个股 当时的小阴小阳爬升今天在这样的环境下，竟然爆发 了"};
//    
//    NSDictionary * dic4 = @{@"time":@"10:46",
//                            @"title":@"本直播室百宝箱《金秋十月包月投资计划》有更新， 请尽快查看。"
//                            };
//    NSArray * arr = @[dic,dic2,dic3,dic4];
//    
//    for (int i = 0; i < 4; i++) {
//        HDLiveHistoryDetailModel * model = [[HDLiveHistoryDetailModel alloc] initWithDict:arr[i]];
//        [self.dataArr addObject:model];
//    }
//    //结束刷新
//    [self thyEndrefreshWithArr:self.dataArr];
    
    
    [[CDAFNetWork sharedMyManager] get:[NSString stringWithFormat:@"http://test.cdtzb.com/%@",LIVEROOM_HISTORY_DETAIL_URL] params:nil success:^(id json) {
        NSLog(@"%@",json);
        
        if ([json isKindOfClass:[NSDictionary class]] && [json[@"data"] isKindOfClass:[NSDictionary class]] && [json[@"data"][@"info"] isKindOfClass:[NSArray class]]&&[json[@"data"][@"info"] count] > 0) {
            
            for (int i = 0; i < [json[@"data"][@"info"] count]; i++) {
                NSDictionary * tempDic = json[@"data"][@"info"][i];
                HDLiveHistoryDetailModel * detailModel = [HDLiveHistoryDetailModel new];
                [detailModel setValuesForKeysWithDictionary:tempDic];
                [self.dataArr addObject:detailModel];
            }
            //年月日
            HDLiveHistoryDetailModel * detailModel = self.dataArr[0];
            self.dateLabl.text = [NSString stringWithFormat:@"%@年%@月%@日",detailModel.y,detailModel.m,detailModel.d];
        }else {
            NSLog(@"没数据/后台数据格式改变了");
        }
        [_tb.mj_header endRefreshing];
        [_tb reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [_tb.mj_header endRefreshing];
    }];
}
- (void) thyEndrefreshWithArr:(NSArray*)arr {
    [_tb.mj_header endRefreshing];
    if ([arr count] < perPageDataNum) {//没有更多数据
        [_tb.mj_footer endRefreshingWithNoMoreData];
    }else {
        [_tb.mj_footer endRefreshing];
    }
    [_tb reloadData];
}

#pragma mark - UIScrollViewDelegate


#pragma mark -foo
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
