//
//  WangcaiTaskViewController.h
//  wangcai
//
//  Created by NPHD on 14-5-21.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface WangcaiTaskViewController : UIViewController <EGORefreshTableHeaderDelegate> {
    BeeUIStack* _beeUIStack;
    
    BOOL _reloading;
    EGORefreshTableHeaderView* _refreshHeaderView;
}

+ (WangcaiTaskViewController*) sharedInstance;

- (IBAction)clickBack:(id)sender;

- (void)setUIStack:(BeeUIStack*) stack;

@property (retain, nonatomic) IBOutlet UITableView* tbView;

@end
