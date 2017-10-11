//
//  HDSegmentView.h
//  HDStock
//
//  Created by hd-app02 on 16/11/17.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollSegmentView.h"

typedef NS_ENUM(NSInteger, KindOfTableView) {
    
    KindOfTableViewRecommend = 0,
    KindOfTableViewImportant,
    KindOfTableViewTFHours,
    KindOfTableViewCalander,
    KindOfTableViewPersonal,
    KindOfTableViewPlate,
    KindOfTableViewTape,
    KindOfTableViewOutskirts,
    
};

@protocol HDSegmentViewDelegate <NSObject>

@optional

- (void)addButtonForScrollSegmentsOnClicked:(UIButton *)button toPushToController:(UIViewController *)viewController;

- (void)reloadSegmentView;

- (void)isKindOfTableViewCells:(KindOfTableView)kind;

@end

@interface HDSegmentView : UIView<ZJScrollPageViewDelegate>

@property (nonatomic, strong) ZJScrollSegmentView * segmentView;

@property (nonatomic, strong) NSMutableArray * titleArray;

@property (nonatomic, weak) id <HDSegmentViewDelegate> delegate;

@property (nonatomic, assign) NSInteger segmentSelected;

@end
