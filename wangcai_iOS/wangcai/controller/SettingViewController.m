//
//  SettingViewController.m
//  wangcai
//
//  Created by 1528 on 13-12-25.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "SettingViewController.h"
#import "RateAppLogic.h"
#import "NSString+FloatFormat.h"
#import "LoginAndRegister.h"
#import "BaseTaskTableViewController.h"
#import "WebPageController.h"
#import "Config.h"

@interface SettingViewController () <RateAppLogicDelegate>

@end

@implementation SettingViewController
@synthesize _logoCell;
@synthesize _msgCell;
@synthesize _bellCell;
@synthesize _gradeCell;
@synthesize _msgSwitch;
@synthesize _musicSwitch;
@synthesize _aboutCell;

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
        
        float fVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if ( fVersion < 7 ) {
            rect = _msgSwitch.frame;
            rect.origin.x -= 20;
            _msgSwitch.frame = rect;
            
            rect = _musicSwitch.frame;
            rect.origin.x -= 20;
            _musicSwitch.frame = rect;
        }
        
        UILabel* label = (UILabel*)[_aboutCell viewWithTag:11];
        NSDictionary* dic = [[NSBundle mainBundle] infoDictionary];
        NSString* appVersion = [dic valueForKey:@"CFBundleVersion"];
        NSString* version = [[[NSString alloc] initWithFormat:@"版本号：%@", appVersion] autorelease];
        [label setText:version];
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
    } else if ( row == 4 ) {
        return _aboutCell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if ( row == 0 ) {
        return 218;
    } else if ( row == 1 ) {
        return 130;
    } else if ( row == 2 || row == 3 ) {
        return 90;
    } else {
        return 70;
    }
    return 0;
}

-(void) setUIStack:(BeeUIStack*) stack {
    _stack = stack;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if ( row == 3 ) {
        // 评分
        [[self class] jumpToAppStoreAndRate];
        [[RateAppLogic sharedInstance] requestRated:self];
    }
    
    return nil;
}

+ (void)jumpToAppStoreAndRate
{
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

#pragma mark <RateAppLogicDelegate>

- (void)onRateAppLogicFinished:(RateAppLogic*)logic isRequestSucceed:(BOOL)isSucceed income:(NSInteger)income resultCode:(NSInteger)result msg:(NSString*)msg
{
    if (isSucceed && income > 0)
    {
        NSString* strIncome = [NSString stringWithFloatRoundToPrecision:((float)income)/100.f precision:1 ignoreBackZeros:YES];
        NSString* btnStr = [NSString stringWithFormat:@"领取 %@ 元",strIncome];
        UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:@"评价成功" message:@"" delegate:self cancelButtonTitle:btnStr otherButtonTitles:nil] autorelease];
        [alertView show];
        
        [[LoginAndRegister sharedInstance] increaseBalance:income];
        [BaseTaskTableViewController setNeedReloadTaskList];
    }
    else
    {
        NSString* msgStr = @"服务器失败";
        if ([msg length] > 0)
        {
            msgStr = msg;
        }
        UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:@"评价失败" message:@"" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
    
}

- (IBAction)clickAbout:(id)sender {
    BeeUIStack* stack = _stack;
    
    NSString* url = [[[NSString alloc] initWithFormat:@"%@128", WEB_SERVICE_VIEW] autorelease];
    
    WebPageController* controller = [[[WebPageController alloc] init:@"使用条款和隐私政策"
                                                                 Url:url Stack:stack] autorelease];
    [stack pushViewController:controller animated:YES];
}

@end
