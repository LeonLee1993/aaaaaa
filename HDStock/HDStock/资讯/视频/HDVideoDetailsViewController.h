//
//  HDVideoDetailsViewController.h
//  HDStock
//
//  Created by hd-app02 on 2016/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockBaseViewController.h"
#import "PCSignInViewController.h"
#define PLAYERHEIGHT 210.0f
@interface HDVideoDetailsViewController : HDStockBaseViewController

@property (nonatomic, assign) NSInteger ItemAid;

@property (nonatomic, assign) NSInteger ItemUid;

@property (nonatomic, copy) NSString * videoUrl;

@property (nonatomic, copy) NSString * picUrl;

@property (nonatomic, copy) NSString * videoTitle;

@property (nonatomic, assign) NSInteger videoLook;

@property (nonatomic, copy)   NSString * tagsname;

@property (nonatomic, copy) NSString * summary;

@end
