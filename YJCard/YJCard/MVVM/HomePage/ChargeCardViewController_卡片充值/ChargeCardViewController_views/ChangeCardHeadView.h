//
//  ChangeCardHeadView.h
//  YJCard
//
//  Created by paradise_ on 2017/7/3.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^dissMissChangeCardViewBlock)();
@interface ChangeCardHeadView : UIView

@property (nonatomic,copy)dissMissChangeCardViewBlock dissMissChangeCardViewBlock;

@end
