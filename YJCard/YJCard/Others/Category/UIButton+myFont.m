//
//  UIButton+myFont.m
//  YJCard
//
//  Created by paradise_ on 2017/7/27.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "UIButton+myFont.h"
//不同设备的屏幕比例(当然倍数可以自己控制)
#import <objc/runtime.h>
#import <objc/message.h>
#define SizeScale ((ScreenHeight > 568) ? ScreenHeight/568 : 1)
NSString * const xw_btnClickedCountKey = nil;
NSString * const xw_btnCurrentActionBlockKey = nil;
@implementation UIButton (myFont)

+ (void)load{
//    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
//    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
//    method_exchangeImplementations(imp, myImp);
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        SEL origilaSEL = @selector(addTarget: action: forControlEvents:);
//        
//        SEL hook_SEL = @selector(xw_addTarget: action: forControlEvents:);
//        
//        //交换方法
//        Method origilalMethod = class_getInstanceMethod(self, origilaSEL);
//        
//        
//        Method hook_method = class_getInstanceMethod(self, hook_SEL);
//        
//        
//        class_addMethod(self,
//                        origilaSEL,
//                        class_getMethodImplementation(self, origilaSEL),
//                        method_getTypeEncoding(origilalMethod));
//        
//        class_addMethod(self,
//                        hook_SEL,
//                        class_getMethodImplementation(self, hook_SEL),
//                        method_getTypeEncoding(hook_method));
//        
//        method_exchangeImplementations(class_getInstanceMethod(self, origilaSEL), class_getInstanceMethod(self, hook_SEL));
//        
//    });
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成333跳过
        if(self.titleLabel.tag != 333){
            CGFloat fontSize = self.titleLabel.font.pointSize;
            self.titleLabel.font = [UIFont systemFontOfSize:fontSize*SizeScale];
        }
    }
    return self;
}

- (void)xw_addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    
    
    __weak typeof(target) weakTarget = target;
    
    __weak typeof(self) weakSelf = self;
    
    //利用 关联对象 给UIButton 增加了一个 block
    if (action) {
        
        [self  setCurrentActionBlock:^{
            @try {
                ((void (*)(void *, SEL,  typeof(weakSelf) ))objc_msgSend)((__bridge void *)(weakTarget), action , weakSelf);
            } @catch (NSException *exception) {
            } @finally {
            }
            
        }];
    }
    
    
    //发送消息 其实是本身  要执行的action 先执行，写下来的 xw_clicked:方法
    [self xw_addTarget:self action:@selector(xw_clicked:) forControlEvents:controlEvents];
}

//拦截了按钮点击后要执行的代码
- (void)xw_clicked:(UIButton *)sender{
    //统计 在这个方法中执行想要操作的
    
    self.btnClickedCount++;
    
    NSLog(@"%@ 点击 %ld次 ",[sender titleForState:UIControlStateNormal], (long)self.btnClickedCount);
    
    //执行原来要执行的方法
    sender.currentActionBlock();
}



//增加一个 block 关联UIButton
- (void)setCurrentActionBlock:(void (^)())currentActionBlock{
    
    objc_setAssociatedObject(self, &xw_btnCurrentActionBlockKey, currentActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())currentActionBlock{
    return objc_getAssociatedObject(self, &xw_btnCurrentActionBlockKey);
}


#pragma mark -统计

//在分类中增加了 btnClickedCount的 (setter 和 getter）方法，使用关联对象增加了相关的成员空间
- (NSInteger)btnClickedCount{
    id tmp = objc_getAssociatedObject(self, &xw_btnClickedCountKey);
    NSNumber *number = tmp;
    return number.integerValue;
}


- (void)setBtnClickedCount:(NSInteger)btnClickedCount{
    objc_setAssociatedObject(self, &xw_btnClickedCountKey, @(btnClickedCount), OBJC_ASSOCIATION_ASSIGN);
}


@end

@implementation UILabel (myFont)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
    
    
    
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成333跳过
        if(self.tag != 333){
            CGFloat fontSize = self.font.pointSize;
            self.font = [UIFont systemFontOfSize:fontSize*SizeScale];
        }
    }
    return self;
}

@end

@implementation UIView (myFont)

+ (void)load{
//    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
//    Method myImp = class_getInstanceMethod([self class], @selector(myCoder:));
//    method_exchangeImplementations(imp, myImp);
}

- (id)myCoder:(NSCoder*)aDecode{
    [self myCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成333跳过
        if(self.tag != 333){
            
        }
    }
    return self;
}





@end
