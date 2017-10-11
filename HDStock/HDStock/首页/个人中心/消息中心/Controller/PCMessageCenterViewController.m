//
//  PCMessageCenterViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCMessageCenterViewController.h"
#import "PCMessageCenterTableViewCell.h"
#import "MessageCenterModel.h"
#import "PCMCFirsrController.h"//互动消息
#import "PCMCSecondViewController.h"//系统通知
#import "PCMCThirdViewController.h"//活动消息
#import "PCMCForthViewController.h"//新股申购
#import "fullPageFailLoadView.h"
#import "NewShareModel.h"
@interface PCMessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource,fullPageFailLoadViewDelegate>

@end

@implementation PCMessageCenterViewController{
    NSMutableArray *messageSourceArr;
    fullPageFailLoadView * failLoadView;
    NewShareModel *NewsModel;
    PCMessageCenterTableViewCell *numcell;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *idstr= [[NSUserDefaults standardUserDefaults]objectForKey:@"clickIdStr"];
    if(![idstr isEqualToString:NewsModel.id.stringValue]&&NewsModel!=nil){
        numcell.numberOfMessage.text = [NSString stringWithFormat:@"%lu",(unsigned long)NewsModel.gupiao_data.count];
    }else{
        numcell.numberOfMessage.text = @"";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initScrollView];
    [self setTableViewsWithCellKindsArray:@[@""]];
    [self setTableView];
    [self setHeader:@"消息中心"];
    if(!messageSourceArr){
        messageSourceArr = @[].mutableCopy;
    }
    failLoadView = [[fullPageFailLoadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:failLoadView];
    failLoadView.delegate = self;
    [failLoadView showWithAnimation];
    [self loadDataOfMessageCenter];
}

- (void)setTableView{
    [self.scrollView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.bounces = NO;
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"PCMessageCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"PCMessageCenterTableViewCell"];
    self.tableView1.backgroundColor = BACKGROUNDCOKOR;
    self.tableView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-74);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView1){
        PCMessageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PCMessageCenterTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
            {
                cell.headImage.image = [UIImage imageNamed:@"tongzhi"];
                cell.title.text = @"系统通知";
                
                if(messageSourceArr.count==2){
                    for (MessageCenterModel *model in messageSourceArr) {
                        if([model.type isEqual:@(2)]){
                            cell.model = model;
                        }
                    }
                }
                
            }
                break;
            case 1:
            {
                
                cell.headImage.image = [UIImage imageNamed:@"huodongxiaoxi"];
                cell.title.text = @"活动消息";
                
                if(messageSourceArr.count==2){
                    for (MessageCenterModel *model in messageSourceArr) {
                        if([model.type isEqual:@(1)]){
                            cell.model = model;
                        }
                    }
                }
            }
                break;
            case 2:
            {
                cell.headImage.image = [UIImage imageNamed:@"xingushengou"];
                cell.title.text = @"新股申购";
                numcell = cell;
                NSString *idstr= [[NSUserDefaults standardUserDefaults]objectForKey:@"clickIdStr"];
                if(![idstr isEqualToString:NewsModel.id.stringValue]&&NewsModel!=nil){
                    numcell.numberOfMessage.text = [NSString stringWithFormat:@"%lu",(unsigned long)NewsModel.gupiao_data.count];
                }else{
                    numcell.numberOfMessage.text = @"";
                }
                
            }
                break;
            case 3:
            {
                
            }
                break;
            default:
                break;
        }
        return cell;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PCMessageCenterTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.numberOfMessage.text = @"";
    
    switch (indexPath.row) {
        case 3:{
            PCMCFirsrController *first = [[PCMCFirsrController alloc]init];
            [self.navigationController pushViewController:first animated:YES];
        }
            break;
        case 0:{
            //系统消息
            PCMCSecondViewController *first = [[PCMCSecondViewController alloc]init];
            first.typeStr = @"2";
            [self.navigationController pushViewController:first animated:YES];
        }
            break;
        case 1:
        {
            //活动消息
            PCMCThirdViewController *first = [[PCMCThirdViewController alloc]init];
            first.typeStr = @"1";
            [self.navigationController pushViewController:first animated:YES];
        }
            break;
        case 2:
        {
            //新股申购
            PCMCForthViewController *first = [[PCMCForthViewController alloc]init];
            first.model = NewsModel;
            [[NSUserDefaults standardUserDefaults]setObject:NewsModel.id.stringValue forKey:@"clickIdStr"];
            [self.navigationController pushViewController:first animated:YES];
        }
            break;
            
        default:
            break;
    }
}


- (void)loadDataOfMessageCenter{
    
    [messageSourceArr removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *userInfoDic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@/type/2",@"http://gkc.cdtzb.com/api/message/count_by_type/token/",userInfoDic[PCUserToken]];
        [[CDAFNetWork sharedMyManager]get:urlStr params:nil success:^(id json) {
            if([json[@"code"] isEqual:@(1)]){
                for (NSDictionary *dic in json[@"data"]) {
                    MessageCenterModel * model = [MessageCenterModel yy_modelWithDictionary:dic];
                    [messageSourceArr addObject:model];
                }
                if(messageSourceArr.count == 2){
                    [self.tableView1 reloadData];
                    [failLoadView hide];
                }
            }else{
                NSLog(@"获取失败");
            }
        } failure:^(NSError *error) {
            [failLoadView showWithoutAnimation];
        }];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *userInfoDic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@/type/1",@"http://gkc.cdtzb.com/api/message/count_by_type/token/",userInfoDic[PCUserToken]];
        [[CDAFNetWork sharedMyManager]get:urlStr params:nil success:^(id json) {
            if([json[@"code"] isEqual:@(1)]){
                for (NSDictionary *dic  in json[@"data"]) {
                    MessageCenterModel * model = [MessageCenterModel yy_modelWithDictionary:dic];
                    [messageSourceArr addObject:model];
                }
                if(messageSourceArr.count == 2){
                    [self.tableView1 reloadData];
                    [failLoadView hide];
                }
            }else{
                NSLog(@"获取失败");
            }
            
        } failure:^(NSError *error) {
            [failLoadView showWithoutAnimation];
        }];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlStr = [NSString stringWithFormat:@"http://gk.cdtzb.com/api/newshare"];
        [[CDAFNetWork sharedMyManager]get:urlStr params:nil success:^(id json) {
            if([json[@"code"] isEqual:@(1)]){
                NewsModel = [NewShareModel yy_modelWithDictionary:json[@"data"]];
            
            }else{
                NSLog(@"获取失败");
            }
            
        } failure:^(NSError *error) {
            [failLoadView showWithoutAnimation];
        }];
    });
    
}

-(void)popMenuDidClickRefresh:(fullPageFailLoadView *)popMenu{
    [popMenu.fullfailLoad hideTheSubViews];
    [self loadDataOfMessageCenter];
}




@end
