//
//  QuestViewController.m
//  wangcai
//
//  Created by NPHD on 14-5-21.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "QuestViewController.h"

@interface QuestViewController ()

@end

@implementation QuestViewController
@synthesize tbView;

static QuestViewController* _sharedInstance = nil;

+ (QuestViewController*) sharedInstance {
    if ( _sharedInstance == nil ) {
        _sharedInstance = [[QuestViewController alloc] initWithNibName:nil bundle:nil];
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
