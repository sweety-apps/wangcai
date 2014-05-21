//
//  QuestViewController.h
//  wangcai
//
//  Created by NPHD on 14-5-21.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestViewController : UIViewController {
    BeeUIStack* _beeUIStack;
}

+ (QuestViewController*) sharedInstance;

- (IBAction)clickBack:(id)sender;

- (void)setUIStack:(BeeUIStack*) stack;

@property (retain, nonatomic) IBOutlet UITableView* tbView;

@end
