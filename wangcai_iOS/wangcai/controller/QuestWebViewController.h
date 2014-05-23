//
//  QuestWebViewController.h
//  wangcai
//
//  Created by NPHD on 14-5-23.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTaskList.h"

@interface QuestWebViewController : UIViewController<UIWebViewDelegate, HttpRequestDelegate> {
    CommonTaskInfo* _info;
}

@property (retain, nonatomic) IBOutlet UIWebView* _webView;

- (IBAction)clickBack:(id)sender;

- (void) setQuestInfo:(CommonTaskInfo*) info;

@end
