//
//  MyCollectViewController.m
//  HDStock
//
//  Created by liyancheng on 16/11/28.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "MyCollectViewController.h"
#import "HDPCCollectedInformationCell.h"//收藏资讯cell
#import "HDPCCollectedVideoCell.h"//收藏视频cell
#import "MyCollectedDataModel.h"//收藏model
#import "HeadLineViewController.h"//资讯详情
#import "HDVideoDetailsViewController.h"//视频详情
#import "HDFailLoadView.h"
#import "fullPageFailLoadView.h"
#import "nothingContainView.h"//没得东西
@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate,fullPageFailLoadViewDelegate>
@property (nonatomic,strong) nothingContainView * nothingContain;
@end

@implementation MyCollectViewController{
    NSInteger page;
    NSMutableArray *dataArr;
    NSString *typeId;
    NSString *headFootRFlag;//是否是mjRFresh
//    MBProgressHUD *LoadHud;
    fullPageFailLoadView * failLoadView;
    
}
#pragma  mark   ----- view's Life
- (void)viewDidLoad {
    headFootRFlag = @"no";
    page = 1;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setHeader:@"我的收藏"];
    [self initTopViewWithArray:@[@"资讯",@"视频"]];
    [self setTableViewsWithCellKindsArray:@[@"",@""]];
    [self setTableView];
    if(!dataArr){
        dataArr = @[].mutableCopy;
    }
    typeId = @"1";
    failLoadView = [[fullPageFailLoadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:failLoadView];
    failLoadView.delegate = self;
    [failLoadView showWithAnimation];
    
    [self loadDataOfCollected];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.nothingContain hide];
    [super viewWillDisappear:animated];
}

#pragma mark  --- lazyLoading

-(nothingContainView *)nothingContain{
    if(!_nothingContain){
        _nothingContain =[[nothingContainView alloc]initWithFrame:CGRectMake(0, 64+41, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        [self.view addSubview:_nothingContain];
    }
    return _nothingContain;
}



#pragma mark ---- loadData
- (void)loadDataOfCollected{
    
    if([headFootRFlag isEqualToString:@"no"]){
        
    }
    NSDictionary *dic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
    if([dic[PCUserState] isEqualToString:@"success"]){
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        [mutDic setObject:dic[PCUserToken] forKey:@"token"];
        NSString * url = [NSString stringWithFormat:PCMyCollectedURL,(long)page,typeId,arc4random()%10000];
        [[CDAFNetWork sharedMyManager]get:url params:mutDic success:^(id json) {
//                [LoadHud hideAnimated:YES];
            if([json[@"code"] isEqual:@(1)]){
                if([json[@"data"] isKindOfClass:[NSNull class]]){
//                    [LYCFactory showLycHudToObject:self.view withTitil:@"没有更多数据了"];
                    if(dataArr.count ==0){
                        [self.nothingContain show];
                    }else{
                        [self.nothingContain hide];
                    }
                    [self endRefresh];
                }else{
                    for (NSDictionary *dic in json[@"data"]) {
                        MyCollectedDataModel *model = [MyCollectedDataModel yy_modelWithDictionary:dic];
                        [dataArr addObject:model];
                    }
                    if(dataArr.count == 0){
                        [self.nothingContain show];
                    }else{
                        [self.nothingContain hide];
                    }
                    [self.tableView1 reloadData];
                    [self.tableView2 reloadData];
                    [self endRefresh];
                }
            }else{
                NSLog(@"加载失败");
            }
            [failLoadView hide];
        } failure:^(NSError *error) {
            [failLoadView showWithoutAnimation];
        }];
    }
    else{
        
    }
}



#pragma mark ---- initTableView
- (void)setTableView{
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.backgroundColor = BACKGROUNDCOKOR;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"HDPCCollectedInformationCell" bundle:nil] forCellReuseIdentifier:@"HDPCCollectedInformationCell"];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView2.backgroundColor = BACKGROUNDCOKOR;
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView2 registerNib:[UINib nibWithNibName:@"HDPCCollectedVideoCell" bundle:nil] forCellReuseIdentifier:@"HDPCCollectedVideoCell"];
    WEAK_SELF;
    self.tableView1.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
        [dataArr removeAllObjects];
        headFootRFlag = @"yes";
        page = 1;
        [weakSelf loadDataOfCollected];
    }];
    
    self.tableView1.mj_footer = [PSYRefreshGifFooter footerWithRefreshingBlock:^{
        headFootRFlag = @"yes";
        page ++;
        [weakSelf loadDataOfCollected];
    }];
    
    self.tableView2.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
        headFootRFlag = @"yes";
        [dataArr removeAllObjects];
        page = 1;
        [weakSelf loadDataOfCollected];
    }];
    
    self.tableView2.mj_footer = [PSYRefreshGifFooter footerWithRefreshingBlock:^{
        headFootRFlag = @"yes";
        page ++;
        [weakSelf loadDataOfCollected];
    }];
}




- (void)cancelCollectionWithAid:(NSString* )aid andIndexPath:(NSIndexPath *)indexPath{
    
    WEAK_SELF;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSString * url = [NSString stringWithFormat:PCCancelCollection,aid,arc4random()%1000];
    NSDictionary *infoDic=[[LYCUserManager informationDefaultUser]getUserInfoDic];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:infoDic[PCUserToken] forKey:@"token"];
    dispatch_async(queue, ^{
        STRONG_SELF;
        [[CDAFNetWork sharedMyManager]get:url params:dic success:^(id json) {
            NSLog(@"%@",json[@"msg"]);
            if ([json[@"msg"] isEqualToString:@"收藏删除成功"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = json[@"msg"];
                hud.label.textColor = COLOR(orangeColor);
                [hud hideAnimated:YES afterDelay: 2];
                NSUInteger row = [indexPath row];
                [dataArr removeObjectAtIndex:row];
                
                if([typeId isEqualToString:@"1"]){
                    [self.tableView1 deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                     [self.tableView2 deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = json[@"msg"];
                hud.label.textColor = COLOR(orangeColor);
                [hud hideAnimated:YES afterDelay: 2];
            }
            
        } failure:^(NSError *error) {
            
            
        }];
    });
}


-(void)endRefresh{
    [self.tableView1.mj_header endRefreshing];
    [self.tableView1.mj_footer endRefreshing];
    [self.tableView2.mj_header endRefreshing];
    [self.tableView2.mj_footer endRefreshing];
}

-(void)topButtonEvent:(UIButton *)sender{
    [self.nothingContain hide];
    [super topButtonEvent:sender];
    NSLog(@"%ld",(long)sender.tag);
    [dataArr removeAllObjects];
    headFootRFlag = @"no";
    if(sender.tag == 200){
        typeId = @"1";
        [self loadDataOfCollected];
    }else{
        typeId = @"2";
        [self loadDataOfCollected];
    }
    
}
#pragma mark ---- tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([typeId isEqualToString:@"1"]){
        HeadLineViewController *headLine = [[HeadLineViewController alloc]init];
        MyCollectedDataModel *model = dataArr[indexPath.row];
        headLine.aid = [(model.id) integerValue];
        headLine.imageUrlStr = model.pic;
        headLine.tittle = model.title;
        [self.navigationController pushViewController:headLine animated:YES];
    }else{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HDVideoDetailsViewController * videoDetail = [mainStoryboard instantiateViewControllerWithIdentifier:@"HDVideoDetailsViewController"];
        MyCollectedDataModel *model = dataArr[indexPath.row];
        videoDetail.ItemAid = [(model.id) integerValue];
        videoDetail.videoTitle = model.title;
        videoDetail.videoLook = [(model.id) integerValue];
        videoDetail.picUrl = model.pic;
        videoDetail.videoUrl = model.fromurl;
        [self.navigationController pushViewController:videoDetail animated:NO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView1){
        HDPCCollectedInformationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HDPCCollectedInformationCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = dataArr[indexPath.row];
        return cell;
    }else if (tableView == self.tableView2){
        HDPCCollectedInformationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HDPCCollectedVideoCell"];
        cell.model = dataArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView1) {
        return 118;
    }else if(tableView == self.tableView2){
        return 118;
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
        MyCollectedDataModel * model = dataArr[indexPath.row];
        NSLog(@"%@",model.id);
        NSLog(@"%@",model.favid);
        [self cancelCollectionWithAid:model.favid andIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([typeId isEqualToString:@"1"]){
        if(tableView == self.tableView1){
            return dataArr.count;
        }else{
            return 0;
        }
    }else{
        if(tableView == self.tableView1){
            return 0;
        }else{
            return dataArr.count;
        }
    }
}

#pragma mark --- otherfunction
-(void)popMenuDidClickRefresh:(fullPageFailLoadView *)popMenu{
    [popMenu.fullfailLoad hideTheSubViews];
    [self loadDataOfCollected];
}

@end
