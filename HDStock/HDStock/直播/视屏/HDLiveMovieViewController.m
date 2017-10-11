//
//  HDLiveMovieViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/21.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveMovieViewController.h"
#import "HDLiveViewScreenCollectionViewCell.h"
#import "HDVideoDetailsViewController.h"

#define Margin 10.0f

@interface HDLiveMovieViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> 


@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation HDLiveMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self fitFrame];
    [self createCollectionView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    _collectionView.frame = CGRM(0, 0,SCREEN_SIZE_WIDTH , self.view.bounds.size.height);
    
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObjectsFromArray:@[@"",@"",@"",@"",@"",@"",@"",@""]];
    }
    return _dataArray;
}

- (void) fitFrame {
    CGRect frame = self.view.frame;
    frame.size.height = SCREEN_HEIGHT-NAV_STATUS_HEIGHT-SCREEN_SIZE_WIDTH*9.0/16-90;
    self.view.frame = frame;
}

- (void)createCollectionView{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;
    
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.backgroundColor = COLOR(whiteColor);
    
    [_collectionView registerNib:[UINib nibWithNibName:@"HDLiveViewScreenCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HDVideoCell"];
    
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
    
    [self.view addSubview:_collectionView];
    
    //网络请求
    WEAK_SELF;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        STRONG_SELF;
        [strongSelf requstOfShiPing];
    }];
    
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        STRONG_SELF;
        [strongSelf requstOfShiPing];
    }];
    
//    [_collectionView.mj_header beginRefreshing];
    
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    CGSize size = {0, 0};
    return size;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HDLiveViewScreenCollectionViewCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"HDVideoCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDLiveViewScreenCollectionViewCell" owner:self options:nil] lastObject];
    }
    
    //赋值／记得确定是哪个model
//    if (self.dataArray.count > 0) {
//        HDLiveViewScreenModel * model = self.dataArray[indexPath.row];
//        [cell configUIWithModel:model];
//    }
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    if(segmentselected == 0){
//        if (indexPath.section == 0 && indexPath.row == 0) {
//            return CGSizeMake(SCREEN_WIDTH - Margin * 2, (SCREEN_WIDTH - Margin * 2)*360/535);
//        }
//    }
    return CGSizeMake((SCREEN_WIDTH - Margin * 3)/2, 140);
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

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"hello");
    
//    HDVideoDetailsViewController * vedioVC = [HDVideoDetailsViewController new];
//    vedioVC.ItemAid = 2;
//    [self.navigationController pushViewController:vedioVC animated:YES];
}
#pragma mark - 网络请求

- (void) requstOfShiPing {
    
}

#pragma mark - foo
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
