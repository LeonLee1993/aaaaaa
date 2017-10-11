//
//  NSNull+LYCNullMethod.m
//  YJCard
//
//  Created by paradise_ on 2017/8/30.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "NSNull+LYCNullMethod.h"

@implementation NSNull (LYCNullMethod)

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([self respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:self];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *sig = [[NSNull class] instanceMethodSignatureForSelector:selector];
    if(sig == nil) {
        sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }
    return sig;
}

@end

