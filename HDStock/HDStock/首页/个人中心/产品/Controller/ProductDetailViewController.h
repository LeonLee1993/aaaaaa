//
//  ProductDetailViewController.h
//  HDStock
//
//  Created by liyancheng on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "LYCBaseViewController.h"

@interface ProductDetailViewController : LYCBaseViewController

@property (nonatomic,strong) NSString *urlStr;
@property (nonatomic,strong) NSString *priceStr;
@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,copy) NSString * shareImageStr;
@property (nonatomic,copy) NSString * shareTextStr;

@end
