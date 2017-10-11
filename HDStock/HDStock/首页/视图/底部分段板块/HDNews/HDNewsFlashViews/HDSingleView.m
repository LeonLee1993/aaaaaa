//
//  HDSingleView.m
//  HDGolden
//
//  Created by hd-app02 on 16/10/18.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDSingleView.h"

@implementation HDSingleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    
    [self drawCircle];
    
}

//画圆
- (void)drawCircle{
    
    
    CGFloat Y = 10;
    CGFloat X = self.bounds.size.width/3.0f;
    
    CGFloat W = 10;
    CGFloat H = 10;
    
    CGFloat LSX = X + W/2.0f;
    CGFloat LSY = Y + H + 5.0f;
    
    CGFloat LEX = LSX;
    CGFloat LEY = self.bounds.size.height - 5.0f;
//1.获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //2.绘制图形
    CGContextAddEllipseInRect(context, CGRectMake(X, Y, W, H));
    
    CGContextSetRGBStrokeColor(context, 200/255.0f, 199/255.0f, 204/255.0f, 1.0);
    CGContextSetLineWidth(context, 1);
    
    //3.显示在View上
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, LSX, LSY);
//    // 设置终点
    CGContextAddLineToPoint(context, LEX, LEY);
//    
////    // 设置绘图状态
////    // 设置线条颜色 红色
    CGContextSetRGBStrokeColor(context, 200/255.0f, 199/255.0f, 204/255.0f, 1.0);
//    // 设置线条宽度
    CGContextSetLineWidth(context, 1);
////    // 设置线条的起点和终点的样式
////    CGContextSetLineCap(ctx, kCGLineCapRound);
////    // 设置线条的转角的样式
////    CGContextSetLineJoin(ctx, kCGLineJoinRound);
////    // 绘制一条空心的线
    CGContextStrokePath(context);
    
    
}
@end
