//
//  HDStockTabBarController.h
//  HDStock
//
//  Created by hd-app02 on 16/11/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockBaseTabBarController.h"
#import "ZHTabBar.h"
@interface HDStockTabBarController : HDStockBaseTabBarController<ZHTabBarDelegate,UITabBarControllerDelegate>
@property (strong, nonatomic) IBOutlet ZHTabBar *HDtabBar;

@end
