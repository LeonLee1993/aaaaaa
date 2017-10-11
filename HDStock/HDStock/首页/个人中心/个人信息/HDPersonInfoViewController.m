//
//  HDPersonInfoViewController.m
//  HDStock
//
//  Created by hd-app01 on 16/11/16.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDPersonInfoViewController.h"
#import "HDPersonChangeNameViewController.h"
#import "HDPersonChangePasswordViewController.h"
#import "HDPersonChangePhoneNumViewController.h"
#import "HDPersonSetTrueNameViewController.h"
#import "AppDelegate.h"
#import "LYCImagePicker.h"


@interface HDPersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate> {
    UIView * headBgView;//头部背景视图
    UIImageView * headPicIMV;//头像imv
    CGFloat headPicWidth;//头像宽度
    UITableView * _tb;
    NSArray * tabTitleArr;//表格标题
    NSMutableArray * detailInfoArr;//个人信息简介
    NSArray * changeDetailVCArr;//修改详细信息VC；
    UITableView * tb;
}

@property (nonatomic, weak) LYCImagePicker *imagePicker;

@end

@implementation HDPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    
    [self setNormalBackNav];
    
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSDictionary *dic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    if(dic[PCUserName]){
        detailInfoArr = [[NSMutableArray alloc] initWithArray:@[dic[PCUserName],@"",dic[PCUserPhone],@"未认证"]];
        if([dic[PCUserState] isEqualToString:@"success"]){
            if([[LYCUserManager informationDefaultUser].defaultUser objectForKey:@"avatar"]){
                headPicIMV.image = [UIImage imageWithData:[[LYCUserManager informationDefaultUser].defaultUser objectForKey:@"avatar"]];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    headPicIMV.image = [UIImage imageNamed:@"weidenglu"];
                });
            }
        }else{
            headPicIMV.image = [UIImage imageNamed:@"weidenglu"];
        }
    }else{
        detailInfoArr = [[NSMutableArray alloc]  initWithArray:@[@"未登录",@"",@"",@"未认证"]];
        headPicIMV.image = [UIImage imageNamed:@"weidenglu"];
    }
    [tb reloadData];
}

- (void) setUp {
    
    headPicWidth = SCREEN_WIDTH/375*93;//头像高度
    tabTitleArr = @[@"昵称",@"密码",@"手机号"];
    NSDictionary *dic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    if(dic[PCUserName]&&dic[PCUserPhone]){
        detailInfoArr = [[NSMutableArray alloc] initWithArray:@[dic[PCUserName],@"",dic[PCUserPhone],@"未认证"]];
    }else{
        detailInfoArr = [[NSMutableArray alloc] initWithArray:@[@"未登录",@"",@"",@"未认证"]];
    }
    changeDetailVCArr = @[[HDPersonChangeNameViewController new],[HDPersonChangePasswordViewController new],[HDPersonChangePhoneNumViewController new],[HDPersonSetTrueNameViewController new]];
    
}

- (void) createUI {
    //头像
    headBgView = [self createHeadBgView];
    [self.view addSubview:headBgView];
    //表格
    [self createPlainTB];
    
}
- (UIView *) createHeadBgView {
    //背景
    UIView * tempHeadBgView = [[UIView alloc] initWithFrame:CGRM(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*221)];
    tempHeadBgView.backgroundColor = MAIN_COLOR;
    UIView * goBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 100, 40)];
    UITapGestureRecognizer *tapToGoBack = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToGoBack)];
    [goBackView addGestureRecognizer:tapToGoBack];
    goBackView.userInteractionEnabled= YES;
    UIImageView * goBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 12, 19)];
    goBackImage.image = [UIImage imageNamed:@"back_icon"];
    [goBackView addSubview:goBackImage];
    [tempHeadBgView addSubview:goBackView];

    
    UIImageView* imageViewBack = [[UIImageView alloc]initWithFrame:CGRectMake(CGMID_X(tempHeadBgView.frame)-48, SCREEN_WIDTH/375*84-8, 96, 96)];
    imageViewBack.image = [UIImage imageNamed:@"touxiang_bg"];
    [tempHeadBgView addSubview:imageViewBack];
    
    //头像
    headPicIMV =  [[UIImageView alloc] initWithFrame:CGRM(CGMID_X(tempHeadBgView.frame)-40, SCREEN_WIDTH/375*84, 80, 80)];
    NSDictionary *dic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    if([dic[PCUserState] isEqualToString:@"success"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            headPicIMV.image = [UIImage imageWithData:[[LYCUserManager informationDefaultUser].defaultUser objectForKey:@"avatar"]];
        });
    }else{
        headPicIMV.image = imageNamed(@"weidenglu");
    }
    headPicIMV.layer.cornerRadius = 40;
    headPicIMV.layer.masksToBounds = YES;
    headPicIMV.userInteractionEnabled = YES;
    [tempHeadBgView addSubview:headPicIMV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSetHeadImage)];
    [headPicIMV addGestureRecognizer:tap];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headPicIMV.frame)-25, CGRectGetMaxY(headPicIMV.frame)-25, 30, 30)];
    iconImage.image = [UIImage imageNamed:@"personal_photo"];
    [tempHeadBgView addSubview:iconImage];
    
    return tempHeadBgView;
}

- (void)tapToSetHeadImage{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSDictionary *userdic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    headPicIMV.image = info[@"UIImagePickerControllerEditedImage"];
    NSString *postImageStr = [NSString stringWithFormat:@"http://gk.cdtzb.com/api/member/change_user_head"];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:userdic[PCUserToken] forKey:@"token"];
    NSData *data = UIImageJPEGRepresentation(headPicIMV.image, 0.1);
    AFHTTPSessionManager*manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", @"application/javascript", @"text/js", @"application/x-javascript", nil];
    [[LYCUserManager informationDefaultUser].defaultUser setObject:data forKey:@"avatar"];
    [manager POST:postImageStr parameters:mutDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"filedata" fileName:@"filedata.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([responseObject[@"code"] isEqual:@(1)]){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = responseObject[@"msg"];
            [hud hideAnimated:YES afterDelay: 1];
            [[LYCUserManager informationDefaultUser].defaultUser setObject:data forKey:@"avatar"];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = responseObject[@"msg"];
            [hud hideAnimated:YES afterDelay: 1];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            LYCImagePicker *picker = [[LYCImagePicker alloc]init];
            _imagePicker = picker;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
            picker.delegate = self;
        }
            break;
        case 1:
        {
            LYCImagePicker *picker = [[LYCImagePicker alloc]init];
            _imagePicker = picker;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
            picker.delegate = self;
        }
            break;
    }
}

- (void)tapToGoBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 创建表格
- (void ) createPlainTB {
    
    tb = [[UITableView alloc] initWithFrame:CGRectMake(0, CGMAX_Y(headBgView.frame), SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT - CGMAX_Y(headBgView.frame)) style:(UITableViewStylePlain)];
    tb.showsVerticalScrollIndicator = NO;
    tb.tableFooterView = [[UIView alloc] init];
    tb.delegate = self;
    tb.dataSource = self;
    tb.bounces = NO;
    _tb = tb;
    [self.view addSubview:_tb];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tabTitleArr.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 41;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuseID = @"reuseCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:reuseID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row!=2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = tabTitleArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = detailInfoArr[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    changeDetailVCArr = @[[HDPersonChangeNameViewController new],[HDPersonChangePasswordViewController new],[HDPersonChangePhoneNumViewController new],[HDPersonSetTrueNameViewController new]];

    switch (indexPath.row) {
        case 0:
        {//昵称
            HDPersonChangeNameViewController * nameVC = [HDPersonChangeNameViewController new];
            nameVC.changNickNameBlock = ^(NSString * changedNickName){
                cell.detailTextLabel.text = changedNickName;
            };
//            [self presentViewController:nameVC animated:YES completion:nil];
//            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [delegate.window.rootViewController presentViewController:nameVC animated:YES completion:nil];
            [self.navigationController pushViewController:nameVC animated:YES];
            
        }
            break;
        case 1:
        {//密码
            HDPersonChangePasswordViewController * passwordVC = [[HDPersonChangePasswordViewController alloc]init];
            WEAK_SELF;
            passwordVC.block = ^{
                weakSelf.block();
            };
            [self.navigationController pushViewController:passwordVC animated:YES];
        }
            break;
        case 2:
        {//电话
//            HDPersonChangePhoneNumViewController * phoneVC = [HDPersonChangePhoneNumViewController new];
//            [self.navigationController pushViewController:phoneVC animated:YES];
        }
            break;
        case 3:
        {//实名认证
            HDPersonSetTrueNameViewController * trueNameVC = [HDPersonSetTrueNameViewController new];
            [self.navigationController pushViewController:trueNameVC animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//
//{
//    
//    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,30)];
//    
//    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
//    
//    cancelBtn.backgroundColor = [UIColor redColor];
//    
//    [cancelBtn addTarget:self action:@selector(click) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
//    
//    [viewController.navigationItem setRightBarButtonItem:btn animated:NO];
//    
//}
//
//- (void)click{
//    
//    //做你需要做的事情
//    
//    [self imagePickerControllerDidCancel:self.imagePicker];
//    
//}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated

{
    
    for (UINavigationItem *item in navigationController.navigationBar.subviews) {
        
        if ([item isKindOfClass:[UIButton class]]&&([item.title isEqualToString:@"取消"]||[item.title isEqualToString:@"Cancel"]))
        {
            UIButton *button = (UIButton *)item;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

@end
