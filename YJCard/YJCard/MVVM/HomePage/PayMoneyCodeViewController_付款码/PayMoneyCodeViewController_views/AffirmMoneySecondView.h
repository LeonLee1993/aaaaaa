//
//  AffirmMoneySecondView.h
//  YJCard
//
//  Created by paradise_ on 2017/7/25.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^backBlock)();
@interface AffirmMoneySecondView : UIView
@property (nonatomic,copy) backBlock backBlock;

@property (nonatomic,strong) NSArray * cardsArr;

@end
