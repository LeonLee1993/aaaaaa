//
//  LYCStateViews.h
//  YJCard
//
//  Created by paradise_ on 2017/8/1.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYCStateViews : UIView
typedef NS_ENUM(NSInteger, LYCStateViewState) {
    //加载中
    LYCStateViewLoad,
    //加载失败
    LYCStateViewFail,
    //加载时不可点
    LYCStateNoUerInterface
};

+ (instancetype)LYCshowStateViewTo:(UIView *)view withState:(LYCStateViewState) state andTest:(NSString *)text;

-(void)LYCHidStateView;

@property (nonatomic,strong)    NSString *textStr;
@property (nonatomic,assign) LYCStateViewState lycStateViewState;
@end
