//
//  OnlineWallViewController.h
//  wangcai
//
//  Created by 1528 on 13-12-31.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMOfferWallViewController.h"
#import "DMOfferWallManager.h"
#import "HttpRequest.h"
#import "UICustomAlertView.h"
#import "YouMiConfig.h"

@protocol OnlineWallViewControllerDelegate <NSObject>
- (void) onRequestAndConsumePointCompleted : (BOOL) suc Consume:(NSInteger) consume;
@end

@interface OnlineWallViewController : UIViewController<DMOfferWallDelegate, DMOfferWallManagerDelegate, HttpRequestDelegate> {
    DMOfferWallViewController* _offerWallController;
    DMOfferWallManager*        _offerWallManager;
    NSInteger                  _nConsume;
    id<OnlineWallViewControllerDelegate>        _delegate;
    
    UICustomAlertView* _alertView;
    
    NSInteger                  _remained;
    
    BOOL               _request;
    NSInteger          _allConsume;
}

@property (nonatomic,assign) id<OnlineWallViewControllerDelegate>  delegate;

+ (OnlineWallViewController*) sharedInstance;

- (void)setFullScreenWindow:(UIWindow*) window;
- (void)showWithModal;
- (void)requestAndConsumePoint;

- (IBAction)clickDomob:(id)sender;
- (IBAction)clickYoumi:(id)sender;
@end
