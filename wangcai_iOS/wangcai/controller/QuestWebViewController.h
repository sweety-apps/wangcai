//
//  QuestWebViewController.h
//  wangcai
//
//  Created by NPHD on 14-5-23.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestViewController.h"

@interface QuestWebViewController : UIViewController<UIWebViewDelegate, HttpRequestDelegate, UIAlertViewDelegate> {
    SurveyInfo* _info;
    UIAlertView* _alertView;
}

@property (retain, nonatomic) IBOutlet UIWebView* _webView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView* _loadingView;
@property (retain, nonatomic) IBOutlet UIButton* _errBtn;
@property (retain, nonatomic) IBOutlet UILabel* _errText;

- (IBAction)clickBack:(id)sender;

- (void) setQuestInfo:(SurveyInfo*) info;

- (IBAction)onRequest:(id)sender;

@end
