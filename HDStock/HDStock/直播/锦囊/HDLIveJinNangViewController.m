//
//  HDLIveJinNangViewController.m
//  HDStock
//  直播－锦囊
//  Created by hd-app01 on 16/11/21.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLIveJinNangViewController.h"
#import "HDLiveJinNangTableViewCell.h"
#import "HDLiveJinNangModel.h"

//表格复用标记
static NSString * reuseId = @"LiveJinNangCell";
static NSString * reusedHeaderView = @"reusedHeader";

@interface HDLIveJinNangViewController ()<UITableViewDelegate,UITableViewDataSource>{
//    UITableView *_tb;//表格
    NSInteger perPageDataNum;//一页多少个数据
    NSInteger currentPageIndex;//当前页数
    
}
@property (nonatomic,strong) NSMutableArray<HDLiveJinNangModel*> * dataArr;

@end

@implementation HDLIveJinNangViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self fitFrame];
    [self setUp];
    [self createGropedTB];
    
}
//懒加载
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
        [_dataArr addObjectsFromArray:@[@"",@"",@"",@"",@"",@""]];
    }
    return _dataArr;
}
//设置self.view的高度
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
- (void ) createGropedTB {
    
    UITableView * tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, self.view.frame.size.height) style:(UITableViewStyleGrouped)];
    tb.separatorStyle = UITableViewCellSelectionStyleNone;
    tb.delegate = self;
    tb.dataSource = self;
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
    
    _tb.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        STRONG_SELF;
        [strongSelf requstOfJinNang];
    }];
    
//    [_tb.mj_header beginRefreshing];
    
}
- (void) registCell {
    [_tb registerNib:[UINib nibWithNibName:@"HDLiveJinNangTableViewCell" bundle:nil] forCellReuseIdentifier:reuseId];

}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 191;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.0f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView * tempHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusedHeaderView];
    if (!tempHeaderView) {
        tempHeaderView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:reusedHeaderView];
        tempHeaderView.backgroundColor = UICOLOR(238, 238, 245, 1);
    }
    return tempHeaderView;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDLiveJinNangTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDLiveJinNangTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //有值即可赋值
//    if (self.dataArr.count > 0) {
//        HDLiveJinNangModel * model = self.dataArr[indexPath.section];
//        [cell configUIWithModel:model];
//    }
    
    return cell;
}


#pragma mark -网络请求
- (void) requstOfJinNang {
    
}


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
