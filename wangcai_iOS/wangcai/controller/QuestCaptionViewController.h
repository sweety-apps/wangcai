//
//  QuestCaptionViewController.h
//  wangcai
//
//  Created by NPHD on 14-5-22.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTaskList.h"
#import "QuestViewController.h"

@interface QuestCaptionViewController : UIViewController {
    SurveyInfo* _info;
}

@property (retain, nonatomic) IBOutlet UIView* _subView;

- (void) setQuestInfo : (SurveyInfo*) info;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickOk:(id)sender;
@end
