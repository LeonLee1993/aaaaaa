//
//  HDStockURLHeader.h
//  HDStock
//
//  Created by hd-app02 on 16/11/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#ifndef HDStockURLHeader_h
#define HDStockURLHeader_h

//域名
#define HDBaseURL @"http://test.cdtzb.com/"

/***********************************    首页    ***************************/
//热点资讯
#define Home_HotNews [HDBaseURL stringByAppendingString:@"api.php?mod=article&act=tags&tags=2&time=%u"]
//资讯列表
#define Home_HeadLineCateNews [HDBaseURL stringByAppendingString:@"api.php?mod=hd&type=list&page=%ld&perpage=%ld&catid=%ld&token=%@&time=%u"]
//资讯网页详情
#define HeadLineNewsDetails [HDBaseURL stringByAppendingString:@"portal.php?mod=view&aid=%ld&mobile=2&time=%u"]
//资讯网页详情分享页
#define HeadLineNewsShareDetails [HDBaseURL stringByAppendingString:@"portal.php?mod=views&aid=%ld&mobile=2&time=%u"]

//文章详情
#define NewsDetails [HDBaseURL stringByAppendingString:@"api.php?mod=hd&type=detail&aid=%ld&time=%u"]
//广告
#define Advertisement [HDBaseURL stringByAppendingString:@"api.php?mod=adv&operation=ad&type=custom&customid=%d&time=%u"]
//早晚评
#define MorningAndEvening [HDBaseURL stringByAppendingString:@"api.php?mod=article&act=layer&op=home&catid=21&time=%u"]
//每日一股
#define EveryDayOneStock @"http://gk.cdtzb.com/api/product/getDailystock"
//点赞列表
#define PrasiedList [HDBaseURL stringByAppendingString:@"api.php?mod=thumbs&type=clicks&op=list&page=1&token=%@&time=%u"]

/********************************************  行情  **********************/

/********************************************  资讯  ***********************/
//收藏
#define CollectionTheArticle [HDBaseURL stringByAppendingString:@"api.php?mod=spacecp&op=add&ac=favorite&type=article&id=%ld&handlekey=favoritearticlehk_%ld&token=%@&time=%u"]
//取消收藏
#define CancelCollection [HDBaseURL stringByAppendingString:@"api.php?mod=spacecp&ac=favorite&op=delete&favid=%ld&token=%@&time=%u"]


//
#define PCCancelCollection @"http://test.cdtzb.com/api.php?mod=spacecp&ac=favorite&op=delete&favid=%@&time=%u"
//文章点赞
#define PraiseArticle [HDBaseURL stringByAppendingString:@"api.php?mod=hd&type=click&idtype=aid&id=%ld&clickid=1&hash=%@&handlekey=clickhandle&token=%@&time=%u"]
/********************************************  订单购买  ***********************/
/**APP订单生成接口详细信息：
接口地址：http://gkc.cdtzb.com/
请求方式：post
所需参数：
 token		请求token
 product_id	商品id
 price		商品价格
 pay_uid		支付人uid
 pay_type		支付方式(同上)
 device_info	支付设备信息
 out_trade_no	商户订单号
 attach		商家数据包
 nonce_str	随机字符串
 */
#define MAKE_ORDER @"http://gkc.cdtzb.com/"


/********************************************  直播  ***********************/
/**直播列表*/
#define LIVEROOM_LIST_URL [HDBaseURL stringByAppendingString:@"liveroom.php?"]
//#define LIVEROOM_LIST_URL @"http://test.cdtzb.com/liveroom.php?mod=public&act=room_list&ajax=1"
/**直播室历史列表*/
#define LIVEROOM_HISTORY_URL @"liveroom.php?mod=public&act=room_history&room_id=100001"
/**直播室历史列表*/
#define LIVEROOM_HISTORY_DETAIL_URL @"liveroom.php?mod=text&type=live_history&belong_room=100001&y=2016&m=12&d=8&page=1&size=10"

/**直播列表-关注*/
#define LIVEROOM_LIST_CARE_URL @"api_user.php?mod=follow&act=add"

/**直播列表-取消关注*/
#define LIVEROOM_LIST_CANCELLE_CARE_URL @"api_user.php?mod=follow&act=del"
/** 直播页的网页地址*/
#define LivePageWebUrl @"http://gk.cdtzb.com/api/index"
/** 直播地址*/
#define LiveAddressUrl @"http://okcaifu.cn/kongxian/kongxian.m3u8"
//#define LiveAddressUrl @"http://video.cdtzb.com/Video/d5601fcc578a481d9dd112e9477dccf9/gywt/JH20170208.m3u8"

#define globleURL_prefix @"http://test.cdtzb.com/"

/********************************************  个人信息  ***********************/
//注册
//#define resignStr @"http://test.cdtzb.com/api.php?mod=member&act=register_mobile"
#define resignStr @"http://gk.cdtzb.com/api/gbs/add"
//登录
//#define loginStr @"http://test.cdtzb.com/api.php?mod=member&act=login"
#define loginStr @"http://gk.cdtzb.com/api/gbs/login"
//获得头像
//http://test.cdtzb.com/api.php?mod=member&act=uploadavatar&type=get_head_pic
#define getAvatar @"http://gk.cdtzb.com/api/member/get_head_pic&token="
//获得用户信息http://test.cdtzb.com/api.php?mod=member&act=profile&method=info
#define getInformationStr  @"http://gk.cdtzb.com/api/member/get_user_info"

#define URL_ChangePW @"http://gk.cdtzb.com/api/gbs/editpassword"
//获取验证码
#define getCode @"http://test.cdtzb.com/api.php?mod=member&act=note&mobile=%@&type=%@&test=1%d"
//修改名字
#define changedName @"http://gk.cdtzb.com/api/member/set_nickname"
//我的收藏
#define PCMyCollectedURL @"http://test.cdtzb.com/api.php?mod=spacecp&op=list&ac=favorite&page=%ld&typeid=%@&%u"

#define PCProductDetailURL @"http://gk.cdtzb.com/api/product/detail"
//已购买产品列表
#define PCProductListURL @"http://gk.cdtzb.com/api/product/getList"

#define MarketDefaultListURL @"http://db2015.wstock.cn/wsDB_API2/stock.php?symbol=SH000001,SZ399001,SZ399006&r_type=2&u=cngywt&p=web8858"
//已购买产品本地列表标志
#define alreadyBuiedKey @"alreadyBuied"

#endif /* HDStockURLHeader_h */
