//
//  HDOnlyFaNewsViewController.h
//  HDStock
//
//  Created by hd-app02 on 2016/11/25.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockBaseViewController.h"
#import "ZJScrollPageView.h"
@interface HDOnlyFaNewsViewController : HDStockBaseViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, assign) NSInteger segmentselected;

@end
