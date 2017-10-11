//
//  HDGuidanceViewController.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/26.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDGuidanceViewController.h"

@interface HDGuidanceViewController ()<PSYScrollViewDelegate>

@end

@implementation HDGuidanceViewController{
    PSYScrollPageView *scrollPage; //用于存放并显示引导页
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrollPage = [[PSYScrollPageView alloc]initWithFrame:SCREEN_BOUNDS numberOfItem:4 itemSize:CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT) complete:^(NSArray *items) {
        
            for (int i = 0; i < items.count; i ++) {
        
                UIImageView * imageView = items[i];
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guiding_%d",i+1]];
            }
    }];
    
    scrollPage.delegate = self;
    
    UIImage * defaultImage = [[UIImage imageWithColor:[UIColor colorWithHexString:@"#209CEA" withAlpha:0.25098039215686274] size:CGSizeMake(11, 11)]imageByRoundCornerRadius:11/2.0f];
    
    UIImage * currentImage = [[UIImage imageWithColor:[UIColor colorWithHexString:@"#209CEA" withAlpha:1] size:CGSizeMake(11, 11)]imageByRoundCornerRadius:11/2.0f];
    
    scrollPage.defaultPageIndicatorImage = defaultImage;
    scrollPage.currentPageIndicatorImage = currentImage;
    
    scrollPage.pagingEnabled = YES;
    
    [self.view addSubview:scrollPage];
    
}

- (void)turnToMainScreen{
    NSLog(@"点击");
    [self.delegate turnToTabBarController];
}




@end
