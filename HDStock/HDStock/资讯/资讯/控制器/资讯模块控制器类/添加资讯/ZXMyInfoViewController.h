//
//  ZXMyInfoViewController.h
//  HDGolden
//
//  Created by hd-app01 on 16/10/21.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDStockBaseViewController.h"


static NSString * const hobbyCell = @"hobbyCell";
static NSString * const tagGroupCell = @"tagGroupCell";

@interface ZXMyInfoViewController : HDStockBaseViewController

/** 返回传值：选中的资讯*/
@property (nonatomic,copy) void(^infoBlcok)(NSArray *);

@end
