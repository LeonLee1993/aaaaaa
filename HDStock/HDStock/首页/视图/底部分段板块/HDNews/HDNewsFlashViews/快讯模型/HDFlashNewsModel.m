//
//  HDFlashNewsModel.m
//  HDGolden
//
//  Created by hd-app02 on 16/10/31.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDFlashNewsModel.h"

@implementation HDFlashNewsModel


- (CGFloat)cellHeight{

    if(!_cellHeight){
    
     CGFloat contentH = [self.content boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:16]} context:nil].size.height;

    _cellHeight = contentH + 60;
    }
    
    return _cellHeight;

}


@end
