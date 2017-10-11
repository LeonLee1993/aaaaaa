//
//  NSArray+crossTheBorder.h
//  HDGolden
//
//  Created by hd-app02 on 16/11/3.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (crossTheBorder)

/*!
 @method objectAtIndexCheck:
 @abstract 检查是否越界和NSNull如果是返回nil
 @result 返回对象
 */
- (id)objectAtIndexCheck:(NSUInteger)index;

@end
