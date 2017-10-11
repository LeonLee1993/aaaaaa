//
//  HDPersonInfoViewController.h
//  HDStock
//
//  Created by hd-app01 on 16/11/16.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "LYCBaseViewController.h"

typedef void(^pwBlock)();

@interface HDPersonInfoViewController : LYCBaseViewController
@property (nonatomic,copy) pwBlock block;
@end
