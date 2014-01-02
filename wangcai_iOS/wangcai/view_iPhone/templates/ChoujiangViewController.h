//
//  ChoujiangViewController.h
//  wangcai
//
//  Created by Lee Justin on 13-12-30.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoujiangViewController : UIViewController<UIAlertViewDelegate> {
    BOOL _hasStarted;
}

@property (nonatomic,retain) IBOutlet UIImageView* beilv1x;
@property (nonatomic,retain) IBOutlet UIImageView* beilv2x;
@property (nonatomic,retain) IBOutlet UIImageView* beilv3x;
@property (nonatomic,retain) IBOutlet UIButton* startButton;
@property (nonatomic,retain) IBOutlet UIButton* backButton;

@property (nonatomic,retain) IBOutlet UIImageView* choice0;
@property (nonatomic,retain) IBOutlet UIImageView* choice1;
@property (nonatomic,retain) IBOutlet UIImageView* choice2;
@property (nonatomic,retain) IBOutlet UIImageView* choice3;
@property (nonatomic,retain) IBOutlet UIImageView* choice4;
@property (nonatomic,retain) IBOutlet UIImageView* choice5;
@property (nonatomic,retain) IBOutlet UIImageView* choice6;
@property (nonatomic,retain) IBOutlet UIImageView* choice7;
@property (nonatomic,retain) IBOutlet UIImageView* choice8;
@property (nonatomic,retain) IBOutlet UIImageView* choice9;
@property (nonatomic,retain) IBOutlet UIImageView* choice10;
@property (nonatomic,retain) IBOutlet UIImageView* choice11;

@property (nonatomic,retain) IBOutlet UIImageView* choiceBorder;
@property (nonatomic,retain) IBOutlet UIImageView* choiceCover;

- (void)setBeiLv:(int)beilvNum;//1-3
- (int)getBeiLv;

- (IBAction)onPressedStartButton:(id)sender;
- (IBAction)onPressedBackButton:(id)sender;


@end
