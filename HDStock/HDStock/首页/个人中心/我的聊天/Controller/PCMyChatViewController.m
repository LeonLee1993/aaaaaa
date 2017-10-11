//
//  PCMyChatViewController.m
//  HDStock
//
//  Created by liyancheng on 16/11/30.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCMyChatViewController.h"
#import "PCMyChatViewCell.h"
//#import <RongIMKit/RongIMKit.h>
#import "ConversationViewController.h"


@interface PCMyChatViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PCMyChatViewController{
    NSMutableArray * conversationListArr;
}
#if 0
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeader:@"产品"];
    [self initScrollView];
    [self setTableViewsWithCellKindsArray:@[@""]];
    [self setTableView];
    
    if(!conversationListArr){
        conversationListArr = @[].mutableCopy;
    }
    [conversationListArr addObjectsFromArray:[[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE)]]];
}

- (void)setTableView{
    [self.scrollView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"PCMyChatViewCell" bundle:nil] forCellReuseIdentifier:@"PCMyChatViewCell"];
    self.tableView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return conversationListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView1){
        PCMyChatViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PCMyChatViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSDictionary *dic = conversationListArr[indexPath.row]
//        NSLog(@"%@",dic[@"targetId"]);

        
        RCConversation *conver = conversationListArr[indexPath.row];
        cell.nameLabel.text = conver.targetId;
        RCMessageContent *tempStr = conver.lastestMessage;
        RCMentionedInfo *info = tempStr.mentionedInfo;
        cell.messageLabel.text = info.mentionedContent;
        return cell;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RCConversation *conver = conversationListArr[indexPath.row];
    RCMessageContent *tempStr = conver.lastestMessage;
    RCMentionedInfo *info = tempStr.mentionedInfo;
    
    if (tableView == self.tableView1) {
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.headIndent = 0;
        style.firstLineHeadIndent = 65;
        style.lineSpacing = 7;
        CGSize firstDesc = [info.mentionedContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSParagraphStyleAttributeName:style} context:nil].size;
        return 91+firstDesc.height-35;
    }else{
        return 0;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //新建一个聊天会话View Controller对象
    ConversationViewController *chat = [[ConversationViewController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    RCConversation *conver = conversationListArr[indexPath.row];
    
    //设置聊天会话界面要显示的标题
    chat.title = conver.conversationTitle;
    chat.targetId = conver.targetId;
    
#if 1
    RCMessageContent *tempStr = conver.lastestMessage;
    NSLog(@"%@",tempStr);
#endif
    
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}

#endif

@end
