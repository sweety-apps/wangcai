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
#import "MessageMgr.h"

#import "CommonTaskList.h"
#import "PunchBoxAd.h"
#import "PBOfferWall.h"
#import "BaseTaskTableViewController.h"

#import "DianRuAdWall.h"
//#import "AdwoOfferWall.h"
#import "MmoneMmtwo.h"
#import "WapsOffer/AppConnect.h"
#import "ComplainViewController.h"

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

-(void)setViewController:(UIViewController*) viewController {
    _viewController = viewController;
}

-(void)pushViewController:(UIViewController*) viewController {
    _backupViewController = _viewController;
    _viewController = viewController;
}

-(void)popViewController {
    _viewController = _backupViewController;
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
        
        // 触控
        [PunchBoxAd startSession:PUNCHBOX_APP_SECRET];
        [PunchBoxAd setVersion:1];
        [PBOfferWall sharedOfferWall].delegate = self;
        
        // 米迪
        [MiidiManager setAppPublisher:APP_MIIDI_ID withAppSecret:APP_MIIDI_SECRET];
        
        // 点入
        [DianRuAdWall initAdWallWithDianRuAdWallDelegate:self];
        
        // 有米积分墙
#if TEST == 1
        NSString* did = [[NSString alloc] initWithFormat:@"dev_%@", deviceId];
        
        [YouMiConfig setUserID:did];

        _mopanAdWallControl = [[MopanAdWall alloc] initWithMopan:MOPAN_APP_ID withAppSecret:MOPAN_APP_SECRET];
        [_mopanAdWallControl setCustomUserID:did];
        
        [PunchBoxAd setUserInfo:did];
        
        [MiidiAdWall setUserParam:did];
        
        // 万普
        [AppConnect getConnect:WAPS_ID pid:@"appstore" userID:did];
#else
        [YouMiConfig setUserID:deviceId];
        
        _mopanAdWallControl = [[MopanAdWall alloc] initWithMopan:MOPAN_APP_ID withAppSecret:MOPAN_APP_SECRET];
        [_mopanAdWallControl setCustomUserID:deviceId];
        
        [PunchBoxAd setUserInfo:deviceId];
        
        [MiidiAdWall setUserParam:deviceId];

        // 万普
        [AppConnect getConnect:WAPS_ID pid:@"appstore" userID:deviceId];
#endif

        [YouMiConfig setUseInAppStore:YES];
        
        [YouMiConfig launchWithAppID:YOUMI_APP_ID appSecret:YOUMI_APP_SECRET];  //服务器版
        
        [YouMiWall enable];
        [YouMiPointsManager enable];
        
        [deviceId release];
        
        [[PBOfferWall sharedOfferWall] loadOfferWall:[PBADRequest request]];
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
    
    _nRecommend = 0;
    NSMutableArray* nsOfferwall = [[[NSMutableArray alloc] init] autorelease];
    
    NSArray* offerlist = [[LoginAndRegister sharedInstance] getOfferwallList];
    for ( int i = 0; i < [offerlist count] && [nsOfferwall count] < 2; i ++ ) {
        NSString* name = [offerlist objectAtIndex:i];
        if ( [[LoginAndRegister sharedInstance] isShowOfferwall:name] && (![[LoginAndRegister sharedInstance] isInMoreOfferwall:name]) ) {
            int nTag = 0;
            if ( [name isEqualToString:@"domob"] ) {
                nTag = 11;
            } else if ( [name isEqualToString:@"youmi"] ) {
                nTag = 12;
            } else if ( [name isEqualToString:@"limei"] ) {
                nTag = 13;
            } else if ( [name isEqualToString:@"mopan"] ) {
                nTag = 15;
            } else if ( [name isEqualToString:@"punchbox"] ) {
                nTag = 16;
            } else if ( [name isEqualToString:@"miidi"] ) {
                nTag = 17;
            } else if ( [name isEqualToString:@"jupeng"] ) {
                nTag = 18;
            } else if ( [name isEqualToString:@"dianru"] ) {
                nTag = 19;
            } else if ( [name isEqualToString:@"adwo"] ) {
                nTag = 20;
            } else if ( [name isEqualToString:@"waps"] ) {
                nTag = 21;
            }
            
            [nsOfferwall pushTail:[view viewWithTag:nTag]];
            
            ASSERT(nTag != 0 );
            
            if ( [[LoginAndRegister sharedInstance] isRecommendOfferwall:name] ) {
                _nRecommend = nTag;
            }
        }
    }
    
    
    [[view viewWithTag:11] setHidden:YES];
    [[view viewWithTag:12] setHidden:YES];
    [[view viewWithTag:13] setHidden:YES];
    [[view viewWithTag:15] setHidden:YES];
    [[view viewWithTag:16] setHidden:YES];
    [[view viewWithTag:17] setHidden:YES];
    [[view viewWithTag:18] setHidden:YES];
    [[view viewWithTag:19] setHidden:YES];
    [[view viewWithTag:20] setHidden:YES];
    [[view viewWithTag:21] setHidden:YES];
    
    _moreView = [view viewWithTag:97];
    [[view viewWithTag:97] setHidden:YES];
    
    [[view viewWithTag:91] setHidden:YES];
    for ( int i = 0; i < [offerlist count]; i ++ ) {
        NSString* name = [offerlist objectAtIndex:i];
        if ( [[LoginAndRegister sharedInstance] isInMoreOfferwall:name] ) {
            [[view viewWithTag:91] setHidden:NO];
            [self repositionMore];
            break;
        }
    }
    
    if ( [nsOfferwall count] == 2 ) {
        // 显示两个按钮
        UIButton* btn1 = (UIButton*) [nsOfferwall objectAtIndex:0];
        UIButton* btn2 = (UIButton*) [nsOfferwall objectAtIndex:1];
        
        CGRect rect = btn1.frame;
        [btn1 setHidden:NO];
        rect.origin.y = 275;
        [btn1 setFrame:rect];
        
        rect = btn2.frame;
        [btn2 setHidden:NO];
        rect.origin.y = 335;
        [btn2 setFrame:rect];
    } else if ( [nsOfferwall count] == 1 ) {
        // 只显示一个按钮
        UIButton* btn1 = (UIButton*) [nsOfferwall objectAtIndex:0];
        
        CGRect rect = btn1.frame;
        [btn1 setHidden:NO];
        rect.origin.y = 310;
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

- (void)repositionMore {
    NSMutableArray* nsOfferwall = [[[NSMutableArray alloc] init] autorelease];
    
    NSArray* offerlist = [[LoginAndRegister sharedInstance] getOfferwallList];
    for ( int i = 0; i < [offerlist count]; i ++ ) {
        NSString* name = [offerlist objectAtIndex:i];
        
        if ( [[LoginAndRegister sharedInstance] isInMoreOfferwall:name] ) {
            int nTag = 0;
            if ( [name isEqualToString:@"domob"] ) {
                nTag = 51;
            } else if ( [name isEqualToString:@"youmi"] ) {
                nTag = 52;
            } else if ( [name isEqualToString:@"limei"] ) {
                nTag = 53;
            } else if ( [name isEqualToString:@"mopan"] ) {
                nTag = 55;
            } else if ( [name isEqualToString:@"punchbox"] ) {
                nTag = 56;
            } else if ( [name isEqualToString:@"miidi"] ) {
                nTag = 57;
            } else if ( [name isEqualToString:@"jupeng"] ) {
                nTag = 58;
            } else if ( [name isEqualToString:@"dianru"] ) {
                nTag = 59;
            } else if ( [name isEqualToString:@"adwo"] ) {
                nTag = 60;
            } else if ( [name isEqualToString:@"waps"] ) {
                nTag = 61;
            }
            
            [nsOfferwall pushTail:[_moreView viewWithTag:nTag]];
            
            ASSERT(nTag != 0 );
        }
    }
    
    [[_moreView viewWithTag:51] setHidden:YES];
    [[_moreView viewWithTag:52] setHidden:YES];
    [[_moreView viewWithTag:53] setHidden:YES];
    [[_moreView viewWithTag:55] setHidden:YES];
    [[_moreView viewWithTag:56] setHidden:YES];
    [[_moreView viewWithTag:57] setHidden:YES];
    [[_moreView viewWithTag:58] setHidden:YES];
    [[_moreView viewWithTag:59] setHidden:YES];
    [[_moreView viewWithTag:60] setHidden:YES];
    [[_moreView viewWithTag:61] setHidden:YES];
    
    for (int i = 0; i < [nsOfferwall count]; i ++ ) {
        UIView* btnView = [nsOfferwall objectAtIndex:i];
        [btnView setHidden:NO];
        CGRect rect = btnView.frame;
        rect.origin.y = 47 + (60 * i);
        [btnView setFrame:rect];
    }
}
    
- (IBAction)onClickBack:(id)sender {
    if ( _moreView != nil ) {
        [_moreView setHidden:YES];
    }
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

- (IBAction) clickMore:(id)sender {
    [_moreView setHidden:NO];
}

- (IBAction)clickMopan:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_mopan" attributes:@{@"currentpage":@"任务列表"}];
    
    _mopanAdWallControl.rootViewController = _viewController;
    [_mopanAdWallControl showAppOffers];
}

- (IBAction)clickPunchBox:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_punchbox" attributes:@{@"currentpage":@"任务列表"}];
    [[PBOfferWall sharedOfferWall] showOfferWallWithScale:0.9f];
   
}

- (void)pbOfferWall:(PBOfferWall *)pbOfferWall finishTaskRewardCoin:(NSArray *)taskCoins {
    
}


// 积分墙加载完成
- (void)pbOfferWallDidLoadAd:(PBOfferWall *)pbOfferWall {
    
}

// 积分墙加载错误
- (void)pbOfferWall:(PBOfferWall *)pbOfferWall loadAdFailureWithError:(PBRequestError *)requestError {
    
}

// 积分墙打开完成
- (void)pbOfferWallDidPresentScreen:(PBOfferWall *)pbOfferWall {
    
}

// 积分墙将要关闭
- (void)pbOfferWallWillDismissScreen:(PBOfferWall *)pbOfferWall {
    
}

// 积分墙关闭完成
- (void)pbOfferWallDidDismissScreen:(PBOfferWall *)pbOfferWall {
    
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
    
    WebPageController* controller = [[[WebPageController alloc] init:@"新手帮助"
                                                                 Url:url Stack:stack] autorelease];
    [stack pushViewController:controller animated:YES];
}

- (IBAction)clickComplain:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    BeeUIStack* stack = [BeeUIRouter sharedInstance].currentStack;
    ComplainViewController* controller = [[[ComplainViewController alloc] init] autorelease];
    [stack pushViewController:controller animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) dealloc {
    if ( self->_alertView != nil ) {
        [self->_alertView release];
        self->_alertView = nil;
    }
    
    [PBOfferWall sharedOfferWall].delegate = nil;
    [[PBOfferWall sharedOfferWall] closeOfferWall];
    
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
    
    int nMsgID = [[MessageMgr sharedInstance] getCurMaxID];
    [dictionary setObject:[NSString stringWithFormat:@"%d", nMsgID] forKey:@"msgid"];
    
    [request request:HTTP_TASK_OFFERWALL Param:dictionary method:@"get"];
}


-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    /*NSError* error;
    NSString* tmp = @"{\"offerwall_income\": 0, \"benefit\": 0, \"wangcai_income\": [{\"task_id\":10000,\"income\":300}], \"exp_next_level\": 2000, \"income\": 0, \"msg\": \"\", \"res\": 0, \"level\": 1, \"exp_current\": 0}";
    NSData* aData = [tmp dataUsingEncoding: NSASCIIStringEncoding];
    body = [NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingMutableLeaves error:&error];
    */
    if ( httpCode == 200 ) {
        int res = [[body objectForKey:@"res"] intValue];
        if ( res == 0 ) {
            int offerwallIncome = [[body valueForKey:@"offerwall_income"] intValue];
            
            int userLevel = [[body valueForKey:@"level"] intValue];
            int currentEXP = [[body valueForKey:@"exp_current"] intValue];
            int nextLevelEXP = [[body valueForKey:@"exp_next_level"] intValue];
            int benefit = [[body valueForKey:@"benefit"] intValue];
            BOOL newMsg = [[body valueForKey:@"new_msg"] boolValue];
            
            if ( newMsg ) {
                [[MessageMgr sharedInstance] updateMsg];
            }
            
            int levelChange = 0;
            if (userLevel > 0)
            {
                int nLevel = [[LoginAndRegister sharedInstance] getUserLevel];
                if ( nLevel < userLevel ) {
                    // 等级变化
                    levelChange = 200;
                }
                [[LoginAndRegister sharedInstance] setUserLevel:userLevel];
                [[LoginAndRegister sharedInstance] setCurrentExp:currentEXP];
                [[LoginAndRegister sharedInstance] setNextLevelExp:nextLevelEXP];
                if (benefit > 0)
                {
                    [[LoginAndRegister sharedInstance] setBenefit:benefit];
                }
                [_baseTaskTableViewController updateLevel];
            }
            
            NSArray* wangcaiIncome = [body valueForKey:@"wangcai_income"];
            int nWangcaiIncome = 0; // 旺财任务获得的钱
            if ( wangcaiIncome != nil ) {
                for ( int i = 0; i < [wangcaiIncome count]; i ++ ) {
                    NSDictionary* item = [wangcaiIncome objectAtIndex:i];
                    
                    //int taskId = [[item objectForKey:@"task_id"] intValue];
                    
                    //if ( [self isUnfinished:taskId] ) {
                    nWangcaiIncome += [[item objectForKey:@"income"] intValue];
                    //}
                }
            }
       
            if ( offerwallIncome > _offerwallIncome || nWangcaiIncome > 0 ) {
                int diff = offerwallIncome - _offerwallIncome;
                
                _offerwallIncome = offerwallIncome;
                
                [self->_delegate onRequestAndConsumePointCompleted:YES Consume:diff Level:levelChange wangcaiIncome:nWangcaiIncome];
            }

            _request = NO;
        } else {
            _request = NO;
        }
    } else {
        _request = NO;
    }
    
    [request release];
}

- (BOOL) isUnfinished:(int) taskId {
    NSArray* unfinished = [[CommonTaskList sharedInstance] getUnfinishedTaskList];
    for ( int i = 0; i < [unfinished count]; i ++ ) {
        CommonTaskInfo* obj = [unfinished objectAtIndex:i];
        if ( [obj.taskId intValue] == taskId ) {
            return YES;
        }
    }
    
    return NO;
}

- (void) open:(NSString*) name {
    if ( [name isEqualToString:@"limei"] ) {
        [self clickLimei:nil];
    } else if ( [name isEqualToString:@"mopan"] ) {
        [self clickMopan:nil];
    } else if ( [name isEqualToString:@"youmi"] ) {
        [self clickYoumi:nil];
    } else if ( [name isEqualToString:@"domob"] ) {
        [self clickDomob:nil];
    } else if ( [name isEqualToString:@"punchbox"] ) {
        [self clickPunchBox:nil];
    } else if ( [name isEqualToString:@"miidi"] ) {
        [self clickMiidi:nil];
    } else if ( [name isEqualToString:@"jupeng"] ) {
        [self clickJupeng:nil];
    } else if ( [name isEqualToString:@"dianru"] ) {
        [self clickDianru:nil];
    } else if ( [name isEqualToString:@"adwo"] ) {
        [self clickAdwo:nil];
    } else if ( [name isEqualToString:@"waps"] ) {
        [self clickWaps:nil];
    }
}

- (IBAction)clickWaps:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_waps" attributes:@{@"currentpage":@"任务列表"}];
    
    [AppConnect showOffers:_viewController];
}

- (IBAction)clickMiidi:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_miidi" attributes:@{@"currentpage":@"任务列表"}];
    
    [MiidiAdWall showAppOffers:_viewController withDelegate:self];
}

- (IBAction)clickDianru:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_dianru" attributes:@{@"currentpage":@"任务列表"}];
    [DianRuAdWall showAdWall:_viewController];
}

- (IBAction)clickAdwo:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    // 安沃
    NSString* deviceId = [[LoginAndRegister sharedInstance] getDeviceId];
#if TEST == 1
    NSString* userid = [NSString stringWithFormat:@"dev_%@", deviceId];
#else
    NSString* userid = [NSString stringWithFormat:@"%@", deviceId];
#endif
    
    NSArray *arr = [NSArray arrayWithObjects:userid, nil];
    MmoneOWSetKeywords(arr);
    //AdwoOWSetKeywords(arr);
    
    [deviceId release];
    
    [MobClick event:@"task_list_click_adwo" attributes:@{@"currentpage":@"任务列表"}];
    MmoneOWPresentMmtwo(ADWO_OFFERWALL_BASIC_PID, _viewController);
    //AdwoOWPresentOfferWall(ADWO_OFFERWALL_BASIC_PID, _viewController);
}

- (NSString *)applicationKey {
    return @"00003215130000F0";
}

- (NSString*) dianruAdWallAppUserId {
    NSString* deviceId = [[LoginAndRegister sharedInstance] getDeviceId];
#if TEST == 1
    NSString* userid = [NSString stringWithFormat:@"dev_%@", deviceId];
#else
    NSString* userid = [NSString stringWithFormat:@"%@", deviceId];
#endif

    [deviceId release];
    
    return userid;
}

@end
