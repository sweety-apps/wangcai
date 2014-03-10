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
#import "BeeUIBoard+ModalBoard.h"
#import "WebPageController.h"

#import "SiWeiAdConfig.h"
#import "SiWeiPointsManger.h"

#import "BaseTaskTableViewController.h"

@interface OnlineWallViewController ()

@end

@implementation OnlineWallViewController
@synthesize adView_adWall;
@synthesize delegate = _delegate;

static OnlineWallViewController* _sharedInstance;

+(OnlineWallViewController*) sharedInstance {
    if ( _sharedInstance == nil ) {
        _sharedInstance = [[OnlineWallViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    return _sharedInstance;
}

-(void)setViewController:(UIViewController*) viewController {
    _viewController = viewController;
}

-(void)setTaskTableViewController:(BaseTaskTableViewController*)taskTableViewController {
    _baseTaskTableViewController = taskTableViewController;
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
        _baseTaskTableViewController = nil;
        
        // 有米积分墙
#if TEST == 1
        NSString* did = [[NSString alloc] initWithFormat:@"dev_%@", deviceId];
        
        _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:DOMOB_PUBLISHER_ID andUserID:did];
        _offerWallController.delegate = self;
        
        [YouMiConfig setUserID:did];
        
        [SiWeiAdConfig launchWithAppID:MOBSMAR_APP_ID];//初始化appid
        [SiWeiAdConfig setDeveloperParam:did];
        [SiWeiPointsManger enableSiweiWall];
        
        _mopanAdWallControl = [[MopanAdWall alloc] initWithMopan:MOPAN_APP_ID withAppSecret:MOPAN_APP_SECRET];
        [_mopanAdWallControl setCustomParam:did];
#else 
        _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:DOMOB_PUBLISHER_ID andUserID:deviceId];
        _offerWallController.delegate = self;

        [YouMiConfig setUserID:deviceId];
        
        [SiWeiAdConfig launchWithAppID:MOBSMAR_APP_ID];//初始化appid
        [SiWeiAdConfig setDeveloperParam:deviceId];
        [SiWeiPointsManger enableSiweiWall];
        
        _mopanAdWallControl = [[MopanAdWall alloc] initWithMopan:MOPAN_APP_ID withAppSecret:MOPAN_APP_SECRET];
        [_mopanAdWallControl setCustomParam:deviceId];
#endif
        
        _siweWall = [SiWeiWall siwei];
        
        [YouMiConfig setUseInAppStore:YES];
        
        [YouMiConfig launchWithAppID:YOUMI_APP_ID appSecret:YOUMI_APP_SECRET];  //服务器版
        
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
    BOOL showLimei = [[LoginAndRegister sharedInstance] isShowLimei];
    BOOL showMobsmar = [[LoginAndRegister sharedInstance] isShowMobsmar];
    BOOL showMopan = [[LoginAndRegister sharedInstance] isShowMopan];
    
    UIView* view = [[[[NSBundle mainBundle] loadNibNamed:@"OnlineWallViewController" owner:self options:nil] firstObject] autorelease];
    
    _nRecommend = 0;
    NSMutableArray* nsOfferwall = [[[NSMutableArray alloc] init] autorelease];
    if ( showDomob ) {
        [nsOfferwall pushTail:[view viewWithTag:11] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendDomob] ) {
            _nRecommend = 11;
        }
    }
    if ( showYoumi ) {
        [nsOfferwall pushTail:[view viewWithTag:12] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendYoumi] ) {
            _nRecommend = 12;
        }
    }
    if ( showLimei && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:13] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendLimei] ) {
            _nRecommend = 13;
        }
    }
    
    if ( showMobsmar && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:14] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendMobsmar] ) {
            _nRecommend = 14;
        }
    }
    
    if ( showMopan && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:15] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendMopan] ) {
            _nRecommend = 15;
        }
    }
    
    [[view viewWithTag:11] setHidden:YES];
    [[view viewWithTag:12] setHidden:YES];
    [[view viewWithTag:13] setHidden:YES];
    [[view viewWithTag:14] setHidden:YES];
    [[view viewWithTag:15] setHidden:YES];
    
    if ( [nsOfferwall count] == 2 ) {
        // 显示两个按钮
        UIButton* btn1 = (UIButton*) [nsOfferwall objectAtIndex:0];
        UIButton* btn2 = (UIButton*) [nsOfferwall objectAtIndex:1];
        
        CGRect rect = btn1.frame;
        [btn1 setHidden:NO];
        rect.origin.y = 321;
        [btn1 setFrame:rect];
        
        rect = btn2.frame;
        [btn2 setHidden:NO];
        rect.origin.y = 380;
        [btn2 setFrame:rect];
    } else if ( [nsOfferwall count] == 1 ) {
        // 只显示一个按钮
        UIButton* btn1 = (UIButton*) [nsOfferwall objectAtIndex:0];
        
        CGRect rect = btn1.frame;
        [btn1 setHidden:NO];
        rect.origin.y = 360;
        [btn1 setFrame:rect];
    } else {
        return ;
    }
    
    if ( _nRecommend != 0 ) {
        UIView* btnView = [view viewWithTag:_nRecommend];
        [[view viewWithTag:22] setFrame:btnView.frame];
        [[view viewWithTag:22] setHidden:NO];
    } else {
        [[view viewWithTag:22] setHidden:YES];
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

- (IBAction)clickMobsmar:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_mobsmar" attributes:@{@"currentpage":@"任务列表"}];
    [_siweWall showOfferWall:_viewController];//打开积分墙
}

- (IBAction)clickMopan:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_mopan" attributes:@{@"currentpage":@"任务列表"}];
    
    _mopanAdWallControl.rootViewController = _viewController;
    [_mopanAdWallControl showAppOffers];
}

- (IBAction)clickLimei:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_limei" attributes:@{@"currentpage":@"任务列表"}];
    [self enterAdWall];
}

// 进入积分墙
-(void)enterAdWall{
    // 实例化 immobView 对象,在此处替换在力美广告平台申请到的广告位 ID;
    self.adView_adWall=[[immobView alloc] initWithAdUnitID:LIMEI_ID];
    //添加 immobView 的 Delegate;
    self.adView_adWall.delegate=self;

    //添加 userAccount 属性,此属性针对多账户应用所使用,用于区分不同账户下的积分(可选)。
    NSString* deviceId = [[LoginAndRegister sharedInstance] getDeviceId];
#if TEST == 1
    NSString* did = [[NSString alloc] initWithFormat:@"dev_%@", deviceId];
    [self.adView_adWall.UserAttribute setObject:did forKey:@"accountname"];
#else
    [self.adView_adWall.UserAttribute setObject:deviceId forKey:@"accountname"];
#endif
    
    [deviceId release];
    
    //开始加载广告。
    [self.adView_adWall immobViewRequest];
    
    UIView* view = _viewController.view;
    
    //将 immobView 添加到界面上。
    [view addSubview:adView_adWall];
    
    //将 immobView 添加到界面后,调用 immobViewDisplay。
    [self.adView_adWall immobViewDisplay];
}

// 设置必需的 UIViewController, 此方法的返回值如果为空,会导致广告展示不正常。
- (UIViewController *)immobViewController{
    return _viewController;
}

- (void) immobView: (immobView*) immobView didFailReceiveimmobViewWithError: (NSInteger) errorCode {
    
}

- (void) immobViewDidReceiveAd:(immobView*)immobView {
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

- (IBAction)clickHelper:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    BeeUIStack* stack = [BeeUIRouter sharedInstance].currentStack;
    
    NSString* url = [[[NSString alloc] initWithFormat:@"%@132", WEB_SERVICE_VIEW] autorelease];
    
    WebPageController* controller = [[[WebPageController alloc] init:@"重要提示"
                                                                 Url:url Stack:stack] autorelease];
    [stack pushViewController:controller animated:YES];
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
                [_baseTaskTableViewController updateLevel];
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
