//
//  ProductDetailViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "ProductDetailViewController.h"
#import <WebKit/WebKit.h>
#import "HDLiveSubmitOrderViewController.h"
#import "panToPopObject.h"
#import "HDShareCustom.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "fullPageFailLoadView.h"
#import "AppDelegate.h"
#import "PCSignInViewController.h"

@interface ProductDetailViewController ()<thyShareCustomDlegate,fullPageFailLoadViewDelegate>
@property (nonatomic,strong) WKWebView * webView;
@property (nonatomic,strong) HDShareCustom * customShare;
@end

@implementation ProductDetailViewController{
    fullPageFailLoadView * fullFailLoad;
    NSString * orderNoStr;//订单号
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
//    Live_shareLive
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"share_iconbig"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClicked)];
    [self setBuyButton];
    [self panToPopView];
    _customShare = [[HDShareCustom alloc]init];
    fullFailLoad = [[fullPageFailLoadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    fullFailLoad.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


-(WKWebView *)webView{
    if(_webView == nil){
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50-64)];
        [self.view addSubview:_webView];
    }
    return _webView;
}


- (void)shareButtonClicked{
    NSArray *shareUrlArr = @[@"http://gk.cdtzb.com/api/product/x6",@"http://gk.cdtzb.com/api/product/qn",@"http://gk.cdtzb.com/api/product/xl",@"http://gk.cdtzb.com/api/product/zy"];
    
    //分享
    [_customShare createShareUI];
    _customShare.shareCustomDlegate = self;
    _customShare.comFromIndex = 0;
    WEAK_SELF;
    //判断是否安装了接受分享的设备
    _customShare.isInstalledAlertBlock = ^(NSString * isInstalledStr){
        STRONG_SELF;
        [strongSelf jugeWithStr:isInstalledStr];
    };
    //开始分享
    _customShare.sharePlatBlock = ^(NSInteger platType){
        STRONG_SELF;
        NSString * shareUrl = shareUrlArr[_idStr.integerValue-1];
        NSString * shareText = @"";
        NSString * shareImage = @"shareIcon";
        if (strongSelf.urlStr) {
            shareUrl = strongSelf.urlStr;
        }
        if (strongSelf.shareTextStr) {
            shareText = strongSelf.shareTextStr;
        }
        if (strongSelf.shareImageStr) {
            shareImage = strongSelf.shareImageStr;
        }
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        if (platType == 2){//微博
            [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",shareText,[NSURL URLWithString:shareUrl] ]
                                                       title:@"炒了20年股我就服他们，炒股的朋友可以看看"
                                                       image:[UIImage imageNamed:shareImage]
                                                         url:[NSURL URLWithString:shareUrl]
                                                    latitude:0
                                                   longitude:0
                                                    objectID:nil
                                                        type:SSDKContentTypeAuto];
            [shareParams SSDKEnableUseClientShare];
            [strongSelf.customShare gotoShareWithContent:shareParams];
        }else if (platType == 0 || platType == 1 || platType == 3) {//微信好友，微信朋友圈，QQ
            //1、创建分享参数
            NSArray* imageArray = @[[UIImage imageNamed:shareImage]];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:shareText
                                                 images:imageArray
                                                    url:[NSURL URLWithString:shareUrl]
                                                  title:@"炒了20年股我就服他们，炒股的朋友可以看看"
                                                   type:SSDKContentTypeAuto];
                [strongSelf.customShare gotoShareWithContent:shareParams];
            }
        }
    };
    
    //分享状态
    self.customShare.shareStatusBlock = ^(NSInteger shareState){
        STRONG_SELF;
        switch (shareState) {
            case SSDKResponseStateSuccess:
            {
                [MBProgressHUD showMessage:@"分享成功" ToView:strongSelf.view RemainTime:2];
            }
                break;
            case SSDKResponseStateFail:
            {
                [MBProgressHUD showMessage:@"分享失败" ToView:strongSelf.view RemainTime:2];
            }
                break;
            case SSDKResponseStateCancel:
            {
                [MBProgressHUD showMessage:@"取消分享" ToView:strongSelf.view RemainTime:2];
                
            }
                break;
            default:
                break;
        }
    };
}

- (void)jugeWithStr:(NSString *)alertStr {
    if (IOS8) {
        //执行操作
        WEAK_SELF;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionContinue = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel  handler:nil];
        [alertController addAction:actionContinue];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"", nil];
        [alter show];
    }
}


- (void)setBuyButton{
    UIButton * buyButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-50, SCREEN_WIDTH, 50)];
//    [buyButton setTitle:[NSString stringWithFormat:@"购买( ¥%@ )",_priceStr] forState:UIControlStateNormal];
    [buyButton setTitle:[NSString stringWithFormat:@"订阅"] forState:UIControlStateNormal];
    buyButton.backgroundColor = MAIN_COLOR;
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(goToPayPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyButton];
}

- (void)goToPayPage{
    
    NSDictionary *dic = [[LYCUserManager informationDefaultUser] getUserInfoDic];

    if([dic[PCUserState] isEqualToString:@"success"]){
//        HDLiveSubmitOrderViewController * submitOrder = [[HDLiveSubmitOrderViewController alloc]init];
//        submitOrder.needPayMoneyStr = _priceStr;
//        submitOrder.productId = _idStr;
//        [self.navigationController pushViewController:submitOrder animated:YES];
        [self addToMyAttention];
        
    }else{
        [self presentTargetViewController:NSStringFromClass([PCSignInViewController class])];
    }
    
}


- (void)addToMyAttention{
    [self requestOfMakeOrder];
}



- (void)panToPopView{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint startPoint;
    CGPoint changedPoint;
    CGPoint velocity = [pan velocityInView:self.view];
    if(velocity.x>0) {
        if(pan.state == UIGestureRecognizerStateBegan){
            startPoint = [pan locationInView:self.view];
        }
        if (pan.state ==UIGestureRecognizerStateChanged){
            changedPoint = [pan locationInView:self.view];
            if((changedPoint.x-startPoint.x)>60){
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (void) shareBlcakBgViewTaped {
    
}

- (void)shareCustomShareBtnClicked {
    
}

-(void)popMenuDidClickRefresh:(fullPageFailLoadView *)popMenu{
   
    
    [popMenu.fullfailLoad hideTheSubViews];
//    [self load];
}

- (void)presentTargetViewController:(NSString *)classStr{
    id targetVC = [[NSClassFromString(classStr) alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:targetVC];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - 网络请求
//生成订单
- (void) requestOfMakeOrder {
    
    NSDictionary * dic = [self getMakeOrderDic];
//    NSLog(@"requestOfMakeOrder--%@",dic);
    if (dic && [[dic allKeys] count] > 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[CDAFNetWork sharedMyManager] post:[NSString stringWithFormat:@"%@api/order/order",MAKE_ORDER] params:dic success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"json--%@",json);
            
            if ([json isKindOfClass:[NSDictionary class]])
            {
                if ([[json[@"code"] stringValue] isEqualToString:@"1"])
                {//订单生成成功
                    if ([json[@"data"] isKindOfClass:[NSArray class]] && [json[@"data"] count]>0)
                    {
                        orderNoStr = json[@"data"][0][@"order_no"];//订单号
                        NSLog(@"orderNoStr--%@",self.idStr);
                        [MBProgressHUD showAutoMessage:json[@"msg"] ToView:self.view];
                        [self showBuySuccessAlert];//购买成功的提示
                        NSArray *arr = [[LYCUserManager informationDefaultUser].defaultUser objectForKey:alreadyBuiedKey];
                        NSMutableArray *mutArr = [NSMutableArray arrayWithArray:arr];
                        if(![mutArr containsObject:self.idStr]){
                            [mutArr addObject:self.idStr];
                        }
                        [[LYCUserManager informationDefaultUser].defaultUser setObject:mutArr forKey:@"alreadyBuied"];
                    }else {
                        NSLog(@"订单生成成功，没数据/后台数据格式改变了");
                    }
                }else {
                    //0：订单生成失败，200:此订单已经购买过，400：未登陆
                    [self showBuyResultAlertWithStr:json[@"msg"]];//订单生成失败的提示
                }
            }else {
                NSLog(@"json返回格式不是dic");
            }
        } failure:^(NSError *error) {
            NSLog(@"error--%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else {
        NSLog(@"没有获取到参数");
    }
}

- (void) showBuyResultAlertWithStr:(NSString *)alertStr {
    if (IOS8) {
        //执行操作
        WEAK_SELF;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionContinue = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel  handler:nil];
        [alertController addAction:actionContinue];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"", nil];
        [alter show];
    }
}

- (void) showBuySuccessAlert {
    if (IOS8) {
        //执行操作
        WEAK_SELF;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"恭喜您，订阅成功！" message:@"投顾服务老师将在24小时内与您取得联系开通服务。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionContinue = [UIAlertAction actionWithTitle:@"已阅" style:UIAlertActionStyleCancel  handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF;
            [strongSelf popToProductListVCWithBuyState:[strongSelf.idStr integerValue]-1];
        }];
        [alertController addAction:actionContinue];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"恭喜您，订阅成功！" message:@"投顾服务老师将在24小时内与您取得联系开通服务。" delegate:self cancelButtonTitle:@"已阅" otherButtonTitles:@"", nil];
        [alter show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self popToProductListVCWithBuyState:[self.idStr integerValue]-1];
}

#pragma mark - 辅助信息
- (NSDictionary*) getMakeOrderDic {
    
    NSDictionary * dic;
    
    NSString * priceStr = @"";
    if (self.priceStr) {
        priceStr = self.priceStr;
    }
    NSString * productIdStr = @"";
    if (self.idStr) {
        productIdStr = self.idStr;
    }
    NSString * randomStr = [NSString stringWithFormat:@"%d",arc4random()%100];
    
    NSDictionary *tokenDic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
//    NSLog(@"tokenDic--%@",tokenDic);
    if (tokenDic && [[tokenDic allKeys] count] > 0 && [tokenDic[@"loginState"] isEqualToString:@"success"]) {
        
        dic = @{@"token":tokenDic[@"token"],
                @"product_id":productIdStr,
                @"price":priceStr,
                @"pay_type":[NSString stringWithFormat:@"%d", 1],
                @"device_info":IDENTIFIER_FOR_VENDOR,
                @"out_trade_no":@"123",
                @"attach":@"123",
                @"nonce_str":randomStr,
                @"wx_appid":@"123"};
        
    }else {
        NSLog(@"没登录");
        dic = @{};
    }
    return dic;
}

- (void) popToProductListVCWithBuyState:(NSInteger) buyState{
    PersonalproductViewController * productListVC = nil;
    for (UIViewController * VC in self.navigationController.viewControllers) {
        
        if ([VC isKindOfClass:[PersonalproductViewController class]]) {
            productListVC = (PersonalproductViewController *)VC;
        }
    }
    AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.buySuccededToRefreshUIBool = YES;
    if(productListVC){
        [self.navigationController popToViewController:productListVC animated:YES];
    }else{
        PersonalproductViewController *productListView = [[PersonalproductViewController alloc]init];
        NSMutableArray *arr = @[].mutableCopy;
        [arr addObjectsFromArray:self.navigationController.viewControllers];
        [arr insertObject:productListView atIndex:1];
        self.navigationController.viewControllers = arr;
        delegate.buySuccededToRefreshUIBool = NO;
        self.hidesBottomBarWhenPushed = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
