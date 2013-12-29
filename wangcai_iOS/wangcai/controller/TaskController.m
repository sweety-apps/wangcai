//
//  TaskController.m
//  wangcai
//
//  Created by 1528 on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "TaskController.h"
#import "Config.h"
#import "MBHUDView.h"

@interface TaskController ()

@end

@implementation TaskController

- (id)init:(NSNumber*)taskId Tab1:(NSString*) tab1 Tab2:(NSString*) tab2 Tab3:(NSString*) tab3 Purse:(float) purse
{
    self = [super initWithNibName:@"TaskController" bundle:nil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"TaskController" owner:self options:nil] firstObject];
        
        self->_webViewController = [[WebViewController alloc]init];
        
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
        
        [self->_webViewController setDelegate:self];
        
        [self->_webViewController setNavigateUrl:WEB_TASK];
        
        [self->_tabController setTabInfo:tab1 Tab2:tab2 Tab3:tab3 Purse:purse];
        [self->_tabController selectTab:1];
    }
    
    return self;
}

- (void) dealloc {
    self->_webViewController = nil;
    self->_tabController = nil;
    [super dealloc];
}

- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)openAppWithIdentifier:(NSString *)appId {
    NSString* strVersion = [[UIDevice currentDevice] systemVersion];
    float version = [strVersion floatValue];
    if ( version >= 6 ) {
        SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
        storeProductVC.delegate = self;
    
        // 显示loading
        [self showLoading];
    
        NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
        [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
            // 隐藏loading
            [self hideLoading];
        
            if (result) {
                [self presentViewController:storeProductVC animated:YES completion:nil];
            } else {
                NSString* desc = [[error userInfo] valueForKey:@"NSLocalizedDescription"];
                
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        }];
    } else {
        NSString* urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8", appId];
        NSURL* url = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void) showLoading {
    [MBHUDView hudWithBody:@"请等待..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
}

- (void) hideLoading {
    [MBHUDView dismissCurrentHUD];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:^{
        [viewController release];
    }];
}

@end
