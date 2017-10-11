//
//  PCRegisterButton.m
//  HDStock
//
//  Created by liyancheng on 16/12/5.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCRegisterButton.h"

@implementation PCRegisterButton

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width/2-12.5, contentRect.size.height/2-12.5, 25, 25);
}

@end
