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
#import "XMLReader.h"

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
        _alertError = nil;
        _alertForceUpdate = nil;
        
        // 初始化sharesdk
        [self initShareSDK];
        
        // 登陆
        [[LoginAndRegister sharedInstance] login:self];
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( _alertError != nil && [alertView isEqual:_alertError] ) {
        // 重试
        [[self.view viewWithTag:11] setHidden:NO];
        [[LoginAndRegister sharedInstance] login:self];
    } else if ( _alertForceUpdate != nil && [alertView isEqual:_alertForceUpdate] ) {
        // 升级
        NSString* urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id776787173?mt=8"];
        NSURL* url = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication] openURL:url];
        
        exit(0);
    }
}

-(void) loginCompleted : (LoginStatus) status HttpCode:(int)httpCode Msg:(NSString*)msg {
    [[self.view viewWithTag:11] setHidden:YES];
    
    if ( status == Login_Success ) {
        int forceUpdate = [[LoginAndRegister sharedInstance] getForceUpdate];
        if ( forceUpdate == 1 ) {
            // 强制升级
            if ( _alertForceUpdate != nil ) {
                [_alertForceUpdate release];
            }
            
            _alertForceUpdate = [[UIAlertView alloc]initWithTitle:@"升级" message:@"为了您红包的安全，需要升级之后才能继续使用。" delegate:self cancelButtonTitle:@"升级" otherButtonTitles:nil, nil];
            [_alertForceUpdate show];
        } else {
            [CATransaction begin];
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionFade;
            transition.duration = 0.5f;
            transition.fillMode = kCAFillModeForwards;
            transition.removedOnCompletion = YES;
            [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
        
            [[CommonTaskList sharedInstance] fetchTaskList:self];
        
            [CATransaction commit];
        }
    } else {
        // 登陆错误，必须登陆成功才能进入下一步
        if ( _alertError != nil ) {
            [_alertError release];
        }
        
        _alertError = [[UIAlertView alloc]initWithTitle:@"错误" message:@"无法访问服务器，请确保网络连接正常" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:nil, nil];
        [_alertError show];
    }
}

- (void) dealloc {
    if ( _alertError != nil ) {
        [_alertError release];
    }
    
    if ( _alertForceUpdate != nil ) {
        [_alertForceUpdate release];
    }
    [super dealloc];
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
    
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(defaultQueue, ^
    {
        NSURL* url = [NSURL URLWithString: @"http://wangcai.meme-da.com/invite/share.xml"];
        NSData* xmlData = [NSData dataWithContentsOfURL: url];
        
        if (xmlData)
        {
            NSError* error = nil;
            NSDictionary* shareDict = [XMLReader dictionaryForXMLData: xmlData error: &error];
            if (shareDict)
            {
                NSDictionary* rootObject = (NSDictionary *)[shareDict objectForKey: @"share"];
                if (rootObject)
                {
                    if ([rootObject count] > 0)
                    {
                        // 豆瓣
                        NSDictionary* doubanObject = (NSDictionary *)[rootObject objectForKey: @"Douban"];
                        if (doubanObject)
                        {
                            NSString* state = (NSString *)[doubanObject objectForKey: @"text"];
                            if ([state intValue])
                            {
                                [ShareSDK connectDoubanWithAppKey: @"0f4b3d0120adb5472de1b70362091fd5" appSecret: @"54b911f9863bdbd7" redirectUri: @"http://www.meme-da.com/"];
                            }
                        }
                        
                        // 163微博
                        NSDictionary* netBaseWeiboObject = (NSDictionary *)[rootObject objectForKey: @"NetbaseWeibo"];
                        if (netBaseWeiboObject)
                        {
                            NSString* state = (NSString *)[netBaseWeiboObject objectForKey: @"text"];
                            if ([state intValue])
                            {
                                [ShareSDK connect163WeiboWithAppKey: @"la0pHcb8OZU5N2Xg" appSecret: @"UrTuNU32cSEfz789pUd0iSGQBJIBaVzh" redirectUri: @"http://www.meme-da.com/"];
                            }
                        }
                        
                        // QQ空间
                        NSDictionary* qzoneObject = (NSDictionary *)[rootObject objectForKey: @"QZone"];
                        if (qzoneObject)
                        {
                            NSString* state = (NSString *)[qzoneObject objectForKey: @"text"];
                            if ([state intValue])
                            {
                                [ShareSDK connectQZoneWithAppKey: @"100577453" appSecret: @"9454dd071c0dc94008caed4045ce5e39" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls: [TencentOAuth class]];
                            }
                        }
                        
                        // 人人
                        NSDictionary* renrenObject = (NSDictionary *)[rootObject objectForKey: @"RenRen"];
                        if (renrenObject)
                        {
                            NSString* state = (NSString *)[renrenObject objectForKey: @"text"];
                            if ([state intValue])
                            {
                                [ShareSDK connectRenRenWithAppId: @"245528" appKey: @"a4825d92031b4a8495d7ef803b480373" appSecret: @"aa95c7e0575e4d8d8fd59cd31b32c76e" renrenClientClass: [RennClient class]];
                            }
                        }
                        
                        // 新浪微博
                        NSDictionary* sinaWeiboObject = (NSDictionary *)[rootObject objectForKey: @"SinaWeibo"];
                        if (sinaWeiboObject)
                        {
                            NSString* state = (NSString *)[sinaWeiboObject objectForKey: @"text"];
                            if ([state intValue])
                            {
                                [ShareSDK connectSinaWeiboWithAppKey: @"338240125" appSecret: @"32ccbf2004d7f8d19e29978aacdc2904" redirectUri: @"https://api.weibo.com/oauth2/default.html" weiboSDKCls: [WeiboSDK class]];
                            }
                        }
                        
                        // 腾讯微博
                        NSDictionary* tencentWeiboObject = (NSDictionary *)[rootObject objectForKey: @"TencentWeibo"];
                        if (tencentWeiboObject)
                        {
                            NSString* state = (NSString *)[tencentWeiboObject objectForKey: @"text"];
                            if ([state intValue])
                            {
                                [ShareSDK connectTencentWeiboWithAppKey: @"801457140" appSecret: @"08c6c07a58f40d2a9b06eabeaf86f6ba" redirectUri: @"http://www.meme-da.com/" wbApiCls: [WBApi class]];
                            }
                        }
                    }
                    else
                    {
                        // xml有问题，share节点下无子节点
                        dispatch_async(dispatch_get_main_queue(), ^
                        {
                        });
                    }
                }
                else
                {
                    // xml有问题，无share根节点
                    dispatch_async(dispatch_get_main_queue(), ^
                    {
                    });
                }
                
            }
            else
            {
                // 解析xml失败，则只分享到QQ应用平台
                dispatch_async(dispatch_get_main_queue(), ^
                {
                });
            }
        }
        else
        {
            // 读取不到xml
            dispatch_async(dispatch_get_main_queue(), ^
            {
            });
        }
    });
    
    // 这几个默认都打开
    // 添加QQ应用
    [ShareSDK connectQQWithAppId: @"100577453" qqApiCls: [QQApiInterface class]];
    // 微信
    [ShareSDK connectWeChatWithAppId: @"wxb36cb2934f410866" wechatCls: [WXApi class]];
    
    // 微信朋友圈
    [ShareSDK connectWeChatTimelineWithAppId: @"wxb36cb2934f410866" wechatCls: [WXApi class]];
    
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
