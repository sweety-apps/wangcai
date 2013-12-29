//
//  StartupController.m
//  wangcai
//
//  Created by 1528 on 13-12-26.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "StartupController.h"
#import "LoginAndRegister.h"
#import "AppBoard_iPhone.h"
#import "AppBoard_iPad.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WBApi.h"
#import <RennSDK/RennSDK.h>
#import "WeiboSDK.h"
#import "CommonTaskList.h"

@interface StartupController () <CommonTaskListDelegate>

@end

@implementation StartupController

- (id)init : (AppDelegate*) delegate
{
    self = [super initWithNibName:@"StartupController" bundle:nil];
    if (self) {
        // Custom initialization
        _delegate = delegate;
        
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"StartupController" owner:self options:nil] firstObject];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        // 初始化sharesdk
        [self initShareSDK];
        
        // 登陆
        [[LoginAndRegister sharedInstance] login:self];
    }
    return self;
}

-(void) loginCompleted : (LoginStatus) status HttpCode:(int)httpCode Msg:(NSString*)msg {
    if ( status == Login_Success ) {
        [CATransaction begin];
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.duration = 0.5f;
        transition.fillMode = kCAFillModeForwards;
        transition.removedOnCompletion = YES;
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
        
        [[CommonTaskList sharedInstance] fetchTaskList:self];
        
        [CATransaction commit];
    } else {
        // 登陆错误
        
        [CATransaction begin];
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.duration = 0.5f;
        transition.fillMode = kCAFillModeForwards;
        transition.removedOnCompletion = YES;
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
        
        if ( [BeeSystemInfo isDevicePad] ) {
            _delegate.window.rootViewController = [AppBoard_iPad sharedInstance];
        } else {
            _delegate.window.rootViewController = [AppBoard_iPhone sharedInstance];
        }
        
        [CATransaction commit];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark <CommonTaskListDelegate>

- (void)onFinishedFetchTaskList:(CommonTaskList*)taskList resultCode:(NSInteger)result
{
    if (result >= 0)
    {
        
    }
    else
    {
        
    }
    
    if ( [BeeSystemInfo isDevicePad] ) {
        _delegate.window.rootViewController = [AppBoard_iPad sharedInstance];
    } else {
        _delegate.window.rootViewController = [AppBoard_iPhone sharedInstance];
    }
}

@end
