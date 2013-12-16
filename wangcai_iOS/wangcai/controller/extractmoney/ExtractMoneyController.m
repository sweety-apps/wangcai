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
#import "TransferToAlipayAndPhoneController.h"

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
        rect.origin.y = 54;
        rect.size.height -= 54;
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
    TransferToAlipayAndPhoneController* controller = [[TransferToAlipayAndPhoneController alloc]init:YES];
    
    [self->_beeStack pushViewController:controller animated:YES];
}

-(void) onPayToPhone:(float) fCoin {
    // 花费充值
    TransferToAlipayAndPhoneController* controller = [[TransferToAlipayAndPhoneController alloc]init:NO];
    
    [self->_beeStack pushViewController:controller animated:YES];
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
