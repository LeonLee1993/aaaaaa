//
//  PCRegisterAcceptButton.m
//  HDStock
//
//  Created by liyancheng on 16/12/5.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCRegisterAcceptButton.h"

@implementation PCRegisterAcceptButton

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width-15, contentRect.size.height/2-6.5, 13, 13);
}

@end
