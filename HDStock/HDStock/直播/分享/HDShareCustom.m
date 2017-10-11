//
//  HDShareCustom.m
//  HDStock
//
//  Created by hd-app01 on 16/12/19.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDShareCustom.h"

#define shareBlakBgViewAlpha 0.3
#define kTransFromForScaleTimeInterVal 0.15
#define kSmallestValue 0.3
#define kBigestValue 1.0

@interface HDShareCustom(){
    int shareType;
//    UILabel * titleL;
    
    UIButton * cancellBtn;
}
@end

@implementation HDShareCustom

static id _publishContent;//类方法中的全局变量这样用（类型前面加static）
static UIVisualEffectView * _effectView;
static UIView * _shareBlakBgView;
static UIView * _shareBgView;

+ (void) registShareSDK {
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:SHARE_APPKEY
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2150087076"
                                           appSecret:@"fff114df6427749e222765c873c013ef"
                                         redirectUri:@"http://open.weibo.com/apps/2150087076/privilege/oauth"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx817e33d58fcd8194"
                                       appSecret:@"a6a6d463da5fea19cb7d9ba38f2ef75d"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105894722"
                                      appKey:@"ifc3705adGcEsbrd"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

-(void)createShareUI {
    if (_isHasCreatedShareUIBool) {
        [self addUI];
        NSLog(@"已创建分享界面，直接添加");
    }else {
        NSArray * shareIconArr = @[imageNamed(@"share_weixin"),imageNamed(@"share_friendCircle"),imageNamed(@"share_QQ"),imageNamed(@"share_weibo")];
        
        NSArray * shareTitleArr = @[@"微信好友",@"微信朋友圈",@"QQ",@"新浪微博"];
        //    _publishContent = publishContent;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //分享黑色背景视图
        _shareBlakBgView = [UIView new];
        _shareBlakBgView.backgroundColor = UICOLOR(28, 28, 28, 1);
        _shareBlakBgView.alpha = shareBlakBgViewAlpha;
        _shareBlakBgView.tag = 8800;
        [window addSubview:_shareBlakBgView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareBlakBgViewTapEvent:)];
        [_shareBlakBgView addGestureRecognizer:tap];
        [window addSubview:_shareBlakBgView];
        
        //分享白色背景视图
        _shareBgView = [UIView new];
        _shareBgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _shareBgView.tag = 8900;
        [window addSubview:_shareBgView];
        
//        NSArray * colorArr = @[[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor]];
        //分享按钮
        for (int i = 0; i < shareTitleArr.count; i++) {
            //icon
            UIImageView * shareIMV = [[UIImageView alloc] init];
            shareIMV.image = shareIconArr[i];
            shareIMV.tag = 920+i;
            [_shareBgView addSubview:shareIMV];
            
            UIButton * shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            shareBtn.tag = 900+i;
            [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
            [_shareBgView addSubview:shareBtn];
//            shareBtn.backgroundColor = colorArr[i];
            
            UILabel * tempTitleLab = [UILabel new];
            tempTitleLab.text = shareTitleArr[i];
            tempTitleLab.textColor = [UIColor colorWithHexString:@"#8F8F8F"];
            tempTitleLab.font = systemFont(14.0*WIDTH);
            tempTitleLab.textAlignment = NSTextAlignmentCenter;
            tempTitleLab.tag = 950+i;
            [_shareBgView addSubview:tempTitleLab];
            
        }
        
        cancellBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [cancellBtn addTarget:self action:@selector(cancellBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        [cancellBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [cancellBtn setTitleColor:TEXT_COLOR forState:(UIControlStateNormal)];
        cancellBtn.titleLabel.font = systemFont(16.0*WIDTH);
        [_shareBgView addSubview:cancellBtn];
        
        UIView * lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#DADADA"];
        lineView.tag = 1314;
        [_shareBgView addSubview:lineView];
        
        
        [self adjustFrameWithtitleArr:shareTitleArr];
        self.isHasCreatedShareUIBool = YES;
    }
    self.isClosedShareUIBool = NO;
}
- (void) adjustFrameWithtitleArr:(NSArray *)shareTitleArr {
    
    CGFloat shareBgViewWidth = SCREEN_SIZE_WIDTH;
    CGFloat shareBgViewHeight = 275*WIDTH;
    CGFloat iconIMVWidth = 49.0*WIDTH;//分享图标宽度
    CGFloat iconLeftSpace = (shareBgViewWidth/2.0-iconIMVWidth*3.0/2)/3.0;//左边距
    CGFloat iconTopSpace = 25.0*WIDTH;//上边距
    CGFloat cancellBtnHeight = 56.0*WIDTH;//取消按钮高度
    CGFloat shareBtnHeight = (shareBgViewHeight-cancellBtnHeight)/2.0;//覆盖的分享按钮高度
    CGFloat shareBtnWidth = shareBgViewWidth/3.0;//覆盖的分享按钮宽度
    CGFloat shareTitleLabHeight = 13*WIDTH;//分享标题label高度
    
    _shareBlakBgView.frame = CGRM(0, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT);
    _shareBgView.frame = CGRM(0, SCREEN_HEIGHT-shareBgViewHeight, shareBgViewWidth, shareBgViewHeight);
    
    
    
    for (int i = 0; i < shareTitleArr.count; i++) {
        //分享图标
        UIImageView * imv = (UIImageView*)[_shareBgView viewWithTag:920+i];
        
        imv.center = CGPointMake(iconLeftSpace+iconIMVWidth/2.0+(iconLeftSpace*2+iconIMVWidth)*(i%3==0?(i%3):(i%3+i/3)), iconTopSpace+iconIMVWidth/2.0+(48*WIDTH+iconIMVWidth)*(i/3));
        imv.bounds = CGRectMake(0, 0, iconIMVWidth, iconIMVWidth);
        
        //分享标题
        UILabel * shareTitleL = (UILabel *)[_shareBgView viewWithTag:950+i];
        shareTitleL.center = CGPointMake(imv.centerX, imv.centerY+iconIMVWidth/2.0+10*WIDTH+ shareTitleLabHeight/2.0);
        shareTitleL.bounds = CGRM(0, 0, shareBtnWidth, shareTitleLabHeight);
        
        //分享图标点击按钮
        UIButton * shareBtn = (UIButton*)[_shareBgView viewWithTag:900+i];
        shareBtn.center = CGPointMake(imv.centerX,shareBtnHeight*(i/3)+shareBtnHeight/2.0);
        shareBtn.bounds = CGRectMake(0, 0, shareBtnWidth, shareBtnHeight);
    }
    
    cancellBtn.center = CGPointMake(shareBgViewWidth/2.0, shareBgViewHeight-cancellBtnHeight+cancellBtnHeight/2.0);
    cancellBtn.bounds = CGRectMake(0, 0, shareBgViewWidth, cancellBtnHeight);
    
    UIView * lineV = [_shareBgView viewWithTag:1314];
    lineV.center = CGPointMake(shareBgViewWidth/2, CGRectGetMinY(cancellBtn.frame)-1);
    lineV.bounds = CGRM(0, 0, shareBgViewWidth, 1);
    
    //添加启动动画
    [self addAnimScale];
    
}
//添加启动动画
- (void) addAnimScale {
    [UIView animateWithDuration:kTransFromForScaleTimeInterVal animations:^{
        _shareBlakBgView.alpha = shareBlakBgViewAlpha;
    }];
    
    _shareBgView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:kTransFromForScaleTimeInterVal animations:^{
        
        _shareBgView.transform = CGAffineTransformMakeScale(1, 1);
        _shareBgView.alpha = 1;
        
    }completion:^(BOOL finish){
        
        
    }];
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, kTransFromForScaleTimeInterVal/2.0);
//    dispatch_after(time, dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:kTransFromForScaleTimeInterVal animations:^{
//            _shareBgView.alpha = 1;
//        }];
//    });
//    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    animation2.fromValue = [NSValue valueWithCGPoint:CGPointMake(kSmallestValue, kSmallestValue)];
//    animation2.toValue = [NSValue valueWithCGPoint:CGPointMake(kBigestValue, kBigestValue)];
//    animation2.duration = kTransFromForScaleTimeInterVal;//不设置时候的话，有一个默认的缩放时间.
//    animation2.removedOnCompletion = NO;
//    animation2.fillMode = kCAFillModeForwards;
//    [_shareBgView.layer addAnimation:animation2 forKey:nil];
    
}
//取消按钮点击事件
- (void) cancellBtnClicked:(UIButton*)sender {
    [self dismiss];
    if ([self shareCustomDlegate] && [[self shareCustomDlegate] respondsToSelector:@selector(shareBlcakBgViewTaped)]) {
        [[self shareCustomDlegate] shareBlcakBgViewTaped];
    }
}
//分享黑色背景点击事件
- (void)shareBlakBgViewTapEvent:(UITapGestureRecognizer *)tap {
    [self dismiss];
    if ([self shareCustomDlegate] && [[self shareCustomDlegate] respondsToSelector:@selector(shareBlcakBgViewTaped)]) {
        [[self shareCustomDlegate] shareBlcakBgViewTaped];
    }
}
//分享按钮点击事件
- (void) shareBtnClicked:(UIButton*)sender {
    
    [self dismiss];
    if (self.comFromIndex == 0 && self.shareCustomDlegate && [self.shareCustomDlegate respondsToSelector:@selector(shareCustomShareBtnClicked)]) {
        [self.shareCustomDlegate shareCustomShareBtnClicked];
    }
    
    shareType = 0;
    switch (sender.tag) {
        case 900:
        {//微信好友
            shareType = SSDKPlatformSubTypeWechatSession;
            NSLog(@" 微信好友");
        }
            break;
            
        case 901:
        {//微信朋友圈
            shareType = SSDKPlatformSubTypeWechatTimeline;
            NSLog(@" 微信朋友圈");
        }
            break;
            
        case 902:
        {//QQ好友
            shareType = SSDKPlatformSubTypeQQFriend;
            NSLog(@" QQ好友");
        }
            break;
        
        case 903:
        {//新浪微博
            shareType = SSDKPlatformTypeSinaWeibo ;
            NSLog(@" 新浪微博");
        }
            break;
                         
        default:
            break;
    }
    
    BOOL isCanOpenWXBool = false;
    BOOL isCanOpenQQBool = false;
    BOOL isSinaWeiBoBool = false;
    
    if (sender.tag == 900 || sender.tag == 901)
    {//微信
        // 检测是否安装了微信
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            
            isCanOpenWXBool = YES;
            if (self.sharePlatBlock) {
                self.sharePlatBlock(sender.tag-900);
            }
        }else {
            isCanOpenWXBool = NO;
            if (self.isInstalledAlertBlock) {
                self.isInstalledAlertBlock(@"没有安装微信");
            }
        }
    }else if (sender.tag == 902)
    {//QQ
        //判断是否安装了QQ
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            isCanOpenQQBool = YES;
            if (self.sharePlatBlock) {
                self.sharePlatBlock(sender.tag-900);
            }
        }else {
            isCanOpenQQBool = NO;
            if (self.isInstalledAlertBlock) {
                self.isInstalledAlertBlock(@"没有安装QQ");
            }
        }
    }else
    {//微博
        isSinaWeiBoBool = YES;
        if (self.sharePlatBlock) {
            self.sharePlatBlock(sender.tag-900);
        }
    }
}
- (void) gotoShareWithContent:(id)publishContent {
    //调用shareSDK的无UI分享类型
    WEAK_SELF;
    [ShareSDK share:shareType parameters:publishContent onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        STRONG_SELF;

        if (strongSelf.shareStatusBlock) {
            strongSelf.shareStatusBlock(state);
        }
    }];
}
//取消分享界面
- (void)dismiss {
    
//    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    animation2.toValue = [NSValue valueWithCGPoint:CGPointMake(kSmallestValue, kSmallestValue)];
//    animation2.duration = kTransFromForScaleTimeInterVal;//不设置时候的话，有一个默认的缩放时间.
//    animation2.removedOnCompletion = NO;
//    animation2.fillMode = kCAFillModeForwards;
//    [_shareBgView.layer addAnimation:animation2 forKey:nil];
    [UIView animateWithDuration:kTransFromForScaleTimeInterVal animations:^{
        
        _shareBgView.transform = CGAffineTransformMakeScale(0.1, 0.1);

    }completion:^(BOOL finish){
        
        
    }];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, kTransFromForScaleTimeInterVal);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kTransFromForScaleTimeInterVal animations:^{
            _shareBgView.alpha = 0;
            _shareBlakBgView.alpha = 0;
        }];
    });
    
    self.isClosedShareUIBool = YES;
}
//添加分享界面
- (void) addUI {
    [self addAnimScale];
}

//- (void)dismiss {
//    
//    [_shareBlakBgView removeFromSuperview];
//    [_shareBgView removeFromSuperview];
//
//    [UIView animateWithDuration:0.3 animations:^{
//        _shareBgView.frame = CGRM(SCREEN_SIZE_WIDTH_HALF, SCREEN_HEIGHT/2, 0, 0);
//
//    }];
//    
//    self.isClosedShareUIBool = YES;
//}
//
//- (void) addUI {
//    
//    CGFloat shareBgViewWidth = 280*WIDTH;
//    CGFloat shareBgViewHeight = 156*WIDTH;
//    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:_shareBlakBgView];
//    [window addSubview:_shareBgView];
//    
////    NSArray * shareTitleArr = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ"];
////
////    [UIView animateWithDuration:0.2 animations:^{
////        [self adjustFrameWithtitleArr:shareTitleArr];
////    }];
//    
//}

@end
