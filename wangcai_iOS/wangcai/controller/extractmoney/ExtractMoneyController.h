//
//  ExtractMoneyController.h
//  wangcai
//
//  Created by 1528 on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"

@interface ExtractMoneyController : UIViewController<WebViewControllerDelegate> {
    WebViewController* _webViewController;
    BeeUIStack* _beeStack;
}

- (id)init:(NSBundle *)nibBundleOrNil;
- (void)setUIStack : (BeeUIStack*) beeStack;

-(void) onAttachPhone;
-(void) onPayToAlipay:(float) fCoin;
-(void) onPayToPhone:(float) fCoin;
@end
