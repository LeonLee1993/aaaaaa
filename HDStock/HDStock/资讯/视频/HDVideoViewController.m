//
//  HDVideoViewController.m
//  HDStock
//
//  Created by hd-app02 on 16/11/15.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDVideoViewController.h"
#import "HDVideoCell.h"

#define Margin 10.0f

@interface HDVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) NSMutableArray * array1;
@property (nonatomic, strong) NSMutableArray * array2;
@property (nonatomic, strong) NSMutableArray * array3;
@end

@implementation HDVideoViewController{
        
        NSInteger page;
        NSInteger perpage;
        NSInteger cateId;

}

- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;

}

- (NSMutableArray *)array1{

    if (!_array1) {
        
        _array1 = [NSMutableArray array];
        
    }
    return _array1;
}

- (NSMutableArray *)array2{
    
    if (!_array2) {
        
        _array2 = [NSMutableArray array];
        
    }
    return _array2;
}

- (NSMutableArray *)array3{
    
    if (!_array3) {
        
        _array3 = [NSMutableArray array];
        
    }
    return _array3;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    
    perpage = 50;
    
    cateId = 7;
    
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
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FootView"];

    [self.view addSubview:_collectionView];
    
    WEAK_SELF;
    
    _collectionView.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestData];
        
    }];
    
    _collectionView.mj_footer = [PSYRefreshGifFooter footerWithRefreshingBlock:^{
        
        perpage = 50;
        
        [weakSelf requestData];
        
    }];

    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView * reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView" forIndexPath:indexPath];
        
        for (UIView * view in head.subviews) {
            
            [view removeFromSuperview];
        }
        UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40)];
        
        if (indexPath.section == 1) {
             lable.text = @"财经观察";
        }else if (indexPath.section == 2) {
            lable.text = @"技术教学";
        }else if (indexPath.section == 3) {
             lable.text = @"直播历史";
        }
        [head addSubview:lable];
        
        reusableview = head;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        
        
        UICollectionReusableView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FootView" forIndexPath:indexPath];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 11)];
        
        view.backgroundColor = BACKGROUNDCOKOR;
        
        [foot addSubview:view];
        
        reusableview = foot;
    }
    
    
    return reusableview;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if(section != 0)
    {
        CGSize size = {SCREEN_WIDTH, 40};
        return size;
    }
    else
    {
        CGSize size = {0, 0};
        return size;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    
    if(section != 3)
    {
        CGSize size = {SCREEN_WIDTH, 11};
        return size;
    }
    else
    {
        CGSize size = {0, 0};
        return size;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    HDVideoCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"HDVideoCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        cell.model = [self.dataArray objectAtIndexCheck:indexPath.item];
        
    }else if (indexPath.section == 1) {
        
        cell.model = [self.array1 objectAtIndexCheck:indexPath.item];
        
    }else if (indexPath.section == 2){
    
        cell.model = [self.array2 objectAtIndexCheck:indexPath.item];
    
    }else if (indexPath.section == 3){
        
        cell.model = [self.array3 objectAtIndexCheck:indexPath.item];
        
    }
    
    return cell;

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    if (self.dataArray.count == 0) {
        
        return 0;
        
    }else{
    
        return 4;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (self.dataArray.count == 0) {
        
        return 0;
        
    }else{
    
    if (section == 0) {
        
        return 3;
        
    }else{
        if (section == 1) {
            
            if (self.array1.count == 0) {
                
                return 0;
            }else{
            
                if (self.array1.count > 4) {
                    return 4;
                }else{
                
                    return self.array1.count;
                
                }
            
            }
        }else if (section == 2) {
            
            if (self.array2.count == 0) {
                
                return 0;
            }else{
                
                if (self.array2.count > 4) {
                    return 4;
                }else{
                    
                    return self.array2.count;
                    
                }
                
            }
        }else if (section == 3) {
            
            if (self.array3.count == 0) {
                
                return 0;
            }else{
                
                if (self.array3.count > 4) {
                    return 4;
                }else{
                    
                    return self.array3.count;
                    
                }
                
            }
        }
    }
    }
    
    return 0;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return CGSizeMake(SCREEN_WIDTH - Margin * 2, (SCREEN_WIDTH - Margin * 2)*402/710 +70);
    }
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
    
    HDHeadLineModel * model = [HDHeadLineModel new];
    
    HDHeadLineModel * model1 = [self.dataArray objectAtIndexCheck:indexPath.item];
    HDHeadLineModel * model2 = [self.array1 objectAtIndexCheck:indexPath.item];
    HDHeadLineModel * model3 = [self.array2 objectAtIndexCheck:indexPath.item];
    HDHeadLineModel * model4 = [self.array3 objectAtIndexCheck:indexPath.item];
    
    switch (indexPath.section) {
        case 0:
            model = model1;
            break;
        case 1:
            model = model2;
            break;
        case 2:
            model = model3;
            break;
        case 3:
            model = model4;
            break;
            
        default:
            break;
    }

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
    
    NSString * url = [NSString stringWithFormat:Home_HeadLineCateNews,(long)page,(long)perpage,(long)cateId,@"0",arc4random()%10000];

    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //
    //    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            [hud hideAnimated:YES];
            
            NSArray * dataArr = json[@"data"];

            [self endRefresh];
            [_collectionView.mj_footer endRefreshingWithNoMoreData];
            
            if (1 == page) { // 说明是在重新请求数据.
                
                [self.dataArray removeAllObjects];
                [self.array1 removeAllObjects];
                [self.array2 removeAllObjects];
                [self.array3 removeAllObjects];
            }
            
            for (NSDictionary * dic in dataArr) {
                
                HDHeadLineModel * headlinemodel = [HDHeadLineModel yy_modelWithDictionary:dic];
                
                [strongSelf.dataArray addObject:headlinemodel];
                
                if ([headlinemodel.catename isEqualToString:@"财经观察"]) {
                    
                    [strongSelf.array1 addObject:headlinemodel];
                    
                }else if ([headlinemodel.catename isEqualToString:@"技术教学"]){
                    
                    [strongSelf.array2 addObject:headlinemodel];
                    
                }else if ([headlinemodel.catename isEqualToString:@"直播历史"]){
                    
                    [strongSelf.array3 addObject:headlinemodel];
                    
                }
                
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
