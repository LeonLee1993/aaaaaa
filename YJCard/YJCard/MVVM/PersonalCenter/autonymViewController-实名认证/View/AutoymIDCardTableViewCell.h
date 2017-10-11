//
//  AutoymIDCardTableViewCell.h
//  YJCard
//
//  Created by paradise_ on 2017/7/21.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYCImagePicker.h"
typedef void (^setImageBlock)();
@interface AutoymIDCardTableViewCell : UITableViewCell<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    LYCImagePicker * _imagePicker;
}
@property (weak, nonatomic) IBOutlet UIImageView *IDCardImageView;

@property (nonatomic,strong) UIViewController * selfVC;

@property (nonatomic,assign) BOOL isFront;

@property (nonatomic,strong) NSDictionary *infoDic;

@property (nonatomic,copy) setImageBlock setImageBlock;


@end
