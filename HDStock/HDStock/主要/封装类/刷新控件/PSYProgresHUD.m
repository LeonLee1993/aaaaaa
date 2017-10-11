//
//  PSYProgresHUD.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/20.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PSYProgresHUD.h"

@implementation PSYProgresHUD

- (instancetype)init{

    if (self = [super init]) {
        
        UIImage  *image=[UIImage sd_animatedGIFNamed:@"effection"];
        UIImageView  *gifview=[[UIImageView alloc]initWithImage:image];
        gifview.image = image;
        self.mode = MBProgressHUDModeCustomView;
        
        self.bezelView.backgroundColor = [UIColor clearColor];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.margin = 0.0f;
        self.customView = gifview;

    }

    return self;
}

@end
