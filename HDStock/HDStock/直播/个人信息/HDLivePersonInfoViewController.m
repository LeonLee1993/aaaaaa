//
//  HDLivePersonInfoViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLivePersonInfoViewController.h"



@interface HDLivePersonInfoViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tb;
    NSArray * titleArr;//表格左边标题数组
    NSDictionary * descTitleDic;//描述信息
    NSArray * descTitleKeyArr;//取数据的key
    NSArray * cellRowHeightArr;//cell每行行高
    NSArray * rightDescArr;//内容
    
}

@end

@implementation HDLivePersonInfoViewController

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self setUp];
    [self requestOfPersonInfo];
    [self createGropedTB];
}
- (void) setUp{
    cellRowHeightArr = @[@[@80,@50,@50,@50],@[@80],@[@50,@50]];
    titleArr = @[@[@"头像",@"昵称",@"认证",@"简介"],@[@"能力圈"],@[@"资格证号",@"从业年限"]];
    rightDescArr = @[@[@"http://www.baidu.com",@"胜者为王",@"第一届实盘大赛专业组第一",@"实战验证实力"],@[@[@"短线",@"中长线",@"计算机",@"食品"]],@[@"A034061680001,每天一节狙击课",@"15年"]];
    descTitleKeyArr = @[@[@"headPic",@"nickName",@"profile",@"descInfo"],@[@"nengLiQuan"],@[@"profileNum",@"jobYear"]];
    
    [descTitleKeyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [descTitleDic setValue:rightDescArr[idx] forKey:obj];
    }];
}
- (void) setNav {
    self.title = @"资料";
    self.view.backgroundColor =  COLOR(whiteColor);
    [self setNormalBackNav];
}
- (void) backItemWithCustemViewBtnClicked {
    [super backItemWithCustemViewBtnClicked];
    if (self.pausePlayerWhenPushBlock) {
        self.pausePlayerWhenPushBlock();
    }
}
#pragma mark - 创建分组表格
- (void ) createGropedTB
{
//    self.automaticallyAdjustsScrollViewInsets = NO;

    UITableView * tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT ) style:(UITableViewStyleGrouped)];
//    tb.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tb.bounds.size.width, 0.01f)];
//    tb.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tb.bounds.size.width,  0.01f)];
    
    tb.delegate = self;
    tb.dataSource = self;
    tb.showsVerticalScrollIndicator = NO;
    tb.bounces = NO;
    _tb = tb;
    [self.view addSubview:_tb];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [titleArr[section] count];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [cellRowHeightArr[indexPath.section][indexPath.row] floatValue];
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 11.0;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuseId = @"guPingCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:reuseId];
    }
    
    [self setCellLabelStyleWithCell:cell indexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0) {//头像
        
        CGFloat headPicHeight = 46;
        UIImageView * headPicIMV = [[UIImageView alloc] initWithFrame:CGRM(SCREEN_WIDTH-10-headPicHeight, [cellRowHeightArr[0][0] floatValue]/2-headPicHeight/2, headPicHeight, headPicHeight)];
        headPicIMV.layer.cornerRadius = headPicHeight/2;
        headPicIMV.layer.masksToBounds = YES;
        headPicIMV.image = imageNamed(@"weidenglu");
        [cell.contentView addSubview:headPicIMV];
        
    }else if (indexPath.section == 1) {//能力圈
        
        for (int i = 0; i < [rightDescArr[indexPath.section][indexPath.row] count]; i++) {
            CGSize tempSize = [rightDescArr[indexPath.section][indexPath.row][i] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
            [self createNengLiQuanLabWithIndex:i bgView:cell.contentView indexPath:indexPath tempSize:tempSize];
        }
    }else {
        cell.detailTextLabel.text = rightDescArr[indexPath.section][indexPath.row];
    }
    
    return cell;
}

- (void) setCellLabelStyleWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath*) indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.textColor = TEXT_COLOR;
    cell.textLabel.textColor = UICOLOR(153, 153, 153, 1);;
    cell.textLabel.font = systemFont(13);
    cell.detailTextLabel.font = systemFont(13);
    cell.detailTextLabel.numberOfLines = 2;
    cell.textLabel.text = titleArr[indexPath.section][indexPath.row];//标题

}
//创建能力圈label
- (void) createNengLiQuanLabWithIndex:(NSInteger)i bgView:(UIView *)bgView indexPath:(NSIndexPath*)indexPath tempSize:(CGSize) tempSize {
    
    CGFloat horSpace = 5;
    CGFloat verSpace = 5;
    
    UILabel * tempLabel = [ZHFactory createLabelWithFrame:CGRectZero andFont:[UIFont systemFontOfSize:13] andTitleColor:UICOLOR(0, 146, 209, 1) title:rightDescArr[indexPath.section][indexPath.row][i]];
    tempLabel.layer.cornerRadius = (tempSize.height+4)/2;
    tempLabel.layer.masksToBounds = YES;
    tempLabel.layer.borderWidth = 1;
    tempLabel.layer.borderColor = UICOLOR(6, 150, 199, 1).CGColor;
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.tag = 600+i;
    [bgView addSubview:tempLabel];
    
    NSInteger btnNumOfEachRow = 3;
    UIView * firstView = nil;
    UIView * frontView = nil;
    if (i == 0) {
        firstView = [bgView viewWithTag:600];
    }
    if (i > 0) {
        frontView = [bgView viewWithTag:600+i-1];
    }
    
    [tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(tempSize.width+12, 21));
        
        i ==0 ? make.left.equalTo(bgView.mas_left).with.offset(SCREEN_WIDTH/3):(i%btnNumOfEachRow==0?make.left.equalTo(bgView.mas_left).with.offset(SCREEN_WIDTH/3):make.left.equalTo(frontView.mas_right).with.offset(horSpace));
        
        i ==0 ? make.top.equalTo(bgView).with.offset([cellRowHeightArr[0][0] floatValue]/2-tempSize.height) : (i%btnNumOfEachRow==0?make.top.equalTo(frontView.mas_bottom).with.offset(verSpace):make.top.equalTo(frontView.mas_top));
    }];
}

#pragma mark - 网络请求
- (void) requestOfPersonInfo {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
