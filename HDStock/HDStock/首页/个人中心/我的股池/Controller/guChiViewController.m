//
//  guChiViewController.m
//  HDStock
//
//  Created by liyancheng on 16/11/28.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "guChiViewController.h"
#import "guChipreSaleCell.h"
#import "guChiOperationCell.h"
#import "guChiEndedCell.h"

@interface guChiViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * guChiTableView;

@end

@implementation guChiViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(UITableView *)guChiTableView{
    if(_guChiTableView == nil){
        
    }
    return  _guChiTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDCOKOR;
    [self setHeader];
    [self setTableView];
}

- (void)setTableView{
    _guChiTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_guChiTableView];
    _guChiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _guChiTableView.delegate = self;
    _guChiTableView.dataSource = self;
    [_guChiTableView registerNib:[UINib nibWithNibName:@"guChipreSaleCell" bundle:nil] forCellReuseIdentifier:@"guChipreSaleCell"];
    [_guChiTableView registerNib:[UINib nibWithNibName:@"guChiOperationCell" bundle:nil] forCellReuseIdentifier:@"guChiOperationCell"];
    [_guChiTableView registerNib:[UINib nibWithNibName:@"guChiEndedCell" bundle:nil] forCellReuseIdentifier:@"guChiEndedCell"];
}



- (void)setHeader{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    headView.backgroundColor = RGBCOLOR(25,121,202);
    [self.view addSubview:headView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 34, 200, 18)];
    [headView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = @"股池";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *backToView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 100, 44)];
    backToView.backgroundColor = [UIColor clearColor];
    [headView addSubview:backToView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToPresentView)];
    UIImageView * backImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 12, 19)];
    [backToView addSubview:backImage];
    [backToView addGestureRecognizer:tap];
}

- (void)backToPresentView{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- tableViewDataSource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
    guChipreSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"guChipreSaleCell"];
    return cell;
    }
    else if(indexPath.row==1){
        guChipreSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"guChiOperationCell"];
        return cell;
    }
    else if(indexPath.row==2){
        guChipreSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"guChiEndedCell"];
        return cell;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return  280;
            break;
        case 1:
            return  315;
            break;
        case 2:
            return  290;
            break;
            
        default:
            break;
    }
    return 0;
    
}

@end
