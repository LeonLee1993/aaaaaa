//
//  HDLiveAskQuestionsViewController.h
//  HDStock
//
//  Created by hd-app01 on 16/11/23.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockBaseViewController.h"

@interface HDLiveAskQuestionsViewController : HDStockBaseViewController

/**向＊＊提问*/
@property (nonatomic,copy) NSString * playerName;

/** push时暂停播放器，返回时打开播放器*/
@property (nonatomic,copy) void(^pausePlayerWhenPushBlock)();

@end
