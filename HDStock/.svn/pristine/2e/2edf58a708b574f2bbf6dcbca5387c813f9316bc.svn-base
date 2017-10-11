//
//  HDPSYScrollButtonView.h
//  HDStock
//
//  Created by hd-app02 on 16/11/11.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSYScrollButtonViewsDelegate <NSObject>

@optional

- (void)psyScrollButtonOnTouched:(UIButton *)button;

@end

@interface HDPSYScrollButtonView : UIView

@property (nonatomic, strong) NSArray * imageArray;

@property (nonatomic, strong) NSArray * titleArray;

@property (nonatomic, strong) NSArray * subTitleArray;

@property (nonatomic, weak) id <PSYScrollButtonViewsDelegate> delegate;

@end
