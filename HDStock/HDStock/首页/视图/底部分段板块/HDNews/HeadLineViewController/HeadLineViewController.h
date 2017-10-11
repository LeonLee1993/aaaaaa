//
//  HeadLineViewController.h
//  HDGolden
//
//  Created by hd-app02 on 16/10/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCSignInViewController.h"

@interface HeadLineViewController : HDStockBaseViewController

@property (nonatomic,assign) NSInteger aid;

@property (nonatomic,assign) NSInteger uid;

@property (nonatomic, copy) NSString * tittle;

@property (nonatomic, copy) NSString * imageUrlStr;

@property (nonatomic, copy) NSString * controllerTitle;

@end
