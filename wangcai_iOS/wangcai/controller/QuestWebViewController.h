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

- (IBAction)clickBack:(id)sender;

- (void) setQuestInfo:(SurveyInfo*) info;

@end
