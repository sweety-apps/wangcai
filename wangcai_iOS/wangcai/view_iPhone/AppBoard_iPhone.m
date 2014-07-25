//
//  AppBoard_iPhone.m
//  wangcai
//
//  Created by Lee Justin on 13-12-8.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "AppBoard_iPhone.h"
#import "MenuBoard_iPhone.h"
#import "LoginAndRegister.h"
#import "PhoneValidationController.h"
#import "OnlineWallViewController.h"
#import "MobClick.h"
#import "WebPageController.h"
#import "MBHUDView.h"
#import "YouMiConfig.h"
#import "YouMiWall.h"
#import "Config.h"
#import "HttpRequest.h"
#import "Common.h"
#import "Config.h"
#import "CommonTaskList.h"
#import "CommonTaskTableViewCell.h"
#import "InstallAppAlertView.h"
#import "AppDelegate.h"

#define SHOW_MASK (0)

#pragma mark -

#undef	MENU_BOUNDS
#define	MENU_BOUNDS	(210.0f)
#undef	MASK_LEFT_X
#define	MASK_LEFT_X	(160.0f)
#undef MENU_TRIGER_BOUNDS
#define	MENU_TRIGER_BOUNDS	(100.0f)

#undef ROTATE_PAN_MENU
#define ROTATE_PAN_MENU 0

#pragma mark -

@implementation AppBoard_iPhone
{
	BeeUIButton *	_mask;
	CGRect			_origFrame;
    BOOL            _hasPanOpened;
    YouMiWallAppModel *destYouMi;
    NSString *wapsurl;
    HttpRequest *_request;
    BOOL _bRequest;
    BOOL _firstRequest;
    NSArray *_list;//旺财自营任务
    InstallAppAlertView *install;
    CommonTaskInfo *wangcaiTask;
    UICustomAlertView *custAlert;
}

DEF_SINGLETON( AppBoard_iPhone )

+ (void)load
{
}

- (void)load
{
	[super load];
    _alertView = nil;
    _remoteNotificationTitle = nil;
    _remoteNotificationUrl = nil;
    _notification = nil;
    _appId = nil;
    _points = nil;
    _pointsLimit = nil;
    
    _wapCustom = [[WapsOfferCustom alloc] init];//在viewDidLoad⽅方法中!
    _wapCustom.delegate = self;//设置当前对象为wapCumtom的代理!
    
    if ( [[LoginAndRegister sharedInstance] isInReview] ) {
        _adView = [[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:nil];
        _adView.indicateTranslucency = YES;
        _adView.indicateRounded = NO;
        [_adView start];
    } else {
        _adView = nil;
    }
}

- (void)unload
{
    if ( _alertView != nil ) {
        [_alertView release];
    }
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self observeNotification:@"showMenu"];
        
        self.view.backgroundColor = [UIColor whiteColor];

		MenuBoard_iPhone * menu = [MenuBoard_iPhone sharedInstance];
		menu.parentBoard = self;

		[self.view addSubview:menu.view];
        
		BeeUIRouter * router = [BeeUIRouter sharedInstance];
		router.parentBoard = self;
		[self.view addSubview:router.view];

		_mask = [BeeUIButton new];
        if (SHOW_MASK)
        {
            _mask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        }
        else
        {
            _mask.backgroundColor = [UIColor clearColor];
        }
		_mask.hidden = YES;
		_mask.signal = @"mask";
        _mask.alpha = 1.0;
		[self.view addSubview:_mask];
        
		[menu selectItem:@"wc_main" animated:NO];
        _hasPanOpened = NO;
        
		[router open:@"wc_main"];
        
        if ( _adView != nil ) {
            CGRect rect = _adView.frame;
            rect.size.height = 50;
            rect.size.width = 320;
            rect.origin.x = 0;
            rect.origin.y = [[UIScreen mainScreen] bounds].size.height - 50;
            
            UIView* view = [[UIView alloc] initWithFrame:rect];
            [view addSubview:_adView];
            [self.view addSubview:view];
        }
        //[self _preOpenBoards:router];
        
        
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        [self unobserveNotification:@"showMenu"];
		SAFE_RELEASE_SUBVIEW( _mask );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
	}
	else if ( [signal is:BeeUIBoard.DID_APPEAR] )
	{
		//[BeeUIRouter sharedInstance].view.pannable = YES;
        //_mask.pannable = YES;
        if ( _origFrame.size.height == 0 && _origFrame.size.width == 0 ) {
            _origFrame = [BeeUIRouter sharedInstance].view.frame;
        }
        
        if ( _remoteNotificationTitle != nil ) {
            BeeUIStack* stack = [BeeUIRouter sharedInstance].currentStack;
            
            WebPageController* controller = [[[WebPageController alloc] init:_remoteNotificationTitle
                                                                         Url:_remoteNotificationUrl Stack:stack] autorelease];
            [stack pushViewController:controller animated:YES];
            
            [_remoteNotificationTitle release];
            _remoteNotificationTitle = nil;
            [_remoteNotificationUrl release];
            _remoteNotificationUrl = nil;
        } else if ( _notification != nil ) {
            [self installAppFromRomoteNotification:_notification];
            [_notification release];
            _notification = nil;
        }
	}
	else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
		//[BeeUIRouter sharedInstance].view.pannable = NO;
        //_mask.pannable = NO;
	}
	else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
	{
	}
}


- (void)setPanable:(BOOL)panable
{
    [BeeUIRouter sharedInstance].view.pannable = panable;
    _mask.pannable = panable;
}

ON_SIGNAL2( UIView, signal )
{
    if ( [signal is:UIView.PAN_START]  )
    {
        [self syncPanPosition];
    }
    else if ( [signal is:UIView.PAN_CHANGED]  )
    {
        [self syncPanPosition];
    }
    else if ( [signal is:UIView.PAN_STOP] || [signal is:UIView.PAN_CANCELLED] )
    {
        [self syncPanPosition];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3f];

		BeeUIRouter * router = [BeeUIRouter sharedInstance];
		
		if ( router.view.left <= MENU_TRIGER_BOUNDS )
		{
			router.view.left = 0;
			
            router.view.transform = CGAffineTransformIdentity;
			_mask.frame = CGRectMake( 0.0, 0.0, _origFrame.size.width, _origFrame.size.height );
            _mask.alpha = 1.0f;
            router.view.frame = _mask.frame;
			
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didMenuHidden)];
		}
		else
		{
            router.view.transform = CGAffineTransformIdentity;
            
            CGFloat panOffsetX = MENU_BOUNDS;
            router.view.frame = CGRectOffset( _origFrame, panOffsetX, 0 );
            router.view.bounds = router.view.frame;
            CGRect currentBounds = router.view.bounds;
            router.view.center = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
            CGFloat boundsX = currentBounds.origin.x;
            if (boundsX < 0)
            {
                INFO(@"<WHY??>");
            }
            CGFloat angle = (boundsX * M_PI / 5120.f);
            if (ROTATE_PAN_MENU)
            {
                router.view.transform = CGAffineTransformMakeRotation(angle);
                INFO(@"<Angle Rotated> A = %f, Off = %f",angle,boundsX);
            }
            
            CGRect rectNewBounds = router.view.bounds;
            CGFloat offsetY = tan(0.5*angle) * boundsX;
            
            if (ROTATE_PAN_MENU)
            {
                rectNewBounds.origin.y = offsetY;
            }
            else
            {
                rectNewBounds.origin.y = 0;
            }
            
            router.view.frame = rectNewBounds;
            
			_mask.frame = CGRectMake( MASK_LEFT_X, 0.0, _origFrame.size.width - MASK_LEFT_X, _origFrame.size.height );
			_mask.alpha = 1.0f;
            
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didMenuShown)];
		}
		
		[UIView commitAnimations];
    }
}

ON_SIGNAL2( mask, signal )
{
	[self hideMenu];
}

ON_SIGNAL3( BeeUIRouter, WILL_CHANGE, signal )
{
}

ON_SIGNAL3( BeeUIRouter, DID_CHANGED, signal )
{
	[[MenuBoard_iPhone sharedInstance] selectItem:[BeeUIRouter sharedInstance].currentStack.name animated:YES];
}

ON_SIGNAL3( MenuBoard_iPhone, first, signal )
{
    [self hideMenu];
    [MobClick event:@"click_buy_item" attributes:@{@"currentpage":@"菜单"}];
	[[BeeUIRouter sharedInstance] open:@"first" animated:YES];
}

ON_SIGNAL3( MenuBoard_iPhone, second, signal )
{
    [self hideMenu];
    [MobClick event:@"click_extract_money" attributes:@{@"current_page":@"菜单"}];
	[[BeeUIRouter sharedInstance] open:@"second" animated:YES];
}

ON_SIGNAL3( MenuBoard_iPhone, my_wangcai, signal )
{
    [self hideMenu];
    [MobClick event:@"click_extract_money" attributes:@{@"current_page":@"菜单"}];
	[[BeeUIRouter sharedInstance] open:@"my_wangcai" animated:YES];
}

ON_SIGNAL3( MenuBoard_iPhone, third, signal )
{
    [self hideMenu];
    [MobClick event:@"click_setting" attributes:@{@"current_page":@"菜单"}];
	[[BeeUIRouter sharedInstance] open:@"third" animated:YES];
}

ON_SIGNAL3( MenuBoard_iPhone, wc_main, signal )
{
    [self hideMenu];
    //static BOOL isFirstShow = YES;
	[[BeeUIRouter sharedInstance] open:@"wc_main" animated:YES];
    //if (!isFirstShow)
    //{
        [self postNotification:@"naviToUserInfoEditor"];
    //}
    //isFirstShow = NO;
	
	
}

- (void)onTouchedInvite:(BOOL)switchToFillInvitedCodeView
{
    // 判断是否绑定了手机
    NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
    if ( phoneNum == nil || [phoneNum isEqualToString:@""] ) {
        if ( _alertView != nil ) {
            [_alertView release];
        }
        
        if ( phoneNum != nil ) {
            [phoneNum release];
        }
        
        _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定手机，请先绑定手机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定手机", nil];
        [_alertView show];
    } else {
        [phoneNum release];
        [self hideMenu];
        
        if (!switchToFillInvitedCodeView)
        {
            [[BeeUIRouter sharedInstance] open:@"invite" animated:YES];
        }
        else
        {
            [[BeeUIRouter sharedInstance] open:@"invite_fill_code" animated:YES];
        }
        
    }
}

ON_SIGNAL3( MenuBoard_iPhone, invite, signal )
{
    [MobClick event:@"click_invite_redbag" attributes:@{@"current_page":@"菜单"}];
    [self onTouchedInvite:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( [_alertView isEqual:alertView] ) {
        if ( buttonIndex == 1 ) {
            [self hideMenu];
            [[BeeUIRouter sharedInstance] open:@"phone_validation" animated:YES];
            
            
        }
    }
    if(alertView.tag == 10010)//有米
    {
        if(buttonIndex == 0){
             [YouMiWall userInstallApp:destYouMi];
             [MobClick event:@"remote_click_install" attributes:@{@"current_page":@"推送安装App"}];
        }else
        {
            [MobClick event:@"remote_cancel_install" attributes:@{@"current_page":@"推送安装App"}];
        }
    }
    if(alertView.tag == 10086)//waps
    {
        if(buttonIndex == 0){
            [_wapCustom listOnClick:wapsurl];
             [MobClick event:@"remote_click_install" attributes:@{@"current_page":@"推送安装App"}];
        }else
        {
            [MobClick event:@"remote_cancel_install" attributes:@{@"current_page":@"推送安装App"}];
        }
    }
}

ON_SIGNAL3( MenuBoard_iPhone, service, signal)
{
    [self hideMenu];
    //统计
    [MobClick event:@"click_help" attributes:@{@"current_page":@"menu"}];
	[[BeeUIRouter sharedInstance] open:@"service" animated:YES];
	
}

ON_SIGNAL3( MenuBoard_iPhone, team, signal )
{
    [self hideMenu];
    [[BeeUIRouter sharedInstance] open:@"team" animated:YES];
	
}

ON_SIGNAL3( MenuBoard_iPhone, busioness, signal )
{
    [self hideMenu];
	[[BeeUIRouter sharedInstance] open:@"busioness" animated:YES];
	
}

- (void)didMenuHidden
{
	_mask.hidden = YES;
    _hasPanOpened = NO;
}

- (void)didMenuShown
{
	BeeUIRouter * router = [BeeUIRouter sharedInstance];

	_mask.frame = CGRectMake( MASK_LEFT_X, 0.0, router.width - MASK_LEFT_X, router.height );
	_mask.hidden = NO;
    _hasPanOpened = YES;
}

- (void)syncPanPosition
{
	BeeUIRouter * router = [BeeUIRouter sharedInstance];
    
    router.view.transform = CGAffineTransformIdentity;
	CGFloat panOffsetX = router.view.panOffset.x;
    if (_hasPanOpened)
    {
        panOffsetX = MENU_BOUNDS + _mask.panOffset.x;
        if((MENU_BOUNDS + panOffsetX) < 0.f)
        {
            panOffsetX = 0.f;
        }
    }
    else
    {
        panOffsetX = router.view.panOffset.x;
        if((_origFrame.origin.x + panOffsetX) < 0.f)
        {
            panOffsetX = 0.f;
        }
    }
    [self syncPanPositionWithOffsetX:panOffsetX];
}


- (void)syncPanPositionWithOffsetX:(CGFloat)panOffsetX
{
	BeeUIRouter * router = [BeeUIRouter sharedInstance];
    router.view.transform = CGAffineTransformIdentity;
    
    router.view.frame = CGRectOffset( _origFrame, panOffsetX, 0 );
    router.view.bounds = router.view.frame;
    CGRect currentBounds = router.view.bounds;
    router.view.center = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    CGFloat boundsX = currentBounds.origin.x;
    if (boundsX < 0)
    {
        INFO(@"<WHY??>");
    }
    CGFloat angle = (boundsX * M_PI / 5120.f);
    if (ROTATE_PAN_MENU)
    {
        router.view.transform = CGAffineTransformMakeRotation(angle);
        INFO(@"<Angle Rotated> A = %f, Off = %f",angle,boundsX);
    }
    
    CGRect rectNewBounds = router.view.bounds;
    CGFloat offsetY = tan(0.5*angle) * boundsX;
    if (ROTATE_PAN_MENU)
    {
        rectNewBounds.origin.y = offsetY;
    }
    else
    {
        rectNewBounds.origin.y = 0;
    }
    router.view.frame = rectNewBounds;
    
	if ( router.view.left <= 0.0f )
	{
		_mask.hidden = YES;
		_mask.alpha = 0.0f;
	}
	else if ( router.view.left >= MENU_BOUNDS )
	{
		_mask.hidden = NO;
		_mask.alpha = 1.0f;
	}
	else
	{
		_mask.hidden = NO;
        _mask.alpha = 1.0f - (MENU_BOUNDS - router.view.left) / MENU_BOUNDS;
	}
    
	_mask.frame = CGRectMake( router.view.left, 0.0, router.width, router.height );
}

- (void)showMenu
{
	//BeeUIRouter * router = [BeeUIRouter sharedInstance];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didMenuShown)];

    [self syncPanPositionWithOffsetX:MENU_BOUNDS];
	
	[UIView commitAnimations];
}

- (void)hideMenu
{
	BeeUIRouter * router = [BeeUIRouter sharedInstance];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didMenuHidden)];
	
    router.view.transform = CGAffineTransformIdentity;
	router.view.frame = CGRectMake( 0.0, 0.0, router.width, router.height );
	
	_mask.frame = CGRectMake( 0.0, 0.0, router.width, router.height );
	_mask.alpha = 0.0f;
	
	[UIView commitAnimations];
}

#pragma mark Notification

ON_NOTIFICATION( notification )
{
	if ([notification.name isEqualToString:@"showMenu"])
    {
        [self showMenu];
    }
}

#pragma mark Message

ON_MESSAGE( message )
{
	
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void) openUrlFromRomoteNotification : (NSString*) title Url:(NSString*) url {
    _remoteNotificationTitle = [title copy];
    _remoteNotificationUrl = [url copy];
}

- (void) showLoading {
    [MBHUDView hudWithBody:@"加载任务中..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
}

- (void) hideLoading {
    [MBHUDView dismissCurrentHUD];
}

- (void) notificationInstallApp:(NSDictionary*) remoteNotifications {
    _notification = [remoteNotifications copy];
}

- (void) buildPointsArray:(NSString*) appid points:(NSString*) points {
    if(_appId)
    {
        [_appId release];
    }
    _appId = [[appid componentsSeparatedByString:@","] retain];
    if(_points)
    {
        [_points release];
    }
    _points = [[NSMutableArray alloc]init];
    if(_pointsLimit)
    {
        [_pointsLimit release];
    }
    _pointsLimit = [[NSMutableArray alloc]init];
    NSArray *origin = [points componentsSeparatedByString:@","];
    for (NSString *p in origin)
    {
        NSArray *source = [p componentsSeparatedByString:@"-"];
        [_points addObject:[source objectAtIndex:0]];
        [_pointsLimit addObject:[source objectAtIndex:1]];
    }
    
   /* if(_appId)
    {
        [_appId release];
    }
    _appId = [appid componentsSeparatedByString:@","];
    _appId = [[NSMutableArray alloc] init];
    while ( YES ) {
        NSRange range = [appid rangeOfString:@","];
        if ( range.length == 0 ) {
            [_appId addObject:appid];
            break;
        } else {
            // 左边
            NSString* left = [appid substringToIndex:range.location];
            NSString* right = [appid substringFromIndex:range.location + range.length];
            
            appid = right;
            [_appId addObject:left];
        }
    }
    
    if(_points)
    {
        [_points release];
    }
    _points = [[NSMutableArray alloc] init];
    if(_pointsLimit)
    {
        [_pointsLimit release];
    }
    _pointsLimit = [[NSMutableArray alloc] init];

    while ( YES ) {
        NSRange range = [points rangeOfString:@","];
        if ( range.length == 0 ) {
            NSRange tmp = [points rangeOfString:@"-"];
            if ( tmp.length == 0 ) {
                [_points addObject:points];
                [_pointsLimit addObject:@"0"];
            } else {
                NSString* point = [points substringToIndex:tmp.location];
                NSString* limit = [points substringFromIndex:tmp.location + tmp.length];
                [_points addObject:point];
                [_pointsLimit addObject:limit];
            }

            break;
        } else {
            // 左边
            NSString* left = [points substringToIndex:range.location];
            NSString* right = [points substringFromIndex:range.location + range.length];
            
            points = right;
            
            NSRange tmp = [left rangeOfString:@"-"];
            if ( tmp.length == 0 ) {
                [_points addObject:left];
                [_pointsLimit addObject:@"0"];
            } else {
                NSString* point = [left substringToIndex:tmp.location];
                NSString* limit = [left substringFromIndex:tmp.location + tmp.length];
                [_points addObject:point];
                [_pointsLimit addObject:limit];
            }
        }
    }
    */
}
- (int)isAppInPush :(NSString*)appId :(NSArray*)source
{
    for (int i = 0; i < source.count; i++)
    {
        if([[source objectAtIndex:i] isEqualToString:appId])
            return i;//返回当前appid的积分策略的索引
    }
    return -1;//表示未找到
}
- (void) installAppFromRomoteNotification:(NSDictionary*) remoteNotifications {
    [MobClick event:@"remote_notify_install_app" attributes:@{@"current_page":@"推送安装App"}];
    if ( [[remoteNotifications allKeys] containsObject:@"youmi"] )
    {
        NSString* appid = [remoteNotifications valueForKey:@"youmi"];
        NSString* points = [remoteNotifications valueForKey:@"points"];
        [self showLoading];
        
        [self buildPointsArray:appid points:points];
        
//        [YouMiWall requestOffersOpenData:YES revievedBlock:^(NSArray *theApps, NSError *error) {
//            [self hideLoading];
//            if (!error) {
//                for ( int i = 0; i < [theApps count]; i ++ ) {
//                    YouMiWallAppModel *model = theApps[i];
//                    NSInteger storeID = [model appStoreID];
//                     NSLog(@"应用:%d",storeID);
//                     NSLog(@"积分:%d",[model points]);
//                    NSString* sid = [NSString stringWithFormat:@"%d", storeID];
//                    if ( [sid isEqualToString:appid] ) {
//                        [YouMiWall userInstallApp:model];
//                        break;
//                    }
//                }
//            }
//        }];
        //zgw change
        [YouMiWall requestOffersOpenData:YES revievedBlock:^(NSArray *theApps, NSError *error) {
            [self hideLoading];
            BOOL isfindOne = NO;
            if (!error)
            {
                for ( int i = 0; i < [theApps count]; i ++ )
                {
                    YouMiWallAppModel *model = theApps[i];
                    NSInteger storeID = [model appStoreID];
                    NSLog(@"%d",storeID);
                    int index = [self isAppInPush:[NSString stringWithFormat:@"%d",storeID] :_appId];
                    
                    if(index == -1){
                        continue;
                    }
                    NSInteger point = [model points];
                    int limit = [[_pointsLimit objectAtIndex:index] integerValue];
                    if(limit < point)
                    {
                        destYouMi = [model retain];
                        isfindOne = YES;
                         int pay = [[_points objectAtIndex:index] integerValue];
                        NSString *money = [NSString stringWithFormat:@"%f",pay/10.f];
                        money = [money substringToIndex:3];
                        install = [[InstallAppAlertView alloc]initWithIcon:[model smallIconURL] title:[model name] desc:[model desc] target:self install:@selector(install) cancel:@selector(cancel) money:money];
                        custAlert = [[UICustomAlertView alloc]init:install];
                        [custAlert show];
                        install.tag = 10010;
                        [install release];
                        break;
                    }
                }
                if(!isfindOne)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您来晚了,任务已经被抢光了!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    [alert release];
                }
            }
        }];
    } else if ( [[remoteNotifications allKeys] containsObject:@"waps"] )
    {
        NSString* appid = [remoteNotifications valueForKey:@"waps"];
        NSString* points = [remoteNotifications valueForKey:@"points"];
        
        [self showLoading];

        [self buildPointsArray:appid points:points];
        
        [_wapCustom loadCustomData]; //调⽤用WapsCustom的loadCustomData⽅方法,请求广告墙数据
    }else if( [[remoteNotifications allKeys] containsObject:@"wangcai"])
    {
        NSString* appid = [remoteNotifications valueForKey:@"wangcai"];
        NSString* points = [remoteNotifications valueForKey:@"points"];
         [self buildPointsArray:appid points:points];
        [self performSelector:@selector(requestList) withObject:nil afterDelay:1.f];
        //[self requestList];
    }
}

- (void)cancel
{
    [MobClick event:@"remote_cancel_install" attributes:@{@"current_page":@"推送安装App"}];
    [custAlert hideAlertView];
   
     [custAlert release];
    install = nil;
}
- (void)install
{
    if(install.tag == 10010)//有米
    {
        [YouMiWall userInstallApp:destYouMi];

    }
    if(install.tag == 10086)//waps
    {
        [_wapCustom listOnClick:wapsurl];
    }
    
    if(install.tag == 10011)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:wangcaiTask.taskRediectUrl]];
    }
    [MobClick event:@"remote_click_install" attributes:@{@"current_page":@"推送安装App"}];
    [custAlert hideAlertView];
    [custAlert release];
    install = nil;
}
//参数:flg为真时,表明正在请求数据;flg为假时,数据请求完成.
- (void)isLoading:(BOOL)flg {
    
}

//参数:offersJson为下载完成后的字符串数据.
- (void)getCustomDataWithJson:(NSString *)offersJson {
    
}

//参数:offersArray为下载完成后的数组数据,数组中的内容为字典格式.
- (void)getCustomDataWithArray:(NSArray *)offersArray {
    [self hideLoading];
    NSDictionary* dict = offersArray[0];
     BOOL isfindOne = NO;
    for (NSDictionary *info in offersArray)
    {
        int point = [[dict objectForKey:@"points"] integerValue];
        NSString *appId = [dict objectForKey:@"ad_id"];
        NSLog(@"%@",appId);
        int index = [self isAppInPush:appId :_appId];
        if(index == -1)
            continue;
        int limit = [[_pointsLimit objectAtIndex:index] integerValue];
        if(limit < point)
        {
            isfindOne = YES;
            if(wapsurl)
            {
                [wapsurl release];
            }
            int pay = [[_points objectAtIndex:index] integerValue];
            wapsurl = [[dict objectForKey:@"click_url"] retain];
            NSString *money = [NSString stringWithFormat:@"%f",pay/10.f];
            money = [money substringToIndex:3];
            install = [[InstallAppAlertView alloc]initWithIcon:[dict objectForKey:@"icon"] title:[dict objectForKey:@"title"] desc:[dict objectForKey:@"info"] target:self install:@selector(install) cancel:@selector(cancel) money:money];
            install.tag = 10086;
            custAlert = [[UICustomAlertView alloc]init:install];
            [custAlert show];
            [install release];
            break;
        }
    }
    if(!isfindOne)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您来晚了,任务已经被抢光了!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

//参数:errorInfo为下载失败后的信息.
- (void)getCustomDataFaile:(NSString *)errorInfo {
    [self hideLoading];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"任务加载失败!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
}

- (void) showLoading:(NSString*) tip {
    [MBHUDView hudWithBody:tip type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
}
- (void) requestList {
    if ( _bRequest ) {
        return;
    }
    
    _bRequest = YES;
    
    if ( _firstRequest ) {
        [self showLoading:@"请等待..."];
    }
    
    if ( _request != nil ) {
        [_request release];
    }
    
    _request = [[HttpRequest alloc] init:self];
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    NSString* timestamp = [Common getTimestamp];
    [dictionary setObject:timestamp forKey:@"stamp"];
    NSDictionary* dic = [[NSBundle mainBundle] infoDictionary];
    NSString* appVersion = [dic valueForKey:@"CFBundleVersion"];
    [dictionary setObject:appVersion forKey:@"ver"];
    [dictionary setObject:APP_NAME forKey:@"app"];
    [_request request:HTTP_TASK_APP_LIST Param:dictionary method:@"get"];
}

- (NSArray*) copyList:(NSArray*) list {
    NSMutableArray* unfinished = [[NSMutableArray alloc] init];
    NSMutableArray* finished = [[NSMutableArray alloc] init];
    
    for ( int i = 0; i < [list count]; i ++ ) {
        NSDictionary* taskDict = [list objectAtIndex:i];
        
        CommonTaskInfo* task = [[[CommonTaskInfo alloc] init] autorelease];
        task.taskIconUrl = [taskDict objectForKey:@"icon"];
        task.taskId = [taskDict objectForKey:@"id"];
        task.taskType = [taskDict objectForKey:@"type"];
        task.taskTitle = [taskDict objectForKey:@"title"];
        task.taskStatus = [taskDict objectForKey:@"status"];
        task.taskMoney = [taskDict objectForKey:@"money"];
        task.taskIconUrl = [taskDict objectForKey:@"icon"];
        task.taskIntro = [taskDict objectForKey:@"intro"];
        task.taskDesc = [taskDict objectForKey:@"desc"];
        task.taskStepStrings = [taskDict objectForKey:@"steps"];
        task.taskLevel = [taskDict objectForKey:@"level"];
        task.taskRediectUrl = [taskDict objectForKey:@"rediect_url"];
        task.taskAppId = [taskDict objectForKey:@"appid"];
        
        if ( [task.taskStatus intValue] == CommonTaskTableViewCellStateFinished ) {
            [finished addObject:task];
        } else {
            [unfinished addObject:task];
        }
    }
    
    [unfinished addObjectsFromArray:finished];
    
    [finished release];
    
    return unfinished;
}

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
//    if ( _request != nil && [request isEqual:_request] ) {
//        if ( _firstRequest ) {
//            [self hideLoading];
//            _firstRequest = NO;
//        }
//        
//        if ( httpCode == 200 ) {
//            // 获取到返回的列表
//            NSNumber* res = [body valueForKey: @"res"];
//            int nRes = [res intValue];
//            if (nRes == 0) {
//                NSArray* list = [body valueForKey: @"task_list"];
//                if ( _list != nil ) {
//                    [_list release];
//                }
//                
//                _list = [self copyList:list];
//            }
//        }
//        
//    }
//    [_request release];
//    _request = nil;
//    _bRequest = NO;
//    BOOL isfindOne;
//    for (CommonTaskInfo *info in _list)
//    {
//        NSString *storeID = info.taskAppId;
//        NSLog(@"%d",storeID);
//        int index = [self isAppInPush:storeID :_appId];
//        
//        if(index == -1){
//            continue;
//        }
//        NSNumber *point = info.taskMoney;
//        int limit = [[_pointsLimit objectAtIndex:index] integerValue];
//        if(limit < [point integerValue])
//        {
//            wangcaiTask = info;
//            isfindOne = YES;
//            install = [[InstallAppAlertView alloc]initWithIcon:info.taskIconUrl title:info.taskTitle desc:info.taskDesc target:self install:@selector(install) cancel:@selector(cancel)];
//            [self.view addSubview:install];
//            install.tag = 10011;
//            break;
//        }
//    }
//    if(!isfindOne)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"任务已经被抢光了!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
}
@end
