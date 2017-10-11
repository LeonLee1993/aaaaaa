//
//  HDGuPingViewController.m
//  HDStock
//  直播-直播内页-股评
//  Created by hd-app01 on 16/11/11.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDGuPingViewController.h"
#import "HDLiveGuPingTableViewCell.h"
#import "HDLiveGuPingModel.h"
#import "HeadLineViewController.h"
#import "HDHeadLineModel.h"

static NSString * reuseId = @"guPingCell";

@interface HDGuPingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSInteger perPageDataNum;//一页多少个数据
    NSInteger currentPageIndex;//当前页数
    
}

@property (nonatomic,strong) NSMutableArray<HDLiveGuPingModel*> * dataArr;

@end

@implementation HDGuPingViewController



- (void)viewDidLoad {
    [super viewDidLoad];

//    [self fitFrame];
    [self setUp];
    [self createTB];
    
}
//懒加载
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
        [_dataArr addObjectsFromArray:@[@"",@"",@"",@"",@"",@""]];
    }
    return _dataArr;
}



- (void) fitFrame {
    CGRect frame = self.view.frame;
    frame.size.height = SCREEN_HEIGHT-NAV_STATUS_HEIGHT-SCREEN_SIZE_WIDTH*9.0/16-90;
    self.view.frame = frame;
}
- (void) setUp {
    perPageDataNum = 50;
    currentPageIndex = 0;
}
#pragma mark - 创建表格
- (void ) createTB {
    
    UITableView * tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, self.view.frame.size.height) style:(UITableViewStylePlain)];
    tb.tableFooterView = [[UIView alloc] init];
    tb.delegate = self;
    tb.dataSource = self;
//    tb.bounces = NO;
    tb.showsVerticalScrollIndicator = NO;
    _tb = tb;
    [self.view addSubview:_tb];
    
    //注册cell
    [self registCell];
    
    //网络请求
    WEAK_SELF;
    _tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        STRONG_SELF;
        [strongSelf requstOfJinNang];
    }];
    
    _tb.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        STRONG_SELF;
        [strongSelf requstOfJinNang];
    }];
//    [_tb.mj_header beginRefreshing];
    
}
- (void) registCell {
    [_tb registerNib:[UINib nibWithNibName:@"HDLiveGuPingTableViewCell" bundle:nil] forCellReuseIdentifier:reuseId];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDLiveGuPingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDLiveGuPingTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //赋值
//    if (self.dataArr.count > 0) {
//        HDLiveGuPingModel * model = [HDLiveGuPingModel new];
//        [cell configUIWIthModel:model];
//    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //跳转到股评详情页
    HeadLineViewController * guPingVC = [HeadLineViewController new];
    guPingVC.aid = 2;
    [self.navigationController pushViewController:guPingVC animated:YES];
}
#pragma mark -网络请求
- (void) requstOfJinNang {
    
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
