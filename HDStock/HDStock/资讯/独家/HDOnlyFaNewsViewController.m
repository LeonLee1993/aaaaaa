//
//  HDOnlyFaNewsViewController.m
//  HDStock
//
//  Created by hd-app02 on 2016/11/25.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDOnlyFaNewsViewController.h"
#import "HDHeadLineModel.h"
#import "HDHeadLineBaseCell.h"
#import "HDHeadLineSingleViewCell.h"
#import "HDHeadLineBigViewCellCell.h"
#import "HDHeadLineThreeViewCellCell.h"
#import "HeadLineViewController.h"

@interface HDOnlyFaNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableview;
@property (nonatomic, strong) HDFailLoadView * failLoadView;
@property (nonatomic, strong) NSMutableArray * headLinedataArray;

@property (nonatomic, strong) UIButton * backToTopButton;

@end

@implementation HDOnlyFaNewsViewController{
    
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
    
    cateId = 5;
    
    [self setupTableview];
    [self setUpBackToTopButton];
    
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [self requestData];

}

- (void)setUpBackToTopButton{
    
    UIImage * back = [UIImage imageNamed:@"backtotop_button"];
    
    CGSize imageSize = back.size;
    //NSLog(@"%@",imageSize);
    
    self.backToTopButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - imageSize.width - 10.0f, SCREEN_HEIGHT - 180.0f, imageSize.width, imageSize.height)];
    
    [self.backToTopButton setBackgroundImage:back forState:UIControlStateNormal];
    
    [self.view addSubview:self.backToTopButton];
    [self.backToTopButton addTarget:self action:@selector(backToTopButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.backToTopButton setHidden:YES];
    
}


- (void)setupTableview{
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - NAV_STATUS_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
    
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
    [_tableview registerNib:[UINib nibWithNibName:@"HDLoadFailCell" bundle:nil] forCellReuseIdentifier:@"HDLoadFailCell"];
    
    WEAK_SELF;
    
    _tableview.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestData];
        
    }];
    
    _tableview.mj_footer = [PSYRefreshGifFooter footerWithRefreshingBlock:^{
        
        page ++;
        
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
        
        HDHeadLineSingleViewCell * cellSingle = [tableView dequeueReusableCellWithIdentifier:@"HDHeadLineSingleViewCell"];
        cellSingle.model = headlineModel;
        
        HDHeadLineBigViewCellCell * cellBig = [tableView dequeueReusableCellWithIdentifier:@"HDHeadLineBigViewCellCell"];
        cellBig.model = headlineModel;
        
        HDHeadLineThreeViewCellCell * cellThreeView = [tableView dequeueReusableCellWithIdentifier:@"HDHeadLineThreeViewCellCell"];
        cellThreeView.model = headlineModel;
        
        if(headlineModel.pic && headlineModel.pic.length > 1){
            
            if (!headlineModel.countmanypic) {
                
                return cellSingle;
                
            }else{
                
                if (headlineModel.countmanypic == 3) {
                    
                    return cellThreeView;
                    
                }else{
                    
                    return cellSingle;
                    
                }
                
            }
            
        }else{
            
            if (!headlineModel.countmanypic || headlineModel.countmanypic == 0) {
                
                return cellBase;
                
            }else{
                
                if (headlineModel.countmanypic == 3) {
                    
                    return cellThreeView;
                    
                }else{
                    
                    return cellSingle;
                    
                }
                
                
            }
            
            
        }
    }else{
        
        HDLoadFailCell * cell = [self.tableview dequeueReusableCellWithIdentifier:@"HDLoadFailCell"];
        self.failLoadView = cell.loadFailView;
        [cell.loadFailView.button addTarget:self action:@selector(loadfailButtonOnTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
    NSString * tagName = model.tags_name.allValues[0];
    if ([tagName isEqualToString:@"专题"] || [tagName isEqualToString:@"广告"]) {
        
        HDSubjectViewController * vc = [[HDSubjectViewController alloc]init];
        
        vc.aid = model.aid;
        vc.uid = model.uid;
        vc.tittle = model.title;
        vc.imageUrlStr = model.pic;
        if ([tagName isEqualToString:@"专题"]){
            
            vc.controllerTitle = @"专题";
            
        }else{
            
            vc.controllerTitle = @"";
            
        }

        [self.navigationController pushViewController:vc animated:NO];
        
    }else{
        //HeadLineViewController * headVC = [[HeadLineViewController alloc]init];
        HDHeadLineDetailViewController * headVC = [[HDHeadLineDetailViewController alloc]init];
        
        headVC.aid = model.aid;
        headVC.uid = model.uid;
        headVC.tittle = model.title;
        headVC.imageUrlStr = model.pic;
        headVC.controllerTitle = @"资讯";
        
        [self.navigationController pushViewController:headVC animated:NO];
    }
}

#pragma mark == 网络请求
- (void)requestData{
    
    [self.failLoadView hideTheSubViews];
    
    NSString * url = [NSString stringWithFormat:Home_HeadLineCateNews,(long)page,(long)perpage,(long)cateId,@"0",arc4random()%10000];
    
    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //
    //    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            NSArray * dataArr = json[@"data"];
            
            if (dataArr.count < perpage) {
                
                [strongSelf.tableview.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                
                [strongSelf endRefresh];
                
            }
            
            if (1 == page) { // 说明是在重新请求数据.
                
                [strongSelf.headLinedataArray removeAllObjects];
            }
            
            for (NSDictionary * dic in dataArr) {
                
                HDHeadLineModel * headlinemodel = [HDHeadLineModel yy_modelWithDictionary:dic];
                
                [strongSelf.headLinedataArray addObject:headlinemodel];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [strongSelf.tableview reloadData];
                
            });
            
        } failure:^(NSError *error) {
            
            [strongSelf endRefresh];
            [strongSelf.failLoadView showTheSubViews];
        }];
        
    });
}

-(void)endRefresh{
    [_tableview.mj_header endRefreshing];
    [_tableview.mj_footer endRefreshing];
}

- (void)loadfailButtonOnTouched:(UIButton *)button{
    
    [self.failLoadView hideTheSubViews];
    
    [self requestData];
    
}

- (void)backToTopButtonOnClicked{
    
    [self.tableview scrollToTop];
    
}

#pragma mark -- 滚动视图代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint contentOffSet = scrollView.contentOffset;
    if (contentOffSet.y > SCREEN_HEIGHT ) {
        
        [self.backToTopButton setHidden:NO];
        
    }else{
        
        [self.backToTopButton setHidden:YES];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
