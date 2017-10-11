//
//  HDNewLiveViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDNewLiveViewController.h"
#import "HDShareCustom.h"

#define kTabBarControllerSelectedIndex 3//当前直播界面在tabbar上面的位置

@interface HDNewLiveViewController ()<touchBeginDelegate,thyShareCustomDlegate>{
    
    AppDelegate * _appDelegate;//用于控制本页面旋转
    UIImageView * navFloorMenuBgIMV;//菜单浮层IMV
    NSArray * vcArr;//装子控制器
    UIViewController * _currentVC;//当前显示的控制器
    
    //直播
    NSURL*  mSourceURL;//直播网址
    BOOL replay;
    BOOL bSeeking;
    BOOL mPaused;
    CGFloat moviePlayerViewHeightRate;//播放器高度=屏幕宽度*9.0/16
    BOOL isReconnectToVedioUrlBool;//是否重连直播地址：默认不重连
    
    UIButton * rotateBtn;//旋转按钮
    UIButton * closeVoiceBtn;//静音按钮
    CGFloat rotateBtnWidth;//旋转按钮宽度
    
    BOOL isFirstComeInThyVCBool;//第一次进入这个页面
    BOOL isReconnectWifi;//重连WiFi、手机网络
    BOOL isPhoneDataUrl;//手机自带网络
    
    CGFloat oldScreenWidth;//用于判断屏幕上一个状态是横屏还是竖屏
    BOOL isViewWillAppearBool;//刚进入界面的bool
    int tabBarSelectedIndex;//判断当前界面是否为直播界面
    
    UIProgressView * _progressView;//网页加载的进度progress


}
@property (nonatomic,strong) HDLiveModel * voiceModel;//KVO控制声音
@property (nonatomic,strong) UIButton * playerUrlErrorBtn;//没有直播资源时的占位按钮

@property (nonatomic, strong) AliVcMediaPlayer* mPlayer;
@property (nonatomic, strong) UIView *mPlayerView;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic,assign)CGPoint originalLocation;

@property (nonatomic,strong) HDShareCustom * customShare;

@end

@implementation HDNewLiveViewController

@synthesize mPlayer;
@synthesize mPlayerView;
@synthesize conn;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
      self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeNavFloorMenuIMV];
}
- (void) dealloc {
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)firstCheckNetworkState
{
    NSInteger netType = [ZHFactory checkNetStatusFromStatusBar];
    if (isViewWillAppearBool) {
        NSLog(@"firstCheckNetworkState-调用viewWillApear，操作");
        isViewWillAppearBool = NO;
        if (netType == 1) {
            //wifi
            [self handleWifiStatusIsViewWillAppearBool:YES];
        }else if (netType == 2){
            //手机自带网络
            [self handleMyselfNetStatusIsViewWillAppearBool:YES];
        }else if (netType == 0){
            //没网
            [self handleNoNetStatusIsViewWillAppearBool:YES];
        }
    }else {
        NSLog(@"firstCheckNetworkState-已经走过viewWillApear了，不操作");
    }
}

/**处理手机自带网络的情况*/
- (void) handleMyselfNetStatusIsViewWillAppearBool:(BOOL) thyBool {
    
    if (tabBarSelectedIndex == kTabBarControllerSelectedIndex) {
        NSLog(@"handleMyselfNetStatus-有手机自带网络");
        
        if (thyBool)
        {//在viewWillAppear中调用
            isPhoneDataUrl = YES;//手机自带网络
            if (mPlayer&&_playerUrlErrorBtn.hidden) {
                [mPlayer pause];//暂停
            }
        }else
        {//在界面中网络发生变化时调用
            NSLog(@"有手机自带网络，checkNetworkState");
            if (mPlayer&&_playerUrlErrorBtn.hidden) {
                [mPlayer pause];//暂停
            }
            isPhoneDataUrl = YES;//4G/3G网
            isReconnectWifi = YES;
        }
        
        [self alertMyselfNetStatus];//手机网提示alert
    }else {
        NSLog(@"handleMyselfNetStatusIsViewWillAppearBool-不在当前界面，不播放");
    }
}

/**处理没有网络的情况*/
- (void) handleNoNetStatusIsViewWillAppearBool:(BOOL) thyBool {
    if (tabBarSelectedIndex == kTabBarControllerSelectedIndex) {
        NSLog(@"handleNoNetStatus-没有网络");
        if (thyBool)
        {//在viewWillAppear中调用
            isPhoneDataUrl = NO;
            isReconnectWifi = YES;
            [MBProgressHUD hideHUDForView:mPlayerView];
            if (mPlayer&&_playerUrlErrorBtn.hidden) {
                [mPlayer pause];
            }
        }else
        {//在界面中网络发生变化时调用
            isReconnectWifi = YES;
            if (mPlayer&&(_playerUrlErrorBtn.hidden||_playerUrlErrorBtn.alpha == 0)) {
                [mPlayer pause];
            }
            [MBProgressHUD hideHUDForView:mPlayerView];
        }
        [[vcArr[0] wkWeb].scrollView.mj_header endRefreshing];
        [self showUrlBreakAlert];
    }else {
        NSLog(@"handleNoNetStatusIsViewWillAppearBool-不在当前界面，不播放");
    }
}

/**处理wifi数据*/
- (void) handleWifiStatusIsViewWillAppearBool: (BOOL) thyBool{
    if (tabBarSelectedIndex == kTabBarControllerSelectedIndex) {
        
        if (thyBool)
        {//在viewWillAppear中调用
            NSLog(@"handleWifiStatusIsViewWillAppearBool-在viewWillAppear中调用");
            isReconnectWifi = NO;
            isPhoneDataUrl = NO;
            
            if (!isFirstComeInThyVCBool) {
                self.playerUrlErrorBtn.hidden = YES;
                [self.playerUrlErrorBtn removeFromSuperview];//移除占位图片
                if (mPlayer&&_appDelegate.isHaveLivePlayed) {
                    [mPlayer play];//继续播放
                    [self showRotateVoiceBtn];
                }else {
                    [self reconnectToVedioUrl];
                }
            }
        }else
        {//在界面中网络发生变化时调用
            NSLog(@"handleWifiStatusIsViewWillAppearBool-在界面中网络发生变化时调用");

            if (isReconnectWifi) {//重连wifi
                if (mPlayer) {
                    if (_appDelegate.isHaveLivePlayed) {
                        [mPlayer play];
                        NSLog(@"已播过，直接播放－checkNetworkState");
                    }else {
                        [self reconnectToVedioUrl];
                        NSLog(@"未播过，重新链接－checkNetworkState");
                    }
                    isReconnectWifi = NO;
                }
            }else if (isReconnectToVedioUrlBool){//重连播放地址
                if (mPlayer) {
                    isReconnectToVedioUrlBool = NO;
                    [self reconnectToVedioUrl];
                    
                    NSLog(@"按照bool值重新链接－checkNetworkState");
                }
            }
            if (!_customShare.isClosedShareUIBool) {
                [_customShare dismiss];
            }
            if (!self.playerUrlErrorBtn.hidden) {
                [self removeLiveReplaceBtn];
            }
            [[vcArr[0] wkWeb].scrollView.mj_header beginRefreshing];
        }
    }else {
        NSLog(@"handleWifiStatusIsViewWillAppearBool-不在当前界面，不操作");
    }
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFirstComeInThyVCBool = YES;
    [self setUp];//初始化
    [self setNormalBackNav];//返回按钮
    [self setNavBarRightItemWithImage:imageNamed(@"Live_Menu")];//菜单按钮
    [self createBlcakFloorMenuView];//创建黑色菜单浮层IMV
    [self prepareForLive];//直播准备工作
    [self setUpLive];//直播初始化
    [self createChildVCs];//创建子控制器
    _appDelegate.countN = 0;
    
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    tabBarSelectedIndex = kTabBarControllerSelectedIndex;
    isViewWillAppearBool = YES;
    self.view.frame = CGRM(0, 64, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT);
    oldScreenWidth = _appDelegate.normalScreenWidth;
    _appDelegate.allowRotation = 1;//只有该界面可以旋转
    [self firstCheckNetworkState];//检查网络
    if (!isFirstComeInThyVCBool) {//不是第一次进入这个界面时，需要重新添加通知
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self addPlayerObserver];
        [self addSetUpLiveObserver];//设置player里的照相环境配置
        [self addNetWorkCheckNotification];//添加网络监听
    }
    [self registOrCancellVoiceAndRotateNotificationWillAppearBool:YES];//注册旋转屏幕通知
    
    //创建网页加载进度的通知
    if ([vcArr[0] wkWeb]) {
        [[vcArr[0] wkWeb] addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _appDelegate.countN = 0;
    isFirstComeInThyVCBool = NO;
    isViewWillAppearBool = NO;
    if (mPlayer) {
        [mPlayer pause];//暂停播放
    }
    self.tabBarController.tabBar.hidden = NO;//显示导航栏
    [self removeNavFloorMenuIMV];//移除菜单浮层
    _appDelegate.allowRotation = 0;//退出后的页面不能旋转
    [self registOrCancellVoiceAndRotateNotificationWillAppearBool:NO];
    [[vcArr[0] wkWeb].scrollView.mj_header endRefreshing];
    //移除通知
    [self removePlayerObserver];//移除观察播放进程的通知
    [self removeSetUpLiveObserver];//移除设置player里的通知
    [self removeNetWorkCheckNotification];//移除网络通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    tabBarSelectedIndex = -1;
    [self.view endEditing:YES];
    
    //移除网页加载进度的通知
    if ([vcArr[0] wkWeb]) {
        [[vcArr[0] wkWeb] removeObserver:self forKeyPath:@"estimatedProgress"];
    }

}

#pragma mark - 懒加载

- (UIButton *)playerUrlErrorBtn {
    if (!_playerUrlErrorBtn) {
        _playerUrlErrorBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_playerUrlErrorBtn setBackgroundImage:imageNamed(@"Live_teacherGone") forState:(UIControlStateNormal)];
        [_playerUrlErrorBtn addTarget:self action:@selector(playerUrlErrorBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        _playerUrlErrorBtn.frame = CGRM(0, 0, mPlayerView.width, mPlayerView.height);
        _playerUrlErrorBtn.hidden = YES;
    }
    return _playerUrlErrorBtn;
}
- (HDLiveModel *)voiceModel {
    if (!_voiceModel) {
        _voiceModel = [HDLiveModel new];
    }
    return _voiceModel;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"keyPath=%@,object=%@,change=%@,context=%@",keyPath,object,change,context);
    if ([keyPath isEqualToString:@"needCloseVoiceBool"]) {
        if (self.voiceModel.needCloseVoiceBool) {//静音
            mPlayer.muteMode = YES;
            _appDelegate.isCloseVoiceBool = YES;
            rotateBtn.selected = NO;
            NSLog(@"静音");
        }else {//扩音
            mPlayer.muteMode = NO;
            _appDelegate.isCloseVoiceBool = NO;
            rotateBtn.selected = YES;
            NSLog(@"扩音");
        }
    }else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object ==[vcArr[0] wkWeb]) {
            [_progressView setAlpha:1.0f];
            [_progressView setProgress:[vcArr[0] wkWeb].estimatedProgress animated:YES];
            
            if([vcArr[0] wkWeb].estimatedProgress >=1.0f) {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [_progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [_progressView setProgress:0.0f animated:NO];
                }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}
#pragma mark - PROTOCOL_METHOD
- (void)webViewTouchbegin {
    [self removeNavFloorMenuIMV];
}
- (void)shareBlcakBgViewTaped {
    NSInteger netType = [ZHFactory checkNetStatusFromStatusBar];
    switch (netType) {
        case 0:
        {//无网
            NSLog(@"shareBlcakBgViewTaped－无网，不播放");
        }
            break;
        case 1:
        {//wifi
            if (mPlayer&&_playerUrlErrorBtn.hidden) {
                NSLog(@"shareBlcakBgViewTaped，wifi播放");
                [mPlayer play];
            }else {
                NSLog(@"当前显示了占位图，不播放");
            }
        }
            break;
        case 2:
        {//手机网
            [self alertMyselfNetStatus];
        }
            break;
        default:
            break;
    }

}

- (void)shareCustomShareBtnClicked {
//    [mPlayer play];
}

#pragma mark - 设置
- (void) setUp {
    
    self.view.backgroundColor = UICOLOR(239, 238, 244, 1);
    //本控制器支持旋转
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _appDelegate.allowRotation = 1;
    
    moviePlayerViewHeightRate = 9.0/16;//播放器高度=屏幕宽度*这个比例
    HDLiveLivingViewController * webVC = [HDLiveLivingViewController new];
    vcArr = @[webVC];
    webVC.touchDelegate = self;//监听网页的点击事件
    (SCREEN_HEIGHT<=HEIGHT_5s)?(rotateBtnWidth = 34):(rotateBtnWidth = 34*WIDTH);//旋转按钮宽度

    //分享
    _customShare = [HDShareCustom new];
    _customShare.comFromIndex = 0;
    _customShare.shareCustomDlegate = self;
    _customShare.isClosedShareUIBool = YES;
    WEAK_SELF;
    //判断是否安装了接受分享的设备
    _customShare.isInstalledAlertBlock = ^(NSString * isInstalledStr){
        STRONG_SELF;
        [strongSelf jugeWithStr:isInstalledStr];
    };
    //开始分享
    _customShare.sharePlatBlock = ^(NSInteger platType){
        STRONG_SELF;
        NSString * str = @"http://gk.cdtzb.com/wap/index";

        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        if (platType == 2){//微博
            [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"年末行情如何把握，尽在股哥直播:%@",[NSURL URLWithString:str] ]
                                                       title:@"股哥直播室"
                                                       image:[UIImage imageNamed:@"share_icon_weibo"]
                                                         url:[NSURL URLWithString:str]
                                                    latitude:0
                                                   longitude:0
                                                    objectID:nil
                                                        type:(SSDKContentTypeAuto)];
            [shareParams SSDKEnableUseClientShare];
            [strongSelf.customShare gotoShareWithContent:shareParams];
        }else if (platType == 0 || platType == 1 || platType == 3) {//微信好友，微信朋友圈，QQ
            //1、创建分享参数
            NSArray* imageArray = @[[UIImage imageNamed:@"share_icon_Live"]];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:@"年末行情如何把握，尽在股哥直播"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:str]
                                                  title:@"股哥直播室"
                                                   type:SSDKContentTypeAuto];
                [strongSelf.customShare gotoShareWithContent:shareParams];
            }
        }
    };
    
    //分享状态
    self.customShare.shareStatusBlock = ^(NSInteger shareState){
        STRONG_SELF;
        if (strongSelf.mPlayer ) {
            [strongSelf.mPlayer play];
        }
        
        switch (shareState) {
            case SSDKResponseStateSuccess:
            {
                [MBProgressHUD showMessage:@"分享成功" ToView:strongSelf.mPlayerView RemainTime:1.3];
            }
                break;
            case SSDKResponseStateFail:
            {
                [MBProgressHUD showMessage:@"分享失败" ToView:strongSelf.mPlayerView RemainTime:1.3];
            }
                break;
            case SSDKResponseStateCancel:
            {
                [MBProgressHUD showMessage:@"取消分享" ToView:strongSelf.mPlayerView RemainTime:1.3];
            }
                break;
            default:
                break;
        }
    };
}

#pragma mark - 创建UI
//创建导航条上菜单浮层
- (void) createBlcakFloorMenuView {
    //黑色背景
    navFloorMenuBgIMV = [[UIImageView alloc] initWithFrame:CGRM(SCREEN_SIZE_WIDTH-10-106, NAV_STATUS_HEIGHT-8.0, 106.0, 95.0)];
    navFloorMenuBgIMV.image = imageNamed(@"Live_blackMenu");
    navFloorMenuBgIMV.userInteractionEnabled = YES;
    navFloorMenuBgIMV.alpha = 0;
    
    NSArray * menuArr = @[@"查看历史",@"分享直播"];
    NSArray * menuImageArr = @[imageNamed(@"Live_history"),imageNamed(@"Live_shareLive")];
    CGFloat navFloorMenuBgIMVHeight = navFloorMenuBgIMV.height-7;
    CGFloat sectionHeight = (navFloorMenuBgIMVHeight-1)/menuArr.count;
    for (int i = 0; i < menuArr.count; i++) {
        //左边的图标
        UIImageView * iconIMV = [[UIImageView alloc] initWithFrame:CGRM(10, 7+(sectionHeight+1)*i+sectionHeight/2-6.5, i==1?12:14, i==1?13:14)];
        iconIMV.image = menuImageArr[i];
        [navFloorMenuBgIMV addSubview:iconIMV];
        
        //右边的字
        UILabel * tempLab = [ZHFactory createLabelWithFrame:CGRM(CGMAX_X(iconIMV.frame)+9, CGMID_Y(iconIMV.frame)-iconIMV.height/2, navFloorMenuBgIMV.width-CGMAX_X(iconIMV.frame)-18, iconIMV.height) andFont:[UIFont systemFontOfSize:14*WIDTH] andTitleColor:[UIColor whiteColor] title:menuArr[i]];
        tempLab.tag = 2000+i;
        tempLab.textAlignment = NSTextAlignmentCenter;
        [navFloorMenuBgIMV addSubview:tempLab];
        
        //分割线
        if (i < menuArr.count-1) {
            UIView * lineView = [[UIView alloc] initWithFrame:CGRM(CGMIN_X(iconIMV.frame), 8+sectionHeight*(i+1), navFloorMenuBgIMV.width-CGMIN_X(iconIMV.frame)*2, 1)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#2c2c2c"];
            [navFloorMenuBgIMV addSubview:lineView];
        }
        
        //按钮
        UIButton * tempMenuBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        tempMenuBtn.frame = CGRM(0, 7+(sectionHeight+1)*i, navFloorMenuBgIMV.width, sectionHeight);
        [tempMenuBtn addTarget:self action:@selector(tempMenuBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        tempMenuBtn.tag = 600+i;
        
        [navFloorMenuBgIMV addSubview:tempMenuBtn];
    }
}

- (void) createChildVCs {
    for (int i = 0; i < vcArr.count; i++) {
        [self addChildViewController:vcArr[i]];
        [[vcArr[i] view] setTag:600+i];
        [self addChildViewController:vcArr[i]];
    }
    
    _currentVC = vcArr[0];
    [self transitionFromOldViewController:_currentVC toNewViewController:vcArr[0]];
    [self fitFrameForChildViewController:vcArr[0]];
    
    //网页加载进度条
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,2)];
    _progressView.tintColor = [UIColor colorWithRed:212/255.0 green:45/255.0 blue:73/255.0 alpha:1];
    _progressView.trackTintColor = [UIColor whiteColor];
    [[vcArr[0] wkWeb] addSubview:_progressView];
    
}

#pragma mark - 创建视屏播放控件
- (void) setupControls
{
    //视频显示区域
    mPlayerView = [[UIView alloc] init];
    mPlayerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:mPlayerView];
    //给视频播放视图添加tap手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mPlayerViewTaped)];
    [mPlayerView addGestureRecognizer:tap];
    
    //旋转按钮
    rotateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rotateBtn.backgroundColor = UICOLOR(29, 29, 29, 0.25);
    rotateBtn.layer.cornerRadius = rotateBtnWidth/2;
    rotateBtn.layer.masksToBounds = YES;
    [rotateBtn setImage:imageNamed(@"Live_rotateToFullScreen") forState:(UIControlStateNormal)];
    [rotateBtn addTarget:self action:@selector(rotateBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rotateBtn];

    //静音按钮
    closeVoiceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    closeVoiceBtn.backgroundColor = UICOLOR(29, 29, 29, 0.25);
    closeVoiceBtn.layer.cornerRadius = rotateBtnWidth/2;
    closeVoiceBtn.layer.masksToBounds = YES;
    [closeVoiceBtn setImage:imageNamed(@"Live_volume") forState:(UIControlStateNormal)];
    [closeVoiceBtn setImage:imageNamed(@"Live_volume_close") forState:(UIControlStateSelected)];
    [self.view addSubview:closeVoiceBtn];
    [closeVoiceBtn addTarget:self action:@selector(closeVoiceBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self adjustLayoutsubViews];
    
    [self hidRotateVoiceBtn];
}
#pragma mark - 设置坐标
- (void) setUpNormalAllSubViews {
    if (mPlayerView) {//防止界面坐标向下移动一个导航栏的高度
        [self adjustLayoutsubViews];
        [self adjustSelectionViewAndChildVCViewsFrame];
    }
}

- (void) adjustSelectionViewAndChildVCViewsFrame {
    for (int i = 0; i < vcArr.count; i++) {
        [self fitFrameForChildViewController:vcArr[i]];
    }
}
- (void)fitFrameForChildViewController:(UIViewController *)chileViewController{
    
    CGFloat mPlayerViewHeight = SCREEN_SIZE_WIDTH*9.0/16;//视屏高度
    if (iPhone5) {
        mPlayerViewHeight = SCREEN_SIZE_WIDTH*9.0/16-13;
    }
    //设置子控制器的frame高度
    CGRect subViewFrame = chileViewController.view.frame;
    subViewFrame.origin.y = CGRectGetMaxY(mPlayerView.frame);//设置子控制器view的y坐标
    subViewFrame.size.height = SCREEN_HEIGHT-NAV_STATUS_HEIGHT-mPlayerViewHeight-50+TABBAR_HEIGHT;
    chileViewController.view.frame = subViewFrame;
    
    //设置子控制器中UI控件的frame高度
    CGRect childSubViewFrame;
    
    if ([chileViewController isEqual:vcArr[0]]) {//直播
        
        childSubViewFrame = [[vcArr[0] wkWeb] frame];
        childSubViewFrame.size.height = chileViewController.view.frame.size.height;
        [vcArr[0] wkWeb].frame = childSubViewFrame;
    }
}
//转换子视图控制器
- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController{
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            _currentVC = newViewController;
            
            [self.view addSubview:_currentVC.view];
            
        }else{
            _currentVC = oldViewController;
        }
    }];
}
- (void)adjustLayoutsubViews {
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice]orientation];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if(!(IOS8)) {
//        orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(UIDeviceOrientationIsLandscape(orientation) || orientation == UIDeviceOrientationUnknown ||
           orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown) {
            //landscape assume  width > height
            if(width<height) {
                CGFloat temp = width;
                width = height;
                height = temp;
            }
        }
    }
    //the furtherst distance in the world
    //is not life and death
    //but when I stand in front of you
    //ye you don't know I love you
    
    CGFloat mPlayerViewHeight = width*9.0/16;
    if (iPhone5) {
        mPlayerViewHeight = width*9.0/16-13;
    }
    
    mPlayerView.frame = CGRectMake(0,0,width,mPlayerViewHeight);
    
    //when change the view size, need to reset the view to the play.
    mPlayer.view = mPlayerView;
    
    CGFloat space = 18;
    rotateBtn.frame = CGRM(CGMAX_X(mPlayerView.frame)-space-rotateBtnWidth, CGMAX_Y(mPlayerView.frame)-space-rotateBtnWidth, rotateBtnWidth, rotateBtnWidth);
    closeVoiceBtn.frame = CGRM(CGMIN_X(rotateBtn.frame), CGMIN_Y(rotateBtn.frame)-space-rotateBtnWidth, rotateBtnWidth, rotateBtnWidth);
}
- (void) changeSubviewsFrameExceptNavIsPortrait:(BOOL)isPortrait  {
    
//    NSLog(@"normalScreenWidth--%f,normalScreenHeight--%f",_appDelegate.normalScreenWidth,_appDelegate.normalScreenHeight);
    CGFloat mPlayerViewHeight = _appDelegate.normalScreenWidth*9.0/16;//播放view高度
    if (iPhone5) {
        mPlayerViewHeight = _appDelegate.normalScreenWidth*9.0/16-13;
    }
    if (isPortrait) {//竖屏
        NSLog(@"切换到竖屏");
        self.view.frame = CGRM(0, NAV_STATUS_HEIGHT, _appDelegate.normalScreenWidth, _appDelegate.normalScreenHeight-NAV_STATUS_HEIGHT);
        mPlayerView.frame = CGRectMake(0,0,_appDelegate.normalScreenWidth,mPlayerViewHeight);

        for (int i = 0; i < self.childViewControllers.count; i++) {
            UIViewController * vc = self.childViewControllers[i];
            vc.view.hidden = NO;
        }
        
        HDLiveLivingViewController * chileViewController = vcArr[0];
        //设置子控制器的frame高度
        CGRect subViewFrame = chileViewController.view.frame;
        subViewFrame.origin.y = CGRectGetMaxY(mPlayerView.frame);//设置子控制器view的y坐标
        subViewFrame.size.height = _appDelegate.normalScreenHeight-NAV_STATUS_HEIGHT-mPlayerViewHeight-50+TABBAR_HEIGHT;
        chileViewController.view.frame = subViewFrame;
        
        //设置子控制器中UI控件的frame高度
        CGRect childSubViewFrame = chileViewController.wkWeb.frame;//[[vcArr[0] wkWeb] frame];
        childSubViewFrame.size.height = chileViewController.view.frame.size.height;
        chileViewController.wkWeb.frame = childSubViewFrame;
        
    }else {
        NSLog(@"切换到横屏");
        mPlayerView.frame = CGRectMake(0, 0, _appDelegate.normalScreenHeight, _appDelegate.normalScreenWidth);
        for (int i = 0; i < self.childViewControllers.count; i++) {
            UIViewController * vc = self.childViewControllers[i];
            vc.view.hidden = YES;
        }
    }
}
- (void) changeRotateBtnFrame:(BOOL) isPotraitBool {
    
    CGFloat space = 18;
    
    rotateBtn.frame = CGRM(CGMAX_X(mPlayerView.frame)-space-rotateBtnWidth, CGMAX_Y(mPlayerView.frame)-space-rotateBtnWidth-(isPotraitBool?(0):(TABBAR_HEIGHT)), rotateBtnWidth, rotateBtnWidth);
    
    closeVoiceBtn.frame = CGRM(CGMIN_X(rotateBtn.frame), CGMIN_Y(rotateBtn.frame)-space-rotateBtnWidth, rotateBtnWidth, rotateBtnWidth);
}
- (void) adjustPlayerUrlErrorBtnFrame {
    _playerUrlErrorBtn.frame = CGRM(0, 0, mPlayerView.width, mPlayerView.height);
}
#pragma mark - 点击事件
//返回按钮点击事件
- (void) backItemWithCustemViewBtnClicked {
    if(self.view.frame.size.width < self.view.frame.size.height) {
        //竖屏
        rotateBtn.selected = NO;
        self.tabBarController.selectedIndex = 0;
    }else if(self.view.frame.size.width > self.view.frame.size.height){
        //横屏
        [self switchToPortrait];
        rotateBtn.selected = NO;
    }
}

//设置导航栏右边按钮
- (void) rightBarImageBtnClciked{
    
    //导航右边按钮点击后的浮层菜单坐标适配横竖屏
    navFloorMenuBgIMV.frame = CGRM(SCREEN_SIZE_WIDTH-10-106, NAV_STATUS_HEIGHT-8.0, 106.0, 95.0);

    [self removeOrAddNavFloorMenuBgIMV];
}

//菜单浮层上按钮点击事件
- (void) tempMenuBtnClicked:(UIButton *)sender {//600+3
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
        case 600:
        {//查看历史
            [self seeHistoryLive];
        }
            break;
        case 601:
        {//分享直播
            if (mPlayer) {
                [mPlayer pause];//暂停直播
                NSLog(@"分享直播-暂停");
            }
            [self removeOrAddNavFloorMenuBgIMV];//移除菜单视图
            [self.customShare createShareUI];
            
        }
            break;
        default:
            break;
    }
}

//分享按钮点击事件
- (void) shareBtnClicked:(UIButton*)sender {//900+3
    
}
//播放器视图点击手势
- (void) mPlayerViewTaped {
    
    UIDeviceOrientation toInterfaceOrientation = [[UIDevice currentDevice] orientation];
    
    if (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight) {//横屏
        [navFloorMenuBgIMV removeFromSuperview];
        if (rotateBtn.hidden) {//show
            [self showRotateVoiceBtn];
            self.navigationController.navigationBar.hidden = NO;
            
        }else {//hidden
            [self hidRotateVoiceBtn];
            self.navigationController.navigationBar.hidden = YES;
        }
    }
}
//屏幕旋转点击事件
- (void) rotateBtnClicked:(UIButton*)sender {
    sender.selected = !sender.selected;

    if (self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden = NO;
    }
    //手动切换横竖屏
    sender.selected?[self switchToLandscape]:[self switchToPortrait];
    //移除更多菜单视图
    [self removeNavFloorMenuIMV];
    
}
//静音点击事件
- (void) closeVoiceBtnClicked:(UIButton*)sender {
    sender.selected = !sender.selected;
    self.voiceModel.needCloseVoiceBool = sender.selected;//关闭声音bool
    _appDelegate.isCloseVoiceBool = sender.selected;
    [self removeNavFloorMenuIMV];
}
//老师暂时离开，去看历史直播
- (void) playerUrlErrorBtnClicked:(UIButton*)sender {
    [self seeHistoryLive];
}
#pragma mark - 辅助方法
- (void) registOrCancellVoiceAndRotateNotificationWillAppearBool:(BOOL)willAppearBool {
    if (willAppearBool) {
        //viewWillAppear
        //监听旋转方向
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        //KVO
        //静音监听
        [self.voiceModel addObserver:self forKeyPath:@"needCloseVoiceBool" options:NSKeyValueObservingOptionNew context:nil];
        
    }else {
        //viewWillDisappear
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];//注销旋转屏幕的监听
        //KVO
        [self.voiceModel removeObserver:self forKeyPath:@"needCloseVoiceBool"];//注销静音监听
    }
}
- (void) removeOrAddNavFloorMenuBgIMV {
    if (navFloorMenuBgIMV.alpha==0) {//添加到window上
        [self addNavFloorMenuBgIMV];

    }else {//
        navFloorMenuBgIMV.alpha = 0;
        [self removeNavFloorMenuIMV];
    }
}
- (void) removeNavFloorMenuIMV {
    navFloorMenuBgIMV.alpha = 0;
    [navFloorMenuBgIMV removeFromSuperview];
}
- (void) addNavFloorMenuBgIMV {
    navFloorMenuBgIMV.alpha = 1;
    [_appDelegate.window addSubview:navFloorMenuBgIMV];
}
- (void) showRotateVoiceBtn {
//    self.navigationController.navigationBar.hidden = NO;
    rotateBtn.hidden = NO;
    closeVoiceBtn.hidden = NO;
    
}
- (void) hidRotateVoiceBtn {
//    self.navigationController.navigationBar.hidden = YES;
    rotateBtn.hidden = YES;
    closeVoiceBtn.hidden = YES;
}
//去看历史直播
- (void) seeHistoryLive {
    [self switchToPortrait];
    HDStockNavigationController * infoNav = self.tabBarController.childViewControllers[2];
    HDInfoMationViewController * infoVC = infoNav.childViewControllers[0];
    infoVC.selectedVC = 2;
    infoVC.fromwhere = @"直播历史";
    [self.tabBarController setSelectedViewController:infoNav];//返回资讯
}
- (void) showLiveViewReplaceBtn {
    self.playerUrlErrorBtn.hidden = NO;
    [self.playerUrlErrorBtn removeFromSuperview];
    [mPlayerView addSubview:self.playerUrlErrorBtn];
    [self hidRotateVoiceBtn];
}
- (void) removeLiveReplaceBtn {
    self.playerUrlErrorBtn.hidden = YES;
    [self.playerUrlErrorBtn removeFromSuperview];
    [self showRotateVoiceBtn];
}
//设置是否需要静音
- (void) setVoiceStatus {
    if (_appDelegate.isCloseVoiceBool) {//需要静音
        self.voiceModel.needCloseVoiceBool = YES;
    }else {
        self.voiceModel.needCloseVoiceBool = NO;
    }
}
- (void)jugeWithStr:(NSString *)alertStr {
    if (IOS8) {
        //执行操作
        
        [UIAlertTool showAlertView:self title:@"温馨提示" message:alertStr cancelTitle:@"OK" otherButtonTitleArr:@[] confirmAction:^(NSInteger tag) {
        
        } cancleAction:^{
            
        } style:(UIAlertControllerStyleAlert)];

    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"", nil];
        [alter show];
    }
}

//退出直播界面
- (void) quickLiveVC {
    [self switchToPortrait];
    rotateBtn.selected = NO;
    self.tabBarController.selectedIndex = 0;//返回首页
}

#pragma mark - 屏幕旋转
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
        return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight);
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}
//点击按钮旋转到横屏
- (void)switchToLandscape
{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
}

//点击返回旋转到竖屏
- (void)switchToPortrait
{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
}
- (void)orientationDidChange
{
    
    UIDeviceOrientation toInterfaceOrientation = [[UIDevice currentDevice] orientation];
    if (!((toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown)|| (toInterfaceOrientation == UIDeviceOrientationFaceUp) || (toInterfaceOrientation == UIDeviceOrientationFaceDown) || (toInterfaceOrientation == UIDeviceOrientationUnknown))) {
        
        if (toInterfaceOrientation == UIDeviceOrientationPortrait){
            //竖屏
            if (self.playerUrlErrorBtn.hidden) {
                [self showRotateVoiceBtn];
            }
            [self changeSubviewsFrameExceptNavIsPortrait:YES];
            [self changeRotateBtnFrame:YES];//改变旋转按钮的坐标
            self.navigationController.navigationBar.hidden = NO;
            if (!(oldScreenWidth == SCREEN_SIZE_WIDTH)) {
                //屏幕旋转了的
                [self removeNavFloorMenuIMV];
                oldScreenWidth = SCREEN_SIZE_WIDTH;
            }
            
        }else if (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight) {
            //横屏
            self.view.frame = CGRM(0, 0, _appDelegate.normalScreenHeight, _appDelegate.normalScreenWidth);
            [self.customShare dismiss];
            [self hidRotateVoiceBtn];
            [self changeSubviewsFrameExceptNavIsPortrait:NO];
            [self changeRotateBtnFrame:NO];
            self.navigationController.navigationBar.hidden = YES;
            if (!(oldScreenWidth == SCREEN_SIZE_WIDTH)) {
                //屏幕旋转了的
                [self removeNavFloorMenuIMV];
                oldScreenWidth = SCREEN_SIZE_WIDTH;
            }
        }
        [self adjustPlayerUrlErrorBtnFrame];
    }
}

#pragma - mark - 直播

-(AliVcAccesskey*)getAccessKeyIDSecret
{
    AliVcAccesskey* accessKey = [[AliVcAccesskey alloc] init];
    accessKey.accessKeyId = LiveAccessKeyID;
    accessKey.accessKeySecret = LiveAccessKeySecret;
    return accessKey;
}
-(void)prepareForLive {
    [AliVcMediaPlayer setAccessKeyDelegate:self];
    NSURL* url = [NSURL URLWithString:LiveAddressUrl];
    mSourceURL = [url copy];
}
- (void) SetMoiveSource:(NSURL*)url
{
    mSourceURL = [url copy];
}

- (void) setUpLive {
    // 阻止锁屏
    //进入照相界面，再退出照相。  阻止锁屏功能无效了:解决：放在-(void)viewWillAppear:(BOOL)animated里面
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    mPaused = false;
    
    [self addSetUpLiveObserver];
    
    [self PlayMoive];
    
    mPlayer.scalingMode = scalingModeAspectFitWithCropping;
    
    [self addNetWorkCheckNotification];//添加网络监听
}
- (void) addSetUpLiveObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}
- (void) removeSetUpLiveObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
}
- (void) addNetWorkCheckNotification
{
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkStateChange:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    _appDelegate.countN += 1;
    NSLog(@"监测网络情况countN--%ld",_appDelegate.countN);
    if (!self.conn) {
        self.conn = [Reachability reachabilityForInternetConnection];
    }
    [self.conn stopNotifier];
    [self.conn startNotifier];
}
- (void) removeNetWorkCheckNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
    [self.conn stopNotifier];
}
- (void)networkStateChange:(NSNotification *)no
{
    
    // 通过通知对象获取被监听的Reachability对象
    Reachability *curReach = [no object];
    // 获取Reachability对象的网络状态
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (mSourceURL && ![mSourceURL isFileURL]&&tabBarSelectedIndex == kTabBarControllerSelectedIndex) {
        NSInteger netType = -1;
        // 3.判断网络状态
        if (status == NotReachable){ // 没有网络
            
            netType = 0;
            NSLog(@"====当前网络状态不可达=======");
            [self handleNoNetStatusIsViewWillAppearBool:NO];
        } else if (status == ReachableViaWiFi) { // 有wifi
            
            netType = 1;
            NSLog(@"====当前网络状态为Wifi=======");
            [self handleWifiStatusIsViewWillAppearBool:NO];
            
        } else{ // 没有使用wifi, 使用手机自带网络进行上网
            
            netType = 2;
            NSLog(@"====使用手机自带网络进行上网=======");
            [self handleMyselfNetStatusIsViewWillAppearBool:NO];
            
        }
    }else {
        NSLog(@"networkStateChange-不在当前界面，不播放");
    }
}

- (void)becomeActive{
    [self EnterForeGroundPlayVideo];
}

- (void)resignActive{
    [self EnterBackGroundPauseVideo];
}

-(void) EnterBackGroundPauseVideo
{
    if(mPlayer && mPaused == NO) {
        [mPlayer pause];
        
    }
}

-(void) EnterForeGroundPlayVideo
{
    if(mPlayer && mPaused == NO&&tabBarSelectedIndex==kTabBarControllerSelectedIndex) {
        NSInteger netType = [ZHFactory checkNetStatusFromStatusBar];
        switch (netType) {
            case 1:
            {//wifi
                if (self.customShare.isClosedShareUIBool) {
                    if (mPlayer&&_playerUrlErrorBtn.hidden) {
                        [mPlayer play];
                        NSLog(@"EnterForeGroundPlayVideo,wifi播放");
                    }
                }else {
                    NSLog(@"EnterForeGroundPlayVideo，wifi网,有分享界面不播放");
                }
            }
                break;
            case 2:
            {//手机网
                if (self.customShare.isClosedShareUIBool) {
                    if (mPlayer&&_playerUrlErrorBtn.hidden) {
                        [mPlayer play];
                        [MBProgressHUD showMessage:@"手机流量播放" ToView:mPlayerView RemainTime:2];
                        NSLog(@"EnterForeGroundPlayVideo,手机网播放");
                    }
                }else {
                    NSLog(@"EnterForeGroundPlayVideo，手机网,有分享界面不播放");
                }
            }
                break;
            default:
                break;
        }
        
    }else {
        NSLog(@"EnterForeGroundPlayVideo,没网不播放");
    }
}


- (void) PlayMoive
{
    if(mSourceURL == nil)
        return;
    
    //new the player
    mPlayer = [[AliVcMediaPlayer alloc] init];
    
//    //add player controls
    [self setupControls];
    
    //create player, and  set the show view
    [mPlayer create:mPlayerView];
    
    //register notifications
    [self addPlayerObserver];
    
    mPlayer.mediaType = MediaType_AUTO;
    mPlayer.timeout = 25000;
    mPlayer.dropBufferDuration = 8000;
    
    
    replay = NO;
    bSeeking = NO;
    
    //prepare and play the video
    AliVcMovieErrorCode err = [mPlayer prepareToPlay:mSourceURL];
    NSLog(@"%ld",(long)err);
    if(err != ALIVC_SUCCESS) {
        NSLog(@"preprare failed,error code is %d",(int)err);
        return;
    }
    
    err = [mPlayer play];
    NSLog(@"%ld",(long)err);

    if(err != ALIVC_SUCCESS) {
        NSLog(@"play failed,error code is %d",(int)err);
        return;
    }
    [MBProgressHUD showHUDAddedTo:mPlayerView animated:YES];
    
}

- (void) reconnectToVedioUrl {
    if (tabBarSelectedIndex == kTabBarControllerSelectedIndex) {
        [mPlayer stop];
        [self hidRotateVoiceBtn];//显示声音和旋转按钮
        isReconnectToVedioUrlBool = NO;//重连后不再重连
        _appDelegate.isCloseVoiceBool = NO;
        self.voiceModel.needCloseVoiceBool = NO;
        closeVoiceBtn.selected = NO;
        replay = YES;
        [self replay];
    }else {
        NSLog(@"reconnectToVedioUrl-不在当前界面，不播放");
    }
    
    
}
-(void)replay
{
//    [mPlayer prepareToPlay:mSourceURL];
//    replay = NO;
//    bSeeking = NO;
//    [mPlayer play];
//    [self setVoiceStatus];//设置是否需要静音
    
    if (tabBarSelectedIndex == kTabBarControllerSelectedIndex) {
        //prepare and play the video
        AliVcMovieErrorCode err = [mPlayer prepareToPlay:mSourceURL];
        NSLog(@"%ld",(long)err);
        if(err != ALIVC_SUCCESS) {
            return;
        }
        replay = NO;
        bSeeking = NO;
        err = [mPlayer play];
        NSLog(@"%ld",(long)err);
        if(err != ALIVC_SUCCESS) {
            NSLog(@"play failed,error code is %d",(int)err);
            return;
        }
        WEAK_SELF;
        dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 0.08 * NSEC_PER_SEC);
        dispatch_after(timer, dispatch_get_main_queue(), ^{
            STRONG_SELF;
            if (strongSelf.playerUrlErrorBtn.hidden) {
                [MBProgressHUD showHUDAddedTo:mPlayerView animated:YES];
            }
        });
//        dispatch_time_t timer1 = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
//        dispatch_after(timer1, dispatch_get_main_queue(), ^{
//            NSLog(@"2s后隐藏重播提示HUD");
//            [MBProgressHUD hideHUDForView:mPlayerView animated:YES];
//            
//        });
        [self setVoiceStatus];//设置是否需要静音
    }else {
        NSLog(@"replay-不在当前界面，不播放");
    }
    
}

//recieve finish notification
- (void)OnVideoFinish:(NSNotification *)notification {
    replay = YES;
    [self showLiveViewReplaceBtn];//播放完成,显示去看历史直播按钮
    if (tabBarSelectedIndex == kTabBarControllerSelectedIndex) {
        if (IOS8) {
            //执行操作
            
            [UIAlertTool showAlertView:self title:@"" message:@"播放完成" cancelTitle:@"OK" otherButtonTitleArr:@[] confirmAction:^(NSInteger tag) {
                
            } cancleAction:^{
                
            } style:(UIAlertControllerStyleAlert)];
            
        }else {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"播放完成" message:@"播放完成" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alter show];
        }
    }else {
        NSLog(@"OnVideoFinish-不在当前界面，不播放");
    }
}


//recieve start cache notification
- (void)OnStartCache:(NSNotification *)notification {

    NSInteger netType = [ZHFactory checkNetStatusFromStatusBar];
    switch (netType) {
        case 1:
        {//wifi
            NSLog(@"有wifi，显示缓冲HUD");
            [MBProgressHUD showHUDAddedTo:mPlayerView animated:YES];
//            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 4.5 * NSEC_PER_SEC);
//            dispatch_after(timer, dispatch_get_main_queue(), ^{
//                NSLog(@"4.5s后隐藏缓冲HUD");
//                [MBProgressHUD hideHUDForView:mPlayerView animated:YES];
//            });
        }
            break;
        case 2:
        {//手机自带网络
            NSLog(@"有手机自带网络，显示缓冲HUD");
            [MBProgressHUD showHUDAddedTo:mPlayerView animated:YES];
//            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 4.5 * NSEC_PER_SEC);
//            dispatch_after(timer, dispatch_get_main_queue(), ^{
//                NSLog(@"4.5s后隐藏缓冲HUD");
//                [MBProgressHUD hideHUDForView:mPlayerView animated:YES];
//                
//            });
        }
            break;
        case 0:
        {//没有网
            NSLog(@"没有网，不显示缓冲HUD");
        }
            break;
        default:
            break;
    }
}

//recieve end cache notification
- (void)OnEndCache:(NSNotification *)notification {
    //    [self hideLoadingIndicators];
    [MBProgressHUD hideHUDForView:mPlayerView];
}

-(void)addPlayerObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnVideoPrepared:)
                                                 name:AliVcMediaPlayerLoadDidPreparedNotification object:mPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnVideoError:)
                                                 name:AliVcMediaPlayerPlaybackErrorNotification object:mPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnVideoFinish:)
                                                 name:AliVcMediaPlayerPlaybackDidFinishNotification object:mPlayer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnStartCache:)
                                                 name:AliVcMediaPlayerStartCachingNotification object:mPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnEndCache:)
                                                 name:AliVcMediaPlayerEndCachingNotification object:mPlayer];
}

-(void)removePlayerObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AliVcMediaPlayerLoadDidPreparedNotification object:mPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AliVcMediaPlayerPlaybackErrorNotification object:mPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AliVcMediaPlayerPlaybackDidFinishNotification object:mPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AliVcMediaPlayerStartCachingNotification object:mPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AliVcMediaPlayerEndCachingNotification object:mPlayer];
}
//recieve prepared notification
- (void)OnVideoPrepared:(NSNotification *)notification {

    [MBProgressHUD hideHUDForView:mPlayerView];
    _appDelegate.isHaveLivePlayed = YES;
    
    WEAK_SELF;
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        STRONG_SELF;
        if (strongSelf.playerUrlErrorBtn.hidden) {
            [strongSelf showRotateVoiceBtn];//占位图片隐藏了->才显示旋转按钮
        }
    });
//    WEAK_SELF;
//    //通知主线程刷新
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //回调或者说是通知主线程刷新，
//        STRONG_SELF;
//        if (strongSelf.playerUrlErrorBtn.hidden) {
//            [strongSelf showRotateVoiceBtn];//占位图片隐藏了->才显示旋转按钮
//        }
//    });

    NSLog(@"OnVideoPrepared+?");
}

//recieve error notification
- (void)OnVideoError:(NSNotification *)notification {
    replay = YES;
    //    [playBtn setSelected:YES];
    //    [self showControls:nil];
    
    [MBProgressHUD hideHUDForView:mPlayerView];
    NSString* error_msg = @"未知错误";
    AliVcMovieErrorCode error_code = mPlayer.errorCode;
    switch (error_code) {
        case ALIVC_ERR_FUNCTION_DENIED:
            error_msg = @"未授权";
            break;
        case ALIVC_ERR_ILLEGALSTATUS:
            error_msg = @"非法的播放流程";
            break;
        case ALIVC_ERR_INVALID_INPUTFILE:
            error_msg = @"无法打开";
            //            [self hideLoadingIndicators];
            [MBProgressHUD hideHUDForView:mPlayerView animated:YES];
            break;
        case ALIVC_ERR_NO_INPUTFILE:
            error_msg = @"无输入文件";
            //            [self hideLoadingIndicators];
            [MBProgressHUD hideHUDForView:mPlayerView animated:YES];
            break;
        case ALIVC_ERR_NO_NETWORK:
            error_msg = @"网络连接失败";
            break;
        case ALIVC_ERR_NO_SUPPORT_CODEC:
            error_msg = @"不支持的视频编码格式";
            //            [self hideLoadingIndicators];
            [MBProgressHUD hideHUDForView:mPlayerView animated:YES];
            break;
        case ALIVC_ERR_NO_VIEW:
            error_msg = @"无显示窗口";
            //            [self hideLoadingIndicators];
            [MBProgressHUD hideHUDForView:mPlayerView animated:YES];
            break;
        case ALIVC_ERR_NO_MEMORY:
            error_msg = @"内存不足";
            break;
        case ALIVC_ERR_DOWNLOAD_TIMEOUT:
            error_msg = @"网络超时";
            NSLog(@"%ld",(long)error_code);
            break;
        case ALIVC_ERR_UNKOWN:
            error_msg = @"未知错误";
            break;
        default:
            break;
    }
    NSLog(@"error_msg--%@",error_msg);

    //NSLog(error_msg);
    //the error message is important when error_cdoe > 500
    
    if(error_code > 500 || error_code == ALIVC_ERR_FUNCTION_DENIED) {
        
        if (error_code == ALIVC_ERR_DOWNLOAD_TIMEOUT) {//网络超时
            if (mPlayer && (self.playerUrlErrorBtn.hidden||self.playerUrlErrorBtn.alpha == 0)) {
                [mPlayer pause];
            }
            NSInteger netType = [ZHFactory checkNetStatusFromStatusBar];
            switch (netType) {
                case 1://wifi
                case 2://机自带网络
                {//手机自带网络
                    NSLog(@"有wifi／有手机自带网络,错误提示");
                    if (tabBarSelectedIndex == kTabBarControllerSelectedIndex) {
                        if (IOS8) {
                            //执行操作
                            
                            WEAK_SELF;
                            [UIAlertTool showAlertView:self title:@"错误提示" message:error_msg cancelTitle:@"重新连接" otherButtonTitleArr:@[] confirmAction:^(NSInteger tag) {
                            
                            } cancleAction:^{
                                STRONG_SELF;
                                [strongSelf alertReconnection];
                            } style:(UIAlertControllerStyleAlert)];
                            
                        }else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                                            message:error_msg
                                                                           delegate:self
                                                                  cancelButtonTitle:@""
                                                                  otherButtonTitles:@"重新连接",nil];
                            [alert show];
                        }
                    }else {
                        NSLog(@"OnVideoError-不在当前界面，不播放");
                    }
                }
                    break;
                case 0:
                {//没有网
                    NSLog(@"没有网，错误提示");
                }
                    break;
                default:
                    break;
            }
        }else {//连接失败的提示
            [mPlayer reset];
            [self showLiveViewReplaceBtn];//显示直播view占位按钮
        }
    }
}

#pragma mark - alert
/**手机网提示alert*/
- (void) alertMyselfNetStatus {
    if (tabBarSelectedIndex == kTabBarControllerSelectedIndex) {
        if (IOS8) {
            //执行操作
            WEAK_SELF;
            [UIAlertTool showAlertView:self title:@"温馨提示" message:@"你当前使用的是手机自带网络" cancelTitle:@"退出观看" otherButtonTitleArr:@[@"继续观看"] confirmAction:^(NSInteger tag) {
                STRONG_SELF;
                [strongSelf performSelector:@selector(alertContinueSeeLive)];
            }  cancleAction:^{
                STRONG_SELF;
                [strongSelf performSelector:@selector(alertQuickSeeLive)];
            } style:(UIAlertControllerStyleAlert)];
            
        }else {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"你当前使用的是手机自带网络" delegate:self cancelButtonTitle:@"继续观看" otherButtonTitles:@"退出观看", nil];
            [alter show];
        }
    }
}
//你的网络已断开alert
- (void) showUrlBreakAlert {
    if (IOS8) {
        
        WEAK_SELF;
        [UIAlertTool showAlertView:self title:@"" message:@"你的网络已断开" cancelTitle:@"OK" otherButtonTitleArr:@[] confirmAction:^(NSInteger tag) {
            
        } cancleAction:^{
            STRONG_SELF;
            [strongSelf alertLoadUrlFailedCanRetry];
        } style:(UIAlertControllerStyleAlert)];
        
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:@"你的网络已断开" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
}
//alert等待
- (void) alertWaitConnection {
    
    WEAK_SELF;
    NSInteger netType = [ZHFactory checkNetStatusFromStatusBar];
    switch (netType) {
        case 0:
        {//无网
            NSLog(@"alertWaitConnection-没有网");
            isReconnectWifi = YES;
        }
            break;
        case 1:
        case 2:
        {//有网
            NSLog(@"alertWaitConnection-有网");
            STRONG_SELF;
            if (mPlayer&&tabBarSelectedIndex == kTabBarControllerSelectedIndex) {
                [mPlayer play];//继续播放
            }else {
                [mPlayer pause];
                NSLog(@"alertWaitConnection-不在当前界面，不播放");
            }
        }
            break;
            
        default:
            break;
    }
}
// alert重新连接
- (void) alertReconnection {
    
    NSInteger netType = [ZHFactory checkNetStatusFromStatusBar];
    switch (netType) {
        case 0:
        {//没有网
            NSLog(@"alertReconnection-没有网");
            isReconnectToVedioUrlBool = YES;
        }
            break;
        case 1:
        case 2:
        {//有网
            NSLog(@"alertReconnection-有网");
            if (mPlayer) {
                [self reconnectToVedioUrl];//重连
            }
        }
            break;
            
        default:
            break;
    }
}
- (void) alertLoadUrlFailedCanRetry {

    isReconnectWifi = YES;
}
// alert退出观看
- (void) alertQuickSeeLive {
    [self quickLiveVC];
}
// alert继续观看
- (void) alertContinueSeeLive {
    if (tabBarSelectedIndex == kTabBarControllerSelectedIndex) {
        if (mPlayer && _playerUrlErrorBtn.hidden) {
            [mPlayer play];
            [self removeLiveReplaceBtn];
        }else {
            [self reconnectToVedioUrl];
        }
    }else {
        NSLog(@"alertContinueSeeLive-不在当前界面，不播放");
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (isPhoneDataUrl) {
        //4G网
        if (alertView.numberOfButtons == 2)
        {//2个按钮
            switch (buttonIndex) {
                case 0:
                {//退出观看
                    [self alertQuickSeeLive];
                }
                    break;
                case 1:
                {//继续观看
                    [self alertContinueSeeLive];
                    if (!self.playerUrlErrorBtn.hidden) {
                        [self removeLiveReplaceBtn];
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
    else {
        
        if (alertView.numberOfButtons == 2)
        {
            switch (buttonIndex) {
                case 0:
                {//等待
                    if (mPlayer) {
                        [mPlayer play];
                    }
                }
                    break;
                case 1:
                {//重新连接
                    if (mPlayer) {
                        [self reconnectToVedioUrl];
                    }
                }
                    break;
                default:
                    break;
            }
        }
        else {
            //网络断开
            isReconnectWifi = YES;
        }
    }
}
#pragma mark _ foo

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。注意跟ios6.0之前的区分
    // Add code to clean up any of your own resources that are no longer necessary.
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be
            // needed later.
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            //self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
            
            //判断一下view是否是window的一部分，如果不是，那么可以放心的将self.view 置为空，以换取更多可用内存。
            if ([self isViewLoaded] && self.view.window == nil) {
                self.view = nil;
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
