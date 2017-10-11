//
//  AutonymViewController.h
//  YJCard
//
//  Created by paradise_ on 2017/7/20.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCBaseViewController.h"


typedef NS_ENUM(NSInteger, LYCAutonmyViewState) {
    LYCAutonmyViewStateDefault,//未认证
    LYCAutonmyViewStateGoOn,//认证中
    LYCAutonmyViewStateFail//认证失败
};

@interface AutonymViewController : LYCBaseViewController

@property (nonatomic,assign) LYCAutonmyViewState LYCAutonmyViewState;

@end
