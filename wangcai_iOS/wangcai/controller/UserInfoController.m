//
//  UserInfoController.m
//  wangcai
//
//  Created by 1528 on 13-12-16.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "UserInfoController.h"

@interface UserInfoController ()

@end

@implementation UserInfoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoController" owner:self options:nil] firstObject];
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

@end
