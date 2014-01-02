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

@protocol OnlineWallViewControllerDelegate <NSObject>
- (void) onRequestAndConsumePointCompleted : (BOOL) suc Consume:(NSInteger) consume;
@end

@interface OnlineWallViewController : UIViewController<DMOfferWallDelegate, DMOfferWallManagerDelegate> {
    DMOfferWallViewController* _offerWallController;
    DMOfferWallManager*        _offerWallManager;
    NSInteger                  _nConsume;
    id                         _delegate;
}

+ (OnlineWallViewController*) sharedInstance;

- (void)showWithModal;
- (void)requestAndConsumePoint;
@end
