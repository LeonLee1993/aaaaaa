//
//  HDLiveInerViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/11.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveInerViewController.h"
#import "HDLiveChateViewController.h"
#import "HDLiveLivingViewController.h"
#import "HDLiveAnalystViewController.h"
#import "HDLiveTimeTableViewController.h"

#import "HDLiveMovieViewController.h"
#import "HDLIveJinNangViewController.h"
#import "HDLiveRewardsViewController.h"
#import "HDLiveAskQuestionsViewController.h"

#import <AliyunPlayerSDK/AliyunPlayerSDK.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import "AppDelegate.h"

#import "HDLiveLookHistoryLiveListViewController.h"
#import "HDStockNavigationController.h"
#import "HDInfoMationViewController.h"
#import "HDHomePageViewController.h"

@interface HDLiveInerViewController ()<UITableViewDelegate,UIPageViewControllerDelegate>{
    CGFloat headerViewHeight;//透视图高度
    CGFloat selectionBarHeight;//直播，聊天选择栏高度
    UIImageView * headPicIMV;//头像
    UILabel * nickNameLab;//昵称
    UILabel * liveStatusLab;//直播状态
    UILabel * profileLab;//资格证书
    UIButton * personInfoBtn;//个人信息按钮
    UIView * moveLineView;//可移动横线
    UIView * _headBgView;//顶部个人信息背景视图
    NSArray * selectionArr;//直播，聊天标题数组
    CGFloat selectionBtnWidht;//直播，聊天按钮宽度
    CGFloat verLineViewWidth;//直播，聊天之间的竖线宽度
    CGFloat moveLineViewWidth;//可移动横线宽度
    CGFloat moveLineViewHeight;//可移动横线高度
    UIView * selectionBgView;
    UIScrollView * contentScrollView;//装子控制器的view
//    NSMutableArray * childVCArr;//子控制器数组
    NSArray * vcArr;//装子控制器
    UIViewController * _currentVC;//当前显示的控制器
    CGFloat zanBgViewHeight;//赞的背景视图高度
    //自定义导航条
    UIButton * navNickNameBtn;//导航条上的昵称labl
    UILabel * navNickNameLabel;//导航上昵称labl
    UIImageView * navInfoIntoIMV;//导航条上个人信息箭头
    UIImageView * navPlayerHeadPicIMV;//导航条上的直播者头像
    UIView * navCustomView;//导航条自定义背景视图
    CGFloat navHeadPicHeight;//头像高度
    CGFloat navNickNameWidth;//导航条上昵称labl高度
    CGFloat navCustomViewWidth;//导航条自定义背景视图宽度
    UIButton * supportBtn;//点赞按钮
    UILabel * supportNumLabl;//点赞数
    UIButton * navMenuBtn;//菜单按钮
    UIImageView * navFloorMenuBgIMV;//菜单浮层IMV
    CGFloat shareBlakBgViewAlpha;// 分享时候的黑色遮罩视图透明度
    
    BOOL isNavBarHidden;//导航条是否隐藏了
    BOOL isFirstComeInThisVCBool;//初次进入此界面，用于防止初次进入界面时屏幕下偏移64
    UIDeviceOrientation comeInVCDeviceOrientation;//进入界面的时候设备的放置方向
    
    
    //直播
    NSURL*  mSourceURL;//直播网址
    BOOL replay;
    BOOL bSeeking;
    Reachability *conn;
    BOOL mPaused;
    
    UIButton * rotateBtn;//旋转按钮
    UIButton * closeVoiceBtn;//静音按钮
    CGFloat rotateBtnWidth;//旋转按钮宽度
    
    AppDelegate * _appDelegate;//用于控制本页面旋转
    BOOL isReconnectToVedioUrlBool;//是否重连直播地址：默认不重连
    
}

@property (nonatomic,strong) UIView * shareBlakBgView;//分享时候的黑色遮罩视图
@property (nonatomic,strong) UIView * shareBgView;//分享背景视图
@property (nonatomic,copy) NSArray * shareTitleArr;//分享标题
@property (nonatomic,copy) NSArray * shareIconArr;//分享图片

@property (nonatomic,strong) NSMutableArray * arr;

@property (nonatomic, strong) AliVcMediaPlayer* mPlayer;
@property (nonatomic, strong) UIView *mPlayerView;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic,assign)NSTimeInterval currentPlayPos;
@property (nonatomic,assign)CGPoint originalLocation;

@end

@implementation HDLiveInerViewController
@synthesize mPlayer;
@synthesize mPlayerView;
@synthesize conn;


- (void)orientationDidChange
{
    [navFloorMenuBgIMV removeFromSuperview];
    
    UIDeviceOrientation toInterfaceOrientation = [[UIDevice currentDevice] orientation];

    if (toInterfaceOrientation == UIDeviceOrientationPortrait||toInterfaceOrientation ==UIDeviceOrientationPortraitUpsideDown){//竖屏
        
        //导航条和旋转按钮隐藏
        [self showNavRotateBtn];//显示
        [self changeSubviewsFrameExceptNavIsPortrait:YES];//
        selectionBgView.alpha = 1;
        [self changeRotateBtnFrame:YES];//改变旋转按钮的坐标
        
    }else if (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight) {//横屏
        //导航条和旋转按钮显示
        [self hidNavRotateBtn];
        isNavBarHidden = YES;
        [self changeSubviewsFrameExceptNavIsPortrait:NO];
        [self changeRotateBtnFrame:NO];
    }
    [self adjustNavCustomViewFrame];
}

- (void) changeSubviewsFrameExceptNavIsPortrait:(BOOL)isPortrait  {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    if (isPortrait) {//竖屏
        CGFloat frameY = 0;
        if (isNavBarHidden) {
            frameY = NAV_STATUS_HEIGHT;
        }else if (!isNavBarHidden){//点击横屏时显示了导航条
            frameY = 0;
        }else if (!self.navigationController.navigationBar.hidden){
            frameY = NAV_STATUS_HEIGHT;
        }
        if (isFirstComeInThisVCBool) {
            if (comeInVCDeviceOrientation == UIDeviceOrientationPortrait||comeInVCDeviceOrientation ==UIDeviceOrientationPortraitUpsideDown){//进入界面时是竖屏
//                NSLog(@"竖屏");
                frameY = NAV_STATUS_HEIGHT;
                if (!isNavBarHidden) {
                    frameY = 0;
                }
            }else if (comeInVCDeviceOrientation == UIDeviceOrientationLandscapeLeft || comeInVCDeviceOrientation == UIDeviceOrientationLandscapeRight) {//进入界面时是横屏
//                NSLog(@"横屏");
                frameY = 0;
            }
            isFirstComeInThisVCBool = NO;
        }
        
        //播放器背景视图视图坐标调整
        mPlayerView.frame = CGRectMake(0,frameY,width,width*9.0/16);
        CGRect selBgViewFrame = selectionBgView.frame;
        selBgViewFrame.origin.y = CGRectGetMaxY(mPlayerView.frame);
        selectionBgView.frame = selBgViewFrame;
        for (int i = 0; i < vcArr.count; i++) {
            [self fitFrameForChildViewController:vcArr[i]];
        }
        for (int i = 0; i < self.childViewControllers.count; i++) {
            UIViewController * vc = self.childViewControllers[i];
            vc.view.hidden = NO;
        }
    }else {
        //播放器背景视图视图坐标调整
        mPlayerView.frame = CGRectMake(0, -(self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height), width, height+12);
        selectionBgView.alpha = 0;
        for (int i = 0; i < self.childViewControllers.count; i++) {
            UIViewController * vc = self.childViewControllers[i];
            vc.view.hidden = YES;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;//显示导航栏
    [mPlayer pause];
    _appDelegate.allowRotation = 0;
    [navCustomView removeFromSuperview];
    //移除更多菜单视图
    [self removeNavFloorMenuView];
    //注销旋转屏幕的监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    isFirstComeInThisVCBool = NO;
    [self.view endEditing:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    comeInVCDeviceOrientation = [[UIDevice currentDevice] orientation];
    
    isFirstComeInThisVCBool = YES;//初次进入此界面
    self.tabBarController.tabBar.hidden = YES;//隐藏导航栏
    [mPlayer play];
    if (_liveStatus == 1) {
        //本控制器支持旋转
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _appDelegate.allowRotation = 1;
    }
    [self.navigationController.navigationBar addSubview:navCustomView];
    
    //监听旋转方向
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self setUpAllSubViewsExceptNavView];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setUpAllSubViewsExceptNavView];
}
- (void) setUpAllSubViewsExceptNavView {
    if (mPlayerView) {//防止界面坐标向下移动一个导航栏的高度
        [self adjustLayoutsubViews];
        [self adjustSelectionViewAndChildVCViewsFrame];
    }
}

NSString* accessKeyID = @"QxJIheGFRL926hFX";
NSString* accessKeySecret = @"hipHJKpt0TdznQG2J4D0EVSavRH7mR";

-(AliVcAccesskey*)getAccessKeyIDSecret
{
    AliVcAccesskey* accessKey = [[AliVcAccesskey alloc] init];
    accessKey.accessKeyId = accessKeyID;
    accessKey.accessKeySecret = accessKeySecret;
    return accessKey;
}

-(void)prepareForLive {
    [AliVcMediaPlayer setAccessKeyDelegate:self];
    NSURL* url = [NSURL URLWithString:@"http://okcaifu.cn/kongxian/kongxian.m3u8"];
    mSourceURL = [url copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareForLive];
    
    [self setUp];
    [self setNav];
    [self setNormalBackNav];//设置导航栏返回按钮
    if (_liveStatus == 1) {
        [self setUpLive];//直播初始化
    }
    [self createHeaderView];
    [self createChildVCs];
    
}
- (void) backItemWithCustemViewBtnClicked {
    [self switchToPortrait];//跳界面时先旋转到竖屏
    self.tabBarController.selectedIndex = 0;//返回首页
}
- (void) dealloc {
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (UIView *)shareBlakBgView {
    if (!_shareBlakBgView) {
        _shareBlakBgView = [[UIView alloc] initWithFrame:CGRM(0, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT)];
        _shareBlakBgView.backgroundColor = UICOLOR(28, 28, 28, 1);
        _shareBlakBgView.alpha = shareBlakBgViewAlpha;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareBlakBgViewTapEvent:)];
        [_shareBlakBgView addGestureRecognizer:tap];
    }
    return _shareBlakBgView;
}
- (NSArray *)shareIconArr {
    if (!_shareIconArr) {
        _shareIconArr = @[imageNamed(@"share_weixin"),imageNamed(@"share_friendCircle"),imageNamed(@"share_weibo"),imageNamed(@"share_QQ")];
    }
    return _shareIconArr;
}
- (NSArray *)shareTitleArr {
    if (!_shareTitleArr) {
        _shareTitleArr = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ"];
    }
    return _shareTitleArr;
}
- (UIView *)shareBgView {
    if (!_shareBgView) {
        _shareBgView = [[UIView alloc] initWithFrame:CGRM(0, 0, SCREEN_SIZE_WIDTH, 73)];
        _shareBgView.backgroundColor = COLOR(whiteColor);
        
        for (int i = 0; i < self.shareTitleArr.count; i++) {
            //icon
            UIImageView * shareIMV = [[UIImageView alloc] init];
            shareIMV.image = self.shareIconArr[i];
            shareIMV.tag = 920+i;
            [_shareBgView addSubview:shareIMV];
            //title
            UILabel * title = [ZHFactory createLabelWithFrame:CGRectZero andFont:systemFont(9) andTitleColor:TEXT_COLOR title:self.shareTitleArr[i]];
            title.tag = 940+i;
            title.textAlignment = NSTextAlignmentCenter;
            [_shareBgView addSubview:title];
            
            if (i > 0) {
                UIView * lineView = [UIView new];
                lineView.backgroundColor = LINE_COLOR;
                lineView.tag = 960+i;
                [_shareBgView addSubview:lineView];
            }
            
            UIButton * shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            shareBtn.tag = 900+i;
            [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
            [_shareBgView addSubview:shareBtn];
            
        }
        
        [self adjustShareBgViewFrame];
    }
    return _shareBgView;
}

- (void) setUp {
    //导航条
    self.liveStatus = 1;//视频
    _appDelegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    kScreenIphone5?(navCustomViewWidth = SCREEN_SIZE_WIDTH*2/3.0):(navCustomViewWidth = SCREEN_SIZE_WIDTH*5/8.0);
    
    navHeadPicHeight = 22;
    navNickNameWidth = navCustomViewWidth/2;
    shareBlakBgViewAlpha = 0.25;
    vcArr = @[[HDLiveLivingViewController new],[HDLiveChateViewController new],[HDLiveAnalystViewController new],[HDLiveTimeTableViewController new]];
    
    selectionArr = @[@"直播",@"聊天",@"分析师",@"课程表"];
    headerViewHeight = 120.0f;
    selectionBarHeight = 40.0f;//直播按钮所在行高度
    self.liveStatus == 1 ? (zanBgViewHeight = 50):(zanBgViewHeight = 0);
    verLineViewWidth = 0.5;//竖线宽度
    selectionBtnWidht = (SCREEN_WIDTH-(selectionArr.count-1)*verLineViewWidth)/selectionArr.count;//直播按钮宽度
    moveLineViewWidth = selectionBtnWidht*7.0/9-2;//可移动的横线宽度
    moveLineViewHeight = 2;
    (SCREEN_HEIGHT<=HEIGHT_5s)?(rotateBtnWidth = 31):(rotateBtnWidth = 31*WIDTH);//旋转按钮宽度

}

- (void) setNav {
    
    //添加Logo,只在第一个页面显示，用下面这个方法
    navCustomView = [[UIView alloc] init];

    //播主昵称标签
    NSString * playerName = @"股哥直播室";
    navNickNameLabel = [ZHFactory createLabelWithFrame:CGRectZero andFont:[UIFont boldSystemFontOfSize:NAV_FONT*WIDTH] andTitleColor:[UIColor whiteColor] title:playerName];
    [navCustomView addSubview:navNickNameLabel];
    // navNickNameLabel.backgroundColor = COLOR(redColor);

    //菜单
    navMenuBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [navMenuBtn setImage:imageNamed(@"Live_Menu") forState:(UIControlStateNormal)];
    navMenuBtn.tag = 300;
    [navMenuBtn addTarget:self action:@selector(navMenuBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [navCustomView addSubview:navMenuBtn];
    
    [self createBlcakFloorMenuView];
    
    [self.navigationController.navigationBar addSubview:navCustomView];
    
    [self adjustNavCustomViewFrame];
    
}

//创建导航条上菜单浮层
- (void) createBlcakFloorMenuView {
    //黑色背景
    navFloorMenuBgIMV = [[UIImageView alloc] initWithFrame:CGRM(SCREEN_SIZE_WIDTH-10-106, NAV_STATUS_HEIGHT-10, 106, 118)];
    navFloorMenuBgIMV.image = imageNamed(@"Live_blackMenu");
    navFloorMenuBgIMV.userInteractionEnabled = YES;
    
    NSArray * menuArr = @[@"查看历史",@"分享直播"];
    NSArray * menuImageArr = @[imageNamed(@"Live_care"),imageNamed(@"Live_history"),imageNamed(@"Live_shareLive")];
    CGFloat navFloorMenuBgIMVHeight = navFloorMenuBgIMV.height-7;
    CGFloat sectionHeight = (navFloorMenuBgIMVHeight-2)/3;
    for (int i = 0; i < menuArr.count; i++) {
        //左边的图标
        UIImageView * iconIMV = [[UIImageView alloc] initWithFrame:CGRM(14, 7+(sectionHeight+1)*i+sectionHeight/2-6.5, 15, 13)];
        iconIMV.image = menuImageArr[i];
        [navFloorMenuBgIMV addSubview:iconIMV];
        //        iconIMV.backgroundColor = COLOR(redColor)
        
        //右边的字
        UILabel * tempLab = [ZHFactory createLabelWithFrame:CGRM(CGMAX_X(iconIMV.frame)+12, CGMID_Y(iconIMV.frame)-iconIMV.height/2, 54, iconIMV.height) andFont:[UIFont systemFontOfSize:13] andTitleColor:[UIColor whiteColor] title:menuArr[i]];
        tempLab.tag = 2000+i;
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
#pragma mark - 设置坐标
- (void) adjustShareBgViewFrame {
    
    CGFloat shuxianWidth = 1;
    CGFloat sectionWidth = (SCREEN_SIZE_WIDTH-shuxianWidth*(self.shareTitleArr.count-1))/self.shareTitleArr.count;
    CGFloat iconIMVHeight = 24.0;//分享图标高度
    
    self.shareBlakBgView.frame = CGRM(0, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT);
    _shareBgView.frame = CGRM(0, SCREEN_HEIGHT-73, SCREEN_SIZE_WIDTH, 73);
    
    for (int i = 0; i < self.shareTitleArr.count; i++) {
        CGFloat iconIMVWidth = 30.0;//分享图标宽度
        if (i == 1) {
            iconIMVWidth = 25.0;
        }else if (i== 3) {
            iconIMVWidth = 23.0;
        }
        
        UIImageView * imv = (UIImageView*)[_shareBgView viewWithTag:920+i];
        imv.frame = CGRM((sectionWidth+shuxianWidth)*i+(sectionWidth/2.0-iconIMVWidth/2.0), self.shareBgView.height/2-iconIMVWidth*2/3, i == 3? 23:iconIMVWidth, iconIMVHeight);
        
        UILabel * thyTitle = (UILabel*)[_shareBgView viewWithTag:940+i];
        thyTitle.frame = CGRM((sectionWidth+shuxianWidth)*i, CGMAX_Y(imv.frame)+10, sectionWidth, 10);
        
        UIView * lineview = (UIView*)[_shareBgView viewWithTag:960+i];
        lineview.frame = CGRM(sectionWidth*i, CGMIN_Y(imv.frame), shuxianWidth, CGMAX_Y(thyTitle.frame)-CGMIN_Y(imv.frame));
        
        UIButton * btn = (UIButton*)[_shareBgView viewWithTag:900+i];
        btn.frame = CGRM((sectionWidth+shuxianWidth)*i, 0, sectionWidth, self.shareBgView.height);
    }
}
- (void) adjustNavCustomViewFrame {
    
    CGFloat thyWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat thyHeight = [UIScreen mainScreen].bounds.size.height;
    
    kScreenIphone5?(navCustomViewWidth = thyWidth*2/3.0):(navCustomViewWidth = thyWidth*5/8.0);
    navNickNameWidth = navCustomViewWidth/2;
    
    navCustomView.frame = CGRM(thyWidth-navCustomViewWidth, 0, navCustomViewWidth, NAV_HEIGHT);
    NSString * playerName = @"股哥直播室";
    CGSize navNickNameLabelSize = [playerName sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_FONT*WIDTH]}];
    navNickNameLabel.frame = CGRM(10, navCustomView.height/2-13/2, navNickNameLabelSize.width>=navNickNameWidth?(navNickNameWidth):(navNickNameLabelSize.width), 13);
    
    CGFloat shareBtnWidth = 30;
    navMenuBtn.frame = CGRM(navCustomView.width-5-shareBtnWidth, navCustomView.height/2-shareBtnWidth/2-3, shareBtnWidth, shareBtnWidth);
    
    navFloorMenuBgIMV.frame = CGRM(SCREEN_SIZE_WIDTH-10-106, NAV_STATUS_HEIGHT-10, 106, 118*2/3.0+1);
    
}
- (void) adjustSelectionViewAndChildVCViewsFrame {
    selectionBgView.frame = CGRM(0,CGRectGetMaxY(mPlayerView.frame), SCREEN_WIDTH, selectionBarHeight);
    for (int i = 0; i < vcArr.count; i++) {
        [self fitFrameForChildViewController:vcArr[i]];
    }
}
- (void) changeRotateBtnFrame:(BOOL) isPotraitBool {
    
    CGFloat space = 15;
    
    rotateBtn.frame = CGRM(CGMAX_X(mPlayerView.frame)-space-rotateBtnWidth, CGMAX_Y(mPlayerView.frame)-space-rotateBtnWidth-(isPotraitBool?(0):(TABBAR_HEIGHT)), rotateBtnWidth, rotateBtnWidth);
    
    closeVoiceBtn.frame = CGRM(CGMIN_X(rotateBtn.frame), CGMIN_Y(rotateBtn.frame)-space-rotateBtnWidth, rotateBtnWidth, rotateBtnWidth);
}

#pragma mark - 直播
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [self PlayMoive];
    
    mPlayer.scalingMode = scalingModeAspectFitWithCropping;
    
    [self addNetWorkCheckNotification];
}
- (void) addNetWorkCheckNotification {
    //add network notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
}
- (void)networkStateChange
{
    //网络流判断网络状态
    if (mSourceURL && ![mSourceURL isFileURL]) {
        [self checkNetworkState];
    }
}

- (void)checkNetworkState
{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        NSLog(@"有wifi");
        if (isReconnectToVedioUrlBool) {//重连视屏地址url
            [self reconnectToVedioUrl];
        }else {
            [mPlayer play];
        }
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
//        NSLog(@"使用手机自带网络进行上网");
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:@"你当前使用的是手机自带网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alter show];
        
        if (IOS8) {
            //执行操作
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"你当前使用的是手机自带网络" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:actionCancel];
            [self presentViewController:alertController animated:YES completion:nil];
        }else {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:@"你当前使用的是手机自带网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }
        if (isReconnectToVedioUrlBool) {//重连视屏地址url
            [self reconnectToVedioUrl];
        }else {
            [mPlayer play];
        }
    } else { // 没有网络
        NSLog(@"没有网络");
        [MBProgressHUD hideHUDForView:mPlayerView];
//        [MBProgressHUD showMessage:@"没有网络" ToView:self.view RemainTime:3];
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:@"你的网络已断开，请到设置中去设置" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        
//        [alter show];
        
        if (IOS8) {
            //执行操作
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"你的网络已断开，请到设置中去设置" preferredStyle:UIAlertControllerStyleAlert];
            WEAK_SELF;
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction * _Nonnull action) {
                STRONG_SELF;
                [strongSelf performSelector:@selector(alertLoadUrlFailedCanRetry)];

            }];
            [alertController addAction:actionCancel];
            [self presentViewController:alertController animated:YES completion:nil];
        }else {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:@"你的网络已断开，请到设置中去设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }
        
        [mPlayer pause];
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
    if(mPlayer && mPaused == NO) {
        [mPlayer play];
    }
    
}
- (void) PlayMoive
{
    if(mSourceURL == nil)
        return;
    
    //new the player
    mPlayer = [[AliVcMediaPlayer alloc] init];
    
    //add player controls
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
    if(err != ALIVC_SUCCESS) {
        NSLog(@"preprare failed,error code is %d",(int)err);
        return;
    }
    
    err = [mPlayer play];
    if(err != ALIVC_SUCCESS) {
        NSLog(@"play failed,error code is %d",(int)err);
        return;
    }
    [MBProgressHUD showHUDAddedTo:mPlayerView animated:YES];
    //    [self showLoadingIndicators];
}
#pragma mark - 创建视屏播放控件
- (void) setupControls
{
    //视频显示区域
    mPlayerView = [[UIView alloc] init];
    mPlayerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mPlayerView];
    //给视频播放视图添加tap手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mPlayerViewTaped)];
    [mPlayerView addGestureRecognizer:tap];
    
    //旋转按钮
    rotateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rotateBtn.backgroundColor = UICOLOR(174, 128, 61, 1);
    rotateBtn.layer.cornerRadius = rotateBtnWidth/2;
    rotateBtn.layer.masksToBounds = YES;
    rotateBtn.alpha = 0.6;
    [rotateBtn setImage:imageNamed(@"Live_rotateToFullScreen") forState:(UIControlStateNormal)];
    [rotateBtn addTarget:self action:@selector(rotateBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rotateBtn];
    
    //静音按钮
    closeVoiceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    closeVoiceBtn.backgroundColor = UICOLOR(174, 128, 61, 1);
    closeVoiceBtn.layer.cornerRadius = rotateBtnWidth/2;
    closeVoiceBtn.layer.masksToBounds = YES;
    closeVoiceBtn.alpha = 0.6;
    [closeVoiceBtn setImage:imageNamed(@"Live_volume") forState:(UIControlStateNormal)];
    [closeVoiceBtn setImage:imageNamed(@"Live_volume_close") forState:(UIControlStateSelected)];
    
    [closeVoiceBtn addTarget:self action:@selector(closeVoiceBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:closeVoiceBtn];
    
    [self adjustLayoutsubViews];
}

- (float)iOSVersion {
    static float version = 0.f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return version;
}

- (void)adjustLayoutsubViews {
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice]orientation];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    orientation = [[UIApplication sharedApplication] statusBarOrientation];
    float iosVersion = [self iOSVersion];
    if(iosVersion < 8.0) {
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
    
    mPlayerView.frame = CGRectMake(0,0,width,width*9.0/16);
    
    //when change the view size, need to reset the view to the play.
    mPlayer.view = mPlayerView;
    
    CGFloat space = 15;
    rotateBtn.frame = CGRM(CGMAX_X(mPlayerView.frame)-space-rotateBtnWidth, CGMAX_Y(mPlayerView.frame)-space-rotateBtnWidth, rotateBtnWidth, rotateBtnWidth);
    closeVoiceBtn.frame = CGRM(CGMIN_X(rotateBtn.frame), CGMIN_Y(rotateBtn.frame)-space-rotateBtnWidth, rotateBtnWidth, rotateBtnWidth);
}

//recieve prepared notification
- (void)OnVideoPrepared:(NSNotification *)notification {
    
    //    [self hideLoadingIndicators];
    [MBProgressHUD hideHUDForView:mPlayerView];
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
    
    //NSLog(error_msg);
    //the error message is important when error_cdoe > 500
    
    
    if(error_code > 500 || error_code == ALIVC_ERR_FUNCTION_DENIED) {
        
        if (error_code == ALIVC_ERR_DOWNLOAD_TIMEOUT) {//连接超时
            
            [mPlayer pause];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示"
//                                                            message:error_msg
//                                                           delegate:self
//                                                  cancelButtonTitle:@"等待"
//                                                  otherButtonTitles:@"重新连接",nil];
//            [alert show];
            
            if (IOS8) {
                //执行操作
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:error_msg preferredStyle:UIAlertControllerStyleAlert];
                
                WEAK_SELF;
                UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"等待" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction * _Nonnull action) {
                    STRONG_SELF;
                    [strongSelf performSelector:@selector(alertWaitConnection)];
                }];
                
                UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"重新连接" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction * _Nonnull action) {
                    STRONG_SELF;
                    [strongSelf performSelector:@selector(alertReconnection)];

                }];
                
                [alertController addAction:actionDefault];
                [alertController addAction:actionCancel];
                [self presentViewController:alertController animated:YES completion:nil];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                                message:error_msg
                                                               delegate:self
                                                      cancelButtonTitle:@"等待"
                                                      otherButtonTitles:@"重新连接",nil];
                [alert show];
            }
        }else {//连接失败的提示
            
            [mPlayer reset];
            
//            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:[mSourceURL absoluteString] message:error_msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            
//            [alter show];
            if (IOS8) {
                //执行操作
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[mSourceURL absoluteString] message:error_msg preferredStyle:UIAlertControllerStyleAlert];
                WEAK_SELF;
                UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction * _Nonnull action) {
                    STRONG_SELF;
                    [strongSelf performSelector:@selector(alertLoadUrlFailedCanRetry)];
                }];
                [alertController addAction:actionCancel];
                [self presentViewController:alertController animated:YES completion:nil];
            }else {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:[mSourceURL absoluteString] message:error_msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alter show];
            }
            return;
        }
    }
}
//alert等待
- (void) alertWaitConnection {
    [mPlayer play];
}
//alert重新连接
- (void) alertReconnection {
    [self reconnectToVedioUrl];
}
- (void) alertLoadUrlFailedCanRetry {
    isReconnectToVedioUrlBool = YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//等待
        [mPlayer play];
        if (alertView.numberOfButtons == 1) {//连接视屏地址失败
            isReconnectToVedioUrlBool = YES;//标记为需要重连：当重新检测到有网时重连
        }
    }
    //reconnect
    else if(buttonIndex == 1) {//点击重连按钮，重连视屏url
        [self reconnectToVedioUrl];
    }
}
- (void) reconnectToVedioUrl {
    [mPlayer stop];
    [MBProgressHUD showHUDAddedTo:mPlayerView animated:YES];
    replay = YES;
    [self replay];
    isReconnectToVedioUrlBool = NO;
}
-(void)replay
{
    [mPlayer prepareToPlay:mSourceURL];
    replay = NO;
    bSeeking = NO;
    [mPlayer play];
}

//recieve finish notification
- (void)OnVideoFinish:(NSNotification *)notification {
    replay = YES;
    
//    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"播放完成" message:@"播放完成" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//    [alter show];
    
    if (IOS8) {
        //执行操作
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"播放完成" message:@"播放完成" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"播放完成" message:@"播放完成" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
    }
    
}

//recieve start cache notification
- (void)OnStartCache:(NSNotification *)notification {
    //    [self showLoadingIndicators];
    [MBProgressHUD showHUDAddedTo:mPlayerView animated:YES];
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
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

#pragma mark - 创建界面

- (void) createHeaderView {
    
    CGFloat lineViewHeight = 1;//横线高度
    
    selectionBgView = [[UIView alloc] init];
    selectionBgView.userInteractionEnabled = YES;
    selectionBgView.backgroundColor = COLOR(whiteColor);
    selectionBgView.userInteractionEnabled = YES;
    [self.view addSubview:selectionBgView];
    //底部横线
    UIView * bottomLineView = [[UIView alloc] initWithFrame:CGRM(0, CGHEIGHT(selectionBgView.frame)-lineViewHeight, SCREEN_WIDTH, lineViewHeight)];
    bottomLineView.backgroundColor = LINE_COLOR;
    [selectionBgView addSubview:bottomLineView];
    
    //直播／聊天／百宝箱
    CGSize selectionSize = [@"直播" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    for (int i = 0; i < selectionArr.count; i++) {
        //按钮
        UIButton * tempBtn = [ZHFactory createBtnWithFrame:CGRM((selectionBtnWidht+verLineViewWidth)*i, 0, selectionBtnWidht, selectionBarHeight-lineViewHeight) title:selectionArr[i] titleFont:(i == 0 ? boldSystemFont(13):[UIFont systemFontOfSize:13]) titleCoclor:TEXT_COLOR bgColor:[UIColor whiteColor] cornerRadius:0.1];
        [tempBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateSelected)];
        tempBtn.tag = 500+i;
        i == 0 ? (tempBtn.selected = YES):(tempBtn.selected = NO);
        [tempBtn addTarget:self action:@selector(tempBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [selectionBgView addSubview:tempBtn];
        //竖线
        if (i < selectionArr.count-1) {
            UIView * tempVerLineView = [[UIView alloc] initWithFrame:CGRM(CGRectGetMaxX(tempBtn.frame),CGMID_Y(tempBtn.frame)-selectionSize.height/2, verLineViewWidth, selectionSize.height)];
            tempVerLineView.backgroundColor = LINE_COLOR;
            [selectionBgView addSubview:tempVerLineView];
        }
        
        //移动的先线
        if (tempBtn.selected) {
            moveLineView = [UIView new];
            moveLineView.center = CGPointMake(CGRectGetMidX(tempBtn.frame), CGRectGetMaxY(tempBtn.frame)+1);
            moveLineView.bounds = CGRM(0, 0, moveLineViewWidth, moveLineViewHeight);
            moveLineView.backgroundColor = UICOLOR(0, 120, 205, 1);
            [selectionBgView addSubview:moveLineView];
        }
    }
    [self adjustSelectionViewAndChildVCViewsFrame];
}

//移除更多菜单视图
- (void) removeNavFloorMenuView {
    UIButton * tempNavMennuBtn = (UIButton*)[navCustomView viewWithTag:300];
    if (tempNavMennuBtn.selected) {
        tempNavMennuBtn.selected = NO;
        [navFloorMenuBgIMV removeFromSuperview];
    }
}

#pragma mark - 创建子控制器
- (void) createChildVCs {
    for (int i = 0; i < vcArr.count; i++) {
        [self addChildViewController:vcArr[i]];
        [[vcArr[i] view] setTag:600+i];
    }
    _currentVC = vcArr[0];
    [self transitionFromOldViewController:_currentVC toNewViewController:vcArr[0]];
    [self fitFrameForChildViewController:vcArr[0]];
}

- (void)fitFrameForChildViewController:(UIViewController *)chileViewController{
    
    //设置子控制器的frame高度
    //    chileViewController.view.backgroundColor = COLOR(orangeColor);
    CGRect subViewFrame = chileViewController.view.frame;
    subViewFrame.origin.y = CGRectGetMaxY(selectionBgView.frame)+1;//设置子控制器view的y坐标
    subViewFrame.size.height = SCREEN_HEIGHT-NAV_STATUS_HEIGHT-SCREEN_SIZE_WIDTH*9.0/16-90+TABBAR_HEIGHT;
    
    chileViewController.view.frame = subViewFrame;
    
    //设置子控制器中UI控件的frame高度
    CGRect childSubViewFrame;
    
    if ([chileViewController isEqual:vcArr[0]]) {//直播
        
        childSubViewFrame = [[vcArr[0] wkWeb] frame];
        childSubViewFrame.size.height = chileViewController.view.frame.size.height;
        [vcArr[0] wkWeb].frame = childSubViewFrame;
        
    }else if ([chileViewController isEqual:vcArr[1]]) {//聊天
        
        childSubViewFrame = [[vcArr[1] wkWeb] frame];
        childSubViewFrame.size.height = chileViewController.view.frame.size.height;
        [vcArr[1] wkWeb].frame = childSubViewFrame;
        
    }else if ([chileViewController isEqual:vcArr[2]]) {//分析师
        
        childSubViewFrame = [[vcArr[2] wkWeb] frame];
        childSubViewFrame.size.height = chileViewController.view.frame.size.height;
        [vcArr[2] wkWeb].frame = childSubViewFrame;
        
    }else if ([chileViewController isEqual:vcArr[3]]) {//课程表
        
        childSubViewFrame = [[vcArr[3] wkWeb] frame];
        childSubViewFrame.size.height = chileViewController.view.frame.size.height;
        [vcArr[3] wkWeb].frame = childSubViewFrame;
    }
    
}
- (void) showNavRotateBtn {
    self.navigationController.navigationBar.hidden = NO;
    rotateBtn.hidden = NO;
    closeVoiceBtn.hidden = NO;
    
}
- (void) hidNavRotateBtn {
    self.navigationController.navigationBar.hidden = YES;
    rotateBtn.hidden = YES;
    closeVoiceBtn.hidden = YES;
}
#pragma mark - 点击事件
//播放器视图点击手势
- (void) mPlayerViewTaped {
    
    UIDeviceOrientation toInterfaceOrientation = [[UIDevice currentDevice] orientation];
    
    if (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight) {//横屏
        [navFloorMenuBgIMV removeFromSuperview];
        if (self.navigationController.navigationBar.hidden) {//show
            [self showNavRotateBtn];
            isNavBarHidden = NO;
            
        }else {//hidden
            [self hidNavRotateBtn];
            isNavBarHidden = YES;
        }
    }
}

//导航条上菜单按钮
- (void) navMenuBtnClicked:(UIButton *)sender {//300
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_appDelegate.window addSubview:navFloorMenuBgIMV];
    }else {
        [navFloorMenuBgIMV removeFromSuperview];
    }
}
//菜单浮层上按钮点击事件
- (void) tempMenuBtnClicked:(UIButton *)sender {//600+3
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
        case 600:
        {//查看历史
            UIDeviceOrientation toInterfaceOrientation = [[UIDevice currentDevice] orientation];
            if (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight) {//横屏
                [self switchToPortrait];//跳界面时先旋转到竖屏
                
            }
            
            [mPlayer pause];
            HDStockNavigationController * infoNav = self.tabBarController.childViewControllers[2];
            HDInfoMationViewController * infoVC = infoNav.childViewControllers[0];
            infoVC.selectedVC = 2;
            infoVC.fromwhere = @"跟名家";
            [self.tabBarController setSelectedViewController:infoNav];//返回资讯
        }
            break;
        case 601:
        {//分享直播
            if (self.liveStatus==1) {
                [mPlayer pause];//暂停直播
            }
            [navFloorMenuBgIMV removeFromSuperview];//移除菜单视图
            [_appDelegate.window addSubview:self.shareBlakBgView];
            [_appDelegate.window addSubview:self.shareBgView];
            [self adjustShareBgViewFrame];
        }
            break;
        default:
            break;
    }
    
}
//分享按钮点击事件
- (void) shareBtnClicked:(UIButton*)sender {//900+3
    
}

- (void) shareBlakBgViewTapEvent:(UITapGestureRecognizer*)tap {
    navMenuBtn.selected = !navMenuBtn.selected;
    [self.shareBlakBgView removeFromSuperview];
    [self.shareBgView removeFromSuperview];
    [mPlayer play];
}

//屏幕旋转点击事件
- (void) rotateBtnClicked:(UIButton*)sender {
    sender.selected = !sender.selected;
    
    if (self.navigationController.navigationBar.hidden&&!sender.selected) {
        [self mPlayerViewTaped];
    }
    //手动切换横竖屏
    sender.selected?[self switchToLandscape]:[self switchToPortrait];
    //移除更多菜单视图
    [self removeNavFloorMenuView];
}

//点击按钮旋转到横屏
- (void)switchToLandscape
{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
}

//点击返回旋转到竖屏
- (void)switchToPortrait
{
//    self.navigationController.navigationBar.hidden = NO;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
}
//静音点击事件
- (void) closeVoiceBtnClicked:(UIButton*)sender {
    sender.selected = !sender.selected;
    mPlayer.muteMode = sender.selected;
}
- (void) zanBtnClicked:(UIButton *)sender {//800+(3)
    NSLog(@"点赞");
    sender.selected = !sender.selected;
    //移除更多菜单视图
    [self removeNavFloorMenuView];
    
    switch (sender.tag) {
        case 800:
        {//赞
            
        }
            break;
        case 801:
        {//赏
            HDLiveRewardsViewController * vc = [HDLiveRewardsViewController new];
            [mPlayer pause];
            vc.pausePlayerWhenPushBlock = ^(){
                [mPlayer play];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 802:
        {//问
            HDLiveAskQuestionsViewController * vc = [HDLiveAskQuestionsViewController new];
            vc.playerName = @"";
            [mPlayer pause];
            vc.pausePlayerWhenPushBlock = ^(){
                [mPlayer play];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

//视屏，直播、分析师、课程表  点击事件
- (void) tempBtnClicked:(UIButton *)sender {//500+
    for (UIView * tempView in selectionBgView.subviews) {
        if ([tempView isKindOfClass:[UIButton class]] && tempView.tag>=500&&tempView.tag<600) {
            UIButton * tempBtn = (UIButton*)tempView;
            tempBtn.selected = NO;
            tempBtn.titleLabel.font = systemFont(13);
        }
    }
    
    sender.selected = YES;
    sender.titleLabel.font = boldSystemFont(13);
    //移除更多菜单视图
    [self removeNavFloorMenuView];
    
    [UIView animateWithDuration:0.3 animations:^{
        moveLineView.center = CGPointMake(CGRectGetMidX(sender.frame), CGRectGetMaxY(sender.frame)+1);
        moveLineView.bounds = CGRM(0, 0, moveLineViewWidth, moveLineViewHeight);
    }];
    
    if ((sender.tag == 500 && _currentVC == vcArr[0]) || (sender.tag == 501 && _currentVC == vcArr[1]) || (sender.tag == 502 && _currentVC == vcArr[2]) || (sender.tag == 503 && _currentVC == vcArr[3])) {
        return;
    }
    _currentVC = vcArr[sender.tag-500];
    switch (sender.tag) {
        case 500:{//直播
            [self transitionFromOldViewController:_currentVC toNewViewController:vcArr[0]];
        }
            break;
        case 501:{//聊天
            [self transitionFromOldViewController:_currentVC toNewViewController:vcArr[1]];
        }
            break;
        case 502:{//分析师
            [self transitionFromOldViewController:_currentVC toNewViewController:vcArr[2]];
        }
            break;
        case 503:{//课程表
            [self transitionFromOldViewController:_currentVC toNewViewController:vcArr[3]];
        }
            break;
    }
    [self fitFrameForChildViewController:_currentVC];
}

//转换子视图控制器
- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController{
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            _currentVC = newViewController;
//            [self.view bringSubviewToFront:_currentVC.view];
            
            [self.view addSubview:_currentVC.view];

        }else{
            _currentVC = oldViewController;
        }
    }];
}




@end
