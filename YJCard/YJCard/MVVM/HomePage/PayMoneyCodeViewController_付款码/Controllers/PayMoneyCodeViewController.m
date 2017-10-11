//
//  PayMoneyCodeViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/6/30.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "PayMoneyCodeViewController.h"
#import "ScanCodeViewController.h"
#import "ChangeCardView.h"
#import "SeeBigCodeView.h"
#import "PayMoneyCodeModel.h"
#import "ResetCodeVC.h"
#import "NeedCodeAndSetView.h"
#import "ResetCodeWithCertifyViewController.h"
#import "PayMoneyWithCodeView.h"
#import "PayResultViewController.h"
#import "TradeDetailViewController.h"
#import "FirstTimeSetCode.h"

@interface PayMoneyCodeViewController ()
@property (weak, nonatomic) IBOutlet UIView *payCodeCenterView;
@property (weak, nonatomic) IBOutlet UILabel *seeDetailLabel;
//二维码
@property (weak, nonatomic) IBOutlet UIImageView *biteCode;
//条形码
@property (weak, nonatomic) IBOutlet UIImageView *barCode;
@property (weak, nonatomic) IBOutlet UIView *changePayCardView;
@property (nonatomic,strong) NSMutableArray * PayCardsArr;
@property (nonatomic,strong) NeedCodeAndSetView * needView;

@end

@implementation PayMoneyCodeViewController{
    NSString * barCodeStr;
    NSTimer * payMoneyCodeTimer;
    NSString * lastRequestStr;
    NSString * flagStr;
    NSString * EventcaseStr;
}

-(NeedCodeAndSetView *)needView{
    if(!_needView){
        _needView = [NeedCodeAndSetView viewFromXib];
        __weak typeof (self) weakSelf = self;
        _needView.setPasswordBlock = ^{
            FirstTimeSetCode *VC = [[FirstTimeSetCode alloc]init];
            [weakSelf.navigationController pushViewController:VC animated:YES];
        };
    }
    return _needView;
}

-(NSMutableArray *)PayCardsArr{
    if(!_PayCardsArr){
        _PayCardsArr = @[].mutableCopy;
    }
    return _PayCardsArr;
}

- (IBAction)goBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    UIView *view = [self.view viewWithTag:2000];
    if(view!=nil){
        if(barCodeStr.length>0){
            [[LYCSignalRTool LYCsignalRTool]userCancelPayActionWithString:barCodeStr];
        }
    }
    
}

- (void)showPayMoneyCodeView{
//    PayMoneyCodeView *CodeView = [PayMoneyCodeView viewFromXib];
//    CodeView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/640*376);
//    CodeView.selfVC = self;
}

#pragma mark 二维码放大效果
- (void)seeBigImage:(UITapGestureRecognizer *)tapAction{
    
    UIView *view = [self customSnapshoFromView:_biteCode];
    
    SeeBigCodeView *bigCode = [SeeBigCodeView initWithView:view andViewFrame:tapAction.view.frame andCodeType:orginalCodeIsBite];
    
    [self.view addSubview:bigCode];
}

#pragma mark 条形码放大效果
- (void)seeBigBarImage:(UITapGestureRecognizer *)tapAction{
    UIView *view = [self customSnapshoFromView:_barCode];
    
    SeeBigCodeView *bigCode = [SeeBigCodeView initWithView:view andViewFrame:tapAction.view.frame andCodeType:originalCodeIsBar];
    bigCode.barCodeStr = barCodeStr;
    
    [self.view addSubview:bigCode];
}
#pragma mark 切换卡片
- (void)changeCard{
    
    if(self.PayCardsArr.count == 0){
        
        [MBProgressHUD showWithText:@"请等待数据加载完成后再进行此操作"];
        
    }else{
    
        ChangeCardView *chageCard = [ChangeCardView initWithCards:self.PayCardsArr];
        __weak typeof(self) weakSelf = self;
        chageCard.resetPayNumBlock = ^{
            [weakSelf setPayMoneyCardNumber];
        };
        [self.view addSubview:chageCard];
    }
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    return snapshot;
}

#pragma mark - 切换至扫一扫
- (IBAction)goToScanButtonClicked:(id)sender {
    NSString * setCodeStr = [[NSUserDefaults standardUserDefaults]objectForKey:PayCodeState];
    if([setCodeStr isEqualToString:@"set"]){
        [MobClick event:@"scanEvent"];
        ScanCodeViewController *scan = [[ScanCodeViewController alloc]init];
        scan.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scan animated:NO];
        NSArray * viewControllers = self.navigationController.viewControllers;
        NSMutableArray * arr = [NSMutableArray arrayWithArray:viewControllers];
        [arr removeObjectAtIndex:arr.count-2];
        self.navigationController.viewControllers = arr;
    }else{
        [MBProgressHUD showWithText:@"请先设置支付密码"];
    }
}

- (void) setNavDic {
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]};;
}

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

- (CIImage *)generateQRCodeImage:(NSString *)source
{
    NSData *data = [source dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
    
    return filter.outputImage;
}


- (UIImage *) resizeCodeImage:(CIImage *)image withSize:(CGSize)size
{
    if (image) {
        CGRect extent = CGRectIntegral(image.extent);
        CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
        CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
        size_t width = CGRectGetWidth(extent) * scaleWidth;
        size_t height = CGRectGetHeight(extent) * scaleHeight;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
        CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef imageRef = [context createCGImage:image fromRect:extent];
        CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
        CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
        CGContextDrawImage(contentRef, extent, imageRef);
        CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
        CGContextRelease(contentRef);
        CGImageRelease(imageRef);
        return [UIImage imageWithCGImage:imageRefResized];
    }else{
        return nil;
    }
}

- (CIImage *) generateBarCodeImage:(NSString *)source
{
    // iOS 8.0以上的系统才支持条形码的生成，iOS8.0以下使用第三方控件生成
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 注意生成条形码的编码方式
        NSData *data = [source dataUsingEncoding: NSASCIIStringEncoding];
        CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
        [filter setValue:data forKey:@"inputMessage"];
        // 设置生成的条形码的上，下，左，右的margins的值
        [filter setValue:[NSNumber numberWithInteger:0] forKey:@"inputQuietSpace"];
        return filter.outputImage;
    }else{
        return nil;
    }
}

- (void)getCodeNum{
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];//cardno
    
    NSString *string = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultPayCardID];
    if(string){
        [mutDic setObject:string forKey:@"cardid"];
    }else{
        [mutDic setObject:@"0" forKey:@"cardid"];
    }
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,generatememberqrcode];
    
    self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            PayMoneyCodeModel * codemodel = [PayMoneyCodeModel yy_modelWithDictionary:json[@"data"]];
            barCodeStr = codemodel.payCode;
            CIImage *ciImage = [self generateBarCodeImage:barCodeStr];
           
            UIImage *image = [self resizeCodeImage:ciImage withSize:CGSizeMake((self.view.frame.size.width - 80), 80)];
            _barCode.image = image;
            
            CIImage *ciImagecode = [self generateQRCodeImage:barCodeStr];
            
            _biteCode.image = [self resizeCodeImage:ciImagecode withSize:CGSizeMake(200, 200)];
            
//            [[LYCSignalRTool LYCsignalRTool]payCodeViewJoinTheCilentWithCodeString:barCodeStr];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(seeBigImage:)];
            
            [_biteCode addGestureRecognizer:tap];
            
            [self.PayCardsArr removeAllObjects];
            NSArray * arr = codemodel.memberPayCards;
            for (NSDictionary *dic in arr) {
                MemberPayCardsModel * model = [MemberPayCardsModel yy_modelWithDictionary:dic];
                [self.PayCardsArr addObject:model];
            }
            
            NSString * payMoneyNo = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultPayCard];
            MemberPayCardsModel * model= self.PayCardsArr[0];
            
            if(!payMoneyNo){
                self.payMoneyNumLabel.text = [NSString stringWithFormat:@"支付卡: %@",model.cardNo];
                [[NSUserDefaults standardUserDefaults]setObject:model.cardNo forKey:DefaultPayCard];
            }else{
                self.payMoneyNumLabel.text = [NSString stringWithFormat:@"支付卡: %@",payMoneyNo];
            }
            
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:nil progressViewText:@"" progressViewType:LYCStateViewLoad ViewController:self];
}


- (void)firstTimeGetCodeNum{
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];//cardno
    
    NSString *string = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultPayCardID];
    if(string){
        [mutDic setObject:string forKey:@"cardid"];
    }else{
        [mutDic setObject:@"0" forKey:@"cardid"];
    }
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,generatememberqrcode];
    
    self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            PayMoneyCodeModel * codemodel = [PayMoneyCodeModel yy_modelWithDictionary:json[@"data"]];
            barCodeStr = codemodel.payCode;
            CIImage *ciImage = [self generateBarCodeImage:barCodeStr];
            
            UIImage *image = [self resizeCodeImage:ciImage withSize:CGSizeMake((self.view.frame.size.width - 80), 80)];
            _barCode.image = image;
            
            CIImage *ciImagecode = [self generateQRCodeImage:barCodeStr];
            
            _biteCode.image = [self resizeCodeImage:ciImagecode withSize:CGSizeMake(200, 200)];
            
            [[LYCSignalRTool LYCsignalRTool]payCodeViewJoinTheCilentWithCodeString:barCodeStr];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(seeBigImage:)];
            
            [_biteCode addGestureRecognizer:tap];
            
            [self.PayCardsArr removeAllObjects];
            NSArray * arr = codemodel.memberPayCards;
            for (NSDictionary *dic in arr) {
                MemberPayCardsModel * model = [MemberPayCardsModel yy_modelWithDictionary:dic];
                [self.PayCardsArr addObject:model];
            }
            
            NSString * payMoneyNo = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultPayCard];
            MemberPayCardsModel * model= self.PayCardsArr[0];
            
            if(!payMoneyNo){
                self.payMoneyNumLabel.text = [NSString stringWithFormat:@"支付卡: %@",model.cardNo];
                [[NSUserDefaults standardUserDefaults]setObject:model.cardNo forKey:DefaultPayCard];
            }else{
                self.payMoneyNumLabel.text = [NSString stringWithFormat:@"支付卡: %@",payMoneyNo];
            }
            
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:self.view progressViewText:@"加载中" progressViewType:LYCStateViewLoad ViewController:self];
}

- (void)setTimerToRefresh{
    __weak typeof(self)weakSelf = self;
    if(IS_IOS_8){
        payMoneyCodeTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1] interval:45 target:self selector:@selector(getCodeNum) userInfo:nil repeats:NO];
    }else{
        payMoneyCodeTimer = [NSTimer scheduledTimerWithTimeInterval:45 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf getCodeNum];
        }];
    }
}

-(void)dealloc{
    [payMoneyCodeTimer invalidate];
    payMoneyCodeTimer = nil;
    NSLog(@"delloc");
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:DefaultPayCard];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:DefaultPayCardID];
}

#pragma mark - view's life

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [payMoneyCodeTimer invalidate];
    payMoneyCodeTimer = nil;
    
    [UIScreen mainScreen].brightness = [[[NSUserDefaults standardUserDefaults] objectForKey:@"brightness"] floatValue];
    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"ifNeedChangeLight"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.DidSetCode){
        //设置定时器
        [self setTimerToRefresh];
        
    }else{
        //提示设置密码
        
    }
    
    NSString * setCodeStr = [[NSUserDefaults standardUserDefaults]objectForKey:PayCodeState];
    if(setCodeStr.length>0){
        
        if([setCodeStr isEqualToString:@"set"]){
            [self.needView remove];
            [self firstTimeGetCodeNum];
        }else{
            
        }
        
    }else{
        
    }
    
    if ([UIScreen mainScreen].brightness < 0.8) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[UIScreen mainScreen].brightness] forKey:@"brightness"];
        [UIScreen mainScreen].brightness = 0.8;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString * string = @"该功能用于向商家当面付款 查看详情";
    
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:RGBAColor(255, 255, 255, 0.65)
                         range:NSMakeRange(0, 12)];
    
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, string.length)];
    
    self.seeDetailLabel.attributedText = attributeStr;
    
    UITapGestureRecognizer *tapBar = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeBigBarImage:)];
    [_barCode addGestureRecognizer:tapBar];
    
    UITapGestureRecognizer *tapToChange = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeCard)];
    
    [_changePayCardView addGestureRecognizer:tapToChange];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:PayCodeState] isEqualToString:@"set"]){
//        [self getCodeNum];
        [LYCSignalRTool LYCsignalRTool];
    }else{
        //提示设置密码
        [self.needView showWithCenterPoint:self.payCodeCenterView];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSeeDetail)];
    [self.seeDetailLabel addGestureRecognizer:tap];
    self.seeDetailLabel.userInteractionEnabled = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(judgeByTag:) name:@"getMessageFromMerchant" object:nil];
    
}

- (void)tapToSeeDetail{
    TradeDetailViewController * detali = [[TradeDetailViewController alloc]init];
    detali.type = LYCTradeDetailTypeSeeDetail;
    [self.navigationController pushViewController:detali animated:YES];
}

#pragma mark - 通过SignalR返回的信息跳转
- (void)judgeByTag:(NSNotification *)sender{

    NSDictionary * dic = sender.object;
    
    NSArray * array = dic[@"A"];
    NSString * string = array[0];
    NSArray * componentArr = [string componentsSeparatedByString:@"|"];
    
    @synchronized (self) {
        if([flagStr isEqualToString:[NSString stringWithFormat:@"%@",componentArr[2]]]){
            NSLog(@"相同");
        }else{
            NSLog(@"不同");
            flagStr = [NSString stringWithFormat:@"%@",componentArr[2]];
            NSLog(@"%@",flagStr);
            NSString *caseStr = componentArr[0];
            
            [[NSUserDefaults standardUserDefaults]setObject:componentArr[1] forKey:@"codeString"];
            
            if([caseStr isEqualToString:@"needPwd"]){
                
                    EventcaseStr = @"needPwd";
                    [self needPwdAction:componentArr];
                
            }else if ([caseStr isEqualToString:@"success"]){
                if(lastRequestStr!= componentArr[2]){
                    lastRequestStr = componentArr[2];
                    [self successAction:componentArr];
                }
            }else if ([caseStr isEqualToString:@"notEnoughMoney"]){
                
                [[LYCSignalRTool LYCsignalRTool]userDontHaveEnoughMoneyWithString:componentArr[1]];
                LYCAlertController * alertC = [LYCAlertController alertControllerWithTitle:@"卡片余额不足,请切换其他卡片" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertC animated:YES completion:nil];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                }];
                [alertC addAction:action];
            }
        }
    }
}

#pragma mark - signalR返回消息处理 需要密码
- (void)needPwdAction:(NSArray *)infoArr{
    //跳转至输入支付密码的界面 推出方式
    //如果几次的请求一样就只实现一次
    PayMoneyWithCodeView *CodeView = [PayMoneyWithCodeView viewFromXib];
    CodeView.tag = 2000;
    [CodeView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/640*376)];
    CodeView.selfVC = self;
    CodeView.prepaidID = infoArr[2];
    CodeView.payCodeStr = infoArr[1];
    CodeView.payTypeStr = @"payCodeView";
    __weak typeof (self)weakSelf = self;
    CodeView.dissMissBlock = ^{
        if(barCodeStr.length>0){
            [[LYCSignalRTool LYCsignalRTool]userCancelPayActionWithString:barCodeStr];
            self.payCodeCenterView.userInteractionEnabled = YES;
            self.seeDetailLabel.userInteractionEnabled = YES;
        }
    };
    [self.view addSubview:CodeView];
    self.payCodeCenterView.userInteractionEnabled = NO;
    self.seeDetailLabel.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        CodeView.lyc_y = ScreenHeight -  ScreenHeight/640*376;
    }];
    
    //用户正在输入密码
    [[LYCSignalRTool LYCsignalRTool]userIsInputPassWordWithCodeString:infoArr[1]];
    
    CodeView.forgetPWBlock = ^{
        ResetCodeWithCertifyViewController *reset = [[ResetCodeWithCertifyViewController alloc]init];
        [weakSelf.navigationController pushViewController:reset animated:YES];
    };
    
}
#pragma mark - signalR返回消息处理 交易成功 不需要密码会走
- (void)successAction:(NSArray *)infoArr{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:@"1" forKey:@"tradetype"];
    [mutDic setObject:infoArr[2] forKey:@"tradeid"];
    
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,@"gettradedetails"];
    
    self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            if([EventcaseStr isEqualToString:@"needPwd"]){//如果是需要密码框的 就直接在密码框那里跳转了 不能再走这里
            
            }else{
                
                PayResultViewController * payResult = [[PayResultViewController alloc]init];
                payResult.caseStr = @"payCodeView";
                NSMutableDictionary * infoDic = [NSMutableDictionary dictionaryWithDictionary:json[@"data"]];
                [infoDic setObject:infoArr[2] forKey:@"caseId"];
                payResult.infoDic = infoDic;
                [self.navigationController pushViewController:payResult animated:YES];
                
            }
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:nil progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:self];
}

#pragma mark - 换卡的时候还要换验证码
- (void)setPayMoneyCardNumber{
    NSString * payMoneyNo = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultPayCard];
    [self getCodeNum];
    self.payMoneyNumLabel.text = [NSString stringWithFormat:@"支付卡: %@",payMoneyNo];
}

@end
