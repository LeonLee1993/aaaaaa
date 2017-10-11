//
//  PersonalJinnangViewController.m
//  HDStock
//
//  Created by liyancheng on 16/11/29.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PersonalJinnangViewController.h"
#import "PersonalJinnangCell.h"

@interface PersonalJinnangViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PersonalJinnangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeader:@"产品"];
    [self initScrollView];
    [self setTableViewsWithCellKindsArray:@[@""]];
    [self setTableView];
}

- (void)setTableView{
    [self.scrollView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"PersonalJinnangCell" bundle:nil] forCellReuseIdentifier:@"PersonalJinnangCell"];
    self.tableView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView1){
        PersonalJinnangCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalJinnangCell"];
        return cell;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView1) {
        return 215*SCREEN_WIDTH/375;
    }else{
        return 0;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

@end
