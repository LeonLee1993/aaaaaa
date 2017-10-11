//
//  HDLiveRewardsViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/23.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveRewardsViewController.h"
#import "HDLiveSubmitOrderViewController.h"

@interface HDLiveRewardsViewController (){
    
    //在vc的view上加一个滚动视图，用于textFiled向上推的问题
    UIScrollView * bgSC;//背景滚动视图
    //顶部
    UIView * headBottomBgView;//头部蓝色背景
    CGFloat leftRightSpace;//左右编剧
    CGFloat headBottomViewHeight;
    CGFloat headPicHeight;//头像高度
    UIImageView * headIMV;//头像
    UILabel * nameLabl;//昵称
    UILabel * descLabl;//简介
    UILabel * rewardsNumLabl;//被打赏次数
    //中部
    UIView * centerBgView;//中间的金额背景视图
    CGFloat centerBgViewHeight;//中间背景视图高度
    //底部
    UITextField * inputRewardsTextF;//输入打赏金额
}

@end

@implementation HDLiveRewardsViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    [self createUI];
    
}

- (void) setUp {
    
    [self setNormalBackNav];
    self.title = @"打赏";
    self.view.backgroundColor = UICOLOR(238, 238, 245, 1);
    //顶部
    headBottomViewHeight = 126.0*WIDTH;
    leftRightSpace = 10.0;
    headPicHeight = 46.0;
    //中间
    centerBgViewHeight = 128.0f*WIDTH;
    
}
- (void)backItemWithCustemViewBtnClicked {
    [super backItemWithCustemViewBtnClicked];
    if (self.pausePlayerWhenPushBlock) {
        self.pausePlayerWhenPushBlock();
    }
}
- (void) createUI {
    
    bgSC = [[UIScrollView alloc] initWithFrame:CGRM(0, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT)];
    bgSC.backgroundColor = UICOLOR(238, 238, 245, 1);
    [self.view addSubview:bgSC];
    
    [self createHeadView];
    [self createCenterView];
    [self createBottomView];
}
- (void) createHeadView {

    //蓝色背景
    headBottomBgView = [[UIView alloc] initWithFrame:CGRM(0, 0, SCREEN_WIDTH, headBottomViewHeight)];
    headBottomBgView.backgroundColor = NAVCOLOR;
    [bgSC addSubview:headBottomBgView];
    
    //白色背景上的内容
    CGFloat frontBgViewHeight = headBottomViewHeight-leftRightSpace*2;//白色部分高度
    CGFloat headTopWidth = (SCREEN_SIZE_WIDTH-leftRightSpace*2);//白色部分宽度
    CGFloat headTopHeight = (headBottomViewHeight-leftRightSpace*2)*3.0/5*WIDTH;//虚线上半部分高度
    UIFont *nameFont = [UIFont systemFontOfSize:13];//昵称
    UIFont *descFont = [UIFont systemFontOfSize:11];//昵称下面的介绍
    CGFloat rewardsIMVWidth = 20.0;//赏字大小
    
    //白色背景
    UIView * frontBgView = [[UIView alloc] initWithFrame:CGRM(leftRightSpace, leftRightSpace, SCREEN_SIZE_WIDTH-leftRightSpace*2, frontBgViewHeight)];
    frontBgView.backgroundColor = COLOR(whiteColor);
    frontBgView.layer.cornerRadius = 10;
    frontBgView.layer.masksToBounds = YES;
    [headBottomBgView addSubview:frontBgView];

    //头像
    headIMV = [[UIImageView alloc] initWithFrame:CGRM(leftRightSpace, headTopHeight/2-headPicHeight/2, headPicHeight, headPicHeight)];
    headIMV.image = imageNamed(@"weidenglu");
    headIMV.layer.cornerRadius = headPicHeight/2.0;
    headIMV.layer.masksToBounds = YES;
    [frontBgView addSubview:headIMV];
    //昵称
    CGSize nameSize = [@"张三" sizeWithAttributes:@{NSFontAttributeName:nameFont}];
    nameLabl = [ZHFactory createLabelWithFrame:CGRM(CGMAX_X(headIMV.frame)+leftRightSpace, CGMIN_Y(headIMV.frame)+3, headTopWidth - leftRightSpace - (CGMAX_X(headIMV.frame)+leftRightSpace), nameSize.height) andFont:nameFont andTitleColor:TEXT_COLOR title:@"张三"];
    [frontBgView addSubview:nameLabl];
//    nameLabl.backgroundColor = COLOR(yellowColor);

    //简介
    descLabl = [ZHFactory createLabelWithFrame:CGRM(CGMIN_X(nameLabl.frame), CGMAX_Y(nameLabl.frame)+6, CGWIDTH(nameLabl.frame), CGHEIGHT(nameLabl.frame)) andFont:descFont andTitleColor:UICOLOR(102, 102, 102, 1) title:@"入市18年，能够准确识破主力，及时捕获热点抓停！"];
    [frontBgView addSubview:descLabl];
//    descLabl.backgroundColor = COLOR(orangeColor);
    
    //虚线
    UIImageView * lineIMV = [[UIImageView alloc] initWithFrame:CGRM(0, headTopHeight, headTopWidth, 0.5)];
    lineIMV.image = imageNamed(@"Live_rewards_weakLine");
    [frontBgView addSubview:lineIMV];
    
    //赏字
    UILabel * rewardsLabl = [ZHFactory createLabelWithFrame:CGRM(CGMID_X(headIMV.frame)-rewardsIMVWidth/2, CGMAX_Y(lineIMV.frame)+((frontBgViewHeight-CGMAX_Y(lineIMV.frame))/2-rewardsIMVWidth/2), rewardsIMVWidth, rewardsIMVWidth) andFont:[UIFont systemFontOfSize:13] andTitleColor:[UIColor whiteColor] title:@"赏"];
    rewardsLabl.backgroundColor = UICOLOR(216, 150, 61, 1);
    rewardsLabl.layer.cornerRadius = CGWIDTH(rewardsLabl.frame)/2.0;
    rewardsLabl.layer.masksToBounds = YES;
    rewardsLabl.textAlignment = NSTextAlignmentCenter;
    [frontBgView addSubview:rewardsLabl];
    
    //被打赏：
    CGSize rewardsNumWordsSize = [@"被打赏：" sizeWithAttributes:@{NSFontAttributeName:descFont}];
    UILabel * rewardsNumWordsLabl = [ZHFactory createLabelWithFrame:CGRM(CGMIN_X(nameLabl.frame), CGMID_Y(rewardsLabl.frame)-rewardsNumWordsSize.height/2, rewardsNumWordsSize.width, rewardsNumWordsSize.height) andFont:descFont andTitleColor:TEXT_GRAY_COLOR title:@"被打赏："];
    [frontBgView addSubview:rewardsNumWordsLabl];
    
    rewardsNumLabl = [ZHFactory createLabelWithFrame:CGRM(CGMAX_X(rewardsNumWordsLabl.frame)+2, CGMID_Y(rewardsNumWordsLabl.frame)-rewardsLabl.height/2, headTopWidth-CGMAX_X(rewardsNumWordsLabl.frame)-leftRightSpace, rewardsLabl.height) andFont:descFont andTitleColor:TEXT_GRAY_COLOR title:@"25次"];
    [frontBgView addSubview:rewardsNumLabl];
//    rewardsNumLabl.backgroundColor = COLOR(orangeColor);
    
    
}
- (void) createCenterView {
    centerBgView = [[UIView alloc] initWithFrame:CGRM(0, CGMAX_Y(headBottomBgView.frame), SCREEN_SIZE_WIDTH, centerBgViewHeight)];
    centerBgView.backgroundColor = UICOLOR(238, 238, 245, 1);
    [bgSC addSubview:centerBgView];
    
    NSInteger rowNum = 3;
    CGFloat width = 81*WIDTH;
    CGFloat height = 35*WIDTH;
    CGFloat verSpace = (centerBgView.height-height*2)/3;
    NSArray * moneyArr = @[@"¥ 5",@"¥ 10",@"¥ 20",@"¥ 30",@"¥ 50",@"¥ 100"];
    for (int i = 0; i < moneyArr.count; i++) {
        UIButton * tempMoneyBtn = [ZHFactory createBtnWithFrame:CGRectZero title:moneyArr[i] titleFont:[UIFont systemFontOfSize:13] titleCoclorNormal:TEXT_COLOR titleCoclorSelected:[UIColor whiteColor] backgroundImageNormal:nil backgroundImageSelected:nil tag:300+i];
        i == 0? tempMoneyBtn.selected = YES:NO;
        tempMoneyBtn.isSelected ? (tempMoneyBtn.backgroundColor=UICOLOR(25, 121, 202, 1)):(tempMoneyBtn.backgroundColor=[UIColor whiteColor]);
        [tempMoneyBtn addTarget:self action:@selector(tempMoneyBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        tempMoneyBtn.layer.borderWidth = 0.7;
        tempMoneyBtn.layer.borderColor = UICOLOR(25, 121, 202, 1).CGColor;
        [centerBgView addSubview:tempMoneyBtn];
        
        
        CGFloat space = (centerBgView.width-width*rowNum)/(rowNum+1);
        UIButton * tempView = (UIButton *)[centerBgView viewWithTag:300+i];
        UIView * frontView = nil;
        UIView * firstView = nil;
        if (i > 0) {
            frontView = [centerBgView viewWithTag:300+i-1];
        }
        if (i == 0) {
            firstView = [centerBgView viewWithTag:300];
        }
        
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.size.mas_equalTo(CGSizeMake(width, height));
            
            i ==0 ? make.left.equalTo(centerBgView.mas_left).with.offset(space):(i%rowNum==0?make.left.equalTo(centerBgView.mas_left).with.offset(space):make.left.equalTo(frontView.mas_right).with.offset(space));
            
            i ==0 ? make.top.equalTo(centerBgView).with.offset(verSpace) : (i%rowNum==0?make.top.equalTo(frontView.mas_bottom).with.offset(verSpace):make.top.equalTo(frontView.mas_top));
        }];
    }
}
//填写打赏金额
- (void) createBottomView {
    //背景
    UIView * inputRewordsBgView = [[UIView alloc] initWithFrame:CGRM(0, CGMAX_Y(centerBgView.frame), SCREEN_SIZE_WIDTH, 41*WIDTH)];
    inputRewordsBgView.backgroundColor = UICOLOR(254, 255, 255, 1);
    [bgSC addSubview:inputRewordsBgView];
    
    CGSize daShangLeftSize = [@"打赏金额" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    UILabel * daShangLeftLabl = [ZHFactory createLabelWithFrame:CGRM(leftRightSpace-2, 0, daShangLeftSize.width, inputRewordsBgView.height) andFont:[UIFont systemFontOfSize:15] andTitleColor:TEXT_COLOR title:@"打赏金额"];
    [inputRewordsBgView addSubview:daShangLeftLabl];
    
    //输入框
    inputRewardsTextF = [[UITextField alloc] initWithFrame:CGRM(CGMAX_X(daShangLeftLabl.frame)+leftRightSpace, 0, inputRewordsBgView.width-CGMAX_X(daShangLeftLabl.frame)-leftRightSpace*2-10, inputRewordsBgView.height)];
    inputRewardsTextF.placeholder = @"我是土豪，任意赏";
    inputRewardsTextF.font = systemFont(13);
    inputRewardsTextF.textColor = TEXT_COLOR;
//    inputRewardsTextF.backgroundColor = COLOR(orangeColor);
    [inputRewordsBgView addSubview:inputRewardsTextF];
    
    
    UILabel * yuanLabl = [ZHFactory createLabelWithFrame:CGRM(inputRewordsBgView.width-leftRightSpace-10, 0, 30, inputRewordsBgView.height) andFont:[UIFont systemFontOfSize:15] andTitleColor:TEXT_COLOR title:@"元"];
    [inputRewordsBgView addSubview:yuanLabl];
    
    
    CGFloat giveRewardsBtnHeight = 41*WIDTH;//打赏按钮高度
    CGFloat leftSpace = 30;//左右边距
    UIButton * giveRewardsBtn = [ZHFactory createBtnWithFrame:CGRM(leftSpace, CGMAX_Y(inputRewordsBgView.frame)+ (SCREEN_HEIGHT-CGMAX_Y(inputRewordsBgView.frame))*1.0/7-giveRewardsBtnHeight/2, SCREEN_SIZE_WIDTH-leftSpace*2, giveRewardsBtnHeight) title:@"打赏" titleFont:[UIFont systemFontOfSize:16] titleCoclorNormal:[UIColor whiteColor] titleCoclorSelected:nil backgroundImageNormal:nil backgroundImageSelected:nil tag:400];
    giveRewardsBtn.backgroundColor = NAVCOLOR;
    [giveRewardsBtn addTarget:self action:@selector(giveRewardsBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    giveRewardsBtn.layer.cornerRadius = 6;
    giveRewardsBtn.layer.masksToBounds = YES;
    [bgSC addSubview:giveRewardsBtn];
    
    bgSC.contentSize = CGSizeMake(SCREEN_SIZE_WIDTH, CGMAX_Y(giveRewardsBtn.frame)+2);
}




#pragma mark - 点击事件
- (void) tempMoneyBtnClicked:(UIButton *) sender {
    for (int i = 0; i < 6; i++) {
        UIButton * tempBtn = (UIButton *)[centerBgView viewWithTag:300+i];
        tempBtn.selected = NO;
        tempBtn.backgroundColor = COLOR(whiteColor);
    }
    sender.selected = YES;
    sender.isSelected ? (sender.backgroundColor=UICOLOR(24, 122, 204, 1)):(sender.backgroundColor=[UIColor whiteColor]);
}

- (void) giveRewardsBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    HDLiveSubmitOrderViewController * vc = [HDLiveSubmitOrderViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

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
