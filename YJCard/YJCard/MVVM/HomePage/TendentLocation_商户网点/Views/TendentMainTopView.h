//
//  TendentMainTopView.h
//  YJCard
//
//  Created by paradise_ on 2017/8/7.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TendentTopViewClickBlock)(NSString *);

@interface TendentMainTopView : UIView


@property (nonatomic,strong) NSArray * TendentCategoryArr;

@property (nonatomic,copy) TendentTopViewClickBlock TendentTopViewClickBlock;

@end
