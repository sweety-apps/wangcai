//
//  WangcaiTaskViewController.m
//  wangcai
//
//  Created by NPHD on 14-5-21.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "WangcaiTaskViewController.h"
#import "MBHUDView.h"

@interface WangcaiTaskViewController ()

@end

@implementation WangcaiTaskViewController
@synthesize tbView;

static WangcaiTaskViewController* _sharedInstance = nil;

+ (WangcaiTaskViewController*) sharedInstance {
    if ( _sharedInstance == nil ) {
        _sharedInstance = [[WangcaiTaskViewController alloc] initWithNibName:nil bundle:nil];
    }
    return _sharedInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    rect.origin.y = 96;
    rect.size.height -= 96;
    
    [tbView setFrame:rect];
    
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    CGRect rt = CGRectMake(0.0f,
                           0.0f-tbView.bounds.size.height,
                           tbView.frame.size.width,
                           tbView.frame.size.height);
    EGORefreshTableHeaderView* view1 = [[EGORefreshTableHeaderView alloc]
                                        initWithFrame:rt];
    view1.delegate = self;
    [tbView addSubview:view1];
    _refreshHeaderView = view1;
    [view1 release];
    
    [self requestList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUIStack:(BeeUIStack*) stack {
    self->_beeUIStack = stack;
}

- (IBAction)clickBack:(id)sender {
    [self->_beeUIStack popViewControllerAnimated:YES];
}

- (void) showLoading:(NSString*) tip {
    [MBHUDView hudWithBody:tip type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
}

- (void) hideLoading {
    [MBHUDView dismissCurrentHUD];
}

- (void) requestList {
    [self showLoading:@"请等待..."];
}

@end
