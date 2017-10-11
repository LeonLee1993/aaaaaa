//
//  ZHTagView.h
//  方法测试
//
//  Created by hd-app01 on 16/11/8.
//  Copyright © 2016年 hd-app01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagListDelegate <NSObject>

- (void) tagListDelegateBtnClicked:(UIButton *)sender;

@end

@interface ZHTagView : UIView

@property (nonatomic,copy) NSArray * dataArr;
@property (nonatomic,assign) NSInteger tagListTag;
@property (nonatomic,assign) CGFloat btnWidth;
@property (nonatomic,assign) CGFloat btnHeight;
@property (nonatomic,assign) NSInteger btnNumOfEachRow;


@property (nonatomic,copy) void(^tagListBlcok)(NSInteger btnTag);//点击事件回调
/** 点击时间回调代理*/
@property (nonatomic,weak) id<TagListDelegate>thyDelegate;

- (void) showBtnUserEnabled;
- (void) hidenBtnUserEnabled;


@end
