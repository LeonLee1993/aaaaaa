//
//  HDSelectedViewController.m
//  HDGolden
//
//  Created by hd-app02 on 16/10/21.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDSelectedViewController.h"

@interface HDSelectedViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) UITableView * tableView;

@end

@implementation HDSelectedViewController{

    NSInteger page;
    NSInteger perpage;
    
    
}

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc]init];
    }

    return _dataArray;

}



- (void)viewDidLoad {
    [super viewDidLoad];

    [self registCell];
    [self requestData];
    
    self.view.backgroundColor = COLOR(yellowColor);

    
}

- (void) registCell {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRM(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 150 - SCREEN_WIDTH * 95 / 207) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    
    [self.view addSubview:_tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HDHeadLineNewsCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineNewsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDHeadLineBaseCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineBaseCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDHeadLineSingleViewCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineSingleViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDHeadLineBigViewCellCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineBigViewCellCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HDHeadLineThreeViewCellCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineThreeViewCellCell"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray.count != 0) {
        
    return self.dataArray.count;

    }
    
    return 5;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count != 0) {

    HDHeadLineModel * headlineModel = self.dataArray[indexPath.row];
    
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
    }

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = COLOR(redColor);
    
     return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.dataArray.count != 0){
    HDHeadLineModel * headlineModel = self.dataArray[indexPath.row];
    
    return headlineModel.cellHeight;
    }
    
    return 200;
    
}

- (void)requestData{
    
    NSString * url = [NSString stringWithFormat:Home_HeadLineCateNews,page,perpage,1,arc4random()%10000];
    
    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //
    //    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            if (perpage == 100) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                
                [self endRefresh];
                
            }
            
            NSArray * dataArr = json[@"data"];
            
            if (1 == page) { // 说明是在重新请求数据.
                
                [self.dataArray removeAllObjects];
            }
            
            if (self.dataArray.count != 0) {
                
                [self.dataArray removeAllObjects];
                
            }
            
            for (NSDictionary * dic in dataArr) {
                
                HDHeadLineModel * headlinemodel = [HDHeadLineModel yy_modelWithDictionary:dic];
                
                [strongSelf.dataArray addObject:headlinemodel];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [strongSelf.tableView reloadData];
                
            });
            
        } failure:^(NSError *error) {
            
            [self endRefresh];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.center = self.tableView.center;
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"您的网络不给力!";
            [hud hideAnimated:YES afterDelay: 2];
            
        }];
        
    });
}



-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
