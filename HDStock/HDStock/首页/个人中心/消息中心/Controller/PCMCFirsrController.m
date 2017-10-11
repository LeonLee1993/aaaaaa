//
//  PCMCFirsrController.m
//  HDStock
//
//  Created by liyancheng on 16/12/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCMCFirsrController.h"
#import "PCMCFirstTableViewCell.h"

@interface PCMCFirsrController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView1;
@end

@implementation PCMCFirsrController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.tableView1){
        self.tableView1 = [[UITableView alloc]init];
    }
//    [self setNavDicWithTitleFont:17 titleColor:[UIColor whiteColor] title:@"互动消息"];
    self.title = @"互动消息";
//    [self setNavCustemViewForLeftItemWithImage:imageNamed(@"Live_back") title:@"返回" titleFont:[UIFont systemFontOfSize:(15)] titleCoclor:[UIColor clearColor] custemViewFrame:CGRM(0, 26, 56, 44)];
    // Do any additional setup after loading the view.
    [self setTableView];
}

- (void)setTableView{
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.backgroundColor = BACKGROUNDCOKOR;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"PCMCFirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"PCMCFirstTableViewCell"];
    self.tableView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:_tableView1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        PCMCFirstTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"PCMCFirstTableViewCell"];
        tableViewCell.messageLabel.text =  @"老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！";
        return tableViewCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * tempStr = @"老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！老师讲得好！";
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.headIndent = 0;
    style1.firstLineHeadIndent = 0;
    style1.lineSpacing = 8;
    CGSize secondDesc = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1} context:nil].size;
    return 111+secondDesc.height-28;
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
