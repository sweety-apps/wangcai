//
//  OnlineWallViewController.h
//  wangcai
//
//  Created by 1528 on 13-12-31.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequest.h"
#import "UICustomAlertView.h"
#import "YouMiConfig.h"
#import "MopanAdWall.h"
#import "PBOfferWall.h"

#import "MiidiManager.h"
#import "MiidiAdWallSpendPointsDelegate.h"
#import "MiidiAdWallAwardPointsDelegate.h"
#import "MiidiAdWallGetPointsDelegate.h"
#import "MiidiAdWallShowAppOffersDelegate.h"
#import "MiidiAdWallRequestToggleDelegate.h"

#import "MiidiAdWall.h"
#import "MiidiAdDesc.h"

#import "DianRuAdWall.h"

@protocol OnlineWallViewControllerDelegate <NSObject>
- (void) onRequestAndConsumePointCompleted : (BOOL) suc Consume:(NSInteger) consume Level:(int) change wangcaiIncome:(int) income;
@end

@interface OnlineWallViewController : UIViewController<DianRuAdWallDelegate, HttpRequestDelegate, PBOfferWallDelegate, MiidiAdWallShowAppOffersDelegate> {
    NSInteger                  _nConsume;
    id<OnlineWallViewControllerDelegate>        _delegate;
    
    UICustomAlertView* _alertView;
    
    NSInteger                  _remained;
    
    BOOL               _request;
    NSInteger          _allConsume;
    
    int                _offerwallIncome;
    
    UIViewController* _viewController;
    UIViewController* _backupViewController;
    
    id _baseTaskTableViewController;
    
    MopanAdWall* _mopanAdWallControl;
    
    int         _nRecommend;
    
    UIView*     _moreView;
}

@property (nonatomic,assign) id<OnlineWallViewControllerDelegate>  delegate;

+ (OnlineWallViewController*) sharedInstance;

-(void)setViewController:(UIViewController*) viewController;

-(void)pushViewController:(UIViewController*) viewController;
-(void)popViewController;

-(void)setTaskTableViewController:(id)taskTableViewController;


-(void)enterAdWall;
-(void)QueryScore;
-(void)ReduceScore;

- (void)setFullScreenWindow:(UIWindow*) window;
- (void)showWithModal;
- (void)requestAndConsumePoint;

- (IBAction)clickDomob:(id)sender;
- (IBAction)clickYoumi:(id)sender;
- (IBAction)clickLimei:(id)sender;
- (IBAction)clickWaps:(id)sender;
- (IBAction)clickMopan:(id)sender;
- (IBAction)clickPunchBox:(id)sender;
- (IBAction)clickMiidi:(id)sender;
- (IBAction)clickJupeng:(id)sender;
- (IBAction)clickDianru:(id)sender;
- (IBAction)clickAdwo:(id)sender;

- (IBAction)clickHelper:(id)sender;
- (IBAction)clickComplain:(id)sender;

- (IBAction)clickClose:(id)sender;

- (IBAction)onClickBack:(id)sender;

- (void) open:(NSString*) name;
@end
