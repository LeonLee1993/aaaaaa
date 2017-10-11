//
//  SystemSettingViewController.m
//  HDStock
//
//  Created by liyancheng on 16/11/25.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "PCAboutUsViewController.h"
#import "HDLeftMainViewController.h"
@interface SystemSettingViewController ()
@property (weak, nonatomic) IBOutlet UIView *resignView;

@end

@implementation SystemSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTapToViews];
    [self panToPopView];
    _cacheLabel.text = [self getCacheSize];

}

- (void)addTapToViews{
    
    NSDictionary *dic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    if([dic[PCUserState] isEqualToString:@"success"]){
        _resignView.hidden = NO;
    }else{
        _resignView.hidden = YES;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped:)];
    [_goBackView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped:)];
    [_cacheView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped:)];
    [_aboutUsView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped:)];
    [_callView addGestureRecognizer:tap4];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped:)];
    [_resignPresentCountView addGestureRecognizer:tap5];
    
}

- (void)taped:(UITapGestureRecognizer *)taped{
    switch (taped.view.tag) {
        case 201:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        case 202:
        {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"缓存清除" message:@"您确定要清空全部缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
            }];
            [alertView addAction:OKAction];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [self cleanCache];
            }];
            [alertView addAction:cancleAction];
            [self presentViewController:alertView animated:YES completion:nil];
            
        }
            break;
            
        case 203:
        {
            
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"工作时间：周一至周五8:30——17:30" message:nil preferredStyle:0];
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"4000280000" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self contactUs];
            }];
            [alertView addAction:OKAction];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertView addAction:cancleAction];
            [self presentViewController:alertView animated:YES completion:nil];
            
        }
            break;
            
        case 204:
        {
            PCAboutUsViewController * USVC = [PCAboutUsViewController new];
            [self.navigationController pushViewController:USVC animated:YES];
        }
            break;
            
        case 205:
        {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"退出账号" message:@"确认退出账号?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self logOut];
            }];
            [alertView addAction:OKAction];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertView addAction:cancleAction];
            [self presentViewController:alertView animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

- (void)contactUs{
    NSString *telNumber = [NSString stringWithFormat:@"tel:%@", @"4000280000"];
    NSURL *aURL = [NSURL URLWithString:telNumber];
    if ([[UIApplication sharedApplication] canOpenURL:aURL]) {
        [[UIApplication sharedApplication] openURL:aURL];
    }
}

#pragma mark - 计算缓存大小
- (NSString *)getCacheSize
{
    //定义变量存储总的缓存大小
    long long sumSize = 0;
    
    //01.获取当前图片缓存路径
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
    //02.创建文件管理对象
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    //获取当前缓存路径下的所有子路径
    NSArray *subPaths = [filemanager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
    //遍历所有子文件
    for (NSString *subPath in subPaths) {
        
        NSString *filePath = [cacheFilePath stringByAppendingFormat:@"/%@",subPath];
        
        long long fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
//        NSLog(@"%lld",fileSize);
        sumSize += fileSize;
        
    }
    float size_m = sumSize/(1000.0*1000.0);
    return [NSString stringWithFormat:@"%.2fM",size_m];
}

- (void)cleanCache{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
     [fileManager removeItemAtPath:cacheFilePath error:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
//        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add"]];
    hud.label.text = @"清除成功";

    [hud hideAnimated:YES afterDelay: 2];

    _cacheLabel.text = @"0.00M";
}

- (void)logOut{
    
    [[LYCUserManager informationDefaultUser] logOut];
    [[LYCUserManager informationDefaultUser].defaultUser removeObjectForKey:alreadyBuiedKey];//退出的时候清除保留当前账号的已经保存的产品的id数组
//    NSLog(@"退出当前账号");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"已退出当前账号";
    [hud hideAnimated:YES afterDelay: 1];
    [self.hdLeft.messageArr removeAllObjects];
    [[LYCUserManager informationDefaultUser].defaultUser removeObjectForKey:@"avatar"];
    _resignPresentCountView.hidden = YES;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)panToPopView{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint changedPoint;
    changedPoint = [pan translationInView:self.view];
    if((changedPoint.x)>60&&fabs(changedPoint.y)<10){
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


@end
