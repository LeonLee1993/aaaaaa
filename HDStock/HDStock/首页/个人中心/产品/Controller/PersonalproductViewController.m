//
//  PersonalproductViewController.m
//  HDStock
//
//  Created by liyancheng on 16/11/29.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PersonalproductViewController.h"
#import "PersonalProductTableViewCell.h"//产品cell//裸115
#import "ProductDetailViewController.h"
#import "buiedProductListViewController.h"
#import "fullPageFailLoadView.h"
#import "AppDelegate.h"

#define alreadyBuiedKey @"alreadyBuied"

@interface PersonalproductViewController ()<UITableViewDataSource,UITableViewDelegate,fullPageFailLoadViewDelegate>

@end

@implementation PersonalproductViewController{
    NSMutableArray *statusDataArr;
    fullPageFailLoadView *fullFailLoad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeader:@"巨景金太阳"];
    [self initScrollView];
    [self setTableViewsWithCellKindsArray:@[@""]];
    [self setTableView];
   
    if(!statusDataArr){
        statusDataArr = @[].mutableCopy;
    }
    fullFailLoad = [[fullPageFailLoadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];;
    fullFailLoad.delegate = self;
    [self.view addSubview:fullFailLoad];
    [fullFailLoad showWithAnimation];
    [self loadDataOfProductList];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate * thyDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (thyDel.buySuccededToRefreshUIBool) {
        [fullFailLoad showWithAnimation];
        [self loadDataOfProductList];
        thyDel.buySuccededToRefreshUIBool = NO;
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToPresentView)];
    self.tabBarController.tabBar.hidden = YES;
    [self.backToView addGestureRecognizer:tap];

}

- (void)backToPresentView{
     [self dismissViewControllerAnimated:YES completion:nil];
     [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)loadDataOfProductList{
    [statusDataArr removeAllObjects];
    NSDictionary *userInfoDic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",@"http://gkc.cdtzb.com/api/order/productlist/",userInfoDic[PCUserToken]];
    [[CDAFNetWork sharedMyManager]get:urlStr params:nil success:^(id json) {
        if([json[@"code"] isEqual:@(1)]){
            for (NSDictionary *dic in json[@"data"]) {
                NSString * stateStr = dic[@"status"];
                [statusDataArr addObject:stateStr];
            }
            [self.tableView1 reloadData];
        }else{
            NSLog(@"获取失败");
        }
        [fullFailLoad hide];
    } failure:^(NSError *error) {
        [fullFailLoad showWithoutAnimation];
    }];
}


- (void)setTableView{
    [self.scrollView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.backgroundColor = BACKGROUNDCOKOR;
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"PersonalProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalProductTableViewCell"];
    self.tableView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return statusDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView1){
        PersonalProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalProductTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(statusDataArr.count==4){
            [self setViewWithCell:cell andIndex:indexPath];
        }
        return cell;
    }else{
        return nil;
    }
}

- (void)setViewWithCell:(PersonalProductTableViewCell *)cell andIndex:(NSIndexPath *)indexPath{
    NSArray *arr = [[LYCUserManager informationDefaultUser].defaultUser objectForKey:alreadyBuiedKey];
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:arr];
    
    if( [statusDataArr[indexPath.row] isEqual:@(1)]){
        
        if(![mutArr containsObject:@(indexPath.row+1).stringValue]){
            [mutArr addObject:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
        }
        
        [cell.stateButton setTitle:@" 已订阅 " forState:UIControlStateNormal];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.stateButton.backgroundColor = [UIColor clearColor];
            cell.stateButton.layer.borderWidth = 1;
            cell.stateButton.layer.borderColor = UICOLOR(102,102, 102, 1).CGColor;
            [cell.stateButton setTitleColor:RGBCOLOR(102,102,102) forState:UIControlStateNormal];
        });
    }else{
        [mutArr removeObject:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
        [cell.stateButton setTitle:@" 立即订阅 " forState:UIControlStateNormal];
    }
    
    [[LYCUserManager informationDefaultUser].defaultUser setObject:mutArr forKey:@"alreadyBuied"];
    
    switch (indexPath.row) {
        case 0:
        {
            [self setCell:cell cellImage:@"V6_icon" andCellTest:@"V6尊享版" andCellMainImage:@"chanpin_list_V6" andCellScriptText:@"  VIP尊享版帮您理清市场热点，挖掘潜力龙头，把握大盘方向..." andTestColor:RGBCOLOR(245,185,56)];
        }
            break;
        case 1:
        {
            [self setCell:cell cellImage:@"catchcow_icon" andCellTest:@"擒牛" andCellMainImage:@"chanpin_list_catchcow" andCellScriptText:@"  硝烟四起，烽火连天，股市的战场上神牛狂奔，却总被踩踏。何不..." andTestColor:RGBCOLOR(208,60,84)];
        }
            break;
        case 2:
        {
            [self setCell:cell cellImage:@"catchdragon_icon" andCellTest:@"降龙" andCellMainImage:@"chanpin_list_catchdragon" andCellScriptText:@"  破囚之龙,一飞冲天，欲获龙头，必拥降龙之利器。共振爆点，直指..." andTestColor:RGBCOLOR(42,146,189)];
        }
            break;
        case 3:
        {
            [self setCell:cell cellImage:@"catchmonster_icon" andCellTest:@"捉妖" andCellMainImage:@"chanpin_list_catchgoblin"andCellScriptText:@"  山雄伟，海辽阔，经奇幻。股市风云变幻，妖股横行，妖行千里..." andTestColor:RGBCOLOR(208,80,41)];
        }
            break;
            
        default:
            break;
    }
}

- (void)setCell:(PersonalProductTableViewCell *)cell cellImage:(NSString *)imageName andCellTest:(NSString *)cellTest andCellMainImage:(NSString *)mainImage andCellScriptText:(NSString *)scriptText andTestColor:(UIColor *)color{
    cell.image.image = [UIImage imageNamed:imageName];
    cell.title.text = cellTest;
    cell.title.textColor = color;
    cell.mainImage.image = [UIImage imageNamed:mainImage];
    [cell.stateButton setBackgroundColor:color];
    [cell.stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.scriptLabel.text = scriptText;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView1) {
        return 195*SCREEN_WIDTH/375;
        
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalProductTableViewCell *cellofIndex = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    if( [cellofIndex.stateButton.titleLabel.text isEqualToString:@" 已订阅 "]){
        
        
        buiedProductListViewController *list = [[buiedProductListViewController alloc]init];
        switch (indexPath.row) {
            case 0:
                list.flagStr = @"1";
                break;
            case 1:
                list.flagStr = @"2";
                break;
            case 2:
                list.flagStr = @"3";
                break;
            case 3:
                list.flagStr = @"4";
                break;
                
            default:
                break;
        }
        [self.navigationController pushViewController:list animated:YES];
    }else{
        NSArray * picArr = @[@"V6_pic",@"catchcow_pic",@"catchdragon_pic",@"catchmonster_pic"];
        NSArray * textArr = @[@"  VIP尊享版帮您理清市场热点，挖掘潜力龙头，把握大盘方向...",@"  硝烟四起，烽火连天，股市的战场上神牛狂奔，却总被踩踏。何不...",@"  破囚之龙,一飞冲天，欲获龙头，必拥降龙之利器。共振爆点，直指...",@"  山雄伟，海辽阔，经奇幻。股市风云变幻，妖股横行，妖行千里..."];
        ProductDetailViewController *PDVC = [[ProductDetailViewController alloc]init];
        PDVC.shareImageStr = picArr[indexPath.row];
        PDVC.shareTextStr = textArr[indexPath.row];
        switch (indexPath.row) {
            case 0:
                PDVC.title = @"V6尊享版";
                PDVC.urlStr = @"http://gk.cdtzb.com/api/product/x6";
                PDVC.priceStr = @"998";
                PDVC.idStr = @"1";
                break;
            case 1:
                PDVC.title = @"擒牛";
                PDVC.urlStr = @"http://gk.cdtzb.com/api/product/qn";
                PDVC.priceStr = @"1998";
                PDVC.idStr = @"2";
                break;
            case 2:
                PDVC.title = @"降龙";
                PDVC.urlStr = @"http://gk.cdtzb.com/api/product/xl";
                PDVC.priceStr = @"3998";
                PDVC.idStr = @"3";
                break;
            case 3:
                PDVC.title = @"捉妖";
                PDVC.urlStr = @"http://gk.cdtzb.com/api/product/zy";
                PDVC.priceStr = @"5998";
                PDVC.idStr = @"4";
                break;
                
            default:
                break;
        }
        
        [self.navigationController pushViewController:PDVC animated:YES];
    }
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
