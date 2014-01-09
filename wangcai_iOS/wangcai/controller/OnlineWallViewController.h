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

@protocol OnlineWallViewControllerDelegate <NSObject>
- (void) onRequestAndConsumePointCompleted : (BOOL) suc Consume:(NSInteger) consume;
@end

@interface OnlineWallViewController : UIViewController<DMOfferWallDelegate, DMOfferWallManagerDelegate, HttpRequestDelegate> {
    DMOfferWallViewController* _offerWallController;
    DMOfferWallManager*        _offerWallManager;
    NSInteger                  _nConsume;
    id<OnlineWallViewControllerDelegate>        _delegate;
}

@property (nonatomic,assign) id<OnlineWallViewControllerDelegate>  delegate;

+ (OnlineWallViewController*) sharedInstance;

- (void)showWithModal;
- (void)requestAndConsumePoint;
@end
