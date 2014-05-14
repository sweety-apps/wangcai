//
//  MessageViewController.h
//  wangcai
//
//  Created by zhangc on 14-5-9.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageMgr.h"

@interface MessageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MessageMgrDelegate> {
    BeeUIStack* _beeUIStack;
    
    NSArray*    _msgList;
}

- (IBAction)clickBack:(id)sender;

- (void)setUIStack:(BeeUIStack*) stack;

@property (retain, nonatomic) IBOutlet UITableView* tbView;
@end
