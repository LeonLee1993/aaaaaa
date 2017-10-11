//
//  UIView+PSYView.m
//  测试24
//

#import "UIView+PSYView.h"

@implementation UIView(PSYView)

-(void)addTransitonAnimationWithDuration:(double)duration type:(PSYTransitionType)transitionType directionType:(PSYTransitionDirection)direction{
    
    CATransition * transition = [CATransition animation];
    
    transition.duration = duration;
    
    NSArray * typeArray = @[kCATransitionFade,kCATransitionMoveIn,kCATransitionPush,kCATransitionReveal,@"pageCurl",@"pageUnCurl",@"rippleEffect",@"suckEffect",@"cube",@"oglFlip",@"cameraIrisHollowOpen",@"cameraIrisHollowClose"];
    transition.type = typeArray[transitionType];
    
    NSArray * directionArray = @[kCATransitionFromRight,kCATransitionFromLeft,kCATransitionFromTop,kCATransitionFromBottom];
    transition.subtype = directionArray[direction];
    
    [self.window.layer addAnimation:transition forKey:nil];

}

@end
