//
//  ZHTagView.m
//  方法测试
//
//  Created by hd-app01 on 16/11/8.
//  Copyright © 2016年 hd-app01. All rights reserved.
//

#import "ZHTagView.h"
#import "Masonry.h"

@implementation ZHTagView

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
//    if (self.btnNumOfEachRow) {
        [self createUI];
//    }
}
- (void)setTagListTag:(NSInteger)tagListTag {
    _tagListTag = tagListTag;
}
- (void)setBtnWidth:(CGFloat)btnWidth {
    _btnWidth = btnWidth;
}
- (void)setBtnHeight:(CGFloat)btnHeight {
    _btnHeight = btnHeight;
}
- (void)setBtnNumOfEachRow:(NSInteger)btnNumOfEachRow {
    _btnNumOfEachRow = btnNumOfEachRow;
//    if (self.dataArr) {
//        [self createUI];
//    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
    }
    return self;
}


- (void) createUI {
    
    for (int i = 0; i < self.dataArr.count; i++) {
        UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:self.dataArr[i] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(tagBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        btn.tag = self.tagListTag + i;
        btn.backgroundColor = [UIColor blueColor];
//        btn.frame = CGRectMake(0, 0, 100, 100);
        [self addSubview:btn];
    }
    
    NSInteger rowNum = self.btnNumOfEachRow;
    CGFloat width = self.btnWidth;
    CGFloat height = self.btnHeight;
    CGFloat space = (self.frame.size.width-width*rowNum)/(rowNum+1);
    
    for (int i = 0; i < self.dataArr.count; i++) {
        UIButton * tempView = (UIButton *)[self viewWithTag:self.tagListTag+i];
        
        UIView * frontView = nil;
        UIView * firstView = nil;
        if (i > 0) {
            frontView = [self viewWithTag:self.tagListTag+i-1];
        }
        if (i == 0) {
            firstView = [self viewWithTag:self.tagListTag];
        }
        
        __weak ZHTagView * weakSelf = self;
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong ZHTagView * strongSelf = weakSelf;
            
            make.size.mas_equalTo(CGSizeMake(width, height));
            NSLog(@"%ld",strongSelf.btnNumOfEachRow);
            i ==0 ? make.left.equalTo(strongSelf.mas_left).with.offset(space):(i%strongSelf.btnNumOfEachRow==0?make.left.equalTo(strongSelf.mas_left).with.offset(space):make.left.equalTo(frontView.mas_right).with.offset(space));
            
            i ==0 ? make.top.equalTo(strongSelf).with.offset(110) : (i%strongSelf.btnNumOfEachRow==0?make.top.equalTo(frontView.mas_bottom).with.offset(space):make.top.equalTo(frontView.mas_top));
        }];
    }
}

- (void)drawRect:(CGRect)rect {
    
    NSInteger rowNum = self.btnNumOfEachRow;
    CGFloat width = self.btnWidth;
    CGFloat height = self.btnHeight;
    CGFloat space = (self.frame.size.width-width*rowNum)/(rowNum+1);
    
    for (int i = 0; i < self.dataArr.count; i++) {
        UIButton * tempView = (UIButton *)[self viewWithTag:self.tagListTag+i];
        
        UIView * frontView = nil;
        UIView * firstView = nil;
        if (i > 0) {
            frontView = [self viewWithTag:self.tagListTag+i-1];
        }
        if (i == 0) {
            firstView = [self viewWithTag:self.tagListTag];
        }
        
        __weak ZHTagView * weakSelf = self;
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong ZHTagView * strongSelf = weakSelf;
            
            make.size.mas_equalTo(CGSizeMake(width, height));
            
            i ==0 ? make.left.equalTo(strongSelf.mas_left).with.offset(space):(i%rowNum==0?make.left.equalTo(strongSelf.mas_left).with.offset(space):make.left.equalTo(frontView.mas_right).with.offset(space));
            
            i ==0 ? make.top.equalTo(strongSelf).with.offset(110) : (i%rowNum==0?make.top.equalTo(frontView.mas_bottom).with.offset(space):make.top.equalTo(frontView.mas_top));
        }];
    }
}

- (void)showBtnUserEnabled {
    for (int i = 0; i < self.dataArr.count; i++) {
        UIButton * tempView = (UIButton *)[self viewWithTag:self.tagListTag+i];
        tempView.userInteractionEnabled = YES;
    }
}

- (void)hidenBtnUserEnabled {
    for (int i = 0; i < self.dataArr.count; i++) {
        UIButton * tempView = (UIButton *)[self viewWithTag:self.tagListTag+i];
        tempView.userInteractionEnabled = NO;
    }
}

- (void) tagBtnClicked:(UIButton *) sender {
    
    if (self.thyDelegate && [self.thyDelegate respondsToSelector:@selector(tagListDelegateBtnClicked:)]) {
        [self.thyDelegate tagListDelegateBtnClicked:sender];
    }
    
    //    if (self.tagListBlcok) {
    //        self.tagListBlcok(sender.tag);
    //    }
}

@end
