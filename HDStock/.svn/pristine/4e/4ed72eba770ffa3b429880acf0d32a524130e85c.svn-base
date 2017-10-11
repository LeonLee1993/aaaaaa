//
//  HDBaseModel.m
//  HDStock
//
//  Created by hd-app01 on 16/11/11.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDBaseModel.h"

@implementation HDBaseModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
        
    }
        
    return self;
}


- (void)setValue:(id)value forKey:(NSString *)key
{
    // 服务器是 NSNumber ，模型表里是 NSString类型，所以，要处理
    if ([value isKindOfClass:[NSNumber class]]) {
        
        // NSNumber--> NSString
        [self setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
        
    }else{
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
