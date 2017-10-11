//
//  MyAskAndAnswerViewController.m
//  HDStock
//
//  Created by liyancheng on 16/11/28.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "MyAskAndAnswerViewController.h"
#import "MyAskSecondTableViewCell.h"//我的问答 未回复 已失效 裸71
#import "MyAskFirstTableViewCell.h"//我的问答 已回复 裸150

@interface MyAskAndAnswerViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyAskAndAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setHeader:@"我的问答"];
    [self initTopViewWithArray:@[@"已回复",@"未回复",@"已失效"]];
    [self setTableViewsWithCellKindsArray:@[@"",@"",@""]];
    [self setTableView];
    
}
- (void)setTableView{
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"MyAskFirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyAskFirstTableViewCell"];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    [self.tableView2 registerNib:[UINib nibWithNibName:@"MyAskSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyAskSecondTableViewCell"];
    self.tableView3.delegate = self;
    self.tableView3.dataSource = self;
    [self.tableView3 registerNib:[UINib nibWithNibName:@"MyAskSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyAskSecondTableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView1){
        MyAskFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAskFirstTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView == self.tableView2){
        MyAskSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAskSecondTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        MyAskSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAskSecondTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * tempStr = @"老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！";

    if (tableView == self.tableView1) {
        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
        style1.headIndent = 0;
        style1.firstLineHeadIndent = 0;
        style1.lineSpacing = 9;
        
        NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
        style2.headIndent = 0;
        style2.firstLineHeadIndent = 0;
        style2.lineSpacing = 7;
        CGSize firstDesc = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:style1} context:nil].size;
        CGSize secondDesc = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSParagraphStyleAttributeName:style2} context:nil].size;
        return 150+firstDesc.height-15-12+secondDesc.height-20;
    }else if(tableView == self.tableView2){
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.headIndent = 0;
        style.firstLineHeadIndent = 0;
        style.lineSpacing = 9;
        CGSize firstDesc = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:style} context:nil].size;
        return 71+firstDesc.height-15;
    }else{
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.headIndent = 0;
        style.firstLineHeadIndent = 0;
        style.lineSpacing = 9;
        CGSize firstDesc = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:style} context:nil].size;
        return 71+firstDesc.height-15;
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
