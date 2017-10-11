//
//  NSArray+crossTheBorder.m
//  HDGolden
//
//  Created by hd-app02 on 16/11/3.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "NSArray+crossTheBorder.h"

@implementation NSArray (crossTheBorder)

- (id)objectAtIndexCheck:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end
