//
//  PCMCThirdViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//
#pragma mark ---- 活动消息

#import "PCMCThirdViewController.h"
#import "PCMCThirdTableViewCell.h"
#import "fullPageFailLoadView.h"
#import "nothingContainView.h"//没得东西
#import "systemMessageModel.h"//和系统消息的Model一样的
#import "PCinviteMyFriendsViewController.h"
@interface PCMCThirdViewController ()<UITableViewDataSource,UITableViewDelegate,fullPageFailLoadViewDelegate>
@property (nonatomic,strong) UITableView * tableView1;
@property (nonatomic,strong) nothingContainView * nothingContain;

@end

@implementation PCMCThirdViewController{
    fullPageFailLoadView * failLoadView;
    NSMutableArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.tableView1){
        self.tableView1 = [[UITableView alloc]init];
    }
    self.title = @"活动消息";
    if(!dataArr){
        dataArr = @[].mutableCopy;
    }
    [self setTableView];
    failLoadView = [[fullPageFailLoadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:failLoadView];
    failLoadView.delegate = self;
    [failLoadView showWithAnimation];
    [self loadDataOfPersonalCenter];
}

-(nothingContainView *)nothingContain{
    if(!_nothingContain){
        _nothingContain =[[nothingContainView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        [self.view addSubview:_nothingContain];
    }
    return _nothingContain;
}

- (void)alreadyReadMessage:(NSString *)url{
    [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)setTableView{
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.backgroundColor = BACKGROUNDCOKOR;
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"PCMCThirdTableViewCell" bundle:nil] forCellReuseIdentifier:@"PCMCThirdTableViewCell"];
    self.tableView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:_tableView1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCMCThirdTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"PCMCThirdTableViewCell"];
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(dataArr.count>0){
        tableViewCell.model = dataArr[indexPath.row];
    }
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableViewCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_WIDTH/375*186;
}

- (void)loadDataOfPersonalCenter{
//    userInfoDic[PCUserToken]/
    [dataArr removeAllObjects];
    NSDictionary *userInfoDic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/type/1",@"http://gkc.cdtzb.com/api/message/fetch_all_by_uid_type/token/",userInfoDic[PCUserToken]];
    NSString *alreadyReadUrl = [NSString stringWithFormat:@"%@%@/type/1",@"http://gkc.cdtzb.com/api/message/look_at/token/",userInfoDic[PCUserToken]];
    [[CDAFNetWork sharedMyManager]get:urlStr params:nil success:^(id json) {
        if([json[@"code"] isEqual:@(1)]){
            for (NSDictionary *dic in json[@"data"]) {
                systemMessageModel *model = [systemMessageModel yy_modelWithDictionary:dic];
                [dataArr addObject:model];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self alreadyReadMessage:alreadyReadUrl];
                
            });
            
        }else{
            NSLog(@"获取失败");
        }
        if(dataArr.count ==0){
            [self.nothingContain show];
        }else{
            [self.nothingContain hide];
            [self.tableView1 reloadData];
        }
        [failLoadView hide];
    } failure:^(NSError *error) {
        [failLoadView showWithoutAnimation];
    }];
}

-(void)popMenuDidClickRefresh:(fullPageFailLoadView *)popMenu{
    [popMenu.fullfailLoad hideTheSubViews];
    [self loadDataOfPersonalCenter];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PCinviteMyFriendsViewController *detail = [[PCinviteMyFriendsViewController alloc]init];
    systemMessageModel * model = dataArr[indexPath.row];
    detail.urlStr = model.link_url;
    detail.titelStr = model.content;
    [self.navigationController pushViewController:detail animated:YES];
}


@end
