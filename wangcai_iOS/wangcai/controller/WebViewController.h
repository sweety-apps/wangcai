//
//  WebViewController.h
//  wangcai
//
//  Created by 1528 on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebViewControllerDelegate <NSObject>
// 绑定手机
-(void) onAttachPhone;
// 打款到支付宝
-(void) onPayToAlipay:(float) fCoin;
// 花费充值
-(void) onPayToPhone:(float) fCoin;
@end


@interface WebViewController : UIViewController<UIWebViewDelegate> {
    UIWebView* _webView;
    NSString*  _url;
    id         _delegate;
}

- (id)init;
- (void)setNavigateUrl:(NSString*)url;

- (void)notifyPhoneStatus:(BOOL)isAttach Phone:(NSString*)phone;

- (void)setDelegate:(id)delegate;
@end
