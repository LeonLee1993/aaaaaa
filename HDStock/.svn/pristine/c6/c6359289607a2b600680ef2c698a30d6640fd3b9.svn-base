//
//  HDAdvertisementModel.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/4.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDAdvertisementModel.h"

@implementation HDAdvertisementModel

    
- (UIImage *)bannerImage{

    if (!_bannerImage) {
        
        SDWebImageManager * manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:self.url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (finished) {
                
                _bannerImage = image;
            }
            
        }];
        
    }

    return _bannerImage;

}

@end
