//
//  HDVideoObservationViewController.m
//  HDStock
//
//  Created by hd-app02 on 2016/11/30.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDVideoObservationViewController.h"
#import "HDVideoCell.h"

#define Margin 10.0f

@interface HDVideoObservationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation HDVideoObservationViewController{
    
    NSInteger page;
    NSInteger perpage;
    NSInteger catid;
    
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    perpage = 20;
    catid = self.catID;
    //[self requestData];
    [self setupCollectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self requestData];
    
}

- (void)setupCollectionView{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRM(0, 0, SCREEN_SIZE_WIDTH, self.view.bounds.size.height - NAV_STATUS_HEIGHT - TABBAR_HEIGHT - 40.0f) collectionViewLayout:layout];
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;
    
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.backgroundColor = COLOR(whiteColor);
    
    [_collectionView registerNib:[UINib nibWithNibName:@"HDVideoCell" bundle:nil] forCellWithReuseIdentifier:@"HDVideoCell"];
    
    [self.view addSubview:_collectionView];
    
    WEAK_SELF;
    
    _collectionView.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestData];
        
    }];
    
    _collectionView.mj_footer = [PSYRefreshGifFooter footerWithRefreshingBlock:^{
        
        perpage = 50;
        
        [weakSelf requestData];
        
    }];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView111"];
    
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HDVideoCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"HDVideoCell" forIndexPath:indexPath];

    cell.model = [self.dataArray objectAtIndexCheck:indexPath.item];
    
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArray.count != 0) {
        return self.dataArray.count;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - Margin * 3)/2, (SCREEN_WIDTH - Margin * 3)/2*98/173 + 70);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return Margin;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return Margin;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(Margin, Margin, Margin, Margin);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HDVideoDetailsViewController * videoV = [mainStoryboard instantiateViewControllerWithIdentifier:@"HDVideoDetailsViewController"];
    
    HDHeadLineModel * model = [self.dataArray objectAtIndexCheck:indexPath.item];
    
    videoV.videoTitle = model.title;
    //videoV.videoLook = model.aid;
    
    if (model.tags_name) {
        
        videoV.tagsname = model.tags_name.allValues[0];
    }
    
    videoV.picUrl = model.pic;
    
    videoV.videoUrl = model.fromurl;
    
    videoV.ItemAid = model.aid;
    
    videoV.ItemUid = model.uid;
    
    videoV.summary = model.summary;
    
    [self.navigationController pushViewController:videoV animated:NO];
    
}


#pragma mark == 网络请求
- (void)requestData{
    
    PSYProgresHUD * hud = [[PSYProgresHUD alloc]init];
    
    hud.centerX = self.view.centerX;
    
    hud.centerY = self.view.centerY - NAV_STATUS_HEIGHT;
    
    [self.view addSubview:hud];
    
    [hud showAnimated:YES];
    
    NSString * url = [NSString stringWithFormat:Home_HeadLineCateNews,(long)page,(long)perpage,(long)catid,@"0",arc4random()%10000];
    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //
    //    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            [hud hideAnimated:YES];
            
            if (perpage == 100) {
                
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
                
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
                
                [_collectionView reloadData];
                
                
            });
            
        } failure:^(NSError *error) {
            
            [self endRefresh];
            [hud hideAnimated:YES];
            
        }];
        
    });
}

-(void)endRefresh{
    [_collectionView.mj_header endRefreshing];
    [_collectionView.mj_footer endRefreshing];
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
