//
//  HDFlashNewsModel.h
//  HDGolden
//
//  Created by hd-app02 on 16/10/31.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDFlashNewsModel : NSObject

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * source;
@property (nonatomic,copy) NSString * create_time;

@property (nonatomic,assign) CGFloat cellHeight;

@end
