//
//  QuestCaptionViewController.m
//  wangcai
//
//  Created by NPHD on 14-5-22.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "QuestCaptionViewController.h"
#import "WebPageController.h"
#import "QuestWebViewController.h"

@interface QuestCaptionViewController ()

@end

@implementation QuestCaptionViewController
@synthesize _subView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _info = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    CGRect rect = [[UIScreen mainScreen]bounds];
    
    CGRect subViewRect = _subView.frame;
    
    subViewRect.origin.y = rect.size.height - subViewRect.size.height;
    
    [_subView setFrame:subViewRect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickOk:(id)sender {
    BeeUIStack* stack = [BeeUIRouter sharedInstance].currentStack;
    
    QuestWebViewController* controller = [[[QuestWebViewController alloc] init] autorelease];

    [controller setQuestInfo:_info];

    [stack pushViewController:controller animated:YES];
}

- (void) setQuestInfo : (SurveyInfo*) info {
    _info = info;
}

@end
