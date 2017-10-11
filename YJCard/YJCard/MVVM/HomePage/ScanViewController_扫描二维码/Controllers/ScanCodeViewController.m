//
//  ScanCodeViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/6/28.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//  扫描二维码的界面
//

#import "ScanCodeViewController.h"
#import "HPFunctionButton.h"
#import "PayMoneyCodeViewController.h"
#import "ScanCodeTopView.h"
#import "ScanCodeToPayMoneyViewController.h"
#import "ScanCodeResultModel.h"
#import "SignalRViewController.h"
//#import "MemberPayCardsModel.h"在"ScanCodeResultModel.h"中有引入

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

/**
 *  屏幕 高 宽 边界
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_BOUNDS  [UIScreen mainScreen].bounds

#define TOP (SCREEN_HEIGHT-220)/2
#define LEFT (SCREEN_WIDTH-220)/2

#define kScanRect CGRectMake(LEFT, TOP, 220, 220)

@interface ScanCodeViewController()<AVCaptureMetadataOutputObjectsDelegate>{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
    ScanCodeTopView *Topview;
}

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, assign) BOOL needToAddSubViews;

@property (nonatomic, strong) UIImageView * line;

@end

@implementation ScanCodeViewController


-(void)configView{
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP+10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
     [self.view addSubview:_line];
     timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

-(void)animation1
{
    num ++;
    if(2*num<200){
        _line.frame = CGRectMake(LEFT, TOP+2*num, 220, 2);
        _line.alpha = num / 220.0 + 0.2;
    }
    if (2*num == 200) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            num = 0;
            _line.alpha = num / 220.0 + 0.2;
            _line.frame = CGRectMake(LEFT, TOP+10, 220, 2);
        });
    }
}


- (void)setCropRect:(CGRect)cropRect{
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    
//    CGAffineTransform transform = CGAffineTransformMakeScale(0, 0);
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, self.view.bounds);
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];
    
    HPFunctionButton * pay = [[HPFunctionButton alloc]initWithFrame:CGRectMake(75, self.view.frame.size.height-140, self.view.frame.size.width/36*8, 110)];
    pay.alpha = 0.7;
    [pay setImage:[UIImage imageNamed:@"付款码"] forState:UIControlStateNormal];
    [pay setTitle:@"付款码" forState:UIControlStateNormal];
    pay.titleLabel.textColor = [UIColor whiteColor];
    [pay.titleLabel setFont:[UIFont systemFontOfSize:12]];
    pay.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [[pay rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        PayMoneyCodeViewController *scan = [[PayMoneyCodeViewController alloc]init];
        [self.navigationController pushViewController:scan animated:NO];
        NSArray * viewControllers = self.navigationController.viewControllers;
        NSMutableArray * arr = [NSMutableArray arrayWithArray:viewControllers];
        [arr removeObjectAtIndex:arr.count-2];
        self.navigationController.viewControllers = arr;
    }];
    
    [self.view addSubview:pay];
    
    HPFunctionButton * Scan = [[HPFunctionButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-75-self.view.frame.size.width/36*8, self.view.frame.size.height-140, self.view.frame.size.width/36*8, 110)];
    [Scan setImage:[UIImage imageNamed:@"扫一扫"] forState:UIControlStateNormal];
    [Scan setTitle:@"扫一扫" forState:UIControlStateNormal];
    Scan.userInteractionEnabled = NO;
    [Scan.titleLabel setFont:[UIFont systemFontOfSize:12]];
    Scan.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:Scan];
    [self setUpTopView];
}

#pragma mark - topViewActions
- (void)setUpTopView{
    Topview = [ScanCodeTopView viewFromXib];
    Topview.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    
    UIView * placeHolderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    placeHolderView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:placeHolderView];
    __weak typeof (self)weakSelf = self;
    [[Topview.goBack rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [[Topview.helfButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        SignalRViewController *scanToPay = [[SignalRViewController alloc]init];
        [weakSelf.navigationController pushViewController:scanToPay animated:YES];
    }];
    [self.view addSubview:Topview];
}

- (void)setupCamera
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device==nil) {
        LYCAlertController *alert = [LYCAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
//    // Device
    _device = device;

//    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];

    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

//    设置扫描区域
    CGFloat top = TOP/SCREEN_HEIGHT;
    CGFloat left = LEFT/SCREEN_WIDTH;
    CGFloat width = 220/SCREEN_WIDTH;
    CGFloat height = 220/SCREEN_HEIGHT;
//   top 与 left 互换  width 与 height 互换
    [_output setRectOfInterest:CGRectMake(top,left, height, width)];

    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }

    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }

    // 条码类型 AVMetadataObjectTypeQRCode
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];

//    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    
    [self.view.layer insertSublayer:_preview atIndex:0];
    
//    // Start
    [_session startRunning];
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-150, TOP + 220 +23, 300, 14)];
    label.text = @"将二维码/条码放入框内，即可自动扫描";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGBColor(148,148,148);
    label.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label];
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        [timer setFireDate:[NSDate distantFuture]];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects lastObject];
        stringValue = metadataObject.stringValue;
        NSLog(@"扫描结果：%@",stringValue);
        [Topview closeTheLight];
//        NSArray *arry = metadataObject.corners;
        NSLog(@"%@",NSStringFromCGRect(metadataObject.bounds));
        
//        for (id temp in arry) {
//            NSLog(@"%@",temp);
//        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self goToPayMoneyPageWithCode:stringValue];
    
    } else {
        NSLog(@"无扫描信息");
        return;
    }
}

- (void)goToPayMoneyPageWithCode:(NSString *)codeString{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];//cardno
    [mutDic setObject:codeString forKey:@"paycode"];
    [[NSUserDefaults standardUserDefaults]setObject:codeString forKey:@"codeString"];
    
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString * UrlStr = [NSString stringWithFormat:@"%@%@",GlobelHeader,Checkpaycode];
    
    self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            
            [[LYCSignalRTool LYCsignalRTool]sendMessageToCilentWithCodeString:codeString];
            
            ScanCodeResultModel * model = [ScanCodeResultModel yy_modelWithDictionary:json[@"data"]];
            ScanCodeToPayMoneyViewController *scanToPay = [[ScanCodeToPayMoneyViewController alloc]init];
            [MobClick event:@"payCodeEvent"];
            scanToPay.model = model;
             NSArray * arr = self.navigationController.childViewControllers;
             NSMutableArray *mutArr = [NSMutableArray arrayWithArray:arr];
             for (id obj in arr) {
                  if([obj isKindOfClass:[self class]]){
                       [mutArr removeObject:obj];
                  }
             }
//             self.navigationController.childViewControllers = mutArr;
            [self.navigationController pushViewController:scanToPay animated:YES];
            [self removeFromParentViewController];
        }else{
            if (_session != nil && timer != nil) {
                [_session startRunning];
                [timer setFireDate:[NSDate date]];
            }
            [MBProgressHUD showWithText:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:self.view progressViewText:@"" progressViewType:LYCStateViewLoad ViewController:nil];
    
}

//- (void)drawBoundsWithCorners:(AVMetadataMachineReadableCodeObject *)obCorners{
//    if(obCorners.corners.count){
//        CAShapeLayer *layer = [[CAShapeLayer alloc]init];
//        layer.lineWidth = 4;
//        layer.strokeColor = [UIColor greenColor].CGColor;
//        layer.fillColor = [UIColor redColor].CGColor;
//        
//        UIBezierPath *path = [[UIBezierPath alloc]init];
//        CGPoint point = CGPointZero;
//        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)(obCorners.corners[0]), &point);
//        [path moveToPoint:point];
//        for (int i=1; i<obCorners.corners.count; i++) {
//            CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)(obCorners.corners[i]), &point);
//            [path addLineToPoint:point];
//        }
//        [path closePath];
//        layer.path = path.CGPath;
//        [self.view.layer addSublayer:layer];
//    }else{
//        return;
//    }
//}

#pragma mark - view's life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    
    [self setCropRect:kScanRect];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString * mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
            LYCAlertController * alertC = [LYCAlertController alertControllerWithTitle:@"摄像头访问受限,请前往设置中心设置后使用" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
             [self presentViewController:alertC animated:YES completion:nil];
            [alertC addAction:action];
        }else{
            [self setupCamera];
        }
    });
    [LYCSignalRTool LYCsignalRTool];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_session != nil && timer != nil) {
        [_session startRunning];
        [timer setFireDate:[NSDate date]];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //停止扫描
    [_session stopRunning];
    [timer setFireDate:[NSDate distantFuture]];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:DefaultPayCard];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:DefaultPayCardID];
}

-(void)dealloc{
    [timer invalidate];
    timer = nil;
    NSLog(@"delloc");
}

@end
