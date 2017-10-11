//
//  NSObject+LYCCrashExtention.m
//  LCXCrashExtension
//
//  Created by 李颜成 on 2017/6/5.
//  Copyright © 2017年 licheng. All rights reserved.
//

#import "NSObject+LYCCrashExtention.h"
#import <objc/runtime.h>

@implementation NSObject (LYCCrashExtention)

+ (void)load{
    
}





- (void)exchangeInstanceMethod:(Class)anClass originMethodSel:(SEL)originSEL replaceMethodSel:(SEL)replaceSEL{
    Method originIndex3 = class_getInstanceMethod(anClass, originSEL);
    Method overrideIndex3 = class_getInstanceMethod(anClass, replaceSEL);
    if(!originSEL||!overrideIndex3){
        return;
    }
    method_exchangeImplementations(originIndex3, overrideIndex3);
}


@end
