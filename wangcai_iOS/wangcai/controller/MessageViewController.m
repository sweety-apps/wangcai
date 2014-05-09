//
//  MessageViewController.m
//  wangcai
//
//  Created by zhangc on 14-5-9.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

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

@end
