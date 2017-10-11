//
//  HDLeftPersonalViewController.m
//  HDStock
//
//  Created by liyancheng on 16/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLeftPersonalViewController.h"
#import "HDStockBaseNavigationController.h"

#import "AppDelegate.h"

@interface HDLeftPersonalViewController ()<UIGestureRecognizerDelegate>
{
    CGFloat _horiDis;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)CGFloat tableViewWidth;
@property (nonatomic,strong)UIView *contentView;
@end

@implementation HDLeftPersonalViewController{
    UIView * _blurView;
    BOOL _hasBlurViewFlag;
    AppDelegate * _appDelegate;
}

- (id)initWithLeftViewController:(HDLeftMainViewController *)leftVc andMainViewController:(UITabBarController *)mainVc{
    
    self = [super init];
    if (self) {
        
        self.speed = SLIDE_SPEED;
        self.leftVc = leftVc;
        self.mainVc = mainVc;
        self.panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
        self.panGes.delegate = self;
        [self.mainVc.view addGestureRecognizer:self.panGes];
        
        [self.view addSubview:self.leftVc.view];
        
        UIView *view = [[UIView alloc] init];
        view.frame = self.leftVc.view.bounds;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        self.contentView = view;
        [self.leftVc.view addSubview:view];
        
        for (UIView *theView in self.leftVc.view.subviews) {
            if ([theView isKindOfClass:[UITableView class]]) {
                self.tableView = (UITableView *)theView;
            }
        }
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH - MAIN_VC_SHOWN_DISTANCE, SCREEN_HEIGHT);
//        self.tableView.transform = CGAffineTransformMakeScale(LEFT_SCALE, LEFT_SCALE);
        self.tableView.center = CGPointMake(LEFT_CENTER_X, SCREEN_HEIGHT / 2.0);
        
        [self.view addSubview:self.mainVc.view];
        self.sideClosed = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.leftVc.numberOfTalking = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _hasBlurViewFlag = NO;
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[LYCUserManager informationDefaultUser] autoLogin];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    // 判断下点在不在按钮上
    // 转换坐标系
    NSLog(@"%s",__func__);
    return self.view;
}


#pragma mark ----------- 滑动手势 -----------

- (void)handlePanAction:(UIPanGestureRecognizer *)pan
{
    // 每次滑动都会调用这个方法，往左边滑动为负，往右边滑动为正。
    CGPoint point = [pan translationInView:self.view];
    _horiDis = (point.x * self.speed) + _horiDis;
    BOOL neewMoveWithGes = YES;
    HDStockBaseNavigationController *nav= self.mainVc.selectedViewController;
    if(self.mainVc.selectedIndex ==0&&nav.viewControllers.count==1){
        neewMoveWithGes = YES;
    }else{
        neewMoveWithGes = NO;
    }

    if (((self.mainVc.view.x <=0) && (_horiDis <=0))
        || ((self.mainVc.view.x >= SCREEN_WIDTH - MAIN_VC_SHOWN_DISTANCE) && (_horiDis >=0)))
    {
        _horiDis = 0;
        
        neewMoveWithGes = NO;
    }
 
    if (neewMoveWithGes && (self.mainVc.view.x >= 0) && self.mainVc.view.x <= SCREEN_WIDTH - MAIN_VC_SHOWN_DISTANCE) {
        
        CGFloat centerX = self.mainVc.view.centerX + point.x * self.speed;
        if (centerX < SCREEN_WIDTH / 2.0 + 2) {
            centerX = SCREEN_WIDTH / 2.0;
        }
        CGFloat centerY = self.mainVc.view.centerY;
        self.mainVc.view.center = CGPointMake(centerX, centerY);
        
        CGFloat rate = self.mainVc.view.frame.origin.x / (SCREEN_WIDTH - MAIN_VC_SHOWN_DISTANCE);
        
        [pan setTranslation:CGPointMake(0, 0) inView:self.view]; // 移动以后的坐标设置为0
        CGFloat leftTabCenterX = LEFT_CENTER_X + ((SCREEN_WIDTH - MAIN_VC_SHOWN_DISTANCE) / 2.0 - LEFT_CENTER_X) * rate;
//        CGFloat leftTabScale = LEFT_SCALE + (1 - LEFT_SCALE) * rate;
        
        self.tableView.center = CGPointMake(leftTabCenterX, SCREEN_HEIGHT/2.0);
//        self.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftTabScale, leftTabScale);
        CGFloat alpha = LEFT_ALPHA - LEFT_ALPHA * rate;
        self.contentView.alpha = alpha;
    }else {
        if (self.mainVc.view.origin.x <= 0) {
            [self closeLeftView];
            _horiDis = 0;
        }else if (self.mainVc.view.origin.x >= SCREEN_WIDTH - MAIN_VC_SHOWN_DISTANCE) {
            [self openLeftView];
            _horiDis = 0;
        }
    }
    
    // 手势结束后 修正位置，超过一半时 向 超过的那一半偏移
    if (pan.state  == UIGestureRecognizerStateEnded) {
        
        if (fabs(_horiDis) > SLIDE_SHOULD_CHANGE_STATUS_DISTANCE) {
            
            if (self.sideClosed) {
                [self openLeftView];
            }else {
                [self closeLeftView];
            }
        }else {
            if (self.sideClosed) {
                [self closeLeftView];
            }else {
                [self openLeftView];
            }
        }
        _horiDis = 0;
    }
}

#pragma mark --- 修改视图位置 ---

- (void)openLeftView
{
    [self.leftVc viewWillAppear:YES];
    if(!_hasBlurViewFlag){
        _blurView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _blurView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.mainVc.view addSubview:_blurView];
        _hasBlurViewFlag = YES;
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        // 让主视图变小并移到右边
        self.mainVc.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, MAIN_VC_SHOWN_SCALE, MAIN_VC_SHOWN_SCALE);
        self.mainVc.view.center =  MAIN_VC_SHOWN_CENTER;
        //        self.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        self.tableView.center = CGPointMake((SCREEN_WIDTH - MAIN_VC_SHOWN_DISTANCE) / 2.0, SCREEN_HEIGHT/2.0);
        self.contentView.alpha = 0;
        self.sideClosed = NO;
        
    } completion:^(BOOL finished) {
        [self disableTapButton];
    }];
//    NSLog(@"%d",[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]]);
//    self.leftVc.numberOfTalking = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
}


- (void)closeLeftView
{
    [self.leftVc viewWillDisappear:YES];
    if(_hasBlurViewFlag){
        [_blurView removeFromSuperview];
        _blurView = nil;
        _hasBlurViewFlag = NO;
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mainVc.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        self.mainVc.view.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0);
        
        //        self.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, LEFT_SCALE, LEFT_SCALE);
        self.tableView.center = CGPointMake(LEFT_CENTER_X, SCREEN_HEIGHT/2.0);
        
        self.contentView.alpha = 1;
        self.sideClosed = YES;
        
    } completion:^(BOOL finished) {
        [self removeTap];
    }];
    
}

- (void)removeTap
{
    for (UIButton *btn in self.mainVc.view.subviews) {
        [btn setUserInteractionEnabled:YES];
    }
    [self.mainVc.view removeGestureRecognizer:self.sideLipTapGes];
    self.sideLipTapGes = nil;
}

- (void)disableTapButton
{
    for (UIButton *btn in self.mainVc.view.subviews) {
        [btn setUserInteractionEnabled:NO];
    }
    // 单击
    if (self.sideLipTapGes == nil) {
        self.sideLipTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self.sideLipTapGes setNumberOfTapsRequired:1];
        [self.mainVc.view addGestureRecognizer:self.sideLipTapGes];
        [self.sideLipTapGes setCancelsTouchesInView:YES];
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap
{
    if (self.sideClosed == NO && tap.state == UIGestureRecognizerStateEnded) {
        [self closeLeftView];
        _horiDis = 0;
    }
}

- (void)setPanGesEnabled:(BOOL)enabled
{
    _panGes.enabled = enabled;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view.tag == NO_RESPONSE_VIEW_TAG) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)shouldAutorotate
{
    if (_appDelegate.allowRotation == 1) {
        //视频直播
        return YES;
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (_appDelegate.allowRotation == 1) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    HDStockBaseNavigationController *nav= self.mainVc.selectedViewController;
//    if(self.mainVc.selectedIndex ==0&&nav.viewControllers.count==1){
//        
//    }else{
//        [self.mainVc.view removeGestureRecognizer:self.panGes];
//        [self.panGes setCancelsTouchesInView:NO];
//    }
//}



@end
