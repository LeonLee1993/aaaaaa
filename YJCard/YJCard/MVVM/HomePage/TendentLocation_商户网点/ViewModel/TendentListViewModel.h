//
//  TendentListViewModel.h
//  YJCard
//
//  Created by paradise_ on 2017/8/9.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TendentListViewModel : NSObject

/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

@end
