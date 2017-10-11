//
//  PSYScrollButtons.h
//  自定义宫格排版按钮
//
//  Created by hd-app02 on 16/11/10.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSYScrollButtonsDelegate <NSObject>

@optional

- (void)psySimpleButtonOnTouched:(UIButton *)button;

@end

@interface PSYScrollButtons : UIView

@property (nonatomic, weak) id <PSYScrollButtonsDelegate> delegate;

@end
