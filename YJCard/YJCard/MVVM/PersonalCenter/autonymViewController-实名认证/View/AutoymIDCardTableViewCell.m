//
//  AutoymIDCardTableViewCell.m
//  YJCard
//
//  Created by paradise_ on 2017/7/21.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "AutoymIDCardTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@implementation AutoymIDCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage)];
    [self.IDCardImageView addGestureRecognizer:tap];
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += 20;
    frame.size.height -= 20;
    [super setFrame:frame];
}

- (void)selectImage{
    
    LYCAlertController *alerControl = [[LYCAlertController alloc]init];
    UIAlertAction * takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            /// 用户是否允许摄像头使用
            NSString * mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            /// 不允许弹出提示框
            if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
                
                LYCAlertController * alertC = [LYCAlertController alertControllerWithTitle:@"摄像头访问受限" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [_selfVC dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertC addAction:action];
                [_selfVC presentViewController:alertC animated:YES completion:nil];
                
            }else{
                LYCImagePicker *picker = [[LYCImagePicker alloc]init];
                _imagePicker = picker;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.allowsEditing = YES;
                [_selfVC presentViewController:picker animated:YES completion:nil];
                picker.delegate = self;
            }
            
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            /// 硬件问题提示
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手机没有摄像头或摄像头已损坏" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
#pragma clang diagnostic pop
        }
        
        
    }];
    
    UIAlertAction * takePhotoLBAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LYCImagePicker *picker = [[LYCImagePicker alloc]init];
        _imagePicker = picker;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [_selfVC presentViewController:picker animated:YES completion:nil];
        picker.delegate = self;
    }];
    
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alerControl addAction:takePhotoAction];
    [alerControl addAction:takePhotoLBAction];
    [alerControl addAction:cancel];
    
    [_selfVC presentViewController:alerControl animated:YES completion:nil];
    
}
#pragma mark - imagePicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.IDCardImageView.image = info[@"UIImagePickerControllerEditedImage"];
    
    self.setImageBlock();
    
    [_selfVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}

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

-(void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    if(self.isFront){
//        SDWebImageRetryFailed
//        [self.IDCardImageView sd_setImageWithURL:[NSURL URLWithString:infoDic[@"imageFront"]]];
        [self.IDCardImageView sd_setImageWithURL:[NSURL URLWithString:infoDic[@"imageFront"]]placeholderImage:nil options:SDWebImageRetryFailed];
    }else{
        
        [self.IDCardImageView sd_setImageWithURL:[NSURL URLWithString:infoDic[@"imageReverse"]]placeholderImage:nil options:SDWebImageRetryFailed];
//        [self.IDCardImageView sd_setImageWithURL:[NSURL URLWithString:infoDic[@"imageReverse"]]];
    }
}

@end
