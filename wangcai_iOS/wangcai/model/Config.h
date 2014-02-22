//
//  Config.h
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#ifndef wangcai_Config_h
#define wangcai_Config_h

#if TARGET_VERSION_LITE == 1 
#define APP_NAME   @"WangCai"
#define INVITE_URL @"http://invite.getwangcai.com/index.php?code=%@"

#define WEB_FORCE_UPDATE    @"http://wangcai.meme-da.com/web/update.php?app=wangcai&"

#elif TARGET_VERSION_LITE == 2

#define APP_NAME   @"WangCaiFriend"
#define INVITE_URL @"http://invite.getwangcai.com/index.php?app=wangcaifriend&code=%@"

#define WEB_FORCE_UPDATE    @"http://wangcai.meme-da.com/web/update.php?app=wangcaifriend&"
#endif


#define UMENG_KEY   @"52c65fc056240b00c1128d1e"
#define AES_KEY     @"cd421509726b38a2ffd2997caed6dab9"



#define TEST 0

#if TEST == 0

#define DEBUG_PUSH 0

#define HTTP_LOGIN_AND_REGISTER @"https://ssl.getwangcai.com/0/register"
#define HTTP_BIND_PHONE         @"https://ssl.getwangcai.com/0/account/bind_phone"

#define HTTP_SEND_SMS_CODE      @"https://ssl.getwangcai.com/0/sms/resend_sms_code"
#define HTTP_CHECK_SMS_CODE     @"https://ssl.getwangcai.com/0/account/bind_phone_confirm"
#define HTTP_READ_ACCOUNT_INFO     @"https://ssl.getwangcai.com/0/account/info"
#define HTTP_WRITE_ACCOUNT_INFO     @"https://ssl.getwangcai.com/0/account/update_user_info"
#define HTTP_UPDATE_INVITER     @"https://ssl.getwangcai.com/0/account/update_inviter"

#define HTTP_READ_TASK_LIST     @"https://ssl.getwangcai.com/0/task/list"
#define HTTP_TAKE_AWARD     @"https://ssl.getwangcai.com/0/task/check-in"

#define HTTP_DOWNLOAD_APP       @"https://ssl.getwangcai.com/0/task/download_app"

#define HTTP_PHONE_PAY         @"https://ssl.getwangcai.com/0/order/phone_pay"
#define HTTP_ALIPAY_PAY         @"https://ssl.getwangcai.com/0/order/alipay"

#define HTTP_EXCHANGE_LIST         @"https://ssl.getwangcai.com/0/order/exchange_list"
#define HTTP_EXCHANGE_CODE         @"https://ssl.getwangcai.com/0/order/exchange_code"

#define HTTP_TASK_OFFERWALL         @"https://ssl.getwangcai.com/0/task/poll"

#define HTTP_TASK_COMMENT         @"https://ssl.getwangcai.com/0/task/comment"

#define WEB_EXTRACT_MONEY @"http://wangcai.meme-da.com/web/extract_money.php"
#define WEB_TASK          @"http://wangcai.meme-da.com/web/task/app_task.php"
#define WEB_EXCHANGE_INFO @"http://wangcai.meme-da.com/web/exchange_info2.php"
#define WEB_ORDER_INFO    @"http://wangcai.meme-da.com/web/order_info.php"

#else

#define DEBUG_PUSH 1

#define HTTP_LOGIN_AND_REGISTER @"https://dev.getwangcai.com/0/register"
#define HTTP_BIND_PHONE         @"https://dev.getwangcai.com/0/account/bind_phone"

#define HTTP_SEND_SMS_CODE      @"https://dev.getwangcai.com/0/sms/resend_sms_code"
#define HTTP_CHECK_SMS_CODE     @"https://dev.getwangcai.com/0/account/bind_phone_confirm"
#define HTTP_READ_ACCOUNT_INFO     @"https://dev.getwangcai.com/0/account/info"
#define HTTP_WRITE_ACCOUNT_INFO     @"https://dev.getwangcai.com/0/account/update_user_info"
#define HTTP_UPDATE_INVITER     @"https://dev.getwangcai.com/0/account/update_inviter"

#define HTTP_READ_TASK_LIST     @"https://dev.getwangcai.com/0/task/list"
#define HTTP_TAKE_AWARD     @"https://dev.getwangcai.com/0/task/check-in"

#define HTTP_DOWNLOAD_APP       @"https://dev.getwangcai.com/0/task/download_app"

#define HTTP_PHONE_PAY         @"https://dev.getwangcai.com/0/order/phone_pay"
#define HTTP_ALIPAY_PAY         @"https://dev.getwangcai.com/0/order/alipay"

#define HTTP_EXCHANGE_LIST         @"https://dev.getwangcai.com/0/order/exchange_list"
#define HTTP_EXCHANGE_CODE         @"https://dev.getwangcai.com/0/order/exchange_code"

#define HTTP_TASK_OFFERWALL         @"https://dev.getwangcai.com/0/task/poll"

#define HTTP_TASK_COMMENT         @"https://dev.getwangcai.com/0/task/comment"

#define WEB_EXTRACT_MONEY         @"http://dev.meme-da.com/web/extract_money.php"
#define WEB_TASK                  @"http://dev.meme-da.com/web/task/app_task.php"
#define WEB_EXCHANGE_INFO         @"http://dev.meme-da.com/web/exchange_info.php"
#define WEB_ORDER_INFO            @"http://dev.meme-da.com/web/order_info.php"
#endif


#define HTTP_SERVICE_QUESTION   @"http://service.meme-da.com/index.php/mobile/shouce/list/hc_id/76"
#define HTTP_SERVICE_CENTER     @"http://service.meme-da.com/index.php/mobile/consulting"
#define WEB_SERVICE_VIEW @"http://service.meme-da.com/index.php/mobile/shouce/view/h_id/"

#endif
