//
//  HDLiveAskQuestionsViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/23.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveAskQuestionsViewController.h"
#import "HDLiveAskQuestionTableViewCell.h"
#import "HDLiveSubmitOrderViewController.h"


static NSString * reuseId = @"LiveJinNangCell";

@interface HDLiveAskQuestionsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIScrollView * thySC;
    UIImageView * headIMV;
    UILabel * nameLabl;
    UILabel * descLabl;
    UILabel * askAndAnserLabl;
    UIButton * careBtn;
    UITextView * textV;
    UILabel * payNumLabl;
    UIButton * payAndAskBtn;
    
    UITableView *_tb;
}

@end

@implementation HDLiveAskQuestionsViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self createThyScView];
    [self createPlainTB];
}
- (void) setNav {
    self.title = [NSString stringWithFormat:@"向%@提问",self.playerName];
    [self setNormalBackNav];
}
- (void)backItemWithCustemViewBtnClicked {
    [super backItemWithCustemViewBtnClicked];
    if (self.pausePlayerWhenPushBlock) {
        self.pausePlayerWhenPushBlock();
    }
}
- (void) createThyScView {
    
    //滚动视图
    CGFloat leftSpace = 15;
    thySC = [[UIScrollView alloc] initWithFrame:CGRM(0, 0, SCREEN_SIZE_WIDTH, kScreenIphone5?(370-NAV_STATUS_HEIGHT):((370-NAV_STATUS_HEIGHT)*1.1))];
    thySC.backgroundColor = UICOLOR(248, 248, 248, 1);
    [self.view addSubview:thySC];
    //头像
    headIMV = [[UIImageView alloc] initWithFrame:CGRM(leftSpace, 17, 46, 46)];
    headIMV.image = imageNamed(@"weidenglu");
    headIMV.layer.cornerRadius = headIMV.width/2;
    headIMV.layer.masksToBounds = YES;
    [thySC addSubview:headIMV];
    
    //昵称
    nameLabl = [ZHFactory createLabelWithFrame:CGRM(CGMAX_X(headIMV.frame)+15, 24, (SCREEN_SIZE_WIDTH-CGMAX_X(headIMV.frame)-leftSpace-leftSpace*2-46), 13) andFont:[UIFont systemFontOfSize:13] andTitleColor:TEXT_COLOR title:@"张三"];
    [thySC addSubview:nameLabl];
    
    //关注
    careBtn = [ZHFactory createBtnWithFrame:CGRM(SCREEN_SIZE_WIDTH-leftSpace-46, CGMID_Y(nameLabl.frame)-10.5, 46, 21) title:@"关注" titleFont:[UIFont systemFontOfSize:11] titleCoclor:[UIColor whiteColor] bgColor:NAVCOLOR cornerRadius:2];
    [careBtn addTarget:self action:@selector(careBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [thySC addSubview:careBtn];
    
    //简介
    descLabl = [ZHFactory createLabelWithFrame:CGRM(CGMIN_X(nameLabl.frame), CGMAX_Y(nameLabl.frame)+10, SCREEN_SIZE_WIDTH-CGMAX_X(headIMV.frame)-leftSpace*2, 11) andFont:[UIFont systemFontOfSize:11] andTitleColor:TEXT_GRAY_COLOR title:@"入市18年，能够准确识破主力，及时捕获热点抓涨停！"];
    [thySC addSubview:descLabl];
    
    //向多少人提问了
    askAndAnserLabl = [ZHFactory createLabelWithFrame:CGRM(CGMIN_X(headIMV.frame), CGMAX_Y(headIMV.frame)+10, SCREEN_SIZE_WIDTH-CGMIN_X(headIMV.frame)*2, 11) andFont:[UIFont systemFontOfSize:11] andTitleColor:TEXT_LIGHTGRAY_COLOR title:@"已有489人向张三提问，回复率98%。"];
    [thySC addSubview:askAndAnserLabl];

    //虚线
    UIView * lineView = [[UIView alloc] initWithFrame:CGRM(CGMIN_X(headIMV.frame), CGMAX_Y(askAndAnserLabl.frame)+14, SCREEN_SIZE_WIDTH-CGMIN_X(headIMV.frame)*2, 1)];
    lineView.backgroundColor = LINE_COLOR;
    [thySC addSubview:lineView];
    //输入框
    textV = [[UITextView alloc] initWithFrame:CGRM(CGMIN_X(headIMV.frame), CGMAX_Y(lineView.frame)+10, lineView.width, 109*WIDTH)];
    textV.borderWidth = 1;
    textV.borderColor = LINE_COLOR;
    textV.text = @"1、请试着将问题尽可能清晰相近的描述出来，这样投顾才能更完整、高质量的为你解答； 2、我们会推送你的问题给投顾，投顾会尽快回答你的问题，请耐心等待。问题提出后24小时未回答，您的资金将退回您的账户。";
    [thySC addSubview:textV];
    //
    UILabel * needPayLabl = [ZHFactory createLabelWithFrame:CGRM(CGMIN_X(textV.frame), CGMAX_Y(textV.frame)+5, 80, 11) andFont:[UIFont systemFontOfSize:11] andTitleColor:TEXT_LIGHTGRAY_COLOR title:@"您需支付金额："];
    [thySC addSubview:needPayLabl];
    //需要支付的金额数
    payNumLabl = [ZHFactory createLabelWithFrame:CGRM(CGMAX_X(needPayLabl.frame)+9, CGMIN_Y(needPayLabl.frame), SCREEN_SIZE_WIDTH-CGMAX_X(needPayLabl.frame)-leftSpace, 11) andFont:[UIFont systemFontOfSize:11] andTitleColor:UICOLOR(224, 11, 36, 1) title:@"¥ 5.00"];
    payNumLabl.textAlignment = NSTextAlignmentLeft;
    [thySC addSubview:payNumLabl];
    //支付并提问
    payAndAskBtn = [ZHFactory createBtnWithFrame:CGRM(SCREEN_SIZE_WIDTH_HALF-260*WIDTH/2, CGMAX_Y(needPayLabl.frame)+15, 260*WIDTH, 41) title:@"支付并提问" titleFont:[UIFont systemFontOfSize:16] titleCoclor:[UIColor whiteColor] bgColor:NAVCOLOR cornerRadius:6];
    [payAndAskBtn addTarget:self action:@selector(payAndAskBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [thySC addSubview:payAndAskBtn];
    
    thySC.contentSize = CGSizeMake(SCREEN_SIZE_WIDTH, CGMAX_Y(payAndAskBtn.frame)+5);
    
}
#pragma mark - 创建表格
- (void ) createPlainTB {
    UITableView * tb = [[UITableView alloc] initWithFrame:CGRectMake(0, CGMAX_Y(thySC.frame), SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT - CGMAX_Y(thySC.frame)) style:(UITableViewStyleGrouped)];
    tb.showsVerticalScrollIndicator = NO;
    tb.tableFooterView = [[UIView alloc] initWithFrame:CGRM(0, 0, 0.1f, 0.1f)];
    tb.tableHeaderView = [[UIView alloc] initWithFrame:CGRM(0, 0, SCREEN_SIZE_WIDTH, 41.0f)];
    tb.tableHeaderView.backgroundColor = COLOR(whiteColor);
    tb.delegate = self;
    tb.dataSource = self;
    _tb = tb;
    [self.view addSubview:_tb];
    
    UILabel * headerLabl = [[UILabel alloc] initWithFrame:CGRM(12, 0, SCREEN_SIZE_WIDTH-12, 41)];
    headerLabl.text = @"张三最近的回答";
    headerLabl.font = systemFont(15);
    headerLabl.textColor = TEXT_COLOR;
    headerLabl.textAlignment = NSTextAlignmentLeft;
    headerLabl.backgroundColor = COLOR(whiteColor);
    [tb.tableHeaderView addSubview:headerLabl];
    
    [self registCell];
    
    //网络请求
    WEAK_SELF;
    _tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requstOfAnswers];
    }];
    
    _tb.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requstOfAnswers];
    }];
    
    //    [_tb.mj_header beginRefreshing];
}

- (void) registCell {
    [_tb registerNib:[UINib nibWithNibName:@"HDLiveAskQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:reuseId];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDLiveAskQuestionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDLiveAskQuestionTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - 点击事件
- (void) payAndAskBtnClicked:(UIButton*)sender {
    sender.selected = !sender.selected;
    HDLiveSubmitOrderViewController * vc = [HDLiveSubmitOrderViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) careBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
}

#pragma mark -网络请求

- (void) requstOfAnswers{
    
}

#pragma mark - foo
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
