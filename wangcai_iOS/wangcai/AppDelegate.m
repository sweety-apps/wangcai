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
#import "AppBoard_iPhone.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WBApi.h"
#import <RennSDK/RennSDK.h>
#import "WeiboSDK.h"
#import "model/MobClick.h"
#import "Config.h"
#import "StartupController.h"
#import "OnlineWallViewController.h"
#import "JPushlib/APService.h"
#import "UtilityFunctions.h"
#import "WebPageController.h"

#pragma mark -

@interface AppDelegate ()
{
    StartupController* _startupController;
    
}
@property (nonatomic,assign) StartupController* startupController;

@end

@implementation AppDelegate

@synthesize startupController = _startupController;

- (void)load
{
    StartupController* startup = [[StartupController alloc]init : self];
    _nsRemoteNotifications = nil;
    
    _timeRemoteNotifications = 0;
    _startupController = startup;
    
    [CATransaction begin];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 0.5f;
    transition.fillMode = kCAFillModeForwards;
    transition.removedOnCompletion = YES;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    
    self.window.rootViewController = startup;
    
    [CATransaction commit];

    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)unload
{
	if ( _nsRemoteNotifications != nil ) {
        [_nsRemoteNotifications release];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //[super handleOpenURL:url];
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication
                        annotation:annotation wxDelegate:self];
}

- (void)setLocalNoti
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:60*60*24*7];
        notification.repeatInterval= 0;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
        notification.alertBody=@"您已经超过7天没来了，赶紧回来签个到吧。";//提示信息 弹出提示框
        notification.alertAction = @"打开";  //提示框按钮
        notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
         NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"remindNotLogin" forKey:@"remindNotLogin"];
        notification.userInfo = infoDict; //添加额外的信息
         notification.applicationIconBadgeNumber += 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
       

        UILocalNotification *next = [notification copy];
        next.fireDate = [now dateByAddingTimeInterval:60*60*24*8];
        next.repeatInterval = kCFCalendarUnitDay;
        [[UIApplication sharedApplication] scheduleLocalNotification:next];
        
        [next release];
        [notification release];
    }
   
}
-(void)removeLocalPushNotification
{
    UIApplication* app=[UIApplication sharedApplication];
    NSArray* localNotifications=[app scheduledLocalNotifications];
    
    if (localNotifications.count > 0) {
        
        for (UILocalNotification* notification in localNotifications) {
            
            NSDictionary* dic=notification.userInfo;
            if (dic) {
                NSString* value=[dic objectForKey:@"remindNotLogin"];
                if(!value){
                    value = [dic objectForKey:@"remind"];
                }
                if ([value isEqualToString:@"remindNotLogin"]||[value isEqualToString:@"someValue"]) {
                    [app cancelLocalNotification:notification];
                    
                }
            }
            
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [super application:application didFinishLaunchingWithOptions:launchOptions];
    [self removeLocalPushNotification];
    if ( launchOptions != nil ) {
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if ( pushNotificationKey ) {
            _nsRemoteNotifications = [pushNotificationKey copy];
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            _timeRemoteNotifications = [dat timeIntervalSince1970]*1000;
        }
        UILocalNotification *noti = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        NSDictionary *info = [noti userInfo];
        if([[info objectForKey:@"remindNotLogin"] isEqualToString:@"remindNotLogin"])
        {
            self.isLaunchFromLocalNotification = YES;
        }
    }
    
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    [APService setupWithOption:launchOptions];
    
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSString * token = [deviceToken description];
//	token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
//	token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
//	token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"token=%@",token);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
    
    if ( userInfo != nil ) {
        if ( _nsRemoteNotifications != nil ) {
            [_nsRemoteNotifications release];
        }
        _nsRemoteNotifications = [userInfo copy];
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        _timeRemoteNotifications = [dat timeIntervalSince1970]*1000;
    }
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [super applicationDidEnterBackground:application];
    [self setLocalNoti];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"[Regist Push] Failed, err = %@",error);
    /*
    if (DEBUG_PUSH)
    {
        [UtilityFunctions debugAlertView:@"推送测试（正式版不出现）" content:[NSString stringWithFormat:@"[Regist Push] Failed, err = %@",error]];
    }
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [super applicationDidBecomeActive:application];
    [self removeLocalPushNotification];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            
    [self postNotification:@"applicationDidBecomeActive"];
    
    if ( _nsRemoteNotifications != nil ) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval curTime = [dat timeIntervalSince1970]*1000;
        if ( curTime - _timeRemoteNotifications < 500 ) {
            // 如果小于1s，认为是通过通知来启动的
            //
            [self onShowPageFromRootNotification:_nsRemoteNotifications];
    
            [_nsRemoteNotifications release];
            _nsRemoteNotifications = nil;
        } else {
            [_nsRemoteNotifications release];
            _nsRemoteNotifications = nil;
        }
    }
   // NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"type",@"379395415,242475584,3d60a5b13aec8b3954e2b70c3e130848",@"waps",@"42-1,44-1,40-1",@"points", nil];
    //  [self onShowPageFromRootNotification:dic];
}

-(void) onShowPageFromRootNotification:(NSDictionary*) remoteNotifications {
    NSString* type = [remoteNotifications objectForKey:@"type"];
    if ( [type isEqualToString:@"1"] ) {
        NSString* title = [remoteNotifications objectForKey:@"title"];
        NSString* url = [remoteNotifications objectForKey:@"url"];
    
        if ( [self.window.rootViewController isEqual:[AppBoard_iPhone sharedInstance]] ) {
            // 取当前stack
            BeeUIStack* stack = [BeeUIRouter sharedInstance].currentStack;

            WebPageController* controller = [[[WebPageController alloc] init:title
                                                                     Url:url Stack:stack] autorelease];
            [stack pushViewController:controller animated:YES];
        } else {
            // 界面还没有创建
            [[AppBoard_iPhone sharedInstance] openUrlFromRomoteNotification:title Url:url];
        }
    } else if ( [type isEqualToString:@"2"] ) {
        if ( [self.window.rootViewController isEqual:[AppBoard_iPhone sharedInstance]] ) {
            [[AppBoard_iPhone sharedInstance] installAppFromRomoteNotification:remoteNotifications];
        } else {
            // 界面还没有创建
            [[AppBoard_iPhone sharedInstance] notificationInstallApp:remoteNotifications];
        }
    }
}
@end
