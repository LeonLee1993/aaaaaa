//
//  LYCHelper.m
//  YJCard
//
//  Created by paradise_ on 2017/7/27.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCHelper.h"
#import "ShareView.h"

@implementation LYCHelper


+ (instancetype)helper{
    
    static LYCHelper *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc]init];
        
    });
    
    return instance;
}

+ (void)presentAlerControllerWithMessage:(NSString *)message andVC:(id)viewController{
    LYCAlertController * alert = [LYCAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * certainAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:certainAction];
    [cancelAction setValue:MainColor forKey:@"titleTextColor"];
    [certainAction setValue:MainColor forKey:@"titleTextColor"];
    [viewController presentViewController:alert animated:YES completion:^{
        
    }];
}

+ (CGSize)getsizeOfString:(NSString *)string andAttribute:(NSDictionary *)attridic andLineSpace:(NSInteger )lineSpace andBorderSpace:(NSInteger )borderspace fontSize:(CGFloat )fontSize{
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.headIndent = 0;
    style1.firstLineHeadIndent = 0;
    style1.lineSpacing = lineSpace;
    CGSize secondDesc;
    NSMutableDictionary * mutDic = [NSMutableDictionary dictionaryWithDictionary:attridic];
    mutDic[NSParagraphStyleAttributeName] = style1;
    mutDic[NSFontAttributeName] = [UIFont systemFontOfSize:fontSize];
//    @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1}
    secondDesc = [string boundingRectWithSize:CGSizeMake(ScreenWidth-borderspace, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:mutDic context:nil].size;
    return secondDesc;
}

+ (BOOL)validateIDCardNumber:(NSString *)value {
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 
    int length =0;
    
    if (!value) {
        
        return NO;
        
    }else {
        
        length = value.length;
        
        
        
        if (length !=15 && length !=18) {
            
            return NO;
            
        }
        
    }
    
    // 省份代码
    
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    
    
    NSString *valueStart2 = [value substringToIndex:2];
    
    BOOL areaFlag =NO;
    
    for (NSString *areaCode in areasArray) {
        
        if ([areaCode isEqualToString:valueStart2]) {
            
            areaFlag =YES;
            
            break;
            
        }
        
    }
    
    
    
    if (!areaFlag) {
        
        return false;
        
    }
    
    
    
    
    
    NSRegularExpression *regularExpression;
    
    NSUInteger numberofMatch;
    
    
    
    int year =0;
    
    switch (length) {
            
        case 15:
            
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                     
                                                                       options:NSRegularExpressionCaseInsensitive
                                     
                                                                         error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                     
                                                                       options:NSRegularExpressionCaseInsensitive
                                     
                                                                         error:nil];//测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                             
                                                              options:NSMatchingReportProgress
                             
                                                                range:NSMakeRange(0, value.length)];
            
            
            
//            [regularExpression release];
            
            
            
            if(numberofMatch >0) {
                
                return YES;
                
            }else {
                
                return NO;
                
            }
            
        case 18:
            
            
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                     
                                                                       options:NSRegularExpressionCaseInsensitive
                                     
                                                                         error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                     
                                                                       options:NSRegularExpressionCaseInsensitive
                                     
                                                                         error:nil];//测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                             
                                                              options:NSMatchingReportProgress
                             
                                                                range:NSMakeRange(0, value.length)];
            
            
            
//            [regularExpressionrelease];
            
            
            
            if(numberofMatch >0) {
                
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                
                NSString *M =@"F";
                
                NSString *JYM =@"10X98765432";
                
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    
                    return YES;// 检测ID的校验位
                    
                }else {
                    
                    return NO;
                    
                }
 
            }else {
                
                return NO;
                
            }
            
        default:
            
            return false;
            
    }
    
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType shareTitle:(NSString *)title shareDesc:(NSString *)desc shareUrlStr:(NSString *)urlStr
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  urlStr;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:_selfVC completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
}

+ (void)shareBoardBySelfDefined {
    
    
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    
    NSMutableArray *titlearr = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:5];
    
    int startIndex = 0;
    
    if (hadInstalledWeixin) {
        [titlearr addObjectsFromArray:@[@"微信", @"朋友圈"]];
        [imageArr addObjectsFromArray:@[@"微信icon",@"朋友圈icon"]];
    } else {
        startIndex += 2;
    }
    
    if (hadInstalledQQ) {
        [titlearr addObjectsFromArray:@[@"QQ", @"QQ空间"]];
        [imageArr addObjectsFromArray:@[@"QQ",@"QQ空间icon"]];
    } else {
        startIndex += 2;
    }
    [titlearr addObjectsFromArray:@[@"微博"]];
    [imageArr addObjectsFromArray:@[@"微博icon"]];
    
    ShareView *shareView = [[ShareView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@""];
    LYCHelper *helper = [LYCHelper helper];
    
    [shareView setBtnClick:^(NSInteger btnTag) {
        NSLog(@"\n点击第几个====%d\n当前选中的按钮title====%@",(int)btnTag,titlearr[btnTag]);
        switch (btnTag + startIndex) {
            case 0: {
                // 微信
                [helper shareWebPageToPlatformType:UMSocialPlatformType_WechatSession shareTitle:@"家亲付" shareDesc:@"家亲付为您提供便利生活" shareUrlStr:@"http://wx3.sinaimg.cn/large/006Wsb3Sgy1fjbyu9p8kcj303c03cmxc.jpg"];
            }
                break;
            case 1: {
                // 微信朋友圈
                [helper shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine shareTitle:@"家亲付" shareDesc:@"家亲付为您提供便利生活" shareUrlStr:@"http://wx3.sinaimg.cn/large/006Wsb3Sgy1fjbyu9p8kcj303c03cmxc.jpg"];
            }
                break;
            case 2: {
                // QQ
                [helper shareWebPageToPlatformType:UMSocialPlatformType_QQ shareTitle:@"家亲付" shareDesc:@"家亲付为您提供便利生活" shareUrlStr:@"http://wx3.sinaimg.cn/large/006Wsb3Sgy1fjbyu9p8kcj303c03cmxc.jpg"];
            }
                break;
            case 3: {
                // QQ空间
                [helper shareWebPageToPlatformType:UMSocialPlatformType_Qzone shareTitle:@"家亲付" shareDesc:@"家亲付为您提供便利生活" shareUrlStr:@"http://wx3.sinaimg.cn/large/006Wsb3Sgy1fjbyu9p8kcj303c03cmxc.jpg"];
            }
                break;
            case 4: {
                // 微博
                [helper shareWebPageToPlatformType:UMSocialPlatformType_Sina shareTitle:@"家亲付" shareDesc:@"家亲付为您提供便利生活" shareUrlStr:@"http://wx3.sinaimg.cn/large/006Wsb3Sgy1fjbyu9p8kcj303c03cmxc.jpg"];
                
            }
                break;
            default:
                break;
        }
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
}



@end
