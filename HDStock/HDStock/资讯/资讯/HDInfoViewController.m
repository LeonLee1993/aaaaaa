//
//  HDInfoViewController.m
//  HDStock
//
//  Created by hd-app02 on 16/11/15.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDInfoViewController.h"
#import "ATCarouselView.h"
#import "HDScrollViewsTableViewCell.h"
#import "HDSegmentView.h"

static KindOfTableView selfCellskind = KindOfTableViewRecommend;

@interface HDInfoViewController ()<UITableViewDelegate,UITableViewDataSource,HDSegmentViewDelegate,ATCarouselViewDelegate>

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation HDInfoViewController{
    
    UITableView * tableview;
    
    NSInteger page;
    NSInteger perpage;
    
    NSInteger cateId;
    
}


-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}

#pragma mark == 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    
    [self requestData];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    tableview.frame = self.view.bounds;
    
}


- (void)setUpTableView{

    tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [self.view addSubview:tableview];
    
    tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    tableview.showsVerticalScrollIndicator = NO;
    
    [tableview registerNib:[UINib nibWithNibName:@"HDHeadLineBaseCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineBaseCell"];
    [tableview registerNib:[UINib nibWithNibName:@"HDHeadLineSingleViewCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineSingleViewCell"];
    [tableview registerNib:[UINib nibWithNibName:@"HDHeadLineBigViewCellCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineBigViewCellCell"];
    [tableview registerNib:[UINib nibWithNibName:@"HDHeadLineThreeViewCellCell" bundle:nil] forCellReuseIdentifier:@"HDHeadLineThreeViewCellCell"];
    
    WEAK_SELF;
    
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestData];
        
    }];
    
    tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        perpage = 50;
        
        [weakSelf requestData];
        
    }];


}

#pragma mark == UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger number = 0;

    if (section == 0) {
        
        number = 1;
     }
    
    if (section == 1 && self.dataArray.count != 0) {
        
        number = self.dataArray.count;
        
    }
    
    return number;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return SCREEN_WIDTH * 95 / 207;
    }
    
    if(self.dataArray.count != 0){
        
        HDHeadLineModel * headlineModel = self.dataArray[indexPath.row];
        
        return headlineModel.cellHeight;
    }

    return 200;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HDScrollViewsTableViewCell * cell = [[HDScrollViewsTableViewCell alloc]init];
        
        cell.atcView.delegate = self;
        
        return cell;
        
    }
    if (indexPath.section == 1) {
        
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

    }

    UITableViewCell * cell = [tableview dequeueReusableCellWithIdentifier:@"cell1"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        
    }
    
    cell.backgroundColor = COLOR(purpleColor);

    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HDSegmentView * view = [[HDSegmentView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH * 95 / 207, self.view.bounds.size.width, 40)];
    view.delegate = self;

    view.segmentSelected = selfCellskind;
    return view;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 1) {
        return 40;
    }

    return 0;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1 && self.dataArray.count != 0) {
        return YES;
    }
    
    return NO;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HDHeadLineModel * model = [self.dataArray objectAtIndexCheck:indexPath.row];
    
    HeadLineViewController * headVC = [[HeadLineViewController alloc]init];
    
    headVC.hidesBottomBarWhenPushed = YES;
    
    headVC.aid = model.aid;
    
    [self.delegate turnToAntherControllerOnClicked:nil toPushToController:headVC];
    
}


#pragma mark == HDSegmentViewDelegate
- (void)isKindOfTableViewCells:(KindOfTableView)kind{
    
    selfCellskind = kind;
    
    switch (selfCellskind) {
        case KindOfTableViewRecommend:
            cateId = 1;
            break;
        case KindOfTableViewImportant:
            cateId = 14;
            break;
        case KindOfTableViewTFHours:
            cateId = 1;
            break;
        case KindOfTableViewCalander:
            cateId = 1;
            break;
        case KindOfTableViewPersonal:
            cateId = 16;
            break;
        case KindOfTableViewPlate:
            cateId = 18;
            break;
        case KindOfTableViewTape:
            cateId = 15;
            break;
        case KindOfTableViewOutskirts:
            cateId = 1;
            break;
        default:
            break;
    }
    
    [self requestData];

}

- (void)addButtonForScrollSegmentsOnClicked:(UIButton *)button toPushToController:(UIViewController *)viewController{
    
    [self.delegate turnToAntherControllerOnClicked:button toPushToController:viewController];
    
}

-(void)reloadSegmentView{

    [tableview reloadData];
    
}

- (void)carouselView:(ATCarouselView *)carouselView indexOfClickedImageBtn:(NSUInteger)index{

    NSLog(@"第%lu张图片被点击",index);

}

#pragma mark == 网络请求
- (void)requestData{
    
    NSString * url = [NSString stringWithFormat:Home_HeadLineCateNews,page,perpage,cateId,arc4random()%10000];
    
    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //
    //    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            if (perpage == 100) {
                
                [tableview.mj_footer endRefreshingWithNoMoreData];
                
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
            
                [tableview reloadData];
                
            });
            
        } failure:^(NSError *error) {
             [tableview reloadData];
            [self endRefresh];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.center = tableview.center;
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"您的网络不给力!";
            [hud hideAnimated:YES afterDelay: 2];
            
        }];
        
    });
}



-(void)endRefresh{
    [tableview.mj_header endRefreshing];
    [tableview.mj_footer endRefreshing];
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
