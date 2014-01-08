//
//  SettingViewController.m
//  wangcai
//
//  Created by 1528 on 13-12-25.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize _logoCell;
@synthesize _msgCell;
@synthesize _bellCell;
@synthesize _gradeCell;
@synthesize _msgSwitch;

- (id)init
{
    self = [super initWithNibName:@"SettingViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"SettingViewController" owner:self options:nil] firstObject];
        
        _tableView = (UITableView*)[self.view viewWithTag:99];
        _tableView.separatorStyle = NO;
        
        //_tableView.delegate = self;
        //_tableView.dataSource = self;
        
        CGRect rect = [[UIScreen mainScreen]bounds];
        rect.origin.y = 54;
        rect.size.height -= 54;
        [_tableView setFrame:rect];
        
        // 判断是否开了消息通知
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if ( type == UIRemoteNotificationTypeNone ) {
            // 没有打开
            [_msgSwitch setOn:NO];
        } else {
            [_msgSwitch setOn:YES];
        }
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

- (IBAction)clickBack:(id)sender {
	[[BeeUIRouter sharedInstance] open:@"wc_main" animated:YES];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if ( row == 0 ) {
        return _logoCell;
    } else if ( row == 1 ) {
        return _msgCell;
    } else if ( row == 2 ) {
        return _bellCell;
    } else if ( row == 3 ) {
        return _gradeCell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if ( row == 0 ) {
        return 200.0;
    } else if ( row == 1 ) {
        return 130;
    } else if ( row == 2 || row == 3 ) {
        return 90;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if ( row == 3 ) {
        // 评分
        NSString* oldUrl = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?mt=8&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&id=";
        NSString* ios6Url = @"itms-apps://itunes.apple.com/app/id";
        NSString* url;
        
        float fVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if ( fVersion >= 6 ) {
            url = [ios6Url stringByAppendingString:@"776787173"];
        } else {
            url = [oldUrl stringByAppendingString:@"776787173"];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    
    return nil;
}
@end
