//
//  HDLiveHistoryDetailModel.m
//  HDStock
//
//  Created by hd-app01 on 16/11/30.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveHistoryDetailModel.h"

@implementation HDLiveHistoryDetailModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
        
    }
    
    [self setingFrame];
    
    return self;
}

- (void) setingFrame {
    
    CGFloat leftMargin = 12;
    CGFloat righMmargin = 19;
    //内容标签最大size
    CGSize textMaxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - leftMargin-righMmargin-47-10, MAXFLOAT);
    //内容标签真实坐标（宽，高）
    CGRect textRect = [_content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    //时间
    CGFloat timeX = 10.0f;
    CGFloat timeY = 15.0f;
    CGFloat timeW = 30.0f;
    CGFloat timeH = 9.0f;
    _timeLablFrame = CGRM(timeX, timeY, timeW, timeH);
    
    //三角形
    CGFloat sangleIMVW = 5.0f;;
    CGFloat sangleIMVH = 8.0f;
    CGFloat sangleIMVX = CGMAX_X(_timeLablFrame)+6;
    CGFloat sangleIMVY = CGMID_Y(_timeLablFrame)-sangleIMVH/2;
    _sangleIMVFrame = CGRM(sangleIMVX, sangleIMVY, sangleIMVW, sangleIMVH);
    
    
    //内容标签
    CGFloat titleX = 11.0f;
    CGFloat titleY = 15.0f;
    CGFloat titleW = textMaxSize.width;
    CGFloat titleH = textRect.size.height>50?(50):(textRect.size.height);
    _titleLablFrame = CGRM(titleX, titleY, titleW, titleH);
    
    //内容标签的背景
    CGFloat bgViewX = CGMAX_X(_sangleIMVFrame);
    CGFloat bgViewY = 0;
    CGFloat bgViewW = SCREEN_SIZE_WIDTH-CGMAX_X(_sangleIMVFrame)-10.0f;
    CGFloat bgViewH = CGMAX_Y(_titleLablFrame)+15;
    _bgViewFrame = CGRM(bgViewX, bgViewY, bgViewW, bgViewH);

    
    //行高
    _cellHeight = CGHEIGHT(_bgViewFrame);
//    _titleHeight = _cellHeight - 17-16;
    
}

- (void) setCellMaxHeight {
    
    CGFloat leftMargin = 12;
    CGFloat righMmargin = 19;
    
    //内容标签最大size
    CGSize textMaxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - leftMargin-righMmargin-47-10, MAXFLOAT);
    //内容标签真实坐标（宽，高）
    CGRect textRect = [_content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    //内容标签
    CGFloat titleX = 11.0f;
    CGFloat titleY = 15.0f;
    CGFloat titleW = textMaxSize.width;
    CGFloat titleH = textRect.size.height;
    _titleLablFrame = CGRM(titleX, titleY, titleW, titleH);
    
    //内容标签的背景
    CGFloat bgViewX = CGMAX_X(_sangleIMVFrame);
    CGFloat bgViewY = 0;
    CGFloat bgViewW = SCREEN_SIZE_WIDTH-CGMAX_X(_sangleIMVFrame)-10.0f;
    CGFloat bgViewH = CGMAX_Y(_titleLablFrame)+15;
    _bgViewFrame = CGRM(bgViewX, bgViewY, bgViewW, bgViewH);
    
    //行高
    _cellHeight = CGHEIGHT(_bgViewFrame);
}

@end
