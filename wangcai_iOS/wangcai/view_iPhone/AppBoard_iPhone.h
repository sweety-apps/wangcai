//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  AppBoard_iPhone.h
//  wangcai
//
//  Created by Lee Justin on 13-12-8.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "Bee.h"
#import "YouMiView.h"
#import "WapsOffer/WapsOfferCustom.h"

@interface AppBoard_iPhone : BeeUIBoard <UIAlertViewDelegate, WapsOfferCustomDelegate> {
    UIAlertView* _alertView;
    YouMiView*   _adView;
    
    NSString*    _remoteNotificationTitle;
    NSString*    _remoteNotificationUrl;
    
    NSDictionary* _notification;
    
    WapsOfferCustom* _wapCustom;
    
    NSMutableArray*      _appId;
    NSMutableArray*      _points;
    NSMutableArray*      _pointsLimit;
}

AS_SINGLETON( AppBoard_iPhone )

- (void)setPanable:(BOOL)panable;
- (void)onTouchedInvite:(BOOL)switchToFillInvitedCodeView;
- (void) openUrlFromRomoteNotification : (NSString*) title Url:(NSString*) url;

- (void) installAppFromRomoteNotification:(NSDictionary*) remoteNotifications;
- (void) notificationInstallApp:(NSDictionary*) remoteNotifications;

@end
