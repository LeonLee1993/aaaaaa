//
//  HDStockBaseViewController.m
//  HDStock
//
//  Created by hd-app02 on 16/11/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockBaseViewController.h"
#import "HeadLineViewController.h"
#import "buiedProductListViewController.h"
#import "BuiedProductDetailViewController.h"
#import "HDHeadLineDetailViewController.h"
#import "HDStockNavigationController.h"
#import "HDInfoMationViewController.h"
#import "HDVideoDetailsViewController.h"
#import "HDStockSayingViewController.h"

@interface HDStockBaseViewController ()
@property (nonatomic, strong) PSYLabel * messageLabel;
@property (nonatomic, strong) NSMutableDictionary * messageDic;
@end

@implementation HDStockBaseViewController

- (NSMutableDictionary *)messageDic{

    if (!_messageDic) {
        
        _messageDic = [[NSMutableDictionary alloc]init];
    }

    return _messageDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条颜色
    [self setNavBarBgImagefromColor];
    // 设置导航默认标题的颜色及字体大小
    [self setNavDic];
    //设置子视图背景色
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = BACKGROUNDCOKOR;
    

}


#pragma mark - 导航栏返回按钮带自定义图片和文字
- (void) setNavCustemViewForLeftItemWithImage:(UIImage *)image title:(NSString *)title titleFont:(UIFont *)font titleCoclor:(UIColor *)titleCoclor custemViewFrame:(CGRect)thyFrame {
    UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = thyFrame;
    [btn setTitle:title forState:(UIControlStateNormal)];
    btn.titleLabel.font = font;
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn setTitleColor:titleCoclor forState:(UIControlStateNormal)];
    [btn setImage:image forState:(UIControlStateNormal)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 15)];
    [btn addTarget:self action:@selector(backItemWithCustemViewBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void) backItemWithCustemViewBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 添加按钮
- (void)setNavBarAddRightItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImageNamed(@"whiteAdd") style:(UIBarButtonItemStylePlain) target:self action:@selector(addBtnClicked)];
}
- (void) addBtnClicked {
    
}
#pragma mark - 设置导航栏
- (void) setNavBarLeftItemWithStr:(NSString *) str {
//    @"home_back"
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImageNamed(str) style:(UIBarButtonItemStylePlain) target:self action:@selector(backBtnItemClicked)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor grayColor]];
    //    [self.navigationItem.leftBarButtonItem setTitle:str];
}
#pragma mark - 定制返回按钮点击事件
-(void)backBtnItemClicked{
    if (self.myBlock) {
        self.myBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置导航栏提交
- (void) setNavBarRightSubmitItem {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:(UIBarButtonItemStylePlain) target:self action:@selector(submitBtnClicked)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
}
- (void) submitBtnClicked {
    
}
#pragma mark - 提交按钮点击事件
- (void) setNavBarRightCancelItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImageNamed(@"close") style:(UIBarButtonItemStylePlain) target:self action:@selector(cancelBtnItemClicked)];
}
#pragma mark - 取消按钮点击事件
- (void) cancelBtnItemClicked {
    
}
#pragma mark - 设置
- (void)setNavRightSettingItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImageNamed(@"shezhi") style:(UIBarButtonItemStylePlain) target:self action:@selector(settingBtnClicked)];
}

- (void) settingBtnClicked {
    
}
#pragma mark - 签到
- (void) setNavBarQianDaoLeftItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImageNamed(@"qiandao") style:(UIBarButtonItemStylePlain) target:self action:@selector(qianDaoBtnClicked)];
}
- (void) qianDaoBtnClicked {
    
}
#pragma mark - 颜色转换图片
- (UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark - 去除导航栏下方的横线
- (void) setNavBarBgImagefromColor {
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:NAVCOLOR]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
// 设置导航默认标题的颜色及字体大小
- (void) setNavDic {
    
    if (kScreenIphone5 || kScreenIphone4) {
        self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_FONT],NSForegroundColorAttributeName:NAV_TITLE_COLOR};
    }else{
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_FONT*WIDTH],NSForegroundColorAttributeName:NAV_TITLE_COLOR};
    }
//    NSDictionary * dic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16.0 * WIDTH]};
//    [self.navigationController.navigationBar setTitleTextAttributes:dic];
}

#pragma mark - 导航栏左边占位按钮
- (void) setNavBarLeftPlaceholderItem{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:(UIBarButtonItemStylePlain) target:self action:nil];
    
}

#pragma mark -设置导航栏右边按钮，带text参数
- (void) setNavBarRightItem:(NSString *) thyTitle{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:thyTitle style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarBtnClciked)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
}
- (void) rightBarBtnClciked {
    
}
#pragma mark -设置导航栏右边按钮，带image参数
- (void) setNavBarRightItemWithImage:(UIImage *)thyImage {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:thyImage style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarImageBtnClciked)];
    self.navigationItem.rightBarButtonItem.tintColor = COLOR(whiteColor);

}
- (void) rightBarImageBtnClciked{
    
    
    
}

- (void)setNavDicWithTitleFont:(CGFloat)font titleColor:(UIColor *)color title:(NSString *)title {
    NSDictionary * dic = @{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont systemFontOfSize:font]};
    self.title = title;
    [self.navigationController.navigationBar setTitleTextAttributes:dic];
}

- (void) setNormalBackNav {
    [self setNavCustemViewForLeftItemWithImage:imageNamed(@"Live_back") title:@"" titleFont:[UIFont systemFontOfSize:(15)] titleCoclor:[UIColor whiteColor] custemViewFrame:CGRM(0, 26, 56, 44)];
    
}


- (UIScrollView *) createBgSCWithFrame:(CGRect) frame bgColor:(UIColor *)bgColor{
    UIScrollView * bgSC = [[UIScrollView alloc] initWithFrame:frame];
    bgSC.backgroundColor = bgColor;
    return bgSC;
}

- (void)panToPopView{
    self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:self.pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint changedPoint;
    changedPoint = [pan translationInView:self.view];
    if((changedPoint.x)>60&&fabs(changedPoint.y)<10){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showNewStatuses:(NSString *)message fromLocation:(CGFloat)from
{
    
    if (_messageLabel) {
        
        //[self delayToAnimate];
        
    }
    
    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:13] andMaxW:self.view.size.width];
    // 1.创建一个UILabel
    _messageLabel = [[PSYLabel alloc] init];
    _messageLabel.tag = 1999;
    _messageLabel.userInteractionEnabled = YES;
    // 2.显示文字
    
    _messageLabel.text = message;
    _messageLabel.font = [UIFont systemFontOfSize:13];
    _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _messageLabel.numberOfLines = 2;
    _messageLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    // 3.设置背景
    _messageLabel.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    _messageLabel.alpha = 0.75f;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.textColor = [UIColor whiteColor];
    
    // 4.设置frame
    _messageLabel.width = self.view.width;
    
    if (size.height < 25) {
        
        _messageLabel.height = 35;
    }else{
    
        _messageLabel.height = 50;
    
    }
    
    
    _messageLabel.x = 0;
    _messageLabel.y = from - _messageLabel.height;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(messageOnTaped:)];
    
    [_messageLabel addGestureRecognizer:tap];
    
    if (self.navigationController.navigationBar.hidden == YES) {
        
        [self.navigationController.view addSubview:_messageLabel];
        
    }else{
    
    [self.navigationController.view insertSubview:_messageLabel belowSubview:self.navigationController.navigationBar];
    }
    
    CGFloat duration = 0.75;

    [UIView animateWithDuration:duration animations:^{

        _messageLabel.transform = CGAffineTransformMakeTranslation(0, _messageLabel.height);

    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self delayToAnimate];
        });

        //[self performSelector:@selector(delayToAnimate) withObject:self afterDelay:2.0f];
        
    }];
}

- (void)delayToAnimate{
    
    [UIView animateWithDuration:0.75f animations:^{
    
        _messageLabel.transform = CGAffineTransformIdentity;
                         
    } completion:^(BOOL finished) {
        
        [_messageLabel removeFromSuperview];
        
    }];
}

- (void)messageOnTaped:(UITapGestureRecognizer *)tap{
    
    if (self.messageDic[@"type"] && [self.messageDic[@"type"] isEqualToString:@"add_pro"]) {
        
        buiedProductListViewController *list = [[buiedProductListViewController alloc]init];
        
        NSInteger flag = [(NSString *)self.messageDic[@"category"] integerValue];
        
        switch (flag) {
            case 1:
                list.flagStr = @"1";
                break;
            case 2:
                list.flagStr = @"2";
                break;
            case 3:
                list.flagStr = @"3";
                break;
            case 4:
                list.flagStr = @"4";
                break;
                
            default:
                break;
        }
        [self.navigationController pushViewController:list animated:YES];
        
    }else if (self.messageDic[@"type"] && [self.messageDic[@"type"] isEqualToString:@"add_dynamic"]){
    
        BuiedProductDetailViewController *detail = [[BuiedProductDetailViewController alloc]init];
        detail.flagStr = [NSString stringWithFormat:@"%@",self.messageDic[@"category"]];
        detail.createTimeStr = [NSString stringWithFormat:@"%@",self.messageDic[@"create_date"]];
        [self.navigationController pushViewController:detail animated:YES];
    
    }
    
}

#pragma mark - 通知中心
- (void) registNotificationCenter {
    //注册通知(等待接收消息)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePageSocketDataComing:) name:QUOTATION_NOTE object:nil];
}
- (void) homePageSocketDataComing:(NSNotification *) note {
    NSDictionary * tempDic = note.userInfo[@"socketQuotation"];
    
    if (self.tabBarController.selectedIndex == 3) {
        
        
    }else{
    
    if (self.navigationController.navigationBar.hidden == NO) {
        if (tempDic[@"msg"]) {
            
            [self showNewStatuses:tempDic[@"msg"] fromLocation:NAV_STATUS_HEIGHT];
            
        }
        self.messageDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    }
        
    }
}

- (void) removeNotifacationCenter {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QUOTATION_NOTE object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self registNotificationCenter];
    [_messageLabel removeFromSuperview];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotifacationCenter];
    [_messageLabel removeFromSuperview];
}

- (void)turnToDetailViewController:(HDAdvertisementModel *)model{
    
    NSString * link = model.link;
    
    NSArray * arr = [link getArray];
    
    NSString * classStr = [arr objectAtIndexCheck:0];
    
    NSString * aidStr = [arr objectAtIndexCheck:1];
    
    if ([classStr isEqualToString:@"zx"] && aidStr) {
        
        HDHeadLineDetailViewController * headVC = [[HDHeadLineDetailViewController alloc]init];
        headVC.aid = aidStr.integerValue;
        headVC.controllerTitle = @"资讯";
        
        [self.navigationController pushViewController:headVC animated:NO];
        
    }else if ([classStr isEqualToString:@"sp"] && aidStr){
        
        if(aidStr.integerValue == 0){
            
            HDStockNavigationController * infoNav = self.tabBarController.childViewControllers[2];
            HDInfoMationViewController * infoVC = infoNav.childViewControllers[0];
            infoVC.selectedVC = 2;
            infoVC.fromwhere = @"学技巧";
            [self.tabBarController setSelectedViewController:infoNav];
            
        }else{
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HDVideoDetailsViewController * videoV = [mainStoryboard instantiateViewControllerWithIdentifier:@"HDVideoDetailsViewController"];
            videoV.ItemAid = aidStr.integerValue;
            
            [self.navigationController pushViewController:videoV animated:NO];
            
        }
        
    }else if ([classStr isEqualToString:@"gs"]){
        
        HDStockSayingViewController * sayVC = [[HDStockSayingViewController alloc]init];
        
        [self.navigationController pushViewController:sayVC animated:YES];
        
    }else if ([classStr isEqualToString:@"web"] && aidStr.length > 2){
        
        HDAdversementDetailViewController * headVC = [[HDAdversementDetailViewController alloc]init];
        
        headVC.hidesBottomBarWhenPushed = YES;
        headVC.url = aidStr;
        headVC.imageUrlStr = model.url;
        headVC.tittle = model.title;
        [self.navigationController pushViewController:headVC animated:NO];
        
    }
    
}

@end
