//
//  WebPageController.m
//  wangcai
//
//  Created by 1528 on 13-12-17.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "WebPageController.h"

@interface WebPageController ()

@end

@implementation WebPageController

- (id)init:(NSString *)title Url : (NSString*) url Stack : (BeeUIStack*) stack
{
    self = [super initWithNibName:@"WebPageController" bundle:nil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"WebPageController" owner:self options:nil] firstObject];
        self->_beeUIStack = stack;
        self->_titleLabel = (UILabel*)[self.view viewWithTag:99];
        
        [self->_titleLabel setText:title];
        
        self->_webViewController = [[WebViewController alloc]init];
        [self->_webViewController setDelegate:self];
        
        UIView* view = self->_webViewController.view;
        CGRect rect = [[UIScreen mainScreen]bounds];
        rect.origin.y = 54;
        rect.size.height -= 54;
        view.frame = rect;
        [self.view addSubview:view];
        
        [self->_webViewController setNavigateUrl:url];

    }
    return self;
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

- (void) dealloc {
    self->_webViewController = nil;
    self->_titleLabel = nil;
    self->_beeUIStack = nil;
    [super dealloc];
}

- (IBAction)clickBack:(id)sender {
    [self->_beeUIStack popViewControllerAnimated:YES];
}

@end
