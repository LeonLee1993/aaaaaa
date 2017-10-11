//
//  YYTimeLineVolumeView.h
//  YYStock  ( https://github.com/yate1996 )
//
//  Created by yate1996 on 16/10/10.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYStockTimeLineProtocol.h"
#import "YYVolumePositionModel.h"
#import "YYStockConstant.h"
@interface YYTimeLineVolumeView : UIView
@property (nonatomic,strong) NSArray * fiveDayKeyArr;
@property (nonatomic, assign) YYStockType stockType;
@property (nonatomic, assign) BOOL isFiveKLine;
- (void)drawViewWithXPosition:(CGFloat)xPosition drawModels:(NSArray <id<YYStockTimeLineProtocol>>*)drawLineModels;

@end
