//
//  QuestCaptionViewController.h
//  wangcai
//
//  Created by NPHD on 14-5-22.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTaskList.h"

@interface QuestCaptionViewController : UIViewController {
    CommonTaskInfo* _info;
}

@property (retain, nonatomic) IBOutlet UIView* _subView;

- (void) setQuestInfo : (CommonTaskInfo*) info;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickOk:(id)sender;
@end
