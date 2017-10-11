//
//  AutonymViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/20.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "AutonymViewController.h"
#import "AutoymTableViewCell.h"
#import "AutoymIDCardTableViewCell.h"
#import "AuthenticationFailTableViewCell.h"//实名认证失败的cell
#import "BeingCertionTableViewCell.h"//认证中cell
#import "LYCHelper.h"
#import "AutoMessageTableViewCell.h"
#import "CityField.h"
#import "LYCImagePicker.h"
#import "LYCBaseTabBarController.h"
#import "AppDelegate.h"


#define AutonymTopSpace 64

@interface AutonymViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *commitCerifyButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottonViewHeight;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//AutoymTableViewCell
@property (nonatomic,strong) NSString * image64Base;
@property (nonatomic,strong) NSString * image64Base1;
@property (nonatomic,strong) AutoymTableViewCell * autoymTableViewCell;
@end

@implementation AutonymViewController{
    
    AutoymIDCardTableViewCell * autoymIDCardTableViewCellFirst;
    AutoymIDCardTableViewCell * autoymIDCardTableViewCellSeconde;
    AuthenticationFailTableViewCell * authenticationFailTableViewCell;
    AutoMessageTableViewCell * autoMessageTableViewCell;

    NSString *rejectReason;
    NSDictionary * infoDic;
    LYCStateViews *hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.LYCAutonmyViewState == LYCAutonmyViewStateGoOn || self.LYCAutonmyViewState == LYCAutonmyViewStateFail){
        self.bottonViewHeight.constant = 0;
        [self networkRequestInfo];
    }
    [self setUpTableView];
    self.image64Base = [[NSString alloc]init];
    self.image64Base1 = [[NSString alloc]init];
}

- (void)setUpTableView{
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
}

-(UITableView *)tableView{
//    _tableView.backgroundColor = RGBColor(231, 231, 231);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"AutoymTableViewCell" bundle:nil] forCellReuseIdentifier:@"AutoymTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AutoymIDCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"AutoymIDCardTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AuthenticationFailTableViewCell" bundle:nil] forCellReuseIdentifier:@"AuthenticationFailTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BeingCertionTableViewCell" bundle:nil] forCellReuseIdentifier:@"BeingCertionTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AutoMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"AutoMessageTableViewCell"];
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.LYCAutonmyViewState == LYCAutonmyViewStateDefault){
        return 3;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.LYCAutonmyViewState == LYCAutonmyViewStateDefault){
    
        if(indexPath.row == 0){
            
            AutoymTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutoymTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _autoymTableViewCell = cell;
            return cell;
            
        }else{
            AutoymIDCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutoymIDCardTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selfVC = self;
            cell.userInteractionEnabled = YES;
            if(indexPath.row ==1){
                
                cell.IDCardImageView.image = [UIImage imageNamed:@"拍摄身份证正面"];
                autoymIDCardTableViewCellFirst = cell;
                autoymIDCardTableViewCellFirst.setImageBlock = ^{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        _image64Base  = [self image2DataURL:autoymIDCardTableViewCellFirst.IDCardImageView.image];
                    });
                };
                
                
            }else{
                
                cell.IDCardImageView.image = [UIImage imageNamed:@"拍摄身份证反面"];
                autoymIDCardTableViewCellSeconde = cell;
                autoymIDCardTableViewCellSeconde.setImageBlock = ^{
                     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                         _image64Base1 = [self image2DataURL:autoymIDCardTableViewCellSeconde.IDCardImageView.image];
                     });
                };
                
            }
            return cell;
        }
        
    }else if (self.LYCAutonmyViewState == LYCAutonmyViewStateGoOn){
        if(indexPath.row == 0){
            BeingCertionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeingCertionTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.infoDic = infoDic;
            return cell;
        }else if(indexPath.row == 1){
            AutoMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutoMessageTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            autoMessageTableViewCell = cell;
            cell.infoDic = infoDic;
            return cell;
        }else{
            AutoymIDCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutoymIDCardTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.row ==2){
            cell.isFront = YES;
            }
            if(infoDic){
                cell.infoDic = infoDic;
            }
            return cell;
        }
    }else{
        
        if(indexPath.row == 0){
            AuthenticationFailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuthenticationFailTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            authenticationFailTableViewCell = cell;
            cell.resetBlock = ^{
                self.LYCAutonmyViewState = LYCAutonmyViewStateDefault;
                self.bottonViewHeight.constant = 64;//显示底部的控件
                [self.tableView reloadData];
            };
            return cell;
        }
        if(indexPath.row == 1){
            AutoMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutoMessageTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            autoMessageTableViewCell = cell;
            if(infoDic){
                cell.infoDic = infoDic;
            }
            return cell;
        }else{
            AutoymIDCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutoymIDCardTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selfVC = self;
            cell.userInteractionEnabled = NO;
            if(indexPath.row ==2){
                cell.isFront = YES;
            }
            if(infoDic){
                cell.infoDic = infoDic;
            }
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.LYCAutonmyViewState == LYCAutonmyViewStateDefault){
        if(indexPath.row == 0){
            return ScreenWidth/375 * 200+20;
        }
        else {
            return ScreenWidth/375 * 218.5+20;
        }
    }else if (self.LYCAutonmyViewState == LYCAutonmyViewStateGoOn){
        if(indexPath.row == 0){
            return ScreenWidth/375*50+20;
        }else if(indexPath.row ==1) {
            return ScreenWidth/375 * 200+20;
        }
        else {
            return ScreenWidth/375 * 218.5+20;
        }
    }else if (self.LYCAutonmyViewState == LYCAutonmyViewStateFail){
        if(indexPath.row == 0){
            CGSize size = [LYCHelper getsizeOfString:rejectReason andAttribute:nil andLineSpace:7 andBorderSpace:28 fontSize:16];
            return 104+size.height+ScreenWidth/375*100;
        }else if(indexPath.row ==1) {
            return ScreenWidth/375 * 200+20;
        }
        else {
            return ScreenWidth/375 * 218.5+20;
        }
    }else{
        return 0;
    }
   
}
- (IBAction)goBack:(id)sender {
//    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
//    UIView * disView = [window viewWithTag:1001];
//    disView.hidden = YES;
//    [disView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 提交实名认证
- (IBAction)commitCerifyButtonClicked:(id)sender {
    [MobClick event:@"commitVerify"];
    if(_autoymTableViewCell.nameTF.text.length==0||[_autoymTableViewCell.nameTF.text containsString:@" "]){
        if(_autoymTableViewCell.nameTF.text.length==0){
            [MBProgressHUD showWithText:@"请输入姓名"];
        }else{
            [MBProgressHUD showWithText:@"名字中不能包含空格,请去除空格后重新提交"];
        }
        
    }else if(![LYCHelper validateIDCardNumber:_autoymTableViewCell.IdTF.text]) {
        [MBProgressHUD showWithText:@"请输入正确身份证号码"];
    }else{
        NSData *data1 = UIImagePNGRepresentation(autoymIDCardTableViewCellFirst.IDCardImageView.image);
        NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"拍摄身份证正面"]);
       if( [data1 isEqual:data]){
           [MBProgressHUD showWithText:@"请设置身份证人像面"];
       }else{
           NSData *data1 = UIImagePNGRepresentation(autoymIDCardTableViewCellSeconde.IDCardImageView.image);
           NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"拍摄身份证反面"]);
           if( [data1 isEqual:data]){
               [MBProgressHUD showWithText:@"请设置身份证国徽面"];
           }else{
               if(_autoymTableViewCell.nameTF.text.length>0&&_autoymTableViewCell.IdTF.text.length>0&&_autoymTableViewCell.firstCityField.idStr.length&&_autoymTableViewCell.secondCityField.idStr.length&&_image64Base.length>0&&_image64Base1.length>0){
                   [self networkRequest];
               }else{
                   [MBProgressHUD showWithText:@"请补全个人信息"];
               }
           }
       }
    }
}

#pragma mark - 网络请求
- (void)networkRequest{
    
    hud = [LYCStateViews LYCshowStateViewTo:self.tableView withState:LYCStateViewLoad andTest:@"正在认证中"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
        NSMutableDictionary *mutDic = @{}.mutableCopy;
        [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
        [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];//cardno
        [mutDic setObject:_autoymTableViewCell.nameTF.text forKey:@"name"];//真实姓名
        [mutDic setObject:dic[UserTelNum] forKey:@"mobile"];//电话号码
        [mutDic setObject:_autoymTableViewCell.IdTF.text forKey:@"idcard"];//身份证号码
        [mutDic setObject:_image64Base forKey:@"imagefront"];//身份证正面照片
        [mutDic setObject:_image64Base1 forKey:@"imagereverse"];//身份证反面照片
        [mutDic setObject:_autoymTableViewCell.firstCityField.idStr forKey:@"province"];//省代码
        [mutDic setObject:_autoymTableViewCell.secondCityField.idStr forKey:@"city"];//城市代码
        NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
        NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Submitauth];
        self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
            [hud LYCHidStateView];
            if([json[@"code"] isEqual:@(100)]){
                LYCBaseTabBarController * rootVc = [[LYCBaseTabBarController alloc] init];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                rootVc.selectedIndex = 2;
                delegate.window.rootViewController = rootVc;
            }else{
                
                if(((NSString *)json[@"msg"]).length>0){
                    [MBProgressHUD showWithText:json[@"msg"]];
                }else{
                    [MBProgressHUD showWithText:@"认证失败,请重新尝试"];
                }
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [hud LYCHidStateView];
            [MBProgressHUD showWithText:@"网络错误,认证失败"];
        } andProgressView:nil progressViewText:@"正在认证中" progressViewType:LYCStateViewLoad ViewController:self];
    });

}



- (void)networkRequestInfo{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];//cardno
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Getauthinfo];
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        if([json[@"code"] isEqual:@(100)]){
            infoDic = json[@"data"];
            
            authenticationFailTableViewCell.messageLable.text = [NSString stringWithFormat:@"审核未通过原因: %@",infoDic[@"rejectedReason"]];
            rejectReason = authenticationFailTableViewCell.messageLable.text;
            
            [self.tableView reloadData];
            
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } andProgressView:window progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark - delImages
- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

- (NSString *) image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation([self imageByScalingAndCroppingForSize:CGSizeMake(240, 165) withImage:image]);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation([self imageByScalingAndCroppingForSize:CGSizeMake(240, 165) withImage:image], 1);
        mimeType = @"image/jpeg";
    }
    return [NSString stringWithFormat:@"%@",
            [imageData base64EncodedStringWithOptions: 0]];
}


- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withImage:(UIImage *)image
{
//
    
        UIImage *newImage = nil;
        
        UIImage *sourceImage = image;
        
        CGSize imageSize = sourceImage.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        CGFloat targetWidth = targetSize.width;
        CGFloat targetHeight = targetSize.height;
        CGFloat scaleFactor = 0.0;
        CGFloat scaledWidth = targetWidth;
        CGFloat scaledHeight = targetHeight;
        CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
        if (CGSizeEqualToSize(imageSize, targetSize) == NO)
        {
            CGFloat widthFactor = targetWidth / width;
            CGFloat heightFactor = targetHeight / height;
            
            if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
            else
            scaleFactor = heightFactor; // scale to fit width
            scaledWidth= width * scaleFactor;
            scaledHeight = height * scaleFactor;
            
            // center the image
            if (widthFactor > heightFactor)
            {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            }
            else if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
        
        UIGraphicsBeginImageContext(targetSize); // this will crop
        
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width= scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        [sourceImage drawInRect:thumbnailRect];
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        if(newImage == nil)
        NSLog(@"could not scale image");
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    
        return newImage;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [hud LYCHidStateView];
}





@end
