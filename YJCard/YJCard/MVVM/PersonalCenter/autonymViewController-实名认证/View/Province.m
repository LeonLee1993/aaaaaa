//
//  Province.m
//  06-注册界面
//
//  Created by xiaomage on 15/9/6.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "Province.h"

@implementation Province
+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    Province *obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
}
@end
