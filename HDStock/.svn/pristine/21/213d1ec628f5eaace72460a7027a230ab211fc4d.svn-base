//
//  PCMCForthViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCMCForthViewController.h"
#import "PCMCForthTableViewCell.h"

@interface PCMCForthViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView1;

@end

@implementation PCMCForthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.tableView1){
        self.tableView1 = [[UITableView alloc]init];
    }
    [self setNavDicWithTitleFont:17 titleColor:[UIColor whiteColor] title:@"新股申购"];
    self.title = @"新股申购";
//    [self setNavCustemViewForLeftItemWithImage:imageNamed(@"Live_back") title:@"返回" titleFont:[UIFont systemFontOfSize:(15)] titleCoclor:[UIColor clearColor] custemViewFrame:CGRM(0, 26, 56, 44)];
    [self setTableView];
}

- (void)setTableView{
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.backgroundColor = BACKGROUNDCOKOR;
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"PCMCForthTableViewCell" bundle:nil] forCellReuseIdentifier:@"PCMCForthTableViewCell"];
    self.tableView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:_tableView1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCMCForthTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"PCMCForthTableViewCell"];
    if(self.model.gupiao_data.count ==2){
        tableViewCell.secondView.hidden = NO;
        tableViewCell.lineView.hidden = NO;
        NSDictionary *dic1 = ((NSArray *)self.model.gupiao_data)[0];
        NSDictionary *dic2 = ((NSArray *)self.model.gupiao_data)[1];
        tableViewCell.name.text = dic1[@"name"];
        tableViewCell.code.text = dic1[@"code"];
        tableViewCell.price.text = dic1[@"price"];
        tableViewCell.timeLabel.text = self.model.date;
        tableViewCell.titleLabel.text = self.model.title;
        
        tableViewCell.secondLabel.text = dic2[@"name"];
        tableViewCell.secondCode.text = dic2[@"code"];
        tableViewCell.secondPrice.text = dic2[@"price"];
        
    }else{
        tableViewCell.secondView.hidden = YES;
        tableViewCell.lineView.hidden = YES;
        NSDictionary *dic1 = ((NSArray *)self.model.gupiao_data)[0];
        tableViewCell.name.text = dic1[@"name"];
        tableViewCell.titleLabel.text = self.model.title;
        tableViewCell.code.text = dic1[@"code"];
        tableViewCell.price.text = dic1[@"price"];
        tableViewCell.timeLabel.text = self.model.date;
    }
    return tableViewCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.model.gupiao_data.count ==2){
        return SCREEN_WIDTH/375*235+10;
    }else{
        return SCREEN_WIDTH/375*143+10;
    }
}

@end
