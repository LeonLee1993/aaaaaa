//
//  AutoymTableViewCell.m
//  YJCard
//
//  Created by paradise_ on 2017/7/20.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "AutoymTableViewCell.h"
#import "CityField.h"

@interface AutoymTableViewCell()<UITextFieldDelegate>

@property (nonatomic, assign) NSInteger textLocation;//这里声明一个全局属性，用来记录

@end

@implementation AutoymTableViewCell{
   
    UITextField * flagTF;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.IdTF.delegate = self;
    self.nameTF.delegate = self;
    self.secondCityField.isCities = YES;
    [self.firstCityField becomeFirstResponder];
    [self.firstCityField resignFirstResponder];
    self.firstCityField.idStr = @"650000";
    self.secondCityField.idStr = @"650100";
    
    self.firstCityField.indexSelectdBlock = ^(NSInteger index) {
        self.secondCityField.selProvinceIndex = index;
        [self.secondCityField resetIndex];
        [self.secondCityField resetCity];
        NSLog(@"%@",self.firstCityField.idStr);
        NSLog(@"%@",self.secondCityField.idStr);
    };
    
    self.secondCityField.provinceSetBlock = ^{
        self.firstCityField.text = @"新疆";
        NSLog(@"%@",self.firstCityField.idStr);
        NSLog(@"%@",self.secondCityField.idStr);
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += 20;
    frame.size.height -= 20;
    [super setFrame:frame];
}


- (void)keyboardWillShown:(NSNotification*)aNotification
{

    if(self.firstCityField.isFirstResponder){
        [_dissmissView removeFromSuperview];
        [self showDismissWithNoti:aNotification];
        if(self.firstCityField.text.length==0){
            [self.firstCityField pickerView:nil didSelectRow:0 inComponent:0];
        }
    }else if (self.secondCityField.isFirstResponder){
        [_dissmissView removeFromSuperview];
        [self showDismissWithNoti:aNotification];
        if(self.secondCityField.text.length==0){
            [self.secondCityField pickerView:nil didSelectRow:0 inComponent:0];
        }
    }else{
        [_dissmissView removeFromSuperview];
    }
}




- (void)showDismissWithNoti:(NSNotification *)notification{
//    NSDictionary *info = [notification userInfo];
//    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
    
//    _dissmissView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 35)];
//    _dissmissView.backgroundColor = RGBColor(225, 225, 225);
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"叉叉"]];
//    imageView.frame = CGRectMake(5, 5, 25, 25);
//    [_dissmissView addSubview:imageView];
//    
//    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmissTheView)];
//    [_dissmissView addGestureRecognizer:tap];
//    //输入框位置动画加载
//       [UIView animateWithDuration:duration animations:^{
//        CGRect rect = _dissmissView.frame;
//        rect.origin.y -= keyboardSize.height;
//        _dissmissView.frame = rect;
//    [window addSubview:_dissmissView];
//    }];
}

- (void)dissmissTheView{
    _dissmissView.hidden = YES;
    [_dissmissView removeFromSuperview];
    [self.firstCityField resignFirstResponder];
    [self.secondCityField resignFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField == self.IdTF){
        //敲删除键
        if ([string length]==1) {
            if ([textField.text length]>17)
                return NO;
            if([self validateNumber:string]){
                if([string isEqualToString:@"w"]){
                    NSMutableString *fieldText=[NSMutableString stringWithString:textField.text];
                    NSString *finalText=[fieldText copy];
                    NSString *tempText = [finalText substringToIndex:finalText.length];
                    NSString *string = [NSString stringWithFormat:@"%@x",tempText];
                    textField.text= string;
                    return NO;
                }
                return YES;
            }else{
                return NO;
            }
        }
        
        NSUInteger lengthStr = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthStr; loopIndex++)
        {
            unichar character = [string characterAtIndex:loopIndex];
            if (loopIndex == 0 && character == 48 && textField.text.length == 0)
            {
                return NO;
            }
            if(character ==88||character ==120){
                return YES;
            }
            if (character < 48 || character > 57)
            {
                return NO;
            }
        }

        //获得当前输入框内的字符串
        NSMutableString *fieldText=[NSMutableString stringWithString:textField.text];
        //完成输入动作，包括输入字符，粘贴替换字符
        [fieldText replaceCharactersInRange:range withString:string];
        NSString *finalText=[fieldText copy];
        //如果字符个数大于18就要进行截取前边18个字符
        if ([finalText length]>18) {

            textField.text=[finalText substringToIndex:18];
            return NO;
        }
        return YES;
        
    }
    else if(textField == self.nameTF){
        if ([self stringContainsEmoji:string]) {
            self.textLocation = range.location;
            return NO;
        }else {
            self.textLocation = -1;
        }
        return YES;
    }
    else{
        return YES;
    }
    
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789Xxw"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}

- (BOOL)stringContainsEmoji:(NSString *)string
{
    NSUInteger len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (len < 3) { // 大于2个字符需要验证Emoji(有些Emoji仅三个字符)
        return NO;
    }
    
    // 仅考虑字节长度为3的字符,大于此范围的全部做Emoji处理
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    Byte *bts = (Byte *)[data bytes];
    Byte bt;
    short v;
    for (NSUInteger i = 0; i < len; i++) {
        bt = bts[i];
        
        if ((bt | 0x7F) == 0x7F) { // 0xxxxxxx ASIIC编码
            continue;
        }
        if ((bt | 0x1F) == 0xDF) { // 110xxxxx 两个字节的字符
            i += 1;
            continue;
        }
        if ((bt | 0x0F) == 0xEF) { // 1110xxxx 三个字节的字符(重点过滤项目)
            // 计算Unicode下标
            v = bt & 0x0F;
            v = v << 6;
            v |= bts[i + 1] & 0x3F;
            v = v << 6;
            v |= bts[i + 2] & 0x3F;
            
            // NSLog(@"%02X%02X", (Byte)(v >> 8), (Byte)(v & 0xFF));
            
            if ([self emojiInSoftBankUnicode:v] || [self emojiInUnicode:v]) {
                return YES;
            }
            
            i += 2;
            continue;
        }
        if ((bt | 0x3F) == 0xBF) { // 10xxxxxx 10开头,为数据字节,直接过滤
            continue;
        }
        
        return YES; // 不是以上情况的字符全部超过三个字节,做Emoji处理
    }
    return NO;
}

- (BOOL)emojiInSoftBankUnicode:(short)code
{
    return ((code >> 8) >= 0xE0 && (code >> 8) <= 0xE5 && (Byte)(code & 0xFF) < 0x60);
}

- (BOOL)emojiInUnicode:(short)code
{
    if (code == 0x0023
        || code == 0x002A
        || (code >= 0x0030 && code <= 0x0039)
        || code == 0x00A9
        || code == 0x00AE
        || code == 0x203C
        || code == 0x2049
        || code == 0x2122
        || code == 0x2139
        || (code >= 0x2194 && code <= 0x2199)
        || code == 0x21A9 || code == 0x21AA
        || code == 0x231A || code == 0x231B
        || code == 0x2328
        || code == 0x23CF
        || (code >= 0x23E9 && code <= 0x23F3)
        || (code >= 0x23F8 && code <= 0x23FA)
        || code == 0x24C2
        || code == 0x25AA || code == 0x25AB
        || code == 0x25B6
        || code == 0x25C0
        || (code >= 0x25FB && code <= 0x25FE)
        || (code >= 0x2600 && code <= 0x2604)
        || code == 0x260E
        || code == 0x2611
        || code == 0x2614 || code == 0x2615
        || code == 0x2618
        || code == 0x261D
        || code == 0x2620
        || code == 0x2622 || code == 0x2623
        || code == 0x2626
        || code == 0x262A
        || code == 0x262E || code == 0x262F
        || (code >= 0x2638 && code <= 0x263A)
        || (code >= 0x2648 && code <= 0x2653)
        || code == 0x2660
        || code == 0x2663
        || code == 0x2665 || code == 0x2666
        || code == 0x2668
        || code == 0x267B
        || code == 0x267F
        || (code >= 0x2692 && code <= 0x2694)
        || code == 0x2696 || code == 0x2697
        || code == 0x2699
        || code == 0x269B || code == 0x269C
        || code == 0x26A0 || code == 0x26A1
        || code == 0x26AA || code == 0x26AB
        || code == 0x26B0 || code == 0x26B1
        || code == 0x26BD || code == 0x26BE
        || code == 0x26C4 || code == 0x26C5
        || code == 0x26C8
        || code == 0x26CE
        || code == 0x26CF
        || code == 0x26D1
        || code == 0x26D3 || code == 0x26D4
        || code == 0x26E9 || code == 0x26EA
        || (code >= 0x26F0 && code <= 0x26F5)
        || (code >= 0x26F7 && code <= 0x26FA)
        || code == 0x26FD
        || code == 0x2702
        || code == 0x2705
        || (code >= 0x2708 && code <= 0x270D)
        || code == 0x270F
        || code == 0x2712
        || code == 0x2714
        || code == 0x2716
        || code == 0x271D
        || code == 0x2721
        || code == 0x2728
        || code == 0x2733 || code == 0x2734
        || code == 0x2744
        || code == 0x2747
        || code == 0x274C
        || code == 0x274E
        || (code >= 0x2753 && code <= 0x2755)
        || code == 0x2757
        || code == 0x2763 || code == 0x2764
        || (code >= 0x2795 && code <= 0x2797)
        || code == 0x27A1
        || code == 0x27B0
        || code == 0x27BF
        || code == 0x2934 || code == 0x2935
        || (code >= 0x2B05 && code <= 0x2B07)
        || code == 0x2B1B || code == 0x2B1C
        || code == 0x2B50
        || code == 0x2B55
        || code == 0x3030
        || code == 0x303D
        || code == 0x3297
        || code == 0x3299
        // 第二段
        || code == 0x23F0) {
        return YES;
    }
    return NO;
}

@end
