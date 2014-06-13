//
//  InviteController.m
//  wangcai
//
//  Created by 1528 on 13-12-11.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "InviteController.h"
#import "LoginAndRegister.h"
#import "MBHUDView.h"
#import <ShareSDK/ShareSDK.h>
#import "qrencode.h"
#import "WebPageController.h"
#import "Config.h"
#import "SettingLocalRecords.h"
#import "BaseTaskTableViewController.h"
#import "MobClick.h"
#import "UIGetRedBagAlertView.h"
#import "NSString+FloatFormat.h"

@interface InviteController ()

@end

@implementation InviteController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] firstObject];
        
        [self load:nibNameOrNil];
        
        self._beeStack = nil;
        self.title = @"邀请送红包";
    }
    return self;
}

- (NSArray *)constrainSubview: (UIView *)subview toMatchWithSuperview: (UIView *)superview
{
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary* viewsDictionary = NSDictionaryOfVariableBindings(subview);
    
    NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[subview]|" options: 0 metrics: nil views: viewsDictionary];
    constraints = [constraints arrayByAddingObjectsFromArray: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[subview]|" options: 0 metrics: nil views: viewsDictionary]];
    [superview addConstraints: constraints];
    
    return constraints;
}

- (void) load:(NSString*)nibNameOrNil {
    self.inviteView = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] objectAtIndex:1];

    self.containerView = [self.view viewWithTag:11];
    self.inviteCodeLabel = (UILabel*)[self.inviteView viewWithTag:14];
    self.inviteUrlTextField = (UITextField*)[self.inviteView viewWithTag:18];
    self.qrcodeView = (UIImageView*)[self.inviteView viewWithTag:20];
    self.shareButton = (UIButton*)[self.inviteView viewWithTag:22];

    self.inviteIncome = (UILabel*)[self.inviteView viewWithTag:41];
    self.inviteIncomeTip = (UILabel*)[self.inviteView viewWithTag:42];
    
    [self.containerView addSubview: self.inviteView];
    
    self.priorConstraints = [self constrainSubview: self.inviteView toMatchWithSuperview: self.containerView];
    
    UIImage* shareButtonBkg = [[UIImage imageNamed: @"invite_share_button"] resizableImageWithCapInsets: UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.shareButton setBackgroundImage: shareButtonBkg forState:UIControlStateNormal];
    
    NSString* inviteCode = [[LoginAndRegister sharedInstance] getInviteCode];
    if (inviteCode != nil)
    {
        [self setInviteCode: inviteCode];
    }
    
    int income = [[LoginAndRegister sharedInstance] getInviteIncome];
    if ( income < 0 ) {
        [[self.view viewWithTag:40] setHidden:YES];
        [[self.view viewWithTag:41] setHidden:YES];
    } else {
        NSString* nsIncome = [[NSString alloc]initWithFormat:@"%.2f元", 1.0*income/100];
    
        self.inviteIncome.text = nsIncome;
        [nsIncome release];
    }
    
    self.inviteIncomeTip.text = @"获得额外10%的好友任务奖励";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self._beeStack = nil;
    [self.inviteView release];
    [self.inviteCode release];
    [super dealloc];
}

-(void) ShareCompleted : (id) share State:(SSResponseState) state Err:(id<ICMErrorInfo>) error {
}

- (IBAction)copyUrl:(id)sender
{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.inviteUrlTextField.text;
    
    //统计
    [MobClick event:@"click_copy_to_clipboard" attributes:@{@"current_page":@"邀请",@"content":pasteboard.string}];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"复制成功" message: nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}

- (IBAction)share:(id)sender
{
    //统计
    [MobClick event:@"click_invite_redbag" attributes:@{@"current_page":@"邀请"}];
    
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"Icon@2x" ofType:@"png"];
    
    NSString* url = [NSString stringWithFormat: INVITE_URL, _inviteCode];
    id<ISSContent> publishContent = [ShareSDK content: [NSString stringWithFormat:@"妈妈再也不用担心我的话费了，旺财下载地址:%@", url]  defaultContent:[NSString stringWithFormat:@"妈妈再也不用担心我的话费了。"] image:[ShareSDK imageWithPath:imagePath] title: @"玩应用领红包" url:url description: @"旺财分享" mediaType: SSPublishContentMediaTypeNews];
  
    [publishContent addQQUnitWithType: [NSNumber numberWithInt:SSPublishContentMediaTypeNews]
            content:@"妈妈再也不用担心我的话费了。"
            title:@"玩应用领红包"
            url:url
            image:[ShareSDK imageWithPath:imagePath]];
    
    
    //[publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"妈妈再也不用担心我的话费了，旺财下载地址:%@", url] image:[ShareSDK imageWithPath:imagePath]];
    //[publishContent addTencentWeiboUnitWithContent:[NSString stringWithFormat:@"妈妈再也不用担心我的话费了，旺财下载地址:%@", url] image:[ShareSDK imageWithPath:imagePath]];
    
    [ShareSDK showShareActionSheet: nil shareList: nil content: publishContent statusBarTips: YES authOptions: nil shareOptions: nil result: ^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
     {
         if (state == SSResponseStateSuccess)
         {
             // todo 分享成功
             [SettingLocalRecords saveLastShareDateTime:[NSDate date]];
         }
         else if (state == SSResponseStateFail)
         {
             // todo 分享失败
         }
     }];
}

- (void)setInviteCode: (NSString *)inviteCode
{
    if (_inviteCode != inviteCode)
    {
        [_inviteCode release];
        _inviteCode = [inviteCode copy];
        
        self.inviteCodeLabel.text = _inviteCode;
        self.inviteUrlTextField.text = [NSString stringWithFormat: INVITE_URL, _inviteCode];
        self.qrcodeView.image = [self QRCodeGenerator: [NSString stringWithFormat: INVITE_URL, _inviteCode] andLightColor: [UIColor whiteColor] andDarkColor: [UIColor blackColor] andQuietZone: 1 andSize: 128];
    }
}

- (void)setReceiveMoney:(NSUInteger)receiveMoney
{
}

- (UIImage *)QRCodeGenerator: (NSString *)iData andLightColor: (UIColor *)iLightColor andDarkColor: (UIColor *)iDarkColor andQuietZone: (NSInteger)iQuietZone andSize: (NSInteger)iSize
{
    UIImage* ret = nil;
    QRcode* qr = QRcode_encodeString([iData UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    int logQRSize = qr->width;
    int phyQRSize = (int)(logQRSize + (2 * iQuietZone));
    int scale = (int)(iSize / phyQRSize);
    int imgSize = phyQRSize * scale;
    
    if (scale < 1)
    {
        scale = 1;
    }
    UIGraphicsBeginImageContext(CGSizeMake(imgSize, imgSize));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = CGRectMake(0, 0, imgSize, imgSize);
    CGContextSetFillColorWithColor(ctx, iLightColor.CGColor);
    CGContextFillRect(ctx, bounds);
    
    int x, y;
    CGContextSetFillColorWithColor(ctx, iDarkColor.CGColor);
    for (y = 0; y < logQRSize; y++)
    {
        for (x = 0; x < logQRSize; x ++)
        {
            if (qr->data[y*logQRSize + x] & 1)
            {
                CGContextFillRect(ctx, CGRectMake((iQuietZone + x) * scale, (iQuietZone + y) * scale, scale, scale));
            }
        }
    }
    
    CGImageRef imgRef = CGBitmapContextCreateImage(ctx);
    ret = [UIImage imageWithCGImage: imgRef];
    
    CGImageRelease(imgRef);
    UIGraphicsEndImageContext();
    QRcode_free(qr);
    
    return ret;
}

- (IBAction)clickBack:(id)sender
{
    [[BeeUIRouter sharedInstance] open:@"wc_main" animated:YES];
}

- (IBAction)clickTextLink:(id)sender {
    BeeUIStack* stack = self._beeStack;
    
    NSString* url = [[[NSString alloc] initWithFormat:@"%@123", WEB_SERVICE_VIEW] autorelease];
    
    WebPageController* controller = [[[WebPageController alloc] init:@"如何成为推广员"
                                                                 Url:url Stack:stack] autorelease];
    [stack pushViewController:controller animated:YES];
}

@end
