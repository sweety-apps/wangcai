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
        self.view.hintString = @"This is the  board";
        self.view.backgroundColor = [UIColor colorWithRed:165.f/255.f green:0.f/255.f blue:0.f/255.f alpha:1.0f];
        self.view.clipsToBounds = NO;
		
        //[self showNavigationBarAnimated:NO];
        //[self setTitleString:@"旺财"];
        
        //UIImageView* testImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"testMain"]];
        UIImageView* headExtensionImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_extension_part"]] autorelease];
        CGRect headExtensionImageRect = headExtensionImageView.frame;
        headExtensionImageRect.origin.y -= headExtensionImageRect.size.height;
        headExtensionImageView.frame = headExtensionImageRect;
        [self.view addSubview:headExtensionImageView];
        
        CGRect rectFrame = CGRectZero;
        
        //背景
        UIImageView* headBgImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_page_head"]] autorelease];
        rectFrame = headBgImageView.frame;
        headBgImageView.frame = rectFrame;
        
        UIImageView* listBgImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_bg"]] autorelease];
        rectFrame = listBgImageView.frame;
        rectFrame.origin.y = headBgImageView.frame.size.height;
        listBgImageView.frame = rectFrame;
        
        [self.view addSubview:headBgImageView];
        [self.view addSubview:listBgImageView];
        
        //余额数字
        CommonYuENumView* yuENum = [[[CommonYuENumView alloc] initWithFrame:CGRectMake(0, 85, 285, 55)] autorelease];
        [yuENum setNum:40.55];
        [self.view addSubview:yuENum];
        
        //上面旺财ICON
        UIImageView* headWangcaiIconImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_left_icon"]] autorelease];
        rectFrame = headWangcaiIconImageView.frame;
        rectFrame.origin.x = 34;
        rectFrame.origin.y = 9;
        headWangcaiIconImageView.frame = rectFrame;
        [self.view addSubview:headWangcaiIconImageView];
        
        //左上角按钮
        UIImageView* headLeftBtnImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_back"]] autorelease];
        rectFrame = headLeftBtnImageView.frame;
        rectFrame.origin.x = 14;
        rectFrame.origin.y = 16;
        headLeftBtnImageView.frame = rectFrame;
        
        UIButton* headLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headLeftBtn.backgroundColor = [UIColor clearColor];
        headLeftBtn.frame = rectFrame;
        [headLeftBtn addTarget:self action:@selector(onPressedLeftBackBtn:) forControlEvents:UIControlEventTouchDown];
        
        [self.view addSubview:headLeftBtnImageView];
        [self.view addSubview:headLeftBtn];
        
        //右上角按钮
        UIImageView* headRightBtnImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_right_icon"]] autorelease];
        rectFrame = headRightBtnImageView.frame;
        rectFrame.origin.x = 287;
        rectFrame.origin.y = 16;
        headRightBtnImageView.frame = rectFrame;
        
        UIButton* headRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headRightBtn.backgroundColor = [UIColor clearColor];
        headRightBtn.frame = rectFrame;
        
        
        [self.view addSubview:headRightBtnImageView];
        [self.view addSubview:headRightBtn];
        
        //RMB符号
        UIImageView* rmbIconImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanghuyue"]] autorelease];
        rectFrame = rmbIconImageView.frame;
        rectFrame.origin.x = 14;
        rectFrame.origin.y = 85;
        rmbIconImageView.frame = rectFrame;
        [self.view addSubview:rmbIconImageView];
        
        //元
        rectFrame = CGRectMake(290, 110, 100, 30);
        UILabel* yuanLabel = [[[UILabel alloc] initWithFrame:rectFrame] autorelease];
        yuanLabel.backgroundColor = [UIColor clearColor];
        yuanLabel.font = [UIFont systemFontOfSize:16];
        yuanLabel.textAlignment = NSTextAlignmentLeft;
        yuanLabel.textColor = [UIColor colorWithRed:255.f/255.f green:248.f/255.f blue:189.f/255.f alpha:1.0];
        yuanLabel.text = @"元";
        [self.view addSubview:yuanLabel];
        
        //签到捡钱按钮
        CGFloat btnOffsetX = 135;
        CGFloat btnOffsetY = 174;
        UIImageView* qiandaoIconImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qiandao_button_icon"]] autorelease];
        rectFrame = qiandaoIconImageView.frame;
        rectFrame.origin.x = btnOffsetX+0;
        rectFrame.origin.y = btnOffsetY+0;
        qiandaoIconImageView.frame = rectFrame;
        
        rectFrame = CGRectMake(btnOffsetX+22, btnOffsetY+0, 100, rectFrame.size.height);
        UILabel* qiandaoLabel = [[[UILabel alloc] initWithFrame:rectFrame] autorelease];
        qiandaoLabel.backgroundColor = [UIColor clearColor];
        qiandaoLabel.font = [UIFont systemFontOfSize:12];
        qiandaoLabel.textAlignment = NSTextAlignmentLeft;
        qiandaoLabel.textColor = [UIColor colorWithRed:255.f/255.f green:248.f/255.f blue:189.f/255.f alpha:1.0];
        qiandaoLabel.text = @"签到捡钱";
        
        rectFrame = CGRectMake(btnOffsetX - 20, btnOffsetY - 10, 80, rectFrame.size.height+20);
        UIButton* qiandaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        qiandaoBtn.backgroundColor = [UIColor clearColor];
        qiandaoBtn.frame = rectFrame;
        
        [self.view addSubview:qiandaoIconImageView];
        [self.view addSubview:qiandaoLabel];
        [self.view addSubview:qiandaoBtn];
        
        
        //提现按钮
        btnOffsetX = 231;
        btnOffsetY = 174;
        UIImageView* tixianIconImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tiquxianjin_icon"]] autorelease];
        rectFrame = tixianIconImageView.frame;
        rectFrame.origin.x = btnOffsetX+0;
        rectFrame.origin.y = btnOffsetY+0;
        tixianIconImageView.frame = rectFrame;
        
        rectFrame = CGRectMake(btnOffsetX+26, btnOffsetY+0, 100, rectFrame.size.height);
        UILabel* tixianLabel = [[[UILabel alloc] initWithFrame:rectFrame] autorelease];
        tixianLabel.backgroundColor = [UIColor clearColor];
        tixianLabel.font = [UIFont systemFontOfSize:12];
        tixianLabel.textAlignment = NSTextAlignmentLeft;
        tixianLabel.textColor = [UIColor colorWithRed:255.f/255.f green:248.f/255.f blue:189.f/255.f alpha:1.0];
        tixianLabel.text = @"提取现金";
        
        rectFrame = CGRectMake(btnOffsetX - 20, btnOffsetY - 10, 80, rectFrame.size.height+20);
        UIButton* tixianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tixianBtn.backgroundColor = [UIColor clearColor];
        tixianBtn.frame = rectFrame;
        
        [self.view addSubview:tixianIconImageView];
        [self.view addSubview:tixianLabel];
        [self.view addSubview:tixianBtn];
        
        BaseTaskTableViewController* taskTableViewController = [[BaseTaskTableViewController alloc] initWithNibName:@"BaseTaskTableViewController" bundle:nil];
        taskTableViewController.view.frame = CGRectMake(0, headBgImageView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:taskTableViewController.view];
        _taskTableViewController = taskTableViewController;
        
        //[self.view addSubview:testImageView];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
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
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        self.view.clipsToBounds = NO;
        [self.view superview].clipsToBounds = NO;
        [[self.view superview] superview].clipsToBounds = NO;
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
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

@end
