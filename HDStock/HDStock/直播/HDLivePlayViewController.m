//
//  HDLivePlayViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/11.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLivePlayViewController.h"

@interface HDLivePlayViewController () <UITableViewDelegate> {
    UITableView * _tb;
}

@end

@implementation HDLivePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTB];
}

#pragma mark - 创建表格
- (void ) createTB {
    
    UITableView * tb = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_STATUS_HEIGHT, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT - NAV_STATUS_HEIGHT) style:(UITableViewStylePlain)];
    tb.backgroundColor = [UIColor redColor];
    tb.tableFooterView = [[UIView alloc] init];
    tb.delegate = self;
//    tb.dataSource = self;
    tb.bounces = NO;
    _tb = tb;
    [self.view addSubview:_tb];
}


#pragma mark - UITableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"888";
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

//#pragma mark - UITableViewDataSource





@end
