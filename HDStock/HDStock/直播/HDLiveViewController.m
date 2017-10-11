//
//  HDLiveViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/15.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveViewController.h"
#import "HDLiveInerViewController.h"
#import "HDLiveTableViewCell.h"

static NSString * reuseId = @"LiveTBCell";

@interface HDLiveViewController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView * _tb;
    NSInteger perPageDataNum;//一页多少个数据
    NSInteger currentPageIndex;//当前页数
    NSTimer * timerZ;
}
/**直播列表数据数组*/
@property (nonatomic,strong) NSMutableArray * LiveListArr;

@end

@implementation HDLiveViewController


//直播
NSString*const accessKeyID = @"QxJIheGFRL926hFX";
NSString*const accessKeySecret = @"hipHJKpt0TdznQG2J4D0EVSavRH7mR";

-(AliVcAccesskey*)getAccessKeyIDSecret
{
    AliVcAccesskey* accessKey = [[AliVcAccesskey alloc] init];
    accessKey.accessKeyId = accessKeyID;
    accessKey.accessKeySecret = accessKeySecret;
    return accessKey;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    [self setNav];
    [self createTB];
    //直播
    [AliVcMediaPlayer setAccessKeyDelegate:self];
    
}
- (void) setNav {
    self.title = @"直播";
}
- (void) setUp {
    self.view.backgroundColor = UICOLOR(238, 238, 245, 1);
    perPageDataNum = 20;
}
- (NSMutableArray *)LiveListArr {
    if (!_LiveListArr) {
        _LiveListArr = [NSMutableArray new];
    }
    return _LiveListArr;
}
#pragma mark - 创建表格
- (void ) createTB {
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView * tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT-TABBAR_HEIGHT) style:(UITableViewStyleGrouped)];
    tb.tableHeaderView = [[UIView alloc] initWithFrame:CGRM(0, 0, SCREEN_WIDTH, 0.1f)];
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    tb.showsVerticalScrollIndicator = NO;
    tb.delegate = self;
    tb.dataSource = self;
    _tb = tb;
    [self.view addSubview:_tb];
    
    [self registCell];
    
    WEAK_SELF;
    _tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{//下拉刷新
        [weakSelf requestOfLiveListWithFresh:YES];
    }];
    _tb.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{//上拉加载
        [weakSelf requestOfLiveListWithFresh:NO];
    }];
    [_tb.mj_header beginRefreshing];
    
}
- (void) registCell {
    
    [_tb registerNib:[UINib nibWithNibName:@"HDLiveTableViewCell" bundle:nil] forCellReuseIdentifier:reuseId];
}

#pragma mark - UITableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.LiveListArr.count;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDLiveTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDLiveTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.LiveListArr.count > 0) {
        [cell configUIWithModel:self.LiveListArr[indexPath.section]];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0){
        return 10.f;
    }
    return 8.f;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HDLiveInerViewController * vc = [HDLiveInerViewController new];
    HDLiveListModel * model = self.LiveListArr[indexPath.section];

    if (self.LiveListArr.count > 0) {
        if ([model.status isEqualToString:@"2"]) {//视屏直播
            vc.liveStatus = 1;
            vc.zanNumStr = model.people_total;
            //设置直播网址链接
            [self setVedioPlayUrlWithVC:vc liveUrl:@"http://dscj.oss-cn-shanghai.aliyuncs.com/record/dscj/dscj_73.m3u8"];
        }else if ([model.status isEqualToString:@"1"]) {//文字直播
            vc.liveStatus = 2;
            [self.navigationController pushViewController:vc animated:NO];
        }else{//未直播
            vc.liveStatus = 3;
        }
    }
}

- (void) setVedioPlayUrlWithVC:(HDLiveInerViewController*)vc liveUrl:(NSString*)urlStr{
    //    NSURL* url = [NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
    //    NSURL* url = [NSURL URLWithString:@"http://dscj.oss-cn-shanghai.aliyuncs.com/record/dscj/dscj_73.m3u8"];

    NSURL* url = [NSURL URLWithString:urlStr];
    if (url == nil) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"错误" message:@"直播地址无效" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
        return;
    }
    
    [vc SetMoiveSource:url];
    [self.navigationController pushViewController:vc animated:NO];
}


#pragma mark - 网络请求
- (void) requestOfLiveListWithFresh:(BOOL)isRefresh {

#warning 记得上线时去掉参数里的随机数
    NSInteger randomStr = arc4random();
    NSLog(@"%@",[NSString stringWithFormat:@"%ld",(long)randomStr]);
    [[CDAFNetWork sharedMyManager] get:LIVEROOM_LIST_URL params:@{@"mod":@"public",@"act":@"room_list",@"ajax":@"1",@"randm":[NSString stringWithFormat:@"%ld",(long)randomStr]} success:^(id json) {
        NSLog(@"json--%@",json);
        if ([json isKindOfClass:[NSDictionary class]] && [json[@"data"] isKindOfClass:[NSArray class]] && [json[@"data"] count] > 0) {//数据格式正确并有数据
            if (isRefresh) {//下拉刷新
                [self.LiveListArr removeAllObjects];
            }
            for (NSDictionary * tempDic in json[@"data"]) {
                HDLiveListModel * tempModel = [HDLiveListModel new];
                [tempModel setValuesForKeysWithDictionary:tempDic];
                [self.LiveListArr addObject:tempModel];
            }
            [self thyEndrefreshWithArr:json];//结束刷新
            [_tb reloadData];
        }else {
            NSLog(@"%s直播列表没有数据／格式改变了",__func__);
            [_tb.mj_header endRefreshing];
            [_tb.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error--%@",error);
        [_tb.mj_header endRefreshing];
        [_tb.mj_footer endRefreshing];
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
