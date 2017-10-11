//
//  HDBaskListViewController.m
//  HDStock
//
//  Created by hd-app02 on 16/11/15.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDBaskListViewController.h"
#import "HDHeadLineModel.h"
#import "HDHeadLineBaseCell.h"
#import "HDHeadLineSingleViewCell.h"
#import "HDHeadLineBigViewCellCell.h"
#import "HDHeadLineThreeViewCellCell.h"
#import "HeadLineViewController.h"

@interface HDBaskListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableview;

@property (nonatomic, strong) NSMutableArray * headLinedataArray;

@end

@implementation HDBaskListViewController
{
    
    NSInteger page;
    
    NSInteger perpage;
    
    NSInteger cateId;
    
}

- (NSMutableArray *)headLinedataArray{
    
    if (!_headLinedataArray) {
        
        _headLinedataArray = [[NSMutableArray alloc]init];
    }
    
    return _headLinedataArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    
    perpage = 10;
    
    cateId = 6;
    
    [self requestData];
    
    [self setupTableview];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    _tableview.frame = self.view.bounds;
    
}

- (void)setupTableview{
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    _tableview.delegate = self;
    
    _tableview.dataSource = self;
    
    _tableview.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_tableview];
    _tableview.allowsSelection = YES;
    
    [_tableview registerNib:[UINib nibWithNibName:@"HDTopScrollCell" bundle:nil] forCellReuseIdentifier:@"HDTopScrollCell"];
    [_tableview registerNib:[UINib nibWithNibName:@"HDMiddleCell" bundle:nil] forCellReuseIdentifier:@"HDMiddleCell"];
    
    [_tableview registerNib:[UINib nibWithNibName:@"HDHeadLineBaseCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineBaseCell"];
    [_tableview registerNib:[UINib nibWithNibName:@"HDHeadLineSingleViewCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineSingleViewCell"];
    [_tableview registerNib:[UINib nibWithNibName:@"HDHeadLineBigViewCellCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineBigViewCellCell"];
    [_tableview registerNib:[UINib nibWithNibName:@"HDHeadLineThreeViewCellCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineThreeViewCellCell"];
    
    WEAK_SELF;
    
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestData];
        
    }];
    
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        perpage = 50;
        
        [weakSelf requestData];
        
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.headLinedataArray.count != 0) {
        
        return self.headLinedataArray.count;
        
    }
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.headLinedataArray.count == 0) {
        
        return SCREEN_HEIGHT;
        
    }else{
        
        HDHeadLineModel * model = [self.headLinedataArray objectAtIndexCheck:indexPath.row];
        
        return model.cellHeight;
        
    }
    
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_headLinedataArray.count != 0) {
        
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        HDHeadLineModel * headlineModel = [self.headLinedataArray objectAtIndexCheck:indexPath.row];
        
        HDHeadLineBaseCell * cellBase = [tableView dequeueReusableCellWithIdentifier:@"HDHeadLineBaseCell"];
        cellBase.model = headlineModel;
        [cellBase.cancleButton setHidden:YES];
        
        HDHeadLineSingleViewCell * cellSingle = [tableView dequeueReusableCellWithIdentifier:@"HDHeadLineSingleViewCell"];
        cellSingle.model = headlineModel;
        [cellSingle.cancleButton setHidden:YES];
        
        HDHeadLineBigViewCellCell * cellBig = [tableView dequeueReusableCellWithIdentifier:@"HDHeadLineBigViewCellCell"];
        cellBig.model = headlineModel;
        [cellBig.cancleButton setHidden:YES];
        
        HDHeadLineThreeViewCellCell * cellThreeView = [tableView dequeueReusableCellWithIdentifier:@"HDHeadLineThreeViewCellCell"];
        cellThreeView.model = headlineModel;
        [cellThreeView.cacleButton setHidden:YES];
        
        if(headlineModel.pic.length > 1){
            
            if (!headlineModel.countmanypic) {
                
                return cellSingle;
                
            }
            if (headlineModel.countmanypic) {
                
                if (headlineModel.countmanypic == 1) {
                    
                    return cellSingle;
                    
                }else if (headlineModel.countmanypic == 2){
                    
                    return cellBig;
                    
                }else if (headlineModel.countmanypic == 3){
                    
                    return cellThreeView;
                    
                }
            }
        }
        if (headlineModel.pic.length == 0) {
            
            if (!headlineModel.countmanypic) {
                
                return cellBase;
            }
            
            if (headlineModel.countmanypic) {
                if (headlineModel.countmanypic == 1) {
                    
                    return  cellSingle;
                    
                }else if (headlineModel.countmanypic == 2){
                    
                    return cellBig;
                    
                }else if (headlineModel.countmanypic == 3){
                    
                    return cellThreeView;
                    
                }
            }
        }
    }else{
        
        UITableViewCell * cell = [_tableview dequeueReusableCellWithIdentifier:@"cell1"];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        
        return cell;
        
    }
    
    return nil;
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && self.headLinedataArray.count != 0) {
        return YES;
    }
    
    return NO;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HDHeadLineModel * model = [self.headLinedataArray objectAtIndexCheck:indexPath.row];
    
    HeadLineViewController * headVC = [[HeadLineViewController alloc]init];
    
    headVC.hidesBottomBarWhenPushed = YES;
    
    headVC.aid = model.aid;
    
    [self.navigationController pushViewController:headVC animated:NO];
    
    
}

#pragma mark == 网络请求
- (void)requestData{
    
    NSString * url = [NSString stringWithFormat:Home_HeadLineCateNews,(long)page,(long)perpage,(long)cateId,arc4random()%10000];
    NSLog(@"网址是%@",url);
    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //
    //    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            if (perpage == 100) {
                
                [_tableview.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                
                [self endRefresh];
                
            }
            
            NSArray * dataArr = json[@"data"];
            
            if (1 == page) { // 说明是在重新请求数据.
                
                [self.headLinedataArray removeAllObjects];
            }
            
            if (self.headLinedataArray.count != 0) {
                
                [self.headLinedataArray removeAllObjects];
                
            }
            
            for (NSDictionary * dic in dataArr) {
                
                HDHeadLineModel * headlinemodel = [HDHeadLineModel yy_modelWithDictionary:dic];
                
                [strongSelf.headLinedataArray addObject:headlinemodel];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_tableview reloadData];
                
            });
            
        } failure:^(NSError *error) {
            
            [self endRefresh];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.center = _tableview.center;
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"您的网络不给力!";
            [hud hideAnimated:YES afterDelay: 2];
            
        }];
        
    });
}



-(void)endRefresh{
    [_tableview.mj_header endRefreshing];
    [_tableview.mj_footer endRefreshing];
}

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
