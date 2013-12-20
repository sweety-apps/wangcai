//
//  WebViewController.h
//  wangcai
//
//  Created by 1528 on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate, SKStoreProductViewControllerDelegate> {
    UIWebView* _webView;
    NSString*  _url;
    
    UIView*    _loadingView;
    
    BeeUIStack* _beeStack;
}

- (id)init;
- (void)setBeeUIStack:(BeeUIStack*) beeStack;
- (void)setNavigateUrl:(NSString*)url;

- (void)notifyPhoneStatus:(BOOL)isAttach Phone:(NSString*)phone;

- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
@end
