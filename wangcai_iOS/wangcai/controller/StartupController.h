//
//  StartupController.h
//  wangcai
//
//  Created by 1528 on 13-12-26.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface StartupController : UIViewController< LoginAndRegisterDelegate, UIAlertViewDelegate> {
    AppDelegate* _delegate;
    UIAlertView* _alertForceUpdate;
    UIAlertView* _alertError;
}

- (id) init : (AppDelegate*) delegate;
@end
