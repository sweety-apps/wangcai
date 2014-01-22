//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  WCMainPageBoard_iPhone.m
//  wangcai
//
//  Created by Lee Justin on 13-12-8.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "WCMainPageBoard_iPhone.h"
#import "CommonYuENumView.h"
#import "UserInfoEditorViewController.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@interface WCMainPageBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation WCMainPageBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

+ (void)load
{
	[[BeeUIRouter sharedInstance] map:@"wc_main" toClass:self];
}

- (void)load
{
	[super load];
}

- (void)unload
{
    [_taskTableViewController release];
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self observeNotification:@"naviToUserInfoEditor"];
        [self observeNotification:@"balanceChanged"];
        
        _alertView = nil;
        self.view.hintString = @"This is the  board";
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.clipsToBounds = NO;
		
        [self hideNavigationBarAnimated:NO];
        //[self setTitleString:@"旺财"];
        
        //列表后面的白色背景
        UIView* listBgView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1024)] autorelease];
        listBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:listBgView];
        
        
        //头部超出部分
        //UIImageView* testImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"testMain"]];
        UIImageView* headExtensionImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_extension_part"]] autorelease];
        CGRect headExtensionImageRect = headExtensionImageView.frame;
        headExtensionImageRect.origin.y -= headExtensionImageRect.size.height;
        headExtensionImageView.frame = headExtensionImageRect;
        [self.view addSubview:headExtensionImageView];
        
        CGRect rectFrame = CGRectZero;
        
        //头部导航栏
        UIImageView* headBgImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_page_head"]] autorelease];
        rectFrame = headBgImageView.frame;
        headBgImageView.frame = rectFrame;
        
        [self.view addSubview:headBgImageView];
        
        //上面旺财ICON
        UIImageView* headWangcaiIconImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_left_icon"]] autorelease];
        rectFrame = headWangcaiIconImageView.frame;
        rectFrame.origin.x = 58;
        rectFrame.origin.y = 14;
        headWangcaiIconImageView.frame = rectFrame;
        [self.view addSubview:headWangcaiIconImageView];
        
        //左上角按钮
        UIImageView* headLeftBtnImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_left_menu_btn"]] autorelease];
        headLeftBtnImageView.contentMode = UIViewContentModeTopLeft;
        rectFrame = headLeftBtnImageView.frame;
        rectFrame.origin.x = 14;
        rectFrame.origin.y = 15;
        headLeftBtnImageView.frame = rectFrame;
        
        rectFrame = CGRectMake(0, 0, 107, 48);
        UIButton* headLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headLeftBtn.backgroundColor = [UIColor clearColor];
        headLeftBtn.frame = rectFrame;
        [headLeftBtn addTarget:self action:@selector(onPressedLeftBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:headLeftBtnImageView];
        [self.view addSubview:headLeftBtn];
        
        //右上角按钮
        UIImageView* headRightBtnImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_right_icon"]] autorelease];
        rectFrame = headRightBtnImageView.frame;
        rectFrame.origin.x = 267;
        rectFrame.origin.y = -38;
        headRightBtnImageView.frame = rectFrame;
        _headRightBtnImageView = headRightBtnImageView;
        
        UIButton* headRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headRightBtn.backgroundColor = [UIColor clearColor];
        headRightBtn.frame = rectFrame;
        [headRightBtn addTarget:self action:@selector(onTouchDownRightBtn:) forControlEvents:UIControlEventTouchDown];
        [headRightBtn addTarget:self action:@selector(onTouchUpInsideRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [headRightBtn addTarget:self action:@selector(onTouchReleaseRightBtn:) forControlEvents:UIControlEventTouchUpOutside];
        [headRightBtn addTarget:self action:@selector(onTouchReleaseRightBtn:) forControlEvents:UIControlEventTouchCancel];
        
        
        [self.view addSubview:headRightBtnImageView];
        [self.view addSubview:headRightBtn];
        
        //列表
        BaseTaskTableViewController* taskTableViewController = [[BaseTaskTableViewController alloc] initWithNibName:@"BaseTaskTableViewController" bundle:nil];
        [self.view insertSubview:taskTableViewController.view belowSubview:headExtensionImageView];
        _taskTableViewController = taskTableViewController;
        
        _taskTableViewController.view.frame = CGRectMake(0, headBgImageView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        _taskTableViewController.beeStack = self.stack;
        //_taskTableViewController.containTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - headBgImageView.frame.size.height);
        CGSize tableViewSize = [UIApplication sharedApplication].keyWindow.frame.size;
        _taskTableViewController.tableViewFrame = CGRectMake(0, 0, tableViewSize.width, tableViewSize.height - headBgImageView.frame.size.height);
        _taskTableViewController.containTableView.bounces = YES;
        
        //[self.view addSubview:testImageView];
        
        //抗锯齿
        //self.view.layer.shouldRasterize = YES;
        //self.view.layer.edgeAntialiasingMask = kCALayerLeftEdge ;
        //self.view.layer.masksToBounds = YES;
                 
        // 亲友提示
#if TARGET_VERSION_LITE == 2
        [self showFriendMsg];
#endif
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        [self unobserveNotification:@"naviToUserInfoEditor"];
        [self unobserveNotification:@"balanceChanged"];
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [_taskTableViewController viewWillAppear:NO];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        self.view.clipsToBounds = NO;
        [self.view superview].clipsToBounds = NO;
        [[self.view superview] superview].clipsToBounds = NO;
        
        [_taskTableViewController viewDidAppear:NO];
        
        [[AppBoard_iPhone sharedInstance] setPanable:YES];
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setPanable:NO];
        [_taskTableViewController viewWillDisappear:NO];
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
        [_taskTableViewController viewDidDisappear:NO];
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}


-(void)onPressedLeftBackBtn:(id)sender
{
    [self postNotification:@"showMenu"];
}

-(void)onTouchDownRightBtn:(id)sender
{
    CGRect rectFrame = _headRightBtnImageView.frame;
    rectFrame.origin.x = 267;
    rectFrame.origin.y = -10;
    
    [UIView animateWithDuration:0.2 animations:^(){
        _headRightBtnImageView.frame = rectFrame;
    } completion:^(BOOL finished){
    }];
}

-(void)onTouchReleaseRightBtn:(id)sender
{
    CGRect rectFrame = _headRightBtnImageView.frame;
    rectFrame.origin.x = 267;
    rectFrame.origin.y = -38;
    
    [UIView animateWithDuration:0.2 animations:^(){
        _headRightBtnImageView.frame = rectFrame;
    } completion:^(BOOL finished){
    }];
}

-(void)onTouchUpInsideRightBtn:(id)sender
{
    [self onTouchReleaseRightBtn:sender];
    [self naviToExchangeController];
}

-(void)naviToUserInfoEditor
{
    UserInfoEditorViewController* userInfoCtrl = [[UserInfoEditorViewController alloc] initWithNibName:@"UserInfoEditorViewController" bundle:nil];
    if (self.stack == nil)
    {
        NSLog(@"靠！！！stack空的");
    }
    [self.stack pushViewController:userInfoCtrl animated:NO];
}

-(void)naviToExchangeController
{
    [[BeeUIRouter sharedInstance] open:@"first" animated:YES];
}

#pragma mark Notification

ON_NOTIFICATION( notification )
{
	if ([notification.name isEqualToString:@"naviToUserInfoEditor"])
    {
        [self naviToUserInfoEditor];
    }
    else if ([notification.name isEqualToString:@"balanceChanged"])
    {
        //[_taskTableViewController ]
    }
}

- (void) showFriendMsg {
    if ( _alertView != nil ) {
        [_alertView release];
    }
    
    UIView* view = [[[[NSBundle mainBundle] loadNibNamed:@"StartupController" owner:self options:nil] lastObject] autorelease];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10.0;
    view.layer.borderWidth = 0.0;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UIColor *color = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1];
    
    UIButton* btn = (UIButton*)[view viewWithTag:11];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    
    [btn.layer setBorderWidth:0.5];
    [btn.layer setBorderColor:[color CGColor]];
    
    [btn addTarget:self action:@selector(clickContinue:) forControlEvents:UIControlEventTouchUpInside];
    _alertView = [[UICustomAlertView alloc]init:view];
    
    [_alertView show];
}

- (IBAction)clickContinue:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
}

@end
