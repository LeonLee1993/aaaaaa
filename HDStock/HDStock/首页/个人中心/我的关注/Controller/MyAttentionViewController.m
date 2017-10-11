//
//  MyAttentionViewController.m
//  HDStock
//
//  Created by liyancheng on 16/11/29.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "MyAttentionTableViewCell.h"

@interface MyAttentionViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.tableView1){
        self.tableView1 = [[UITableView alloc]init];
    }
    // Do any additional setup after loading the view.
    [self setHeader:@"我的关注"];
    [self setTableView];
}

- (void)setTableView{
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.backgroundColor = BACKGROUNDCOKOR;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"MyAttentionTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyAttentionTableViewCell"];
    self.tableView1.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:self.tableView1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAttentionTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"MyAttentionTableViewCell"];
//    tableViewCell.messageLabel.text =  @"老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！";
//    return tableViewCell;
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableViewCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 124;
}



@end
