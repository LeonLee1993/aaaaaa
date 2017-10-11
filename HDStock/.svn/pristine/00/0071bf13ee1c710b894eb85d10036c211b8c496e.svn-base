//
//  PSYHUDAnimation.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/18.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PSYHUDAnimation.h"

@implementation PSYHUDAnimation


- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        //创建图片数组
        NSMutableArray *tomImages = [NSMutableArray array];
        
        for (int i = 1; i < 6; i ++) {
            
            //图片的路径
            NSString *imageName = [NSString stringWithFormat:@"LOGO%d.png",i];
        
            //这种方法不会内存溢出
            //NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
            UIImage *image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            [tomImages addObject:image];
            
        }
        
        //添加动画执行的数组
        [self setAnimationImages:tomImages];
        
        //添加动画执行的时间
        [self setAnimationDuration:self.animationImages.count*0.3];
        
        //添加动画执行的次数
        [self setAnimationRepeatCount:0];
        
        //开始动画
        [self startAnimating];
        
    }

    return self;
}

- (void)dealloc{

    self.animationImages = nil;

}

//- (void)layoutSubviews{
//
//    [super layoutSubviews];
//    
//    self.frame = CGRectMake(0, 0, 37, 37);
//
//
//
//}
@end
