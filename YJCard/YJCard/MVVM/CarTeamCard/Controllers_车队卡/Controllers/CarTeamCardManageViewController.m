//
//  CarTeamCardManageViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/7.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "CarTeamCardManageViewController.h"
#import "CTManagerCollectionViewCell.h"
#import "CardListModel.h"
#import "CarTeamCardDetailViewController.h"
#import "QuickBindViewController.h"


@interface CarTeamCardManageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collect;
@property (nonatomic,strong) AFHTTPSessionManager * manager1;

@end

@implementation CarTeamCardManageViewController{
    NSMutableDictionary * _cellDic;
    NSMutableArray * dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCollectionView];
    _cellDic = @{}.mutableCopy;
    dataArr = @[].mutableCopy;
}

- (void)requestInfomation{
    
    if(whetherHaveNetwork){
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
        [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
        NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
        NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,GetCardList];
        //    LYCStateViews *hud = [LYCStateViews LYCshowStateViewTo:self.view withState:LYCStateViewLoad andTest:@"加载中"];
        self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
            if([json[@"code"] isEqual:@(100)]){
                [dataArr removeAllObjects];
                for (NSDictionary * dic in json[@"data"]) {
                    CardListModel *model = [CardListModel yy_modelWithDictionary:dic];
                    [dataArr addObject:model];
                }
                [self.collect reloadData];
            }else{
                [MBProgressHUD showWithText:json[@"msg"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        } andProgressView:self.view progressViewText:@"加载中" progressViewType:0 ViewController:self];
    }else{
        [self.poorNetWorkView show];
        __weak typeof (self) weakSelf = self;
        self.poorNetWorkView.reloadBlock = ^{
            [weakSelf requestInfomation];
        };
    }
    
    
}

- (void)requestInfomations{
    
    if(whetherHaveNetwork){
        
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
        [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
        NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
        NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,GetCardList];
        self.manager1 =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
            if([json[@"code"] isEqual:@(100)]){
                [dataArr removeAllObjects];
                for (NSDictionary * dic in json[@"data"]) {
                    CardListModel *model = [CardListModel yy_modelWithDictionary:dic];
                    [dataArr addObject:model];
                }
                [self.collect reloadData];
            }else{
                [MBProgressHUD showWithText:json[@"msg"]];
            }
            
            [self endRefresh];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [self endRefresh];
    
        } andProgressView:nil progressViewText:@"加载中" progressViewType:0 ViewController:self];
    
    }else{
        
        [self endRefresh];
        [self.poorNetWorkView show];
        __weak typeof (self) weakSelf = self;
        self.poorNetWorkView.reloadBlock = ^{
            [weakSelf requestInfomations];
        };
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    [self.manager1.tasks makeObjectsPerformSelector:@selector(cancel)];
    [self endRefresh];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if(dataArr.count==0){
        [self requestInfomation];
    }
}

- (void)endRefresh{
    [self.collect.mj_header endRefreshing];
}

- (void)setUpCollectionView{
    
    // 配置UICollectionViewFlowLayout
    UICollectionViewFlowLayout *collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    //配置全局每行之间间距,如果需要单独定义,调用[minimumLineSpacingForSectionAtIndex]
    collectionFlowLayout.minimumLineSpacing = 7;
    //全局配置每行中每个Item之间的间距,如果需要单独定义,调用[minimumInteritemSpaceingForSectionAtIndex]
    collectionFlowLayout.minimumInteritemSpacing = 10;
    collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth , ScreenHeight - 64 - 40 - 5) collectionViewLayout:collectionFlowLayout];
    self.view.backgroundColor = RGBColor(243, 243, 243);
    self.collect.backgroundColor = self.view.backgroundColor;
    self.collect.contentInset = UIEdgeInsetsMake(11, 0, 0, 0);
    self.collect.alwaysBounceVertical = YES;
    // 注册
    [self.collect registerNib:[UINib nibWithNibName:@"CTManagerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CTManagerCollectionViewCell"];
    
    //配置数据源
    _collect.dataSource = self;
    _collect.delegate = self;
    [self.view addSubview:_collect];
    __weak typeof(self) weakSelf = self;
    
    self.collect.mj_header = [LYCRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf requestInfomations];
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CTManagerCollectionViewCell *cell = (CTManagerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CTManagerCollectionViewCell" forIndexPath:indexPath];
    
    if(dataArr.count){
        
        cell.model = dataArr[indexPath.row];
        
    }
    return cell;
}

//配置item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth*360/375,ScreenWidth *110/375);
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [MobClick event:@"seeTheDetailOfCard"];
    CarTeamCardDetailViewController *detail = [[CarTeamCardDetailViewController alloc]init];
    CardListModel * model = dataArr[indexPath.row];
    
    if([model.cardStatus isEqualToString:@"待审核"]){
        
        LYCAlertController * alertC = [LYCAlertController alertControllerWithTitle:@"该卡片正在审核中" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:YES completion:nil];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertC addAction:action];
        
    }else{
        
        detail.detailCardId = model.cardId.stringValue;
        detail.detailCardNO = model.cardNo;
        detail.detailCardType = model.cardType.stringValue;
        detail.detailCardData = model.createDateTime;
        detail.detailCardStatus = model.cardStatus;
        [self.navigationController pushViewController:detail animated:YES];
    
    }
}

- (IBAction)addCard:(id)sender {
    [MobClick event:@"quickBind"];
    QuickBindViewController *quickBind = [[QuickBindViewController alloc]init];
    [self.navigationController pushViewController:quickBind animated:YES];
}

- (IBAction)shareButton:(id)sender {
    [LYCHelper helper].selfVC = self;
    [LYCHelper shareBoardBySelfDefined];
}





@end
