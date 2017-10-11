//
//  MyCommentViewController.m
//  HDStock
//
//  Created by liyancheng on 16/11/28.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "MyCommentViewController.h"
#import "MyPersonalCommentCell.h"

@interface MyCommentViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeader:@"我的评论"];
    [self initTopViewWithArray:@[@"资讯",@"视频"]];
    [self setTableViewsWithCellKindsArray:@[@"",@""]];
    [self setTableView];
}

- (void)setTableView{
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"MyPersonalCommentCell" bundle:nil] forCellReuseIdentifier:@"MyPersonalCommentCell"];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    [self.tableView2 registerNib:[UINib nibWithNibName:@"MyPersonalCommentCell" bundle:nil] forCellReuseIdentifier:@"MyPersonalCommentCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView1){
        MyPersonalCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyPersonalCommentCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView == self.tableView2){
        MyPersonalCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyPersonalCommentCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * tempStr = @"老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！";
    if (tableView == self.tableView1) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.headIndent = 0;
        style.firstLineHeadIndent = 0;
        style.lineSpacing = 9;
        CGSize firstDesc = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:style} context:nil].size;
        return 158+firstDesc.height;
    }else if(tableView == self.tableView2){
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.headIndent = 0;
        style.firstLineHeadIndent = 0;
        style.lineSpacing = 9;
        CGSize firstDesc = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:style} context:nil].size;
        return 158+firstDesc.height-15;
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
