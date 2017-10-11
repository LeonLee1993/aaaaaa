//
//  nothingContainView.m
//  HDStock
//
//  Created by liyancheng on 16/12/26.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "nothingContainView.h"

#define nothingY SCREEN_HEIGHT/2 - 110
#define nothingHeight 200
#define nothingWidth 252*200/284
@implementation nothingContainView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = PCBackColor;
        UINavigationController *nav =(UINavigationController *)self.superview.parentController.parentViewController;
        UIImageView *nothingImage;
        if(!nav.navigationBar.hidden){
             nothingImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-nothingWidth/2, nothingY-64-frame.origin.y, nothingWidth, nothingHeight)];
        }else{
            nothingImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-nothingWidth/2, nothingY+64-frame.origin.y, nothingWidth, nothingHeight)];
        }
        nothingImage.image = [UIImage imageNamed:@"nullpage@3x"];
        [self addSubview:nothingImage];
        self.hidden = YES;
    }
    return self;
}

-(void)show{
    self.hidden = NO;
}

-(void)hide
{
    self.hidden = YES;
}


@end
