//
//  HPTopView.m
//  YJCard
//
//  Created by paradise_ on 2017/6/29.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "HPTopView.h"


@interface HPTopView()


@end

@implementation HPTopView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSearch)];
    [self.HPTopSearchView addGestureRecognizer:tap];
}

- (void)tapToSearch{
    self.tapToSearchBlock();
}

@end
