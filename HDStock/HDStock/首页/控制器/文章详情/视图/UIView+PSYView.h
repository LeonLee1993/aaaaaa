//
//  UIView+PSYView.h
//  测试24
//


#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PSYTransitionFade, //交叉淡化过渡
    PSYTransitionMoveIn,  //新视图移到旧视图上面
    PSYTransitionPush,    //新视图把旧视图推出去
    PSYTransitionReveal,  //将旧视图移开,显示下面的
    PSYTransitionpageCurl, //向上翻一页
    PSYTransitionpageUnCurl,  //向下翻一页
    PSYTransitionrippleEffect, //滴水效果
    PSYTransitionsuckEffect, //收缩效果，如一块布被抽走
    PSYTransitioncube,  //立方体效果
    PSYTransitionoglFlip,   //上下翻转效果
    PSYTransitioncameraIrisHollowOpen, //打开相机
    PSYTransitioncameraIrisHollowClose, //关闭相机
}PSYTransitionType;

typedef enum : NSUInteger {
    PSYTransitionFromRight,
    PSYTransitionFromLeft,
    PSYTransitionFromTop,
    PSYTransitionFromBottom
}PSYTransitionDirection;


@interface UIView(PSYView)


-(void)addTransitonAnimationWithDuration:(double)duration type:(PSYTransitionType)transitionType directionType:(PSYTransitionDirection)direction;



@end
