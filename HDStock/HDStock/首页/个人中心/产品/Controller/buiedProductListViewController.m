//
//  buiedProductListViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "buiedProductListViewController.h"
#import "BuiedPruductTableViewCell.h"
#import "BuiedProductDetailViewController.h"
#import "ProductListModel.h"
#import "fullPageFailLoadView.h"

@interface buiedProductListViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,fullPageFailLoadViewDelegate>
@property (nonatomic,strong) UITableView *tableView1;
@end

@implementation buiedProductListViewController{
    NSMutableArray *dataArr;
    fullPageFailLoadView * fullFailLoad;
    NSInteger attentionedCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.tableView1){
        self.tableView1 = [[UITableView alloc]init];
    }
    self.title = @"项目服务";
    [self setTableView];
    if(!dataArr){
        dataArr = @[].mutableCopy;
    }
    
    fullFailLoad = [[fullPageFailLoadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];;
    fullFailLoad.delegate = self;
    [self.view addSubview:fullFailLoad];
    [fullFailLoad showWithAnimation];
    [self loadDataOfProductList];
}

- (void)loadDataOfProductList{
    NSString * url = [NSString stringWithFormat:PCProductListURL];
    WEAK_SELF;
    STRONG_SELF;
    NSDictionary *dic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:_flagStr forKey:@"category"];
    [mutDic setObject:dic[PCUserToken] forKey:@"token"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[CDAFNetWork sharedMyManager]post:url params:mutDic success:^(id json) {
            if([json[@"data"] isKindOfClass:[NSNull class]]||[json[@"data"] isKindOfClass:[NSString class]]){
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"没有更多数据了";
                [hud hideAnimated:YES afterDelay: 1];
                [self endRefresh];
                [fullFailLoad hide];
            }else{
                for (NSDictionary *dic in json[@"data"][@"follow"]) {
                    ProductListModel * model = [ProductListModel yy_modelWithDictionary:dic];
                    [dataArr addObject:model];
                    attentionedCount = ((NSArray *)json[@"data"][@"follow"]).count;
                }
                
                for (NSDictionary *dic in json[@"data"][@"nature"]) {
                    ProductListModel * model = [ProductListModel yy_modelWithDictionary:dic];
                    [dataArr addObject:model];
                }
                [self.tableView1 reloadData];
                [self endRefresh];
                [fullFailLoad hide];
            }
        } failure:^(NSError *error) {
            [fullFailLoad showWithoutAnimation];
            [self endRefresh];
        }];
    });
}

-(void)endRefresh{
    [self.tableView1.mj_header endRefreshing];
    [self.tableView1.mj_footer endRefreshing];
}

- (void)setTableView{
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.backgroundColor = BACKGROUNDCOKOR;
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"BuiedPruductTableViewCell" bundle:nil] forCellReuseIdentifier:@"BuiedPruductTableViewCell"];
    self.tableView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:_tableView1];
    WEAK_SELF;
    self.tableView1.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
        [dataArr removeAllObjects];
        [weakSelf loadDataOfProductList];
    }];
    
    self.tableView1.mj_footer = [PSYRefreshGifFooter footerWithRefreshingBlock:^{
        //因为没分页 所以全删
        [dataArr removeAllObjects];
        [weakSelf loadDataOfProductList];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuiedPruductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuiedPruductTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row+1<attentionedCount){
        cell.bottomAlertLabel.hidden = NO;
        cell.bottomAlertImage.hidden = NO;
        cell.alreadyAttentionLabel.hidden = NO;
        cell.bottomSpaceCS.constant = 38.0;
    }
    cell.listModel = dataArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductListModel *model = dataArr[indexPath.row];
    NSString * tempStr = model.operating_strategy;
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.headIndent = 0;
    style1.firstLineHeadIndent = 0;
    style1.lineSpacing = 7;
    CGSize secondDesc;
    secondDesc = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1} context:nil].size;
    
    if(indexPath.row+1<attentionedCount){
        return 130+secondDesc.height-3;
    }else{
        return 130+secondDesc.height-18;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductListModel *model = dataArr[indexPath.row];
    BuiedProductDetailViewController *detail = [[BuiedProductDetailViewController alloc]init];
    detail.flagStr = _flagStr;
    detail.createTimeStr = model.create_date;
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)setFlagStr:(NSString *)flagStr{
    _flagStr = flagStr;
}

-(void)popMenuDidClickRefresh:(fullPageFailLoadView *)popMenu{

    [popMenu.fullfailLoad hideTheSubViews];
    [self loadDataOfProductList];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [fullFailLoad hide];
}

@end
