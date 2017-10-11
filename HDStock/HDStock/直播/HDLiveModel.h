//
//  HDLiveModel.h
//  HDStock
//
//  Created by hd-app01 on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDLiveModel : NSObject

@property (nonatomic,assign) BOOL needCloseVoiceBool;//需要关闭声音

@property (nonatomic,assign) BOOL rotateBtnIsClickedBool;//旋转按钮是否点击
@property (nonatomic,assign) BOOL isBeforeDeviceOrientationFaceUp;

@end
