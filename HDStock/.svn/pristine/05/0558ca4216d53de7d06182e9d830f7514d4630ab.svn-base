//
//  HDHeadLineModel.m
//  HDGolden
//
//  Created by hd-app02 on 16/10/19.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDHeadLineModel.h"
#import <WebKit/WebKit.h>

@interface HDHeadLineModel()<UIWebViewDelegate>

@property (nonatomic , strong) UIWebView * webview;

@end

@implementation HDHeadLineModel

- (NSString *)HourAndMinTime{

    if (!_HourAndMinTime) {
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSDate * date =[dateFormat dateFromString:self.pubtime];
        
        [dateFormat setDateFormat:@"HH:mm"];
        
        _HourAndMinTime = [dateFormat stringFromDate:date];
    }

    return _HourAndMinTime;

}

- (NSString *)MonthAndDayTime{

    if (!_MonthAndDayTime) {
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSDate * date =[dateFormat dateFromString:self.pubtime];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        _MonthAndDayTime = [dateFormat stringFromDate:date];
        
    }

    return _MonthAndDayTime;
}

- (CGFloat)cellHeight{
    
    if (!_cellHeight) {
        
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width - 16;
        
        CGFloat contentW = [self.title sizeWithAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:16]}].width;
        
        if(self.pic.length > 1){
        
            if (!self.countmanypic) {
                
                return 106;
            }else{
            
                if (self.countmanypic == 3) {
                    
                    if (contentW > screenW) {
                        
                        _cellHeight = 156;
                        
                    }else{
                        
                        _cellHeight = 136;
                        
                    }
                }else{
                
                    return 106;
                
                }
            
            }
        
        
        }else{
        
            if (!self.countmanypic || self.countmanypic == 0) {
                
                if (contentW > screenW) {
                    
                    _cellHeight = 88;
                    
                }else{
                    
                    _cellHeight = 68;
                    
                }
            }else{
            
                if (self.countmanypic == 3) {
                    
                    if (contentW > screenW) {
                        
                        _cellHeight = 156;
                        
                    }else{
                        
                        _cellHeight = 136;
                        
                    }
                }else{
                    
                    return 106;
                    
                }
            
            
            }
        
        
        }
    }
//        if( self.pic.length && self.pic.length > 1){
//            
//            if (!self.countmanypic) {
//                
//                return 106;
//                
//            }
//            if (self.countmanypic) {
//                
//                if (self.countmanypic == 1) {
//                    
//                    return 106;
//                    
//                }else if (self.countmanypic == 3){
//                    
//                    if (contentW > screenW) {
//                        
//                        _cellHeight = 156;
//                        
//                    }else{
//                        
//                        _cellHeight = 136;
//                        
//                    }
//                    
//                }
////                else if (self.countmanypic == 2){
////                    
////                    if (contentW > screenW) {
////                        
////                        _cellHeight = 301;
////                        
////                    }else{
////                        
////                        _cellHeight = 271;
////                        
////                    }
////                    
////                }
//            }
//        }
//        if (!self.pic.length || self.pic.length == 0) {
//            
//            if (!self.countmanypic || self.countmanypic == 0) {
//                
//                if (contentW > screenW) {
//                    
//                    _cellHeight = 88;
//                    
//                }else{
//                    
//                    _cellHeight = 68;
//                    
//                }
//            }
//            
//            if (self.countmanypic) {
//                if (self.countmanypic == 1) {
//                    
//                    return  106;
//                    
//                }else if (self.countmanypic == 3){
//                    
//                    if (contentW > screenW) {
//                        
//                        _cellHeight = 156;
//                        
//                    }else{
//                        
//                        _cellHeight = 136;
//                        
//                    }
//                    
//                }
//            }
//        }
//    }
    
    return _cellHeight * HEIGHT;
}


-(NSString *)tagText{

    if (!_tagText) {
        
        _tagText = self.tags_name[@"6"];
        
    }

    return _tagText;

}

@end
