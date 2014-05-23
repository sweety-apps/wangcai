//
//  QuestViewController.h
//  wangcai
//
//  Created by NPHD on 14-5-21.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "HttpRequest.h"
#import "UICustomAlertView.h"


@interface SurveyInfo : NSObject {
    
}

@property (retain, nonatomic) NSNumber* sid;
@property (retain, nonatomic) NSString* title;
@property (retain, nonatomic) NSString* url;
@property (retain, nonatomic) NSNumber* status;
@property (retain, nonatomic) NSNumber* money;
@property (retain, nonatomic) NSNumber* level;
@property (retain, nonatomic) NSString* intro;
@end

@interface QuestViewController : UIViewController <EGORefreshTableHeaderDelegate, HttpRequestDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    BeeUIStack* _beeUIStack;
    
    BOOL _reloading;
    EGORefreshTableHeaderView* _refreshHeaderView;
    
    BOOL _firstRequest;
    HttpRequest* _request;
    
    NSArray* _list;
    
    BOOL _bShow;
    
    UIAlertView* _alertLevel;
    
    BOOL _bRequest;
    
    UICustomAlertView* _alertInstallApp;
    NSString*    _installUrl;
}

+ (QuestViewController*) sharedInstance;

- (IBAction)clickBack:(id)sender;

- (void)setUIStack:(BeeUIStack*) stack;

- (void) requestList;

@property (retain, nonatomic) IBOutlet UITableView* tbView;

@end
