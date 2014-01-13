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
        _alertView = nil;
        
        _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:PUBLISHER_ID andUserID:deviceId];
        _offerWallController.delegate = self;
        
        _offerWallManager = [[DMOfferWallManager alloc] initWithPublishId:PUBLISHER_ID userId:deviceId];
        _offerWallManager.delegate = self;
        
        // 有米积分墙
        [YouMiConfig setUserID:deviceId];
        [YouMiConfig setUseInAppStore:YES];
        [YouMiConfig launchWithAppID:@"a33a9f68b3eb6147" appSecret:@"02b5609f193b2828"];
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
        
    UIView* view = [[[[NSBundle mainBundle] loadNibNamed:@"OnlineWallViewController" owner:self options:nil] firstObject] autorelease];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10.0;
    view.layer.borderWidth = 0.0;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
        
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
    
    [YouMiWall showOffers:YES didShowBlock:^{
    }didDismissBlock:^{
    }];
}

- (IBAction)clickDomob:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [_offerWallController presentOfferWall];
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
    [_offerWallManager requestOnlinePointCheck];
}

// 积分查询成功之后，回调该接口，获取总积分和总已消费积分。
// Called when finished to do point check.
- (void)offerWallDidFinishCheckPointWithTotalPoint:(NSInteger)totalPoint
                             andTotalConsumedPoint:(NSInteger)consumed {
    _nConsume = totalPoint - consumed;
    NSUInteger remained = [YouMiPointsManager pointsRemained];
    if ( _nConsume > 0 || remained > 0 ) {
        // 有能消费的积分
        // 报给自己的服务器获取能消费的积分数
        HttpRequest* request = [[HttpRequest alloc] init:self];
        
        NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
        NSString* nsPoint = [[[NSString alloc] initWithFormat:@"%d", totalPoint] autorelease];
        [dictionary setObject:nsPoint forKey:@"point"];
      
        [request request:HTTP_TASK_DOMOB Param:dictionary];
    }
}

// 积分查询失败之后，回调该接口，返回查询失败的错误原因。
// Called when failed to do point check.
- (void)offerWallDidFailCheckPointWithError:(NSError *)error {
    
}

#pragma mark Consume Callbacks
// 消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及总积分和总已消费积分。
- (void)offerWallDidFinishConsumePointWithStatusCode:(DMOfferWallConsumeStatusCode)statusCode
                                          totalPoint:(NSInteger)totalPoint
                                  totalConsumedPoint:(NSInteger)consumed {
}

// 消费请求异常应答后，回调该接口，并返回异常的错误原因。
// Called when failed to do consume request.
- (void)offerWallDidFailConsumePointWithError:(NSError *)error {
    
}

#pragma mark CheckOfferWall Enable Callbacks
// 获取积分墙可用状态的回调。
// Called after get OfferWall enable state.
- (void)offerWallDidCheckEnableState:(BOOL)enable {
    
}

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    if ( httpCode == 200 ) {
        int res = [[body objectForKey:@"res"] intValue];
        if ( res == 0 /*测试*/|| [YouMiPointsManager pointsRemained] > 0 ) {
            int inc = [[body objectForKey:@"increment"] intValue];
            NSUInteger remained = [YouMiPointsManager pointsRemained];
            inc = (inc+remained*10);
            if ( inc > 0 ) {
                [YouMiPointsManager spendPoints:remained];
                [self->_delegate onRequestAndConsumePointCompleted:YES Consume:(inc+remained*10)];
            }
            
            [_offerWallManager requestOnlineConsumeWithPoint:_nConsume];
        }
        
    }
}

@end
