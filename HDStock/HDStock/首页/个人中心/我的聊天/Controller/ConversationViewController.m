//
//  ConversationViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/1.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "ConversationViewController.h"


@interface ConversationViewController ()

@end

@implementation ConversationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.backgroundColor = RGBCOLOR(26, 126, 200);
//    NSLog(@"%ld",(long)self.unReadMessage);
//    self.enableUnreadMessageIcon = YES;
//    self.enableNewComingMessageIcon = YES;
////    self.enableTypingStatus = YES;
//}
//
//
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-(void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
//    if([cell isMemberOfClass:[RCTextMessageCell class]]){
//        RCTextMessageCell *cell = (RCTextMessageCell *)cell;
//    }
//}
//
//-(void)didSendMessage:(NSInteger)stauts content:(RCMessageContent *)messageCotent{
//    NSLog(@"%ld",stauts);
//}
//
//- (void)notifyUpdateUnreadMessageCount{
//    [super notifyUpdateUnreadMessageCount];
//    NSLog(@"update");
//}


@end
