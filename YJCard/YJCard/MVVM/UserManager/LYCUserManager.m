//
//  LYCUserManager.m
//  YJCard
//
//  Created by paradise_ on 2017/6/29.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCUserManager.h"

@implementation LYCUserManager

+ (instancetype)ShareUserManager{
    static dispatch_once_t onceToken;
    static LYCUserManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[self alloc]init];
    });
    return instance;
}

@end
