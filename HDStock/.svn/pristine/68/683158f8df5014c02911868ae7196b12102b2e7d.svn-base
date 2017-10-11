//
//  ZXMyInfoViewController.m
//  HDGolden
//
//  Created by hd-app01 on 16/10/21.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "ZXMyInfoViewController.h"
#import "YZTagList.h"

static NSString * const kMyInfoArr = @"myInfoArr";
static NSString * const kAutoInfoArr = @"autoInfoArr";

@interface ZXMyInfoViewController () {
    
    UILabel * centerLable;//推荐资讯
    UILabel * myInfoLabel;//我的资讯
    UIView * navLineView;//导航栏下面的线
    UIView * navCustomView;//导航条自定义背景视图
    CGFloat navCustomViewWidth;//导航条自定义背景视图宽度
}


@property (nonatomic, strong) UITableView * tb;

@property (nonatomic, strong) YZTagList *tagList;//可交换顺序的lab列表视图
@property (nonatomic, strong) NSMutableArray * myInfoArr;//我的资讯
@property (nonatomic, strong) NSMutableArray * autoInfoArr;//推荐资讯

@property (nonatomic,strong) YZTagList * bottomTagList;

@property (nonatomic,strong) UIButton * finishBtn;

@property (nonatomic,strong) UIButton * editBtn;

@property (nonatomic,strong) UIScrollView * sc;//底部滚动视图

@end

@implementation ZXMyInfoViewController

- (NSMutableArray *)autoInfoArr {
    if (!_autoInfoArr) {
        _autoInfoArr = [NSMutableArray array];
        NSArray * arr = nil;
        if ([ZHFactory readPlistWithPlistName:@"infoLabels.plist"]) {//缓存过
            arr = [[ZHFactory readPlistWithPlistName:@"infoLabels.plist"] objectForKey:kAutoInfoArr];
        } else {//未缓存过
            arr = @[@"个股",@"板块",@"大盘",@"外围"];
        }
        [_autoInfoArr addObjectsFromArray:arr];
    }
    return _autoInfoArr;
}

- (YZTagList *)tagList{
    
    if (_tagList == nil) {
        _tagList = [[YZTagList alloc] initWithFrame:CGRectMake(10*WIDTH, CGRectGetMaxY(myInfoLabel.frame)+5, [UIScreen mainScreen].bounds.size.width-20*WIDTH, 0)];
        _tagList.tagCornerRadius = 0;
        _tagList.borderWidth = 1;
        _tagList.borderColor = [UIColor lightGrayColor];
        _tagList.tagColor = TEXT_COLOR;
        _tagList.tagBackgroundColor = [UIColor whiteColor];
        _tagList.tag = 300;
        // 设置排序时，缩放比例
        _tagList.scaleTagInSort = 1.3;
        // 需要排序
        _tagList.isSort = YES;
        // 标签尺寸
        _tagList.tagSize = CGSizeMake(53*WIDTH, 20*WIDTH);
        
        //点击事件回调
        WEAK_SELF;
        _tagList.clickTagBlock = ^(NSString *btnTitleStr){
            STRONG_SELF;
            
            //从我的资讯列表删除
            [strongSelf.tagList.labelTitlesArr removeObject:btnTitleStr];
            [strongSelf clickTag:btnTitleStr];
            
            //添加到推荐资讯列表
            [strongSelf.autoInfoArr addObject:btnTitleStr];
            [strongSelf createBottomTempbtnWithIndex:(int)(strongSelf.autoInfoArr.count-1)];
        };
    }
    return _tagList;
}

- (UIScrollView *)sc {
    if (!_sc) {
        _sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navLineView.frame), SCREEN_SIZE_WIDTH,SCREEN_SIZE_HEIGHT + 5)];
        [self.view addSubview:_sc];
        
    }
    return _sc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];//定制导航栏返回按钮
    [self createUI];//创建界面
    
}

- (void)viewWillAppear:(BOOL)animated{

    [self.navigationController.navigationBar setHidden:NO];

}

- (void)viewDidDisappear:(BOOL)animated{

    [self.navigationController.navigationBar setHidden:YES];

}

//设置导航栏
- (void) setNav {
    self.title = @"我的资讯";
    [self setNavCustemViewForLeftItemWithImage:originalImageNamed(@"Live_back") title:@"返回" titleFont:[UIFont systemFontOfSize:17] titleCoclor:[UIColor whiteColor] custemViewFrame:CGRM(0, 10, 60, 30)];
    
    navLineView = [[UIView alloc] initWithFrame:CGRM(0, 0, SCREEN_SIZE_WIDTH, 1)];
    navLineView.backgroundColor = LINE_COLOR;
    [self.view addSubview:navLineView];
        
}
//导航条返回按钮
- (void)backItemWithCustemViewBtnClicked {
    if (self.infoBlcok) {
        //本地保存
        [self handleLabelsHuanCunData];
        self.infoBlcok(self.tagList.labelTitlesArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//处理缓存数据
- (void) handleLabelsHuanCunData {
    NSDictionary * dic = @{kMyInfoArr:[self.tagList.labelTitlesArr copy],
                           kAutoInfoArr:[self.autoInfoArr copy]
                           };
    [self plistHuanCunWithDic:dic];
}

#pragma mark- plist缓存
//缓存数据到本地plist
- (void) plistHuanCunWithDic:(NSDictionary *) dic {
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"infoLabels.plist"];
    //写入
    [dic writeToFile:plistPath atomically:YES];
}


- (void)clickTag:(NSString *)tag
{
    // 删除标签
    [_tagList deleteTag:tag];
    
}
- (void) createUI {
    
    self.view.backgroundColor = COLOR(whiteColor);
    
    CGSize myInfoSize = [@"我的资讯" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16*WIDTH]}];
    myInfoLabel = [ZHFactory createLabelWithFrame:CGRM(10*2*WIDTH, 20, myInfoSize.width+5, myInfoSize.height) andFont:systemFont(16*WIDTH) andTitleColor:TEXT_COLOR title:@"我的资讯"];
    myInfoLabel.tag = 301;
    [self.sc addSubview:myInfoLabel];

    CGSize desSize = [@"拖拽可排序 点击可编辑" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    UILabel * descLabel = [ZHFactory createLabelWithFrame:CGRM(CGRectGetWidth(self.sc.frame)-desSize.width - 10*WIDTH*2, CGRectGetMidY(myInfoLabel.frame)-desSize.height/2, desSize.width, desSize.height) andFont:systemFont(13) andTitleColor:[UIColor grayColor] title:@"拖拽可排序 点击可编辑"];
    descLabel.tag = 302;
    [self.sc addSubview:descLabel];
    
    [self createHeadTagList];
    
    [self createBottomBtnList];
    
}
//我的资讯
- (void) createHeadTagList {
    NSArray * arr = nil;
    if ([ZHFactory readPlistWithPlistName:@"infoLabels.plist"]) {//有缓存
        arr = [NSArray arrayWithArray:[[ZHFactory readPlistWithPlistName:@"infoLabels.plist"] objectForKey:kMyInfoArr]];
    }else {//还未缓存过
        arr = @[@"推荐",@"要闻",@"7*24小时",@"日历"];
    }
    NSInteger index = 0;
    for (NSString * tagStr in arr) {
        [self.tagList addTag:tagStr andIndex:index];
        [self.tagList.labelTitlesArr addObject:tagStr];
        index ++;
    }
    [self.sc addSubview:_tagList];
}

//推荐资讯
- (void) createBottomBtnList {
    centerLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.tagList.frame)+15*WIDTH, CGRectGetMaxY(self.tagList.frame) + 16*WIDTH, 90, 25)];
    centerLable.textAlignment = NSTextAlignmentLeft;
    centerLable.textColor = TEXT_COLOR;
    centerLable.font = [UIFont systemFontOfSize:16*WIDTH];
    centerLable.text = @"推荐资讯";
    [self.sc addSubview: centerLable];
    centerLable.tag = 303;
    
    if (self.autoInfoArr.count > 0) {//没数据
        for (int i = 0; i < self.autoInfoArr.count; i++) {
            
            UIButton * tempBtn = [self createBottomTempbtnWithIndex:i];
            if (i == self.autoInfoArr.count-1) {
                self.sc.contentSize = CGSizeMake(SCREEN_SIZE_WIDTH-CGRectGetMinX(self.tagList.frame)*2, CGRectGetMaxY(tempBtn.frame)+10);
            }
        }
    }else {//有数据
        self.sc.contentSize = CGSizeMake(SCREEN_SIZE_WIDTH-CGRectGetMinX(self.tagList.frame)*2, CGRectGetMaxY(centerLable.frame)+10);
    }
}
- (UIButton *) createBottomTempbtnWithIndex:(int) i{
    UIButton * tempBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    tempBtn.layer.borderWidth = 1;
    tempBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [tempBtn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
    [tempBtn setTitle:self.autoInfoArr[i] forState:(UIControlStateNormal)];
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [tempBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    tempBtn.tag = 1000 + i;
    [self setBottomBtnFrmeWithBtn:tempBtn tagSize:CGSizeMake(53*WIDTH, 20*WIDTH) index:i];
    [self.sc addSubview:tempBtn];
    
    return tempBtn;
}
- (void) setBottomBtnFrmeWithBtn:(UIButton *) tagButton tagSize:(CGSize) tagSize index:(int) index{
    
    NSInteger kBottomBtnLeftMargin = 10+15;
    NSInteger kBottomBtnListCols = 4;
    
    NSInteger col = index % kBottomBtnListCols;
    NSInteger row = index / kBottomBtnListCols;
    CGFloat btnW = tagSize.width;
    CGFloat btnH = tagSize.height;
    NSInteger margin = (self.sc.frame.size.width - kBottomBtnListCols * btnW - 2 * kBottomBtnLeftMargin) / (kBottomBtnListCols - 1);
    CGFloat btnX = kBottomBtnLeftMargin + col * (btnW + margin);;
    CGFloat btnY = CGRectGetMaxY(centerLable.frame) + (kBottomBtnLeftMargin -8) + row * (btnH + margin);
    tagButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
}

//底部按钮点击事件
- (void) bottomBtnClicked:(UIButton *) sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        [self.tagList.labelTitlesArr addObject:sender.titleLabel.text];
        [self.tagList addTag:sender.titleLabel.text andIndex:self.tagList.labelTitlesArr.count-1];
        
        [self.autoInfoArr removeObject:sender.titleLabel.text];
        [sender removeFromSuperview];
        
        if (CGRectGetMaxY(self.tagList.frame) >= CGRectGetMinY(centerLable.frame)) {
            //[UIView animateWithDuration:0.3 animations:^{
                CGSize tuiJianSize = [@"推荐资讯" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16*WIDTH]}];
                centerLable.frame = CGRectMake(CGRectGetMinX(self.tagList.frame)+15*WIDTH, CGRectGetMaxY(self.tagList.frame) + 16*WIDTH, tuiJianSize.width, tuiJianSize.height+5);
            //}];
        }
        
        NSMutableArray * tempArr = [NSMutableArray array];
        for (UIView * tempView in self.sc.subviews) {
            if (tempView.tag >= 1000){
                UIButton * tempBtn = (UIButton *) tempView;
                [tempArr addObject:tempBtn];
            }
        }
        
        for (int i = 0; i < tempArr.count; i++) {
            UIButton * btn = (UIButton *) tempArr[i];
            if (btn.tag > sender.tag) {
                btn.tag -= 1;
            }
        }
        
        for (int i = 0; i < tempArr.count; i++) {
            UIButton * tempBtn = (UIButton *) tempArr[i];
            //[UIView animateWithDuration:0.3 animations:^{
                [self setBottomBtnFrmeWithBtn:tempBtn tagSize:CGSizeMake(53*WIDTH, 20*WIDTH) index:i];
            //}];
            if (i == self.autoInfoArr.count-1) {
                self.sc.contentSize = CGSizeMake(SCREEN_SIZE_WIDTH-CGRectGetMinX(self.tagList.frame)*2, CGRectGetMaxY(tempBtn.frame)+10);
            }
        }
    }
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
