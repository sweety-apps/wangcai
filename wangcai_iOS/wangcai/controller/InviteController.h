//
//  InviteController.h
//  wangcai
//
//  Created by 1528 on 13-12-11.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareSocial.h"

@interface InviteController : UIViewController<ShareSocialDelegate> {
    NSString* _inviteCode;
    IBOutlet UILabel* _myInviteLabel;
}

- (IBAction) copyToClip:(id)sender;
- (IBAction) clickShare:(id)sender;

@property (nonatomic, retain) UILabel* _myInviteLabel;

-(void) ShareCompleted : (id) share State:(SSResponseState) state Err:(id<ICMErrorInfo>) error;

@end
