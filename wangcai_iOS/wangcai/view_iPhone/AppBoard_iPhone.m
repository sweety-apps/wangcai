//
//  AppBoard_iPhone.m
//  wangcai
//
//  Created by Lee Justin on 13-12-8.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "AppBoard_iPhone.h"
#import "MenuBoard_iPhone.h"

#pragma mark -

#undef	MENU_BOUNDS
#define	MENU_BOUNDS	(160.0f)

#pragma mark -

@implementation AppBoard_iPhone
{
	BeeUIButton *	_mask;
	CGRect			_origFrame;
}

DEF_SINGLETON( AppBoard_iPhone )

+ (void)load
{
}

- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.view.backgroundColor = [UIColor whiteColor];

		MenuBoard_iPhone * menu = [MenuBoard_iPhone sharedInstance];
		menu.parentBoard = self;
		menu.view.backgroundColor = RGB(15, 15, 15);
		[self.view addSubview:menu.view];

		BeeUIRouter * router = [BeeUIRouter sharedInstance];
		router.parentBoard = self;
		[self.view addSubview:router.view];

		_mask = [BeeUIButton new];
		_mask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
		_mask.hidden = YES;
		_mask.signal = @"mask";
		[self.view addSubview:_mask];

		[menu selectItem:@"first" animated:NO];
		[router open:@"first"];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
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
		[BeeUIRouter sharedInstance].view.pannable = YES;
	}
	else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
		[BeeUIRouter sharedInstance].view.pannable = NO;
	}
	else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
	{
	}
}

ON_SIGNAL2( UIView, signal )
{
    if ( [signal is:UIView.PAN_START]  )
    {
        _origFrame = [BeeUIRouter sharedInstance].view.frame;

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
		
		if ( router.view.left <= MENU_BOUNDS )
		{
			router.view.left = 0;
			
			_mask.frame = CGRectMake( 0.0, 0.0, router.width, router.height );
			_mask.alpha = 1.0f;
			
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didMenuHidden)];
		}
		else
		{
			router.view.left = MENU_BOUNDS;
			
			_mask.frame = CGRectMake( MENU_BOUNDS, 0.0, router.width - MENU_BOUNDS, router.height );
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
	[[BeeUIRouter sharedInstance] open:@"first" animated:YES];

	[self hideMenu];
}

ON_SIGNAL3( MenuBoard_iPhone, second, signal )
{
	[[BeeUIRouter sharedInstance] open:@"second" animated:YES];
	
	[self hideMenu];
}

ON_SIGNAL3( MenuBoard_iPhone, third, signal )
{
	[[BeeUIRouter sharedInstance] open:@"third" animated:YES];
	
	[self hideMenu];
}

ON_SIGNAL3( MenuBoard_iPhone, team, signal )
{
	[[BeeUIRouter sharedInstance] open:@"team" animated:YES];
	
	[self hideMenu];
}

- (void)didMenuHidden
{
	_mask.hidden = YES;
}

- (void)didMenuShown
{
	BeeUIRouter * router = [BeeUIRouter sharedInstance];

	_mask.frame = CGRectMake( MENU_BOUNDS, 0.0, router.width - MENU_BOUNDS, router.height );
	_mask.hidden = NO;
}

- (void)syncPanPosition
{
	BeeUIRouter * router = [BeeUIRouter sharedInstance];
	CGFloat panOffsetX = router.view.panOffset.x;
    if((_origFrame.origin.x + panOffsetX) < 0.f)
    {
        panOffsetX = 0.f;
    }
	router.view.frame = CGRectOffset( _origFrame, panOffsetX, 0 );

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
	BeeUIRouter * router = [BeeUIRouter sharedInstance];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didMenuShown)];
	
	router.view.left = MENU_BOUNDS;
	
	_mask.frame = CGRectMake( MENU_BOUNDS, 0.0, router.width - MENU_BOUNDS, router.height );
	_mask.alpha = 1.0f;
	
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
	
	router.view.left = 0.0f;
	
	_mask.frame = CGRectMake( 0.0, 0.0, router.width, router.height );
	_mask.alpha = 0.0f;
	
	[UIView commitAnimations];
}

#pragma mark Notification

ON_NOTIFICATION( notification )
{
	
}

#pragma mark Message

ON_MESSAGE( message )
{
	
}

@end
