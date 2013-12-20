//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "AppDelegate.h"
#import "AppBoard_iPhone.h"
#import "AppBoard_iPad.h"
#import "LoginAndRegister.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WBApi.h"
#import <RennSDK/RennSDK.h>
#import "WeiboSDK.h"


#pragma mark -

@implementation AppDelegate

- (void)load
{
	if ( [BeeSystemInfo isDevicePad] )
	{
		self.window.rootViewController = [AppBoard_iPad sharedInstance];
	}
	else
	{
		self.window.rootViewController = [AppBoard_iPhone sharedInstance];
	}
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    // 初始化sharesdk
    [self initShareSDK];
    
    // 登录
    [[LoginAndRegister sharedInstance]login:nil];
}

- (void)unload
{
	
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //[super handleOpenURL:url];
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication
                        annotation:annotation wxDelegate:self];
}

- (void) initShareSDK {
    [ShareSDK registerApp:@"ebe1cada416"];

    // 新浪微博
    [ShareSDK connectSinaWeiboWithAppKey: @"338240125" appSecret: @"32ccbf2004d7f8d19e29978aacdc2904" redirectUri: @"https://api.weibo.com/oauth2/default.html" weiboSDKCls: [WeiboSDK class]];
    
    // 添加QQ应用
    [ShareSDK connectQQWithAppId: @"100577453" qqApiCls: [QQApiInterface class]];
    
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey: @"100577453" appSecret: @"9454dd071c0dc94008caed4045ce5e39" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls: [TencentOAuth class]];
    
    // TX微博
    [ShareSDK connectTencentWeiboWithAppKey: @"801457140" appSecret: @"08c6c07a58f40d2a9b06eabeaf86f6ba" redirectUri: @"http://www.meme-da.com/" wbApiCls: [WBApi class]];
    
    // 163微博
    [ShareSDK connect163WeiboWithAppKey: @"la0pHcb8OZU5N2Xg" appSecret: @"UrTuNU32cSEfz789pUd0iSGQBJIBaVzh" redirectUri: @"http://www.meme-da.com/"];
    
    // 豆瓣
    [ShareSDK connectDoubanWithAppKey: @"0f4b3d0120adb5472de1b70362091fd5" appSecret: @"54b911f9863bdbd7" redirectUri: @"http://www.meme-da.com/"];
    
    // 人人
    [ShareSDK connectRenRenWithAppId: @"245528" appKey: @"a4825d92031b4a8495d7ef803b480373" appSecret: @"aa95c7e0575e4d8d8fd59cd31b32c76e" renrenClientClass: [RennClient class]];
    
    // 微信
    [ShareSDK connectWeChatWithAppId: @"wxb36cb2934f410866" wechatCls: [WXApi class]];
    
    // 微信朋友圈
    [ShareSDK connectWeChatFavWithAppId: @"wxb36cb2934f410866" wechatCls: [WXApi class]];
    
    // 微信好友
    [ShareSDK connectWeChatSessionWithAppId: @"wxb36cb2934f410866" wechatCls: [WXApi class]];
    
    // 微信收藏
    [ShareSDK connectWeChatFavWithAppId: @"wxb36cb2934f410866" wechatCls: [WXApi class]];
    //……
}

@end
