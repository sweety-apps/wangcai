//
//  OnlineWallViewController.m
//  wangcai
//
//  Created by 1528 on 13-12-31.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "OnlineWallViewController.h"
#import "LoginAndRegister.h"
#import "HttpRequest.h"
#import "config.h"
#import "YouMiConfig.h"
#import "YouMiWall.h"
#import "YouMiWallAppModel.h"
#import "YouMiPointsManager.h"
#import "SettingLocalRecords.h"
#import "MobClick.h"


#define PUBLISHER_ID @"96ZJ2I4gzeykPwTACk"

@interface OnlineWallViewController ()

@end

@implementation OnlineWallViewController

@synthesize delegate = _delegate;

static OnlineWallViewController* _sharedInstance;

+(OnlineWallViewController*) sharedInstance {
    if ( _sharedInstance == nil ) {
        _sharedInstance = [[OnlineWallViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    return _sharedInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString* deviceId = [[LoginAndRegister sharedInstance] getDeviceId];
        _offerwallIncome = [[LoginAndRegister sharedInstance] getOfferwallIncome];
        
        _alertView = nil;
        _request = NO;
        
        // 有米积分墙
#if TEST == 1
        NSString* did = [[NSString alloc] initWithFormat:@"dev_%@", deviceId];
        
        _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:PUBLISHER_ID andUserID:did];
        _offerWallController.delegate = self;
        
        [YouMiConfig setUserID:did];
#else 
        _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:PUBLISHER_ID andUserID:deviceId];
        _offerWallController.delegate = self;

        [YouMiConfig setUserID:deviceId];
#endif
        [YouMiConfig setUseInAppStore:YES];
        
        //[YouMiConfig launchWithAppID:@"a33a9f68b3eb6147" appSecret:@"02b5609f193b2828"];
        [YouMiConfig launchWithAppID:@"c43af0b9f90601cf" appSecret:@"14706b7214e01b2b"];  //服务器版
        
        [YouMiWall enable];
        [YouMiPointsManager enable];
        
        [deviceId release];
    }
    return self;
}

- (void)setFullScreenWindow:(UIWindow*) window {
    [YouMiConfig setFullScreenWindow:window];
}

- (void)showWithModal {
    if ( _alertView != nil ) {
        [_alertView release];
    }
    
    BOOL showDomob = [[LoginAndRegister sharedInstance] isShowDomob];
    BOOL showYoumi = [[LoginAndRegister sharedInstance] isShowYoumi];
    
    UIView* view;
    if ( showDomob && showYoumi ) {
        view = [[[[NSBundle mainBundle] loadNibNamed:@"OnlineWallViewController" owner:self options:nil] firstObject] autorelease];
    } else if ( !showDomob && showYoumi ) {
        view = [[[[NSBundle mainBundle] loadNibNamed:@"OnlineWallViewController" owner:self options:nil] objectAtIndex:2] autorelease];
    } else {
        view = [[[[NSBundle mainBundle] loadNibNamed:@"OnlineWallViewController" owner:self options:nil] objectAtIndex:1] autorelease];
    }
    
    UIColor *color = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1];
        
    UIButton* btn = (UIButton*)[view viewWithTag:11];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    
    [btn.layer setBorderWidth:0];
    
    btn = (UIButton*)[view viewWithTag:12];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    
    [btn.layer setBorderWidth:0];

    _alertView = [[UICustomAlertView alloc]init:view];
        
    //[view release];
    [_alertView show];
}

- (IBAction)clickYoumi:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_youmi" attributes:@{@"currentpage":@"任务列表"}];
    [YouMiWall showOffers:YES didShowBlock:^{
    }didDismissBlock:^{
    }];
}

- (IBAction)clickDomob:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_duomeng" attributes:@{@"currentpage":@"任务列表"}];
    [_offerWallController presentOfferWall];
}

- (IBAction)clickClose:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) dealloc {
    _offerWallController.delegate = nil;
    [_offerWallController release];
    _offerWallController = nil;
    
    if ( self->_alertView != nil ) {
        [self->_alertView release];
        self->_alertView = nil;
    }
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 积分墙开始加载数据。
- (void)offerWallDidStartLoad {
    
}

// 积分墙加载完成。
- (void)offerWallDidFinishLoad {
    
}

// 积分墙加载失败。可能的原因由error部分提供,例如⺴⽹网络连接失败、被禁⽤用等。
- (void)offerWallDidFailLoadWithError:(NSError *)error {
    
}

// 积分墙页面被关闭。
// Offer wall closed.
- (void)offerWallDidClosed {
    
}

- (void)requestAndConsumePoint {
    if ( _request ) {
        return ;
    }
    
    _request = YES;
    
    // 查询自己的服务器来获取积分
    HttpRequest* request = [[HttpRequest alloc] init:self];
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    [request request:HTTP_TASK_OFFERWALL Param:dictionary method:@"get"];
}


-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    if ( httpCode == 200 ) {
        int res = [[body objectForKey:@"res"] intValue];
        if ( res == 0 ) {
            int offerwallIncome = [[body valueForKey:@"offerwall_income"] intValue];
            
            int userLevel = [[body valueForKey:@"level"] intValue];
            int currentEXP = [[body valueForKey:@"exp_current"] intValue];
            int nextLevelEXP = [[body valueForKey:@"exp_next_level"] intValue];
            int benefit = [[body valueForKey:@"benefit"] intValue];
            
            if (userLevel > 0)
            {
                [[LoginAndRegister sharedInstance] setUserLevel:userLevel];
                [[LoginAndRegister sharedInstance] setCurrentExp:currentEXP];
                [[LoginAndRegister sharedInstance] setNextLevelExp:nextLevelEXP];
                if (benefit > 0)
                {
                    [[LoginAndRegister sharedInstance] setBenefit:benefit];
                }
            }
            
            if ( offerwallIncome > _offerwallIncome ) {
                int diff = offerwallIncome - _offerwallIncome;
                
                _offerwallIncome = offerwallIncome;
                [self->_delegate onRequestAndConsumePointCompleted:YES Consume:diff];
            }

            _request = NO;
        } else {
            _request = NO;
        }
    } else {
        _request = NO;
    }
}

@end
