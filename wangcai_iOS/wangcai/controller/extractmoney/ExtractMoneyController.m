//
//  ExtractMoneyController.m
//  wangcai
//
//  Created by 1528 on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "ExtractMoneyController.h"
#import "Config.h"
#import "PhoneValidationController.h"

@interface ExtractMoneyController ()

@end

@implementation ExtractMoneyController

- (id)init:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ExtractMoneyController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"ExtractMoneyController" owner:self options:nil] firstObject];
        
        self->_webViewController = [[WebViewController alloc]init];
        [self->_webViewController setDelegate:self];
        
        UIView* view = self->_webViewController.view;
        CGRect rect = [[UIScreen mainScreen]bounds];
        rect.origin.y = 75;
        rect.size.height -= 75;
        view.frame = rect;
        [self.view addSubview:view];
        
        [self->_webViewController setNavigateUrl:WEB_EXTRACT_MONEY];
    }
    return self;
}


-(void) onAttachPhone {
    PhoneValidationController* phoneVal = [[PhoneValidationController alloc]initWithNibName:@"PhoneValidationController" bundle:nil];
    
    [self->_beeStack pushViewController:phoneVal animated:YES];
}

-(void) onPayToAlipay:(float) fCoin {
    // 转帐到支付宝
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"转帐到支付宝" message:@"......" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

-(void) onPayToPhone:(float) fCoin {
    // 花费充值
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"话费充值" message:@"......" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) dealloc {
    self->_webViewController = nil;
    self->_beeStack = nil;
    [super dealloc];
}

- (void)setUIStack : (BeeUIStack*) beeStack {
    self->_beeStack = beeStack;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
