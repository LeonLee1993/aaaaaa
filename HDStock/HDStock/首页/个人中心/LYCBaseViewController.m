//
//  HDStockBaseViewController.m
//  HDStock
//
//  Created by hd-app02 on 16/11/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "LYCBaseViewController.h"

@interface LYCBaseViewController ()
@property (nonatomic, strong) PSYLabel * messageLabel;
@end

@implementation LYCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条颜色
    [self setNavBarBgImagefromColor];
    // 设置导航默认标题的颜色及字体大小
    [self setNavDic];
    [self panToPopView];
    [self setNavCustemViewForLeftItemWithImage:imageNamed(@"Live_back") title:@"返回" titleFont:[UIFont systemFontOfSize:(15)] titleCoclor:[UIColor clearColor] custemViewFrame:CGRM(0, 26, 56, 44)];
    //设置子视图背景色
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
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 15)];
    [btn addTarget:self action:@selector(backItemWithCustemViewBtnCli) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void) backItemWithCustemViewBtnCli {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
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
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:MAIN_COLOR]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}
// 设置导航默认标题的颜色及字体大小
- (void) setNavDic {
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_FONT*WIDTH],NSForegroundColorAttributeName:NAV_TITLE_COLOR};;
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
    [self setNavCustemViewForLeftItemWithImage:imageNamed(@"Live_back") title:@"返回" titleFont:[UIFont systemFontOfSize:(15)] titleCoclor:[UIColor whiteColor] custemViewFrame:CGRM(0, 26, 56, 44)];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGPoint changedPoint;
        changedPoint = [pan translationInView:self.view];
        if((changedPoint.x)>60&&fabs(changedPoint.y)<10){
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

//- (void)showNewStatuses:(NSString *)message fromLocation:(CGFloat)from
//{
//    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:13] andMaxW:self.view.size.width];
//    // 1.创建一个UILabel
//    _messageLabel = [[PSYLabel alloc] init];
//    _messageLabel.tag = 1999;
//    _messageLabel.userInteractionEnabled = YES;
//    // 2.显示文字
//    
//    _messageLabel.text = message;
//    _messageLabel.font = [UIFont systemFontOfSize:13];
//    _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    _messageLabel.numberOfLines = 2;
//    _messageLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
//    
//    // 3.设置背景
//    _messageLabel.backgroundColor = [UIColor colorWithHexString:@"#ff8c54"];
//    _messageLabel.alpha = 0.9f;
//    _messageLabel.textAlignment = NSTextAlignmentLeft;
//    _messageLabel.textColor = [UIColor whiteColor];
//    
//    // 4.设置frame
//    _messageLabel.width = self.view.width;
//    
//    if (size.height < 25) {
//        
//        _messageLabel.height = 26;
//    }else{
//    
//        _messageLabel.height = size.height;
//    
//    }
//    
//    
//    _messageLabel.x = 0;
//    _messageLabel.y = from - _messageLabel.height;
//    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(messageOnTaped:)];
//    
//    [_messageLabel addGestureRecognizer:tap];
//    
//    if (self.navigationController.navigationBar.hidden == YES) {
//        
//        [self.navigationController.view addSubview:_messageLabel];
//        
//    }else{
//    
//    [self.navigationController.view insertSubview:_messageLabel belowSubview:self.navigationController.navigationBar];
//    }
//    
//    CGFloat duration = 0.75;
//
//    [UIView animateWithDuration:duration animations:^{
//
//        _messageLabel.transform = CGAffineTransformMakeTranslation(0, _messageLabel.height);
//
//    } completion:^(BOOL finished) {
//
//        [self performSelector:@selector(delayToAnimate) withObject:self afterDelay:3.0f];
//        
//    }];
//}
//
//- (void)delayToAnimate{
//    
//    [UIView animateWithDuration:0.75f animations:^{
//    
//        _messageLabel.transform = CGAffineTransformIdentity;
//                         
//    } completion:^(BOOL finished) {
//        
//        [_messageLabel removeFromSuperview];
//        
//    }];
//}
//
//- (void)messageOnTaped:(UITapGestureRecognizer *)tap{
//    
//    
//
//    NSLog(@"点击消息%@",tap.self.view);
//
//
//}

//#pragma mark - 通知中心
//- (void) registNotificationCenter {
//    //注册通知(等待接收消息)
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePageSocketDataComing:) name:QUOTATION_NOTE object:nil];
//}
//- (void) homePageSocketDataComing:(NSNotification *) note {
//    NSDictionary * tempDic = note.userInfo[@"socketQuotation"];
//    
//    if (self.tabBarController.selectedIndex == 3) {
//        
//        
//    }else{
//    
//    if (self.navigationController.navigationBar.hidden == YES) {
//        [self showNewStatuses:tempDic[@"type"] fromLocation:0];
//    }else{
//    
//    [self showNewStatuses:tempDic[@"type"] fromLocation:NAV_STATUS_HEIGHT];
//    }
//    }
//}
//- (void) removeNotifacationCenter {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:QUOTATION_NOTE object:nil];
//}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//    [self registNotificationCenter];
//    [_messageLabel removeFromSuperview];
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self removeNotifacationCenter];
//    [_messageLabel removeFromSuperview];
//}


@end
