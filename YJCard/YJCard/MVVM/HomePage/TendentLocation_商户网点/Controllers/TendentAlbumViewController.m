//
//  TendentAlbumViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/8/9.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TendentAlbumViewController.h"
#import "TendentAlbumCollectionViewCell.h"

@interface TendentAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation TendentAlbumViewController{
    NSMutableArray * dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getTendentList];
    dataArr = @[].mutableCopy;
    // 配置UICollectionViewFlowLayout
    UICollectionViewFlowLayout *collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    //配置全局每行之间间距,如果需要单独定义,调用[minimumLineSpacingForSectionAtIndex]
    collectionFlowLayout.minimumLineSpacing = 10;
    //全局配置每行中每个Item之间的间距,如果需要单独定义,调用[minimumInteritemSpaceingForSectionAtIndex]
    collectionFlowLayout.minimumInteritemSpacing = 10;
    collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.collectionViewLayout = collectionFlowLayout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TendentAlbumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TendentAlbumCollectionViewCell"];
}

//配置item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth/375*172.5,ScreenWidth/375*172.5);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TendentAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TendentAlbumCollectionViewCell" forIndexPath:indexPath];
    cell.imageURL = dataArr[indexPath.row][@"imgUrl"];
    return cell;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)getTendentList{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:self.idStr forKey:@"retailerid"];
    // 发送请求
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,@"getretailerpics"];
    self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        
        if([json[@"code"] isEqual:@(100)]){
            
            [dataArr addObjectsFromArray:json[@"data"]];
            
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {

        [self getTendentList];
    } andProgressView:nil progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:nil];
}


@end
