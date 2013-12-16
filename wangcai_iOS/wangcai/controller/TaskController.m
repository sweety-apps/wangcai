//
//  TaskController.m
//  wangcai
//
//  Created by 1528 on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "TaskController.h"
#import "Config.h"

@interface TaskController ()

@end

@implementation TaskController

- (id)init:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TaskController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"TaskController" owner:self options:nil] firstObject];
        
        self->_webViewController = [[WebViewController alloc]init];
        [self->_webViewController setDelegate:self];
        
        self->_tabController = [[TabController alloc] init:nil];
        
        UIView* viewTab = self->_tabController.view;
        CGRect rectTab = viewTab.frame;
        rectTab.origin.y = 54;
        viewTab.frame = rectTab;
        [self.view addSubview:viewTab];
        
        UIView* view = self->_webViewController.view;
        CGRect rect = [[UIScreen mainScreen]bounds];
        rect.origin.y = 153;
        rect.size.height -= 153;
        view.frame = rect;
        [self.view addSubview:view];
        
        [self->_webViewController setNavigateUrl:WEB_TASK];
        
        [self->_tabController setTabInfo:@"在AppStore安装" Tab2:@"游戏内注册" Tab3:@"领取" Purse:1];
        [self->_tabController selectTab:1];
    }
    
    return self;
}

- (void) dealloc {
    self->_webViewController = nil;
    self->_tabController = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
