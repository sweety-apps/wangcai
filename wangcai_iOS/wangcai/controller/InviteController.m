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

@interface InviteController ()

@end

@implementation InviteController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = @"邀请送红包";
        _inviterUpdate = [[InviterUpdate alloc] init];

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.containerView addSubview: self.inviteView];
    
    self.priorConstraints = [self constrainSubview: self.inviteView toMatchWithSuperview: self.containerView];
    
    UIImage* shareButtonBkg = [[UIImage imageNamed: @"invite_share_button"] resizableImageWithCapInsets: UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.shareButton setBackgroundImage: shareButtonBkg forState:UIControlStateNormal];
    [self.invitedButton setBackgroundImage: shareButtonBkg forState: UIControlStateNormal];
    
    UIImage* segmentSelected = [[UIImage imageNamed: @"invite_seg_select"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 8, 0, 8)];
    
    UIImage* segmentUnselected = [[UIImage imageNamed: @"invite_seg_normal"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 8, 0, 8)];
    
    UIImage* segmentSelectedUnselected = [UIImage imageNamed: @"invite_seg_sel_unsel"];
    
    UIImage* segmentUnselectedSelected = [UIImage imageNamed: @"invite_seg_unsel_sel"];
    
    UIImage* segmentUnselectedUnselected = [UIImage imageNamed: @"invite_seg_unsel_unsel"];
    
    UIImage* segmentSelectedSelected = [UIImage imageNamed: @"invite_seg_sel_sel"];
    
    [self.segment setBackgroundImage: segmentUnselected forState: UIControlStateNormal barMetrics: UIBarMetricsDefault];
    [self.segment setBackgroundImage: segmentSelected forState: UIControlStateSelected barMetrics: UIBarMetricsDefault];
    [self.segment setDividerImage: segmentSelectedUnselected forLeftSegmentState: UIControlStateSelected rightSegmentState: UIControlStateNormal barMetrics: UIBarMetricsDefault];
    [self.segment setDividerImage: segmentUnselectedSelected forLeftSegmentState: UIControlStateNormal rightSegmentState: UIControlStateSelected barMetrics: UIBarMetricsDefault];
    [self.segment setDividerImage: segmentUnselectedUnselected forLeftSegmentState: UIControlStateNormal rightSegmentState: UIControlStateNormal barMetrics: UIBarMetricsDefault];
    
    [self.segment setDividerImage: segmentSelectedSelected forLeftSegmentState: UIControlStateHighlighted rightSegmentState: UIControlStateSelected barMetrics: UIBarMetricsDefault];
    [self.segment setDividerImage: segmentSelectedSelected forLeftSegmentState: UIControlStateSelected rightSegmentState: UIControlStateHighlighted barMetrics: UIBarMetricsDefault];
    
    CGRect segmentFrame = [self.segment frame];
    segmentFrame.size.height = 38;
    [self.segment setFrame: segmentFrame];
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17], UITextAttributeFont, [UIColor grayColor], UITextAttributeTextColor, nil];
    [self.segment setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17], UITextAttributeFont, [UIColor whiteColor], UITextAttributeTextColor, nil];
    [self.segment setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
    
    NSString* inviteCode = [[LoginAndRegister sharedInstance] getInviteCode];
    if (inviteCode != nil)
    {
        [self setInviteCode: inviteCode];
    }
    
    NSString* inviter = [[LoginAndRegister sharedInstance] getInviter];
    if (!(inviter == nil || [inviter length] == 0))
    {
        [self setInvitedPeople: inviter];
        [self updateInvitersControls: YES];
    }
    else
    {
        [self updateInvitersControls: NO];
    }
    
    [self updateErrorMsg: NO msg: nil];
}

- (void)updateErrorMsg: (BOOL)error msg: (NSString *)errMsg
{
    if (error)
    {
        [self.errorImage setHidden: NO];
        [self.errorMessage setHidden: NO];
        [self.errorMessage setText: errMsg];
    }
    else
    {
        [self.errorImage setHidden: YES];
        [self.errorMessage setHidden: YES];
    }
}

- (void)updateInvitersControls: (BOOL)hasInviter
{
    if (hasInviter)
    {
        self.invitedPeopleTextfield.enabled = NO;
        self.invitedButton.hidden = YES;
    }
    else
    {
        self.invitedPeopleTextfield.enabled = YES;
        self.invitedButton.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self.inviteView release];
    [self.invitedView release];
    [self.inviteCode release];
    [self.invitedPeople release];
    [_inviterUpdate release];
    [_errorImage release];
    [super dealloc];
}

-(void) ShareCompleted : (id) share State:(SSResponseState) state Err:(id<ICMErrorInfo>) error {
}

- (IBAction)copy:(id)sender
{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.inviteUrlTextField.text;
}

- (IBAction)share:(id)sender
{
    id<ISSContent> publishContent = [ShareSDK content: [NSString stringWithFormat: @"http://wangcai.meme-da.com/invite/index.php?code=%@", _inviteCode] defaultContent: [NSString stringWithFormat: @"http://wangcai.meme-da.com/invite/index.php?code=%@", _inviteCode] image: nil title: @"旺财分享" url: [NSString stringWithFormat: @"http://wangcai.meme-da.com/invite/index.php?code=%@", _inviteCode] description: @"旺财分享" mediaType: SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet: nil shareList: nil content: publishContent statusBarTips: YES authOptions: nil shareOptions: nil result: ^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
     {
         if (state == SSResponseStateSuccess)
         {
             // todo 分享成功
         }
         else if (state == SSResponseStateFail)
         {
             // todo 分享失败
         }
     }];
}

- (IBAction)switchView:(id)sender
{
    UIView* fromView, *toView;
    
    if ([self.inviteView superview] != nil)
    {
        fromView = self.inviteView;
        toView = self.invitedView;
    }
    else
    {
        fromView = self.invitedView;
        toView = self.inviteView;
    }
    
    NSArray* priorConstraints = self.priorConstraints;
    [UIView transitionFromView: fromView toView: toView duration: 0.4 options: UIViewAnimationOptionTransitionCrossDissolve completion: ^(BOOL finished)
    {
        [self.containerView removeConstraints: priorConstraints];
    }];
    self.priorConstraints = [self constrainSubview: toView toMatchWithSuperview: self.containerView];
}

- (void)setInviteCode: (NSString *)inviteCode
{
    if (_inviteCode != inviteCode)
    {
        [_inviteCode release];
        _inviteCode = [inviteCode copy];
        
        self.inviteCodeLabel.text = _inviteCode;
        self.inviteUrlTextField.text = [NSString stringWithFormat: @"http://wangcai.meme-da.com/invite/index.php?code=%@", _inviteCode];
        self.qrcodeView.image = [self QRCodeGenerator: [NSString stringWithFormat: @"http://wangcai.meme-da.com/invite/index.php?code=%@", _inviteCode] andLightColor: [UIColor whiteColor] andDarkColor: [UIColor blackColor] andQuietZone: 1 andSize: 128];
    }
}

- (void)setInvitedPeople: (NSString *)invitedPeople
{
    if (_invitedPeople != invitedPeople)
    {
        [_invitedPeople release];
        _invitedPeople = [invitedPeople copy];
        
        self.invitedPeopleTextfield.text = _invitedPeople;
    }
}

- (void)setReceiveMoney:(NSUInteger)receiveMoney
{
    _receiveMoney = receiveMoney;
    self.receiveMoneyLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)_receiveMoney];
}

- (UIImage *)QRCodeGenerator: (NSString *)iData andLightColor: (UIColor *)iLightColor andDarkColor: (UIColor *)iDarkColor andQuietZone: (NSInteger)iQuietZone andSize: (NSInteger)iSize
{
    UIImage* ret = nil;
    QRcode* qr = QRcode_encodeString([iData UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    int logQRSize = qr->width;
    int phyQRSize = logQRSize + (2 * iQuietZone);
    int scale = iSize / phyQRSize;
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
    [self postNotification: @"showMenu"];
}

- (IBAction)hideKeyboard:(id)sender
{
    [_invitedPeopleTextfield resignFirstResponder];
}

- (void)showLoading
{
    [MBHUDView hudWithBody: @"请等待..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter: -1 show: YES];
}

- (void)hideLoading
{
    [MBHUDView dismissCurrentHUD];
}

- (IBAction)updateInviter:(id)sender
{
    NSString* inviter = self.invitedPeopleTextfield.text;
    [_inviterUpdate updateInviter: inviter delegate: self];
    [self showLoading];
}

- (void)updateInviterCompleted:(BOOL)suc errMsg:(NSString *)errMsg
{
    [self hideLoading];
    if (suc)
    {
        // 发送成功
        [self setInvitedPeople: self.invitedPeopleTextfield.text];
        [self updateInvitersControls: YES];
    }
    else
    {
        // 发送失败
        if (errMsg == nil)
        {
            [self updateErrorMsg: YES msg: @"绑定邀请人失败"];
        }
        else
        {
            [self updateErrorMsg: YES msg: errMsg];
        }
    }
}

@end
