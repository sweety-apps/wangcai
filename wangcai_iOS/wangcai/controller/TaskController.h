//
//  TaskController.h
//  wangcai
//
//  Created by 1528 on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "TabController.h"

@interface TaskController : UIViewController {
    WebViewController* _webViewController;
    TabController* _tabController;
}

- (id)init:(NSBundle *)nibBundleOrNil;
@end
