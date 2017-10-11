//
//  Province.h
//  06-注册界面
//
//  Created by xiaomage on 15/9/6.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject
/**< 当前省的所有城市 */
@property (nonatomic, strong) NSArray *cities;

/**< 当前省名称 */
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
