//
//  InviteController.m
//  wangcai
//
//  Created by 1528 on 13-12-11.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "InviteController.h"
#import <ShareSDK/ShareSDK.h>

@interface InviteController ()

@end

@implementation InviteController
//@synthesize _myInviteLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self->_inviteCode = @"inviteCode";
        
        //self.title = @"邀请送红包";
        
        UIView* view = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] firstObject];
        self.view = view;
        
        //[self->_myInviteLabel setText:self->_inviteCode];
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

- (void)dealloc {
    //[self->_inviteCode release];
    [super dealloc];
}

- (IBAction) copyToClip:(id)sender {
    //UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    //pasteboard.string = self->_inviteCode;
}

-(void) ShareCompleted : (id) share State:(SSResponseState) state Err:(id<ICMErrorInfo>) error {
}

- (IBAction) clickShare:(id)sender {
    NSString* imagePath = [[NSBundle mainBundle] pathForResource: @"Share" ofType: @"jpg"];
    
    id<ISSContent> publishContent = [ShareSDK content: @"微信朋友圈测试分享" defaultContent: @"默认分享内容" image: [ShareSDK imageWithPath: imagePath] title: @"微信分享测试" url: @"http://www.baidu.com" description: @"微信分享测试" mediaType: SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet: nil shareList: nil content: publishContent statusBarTips: YES authOptions: nil shareOptions: nil result: ^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
     {
         if (state == SSResponseStateSuccess)
         {
             NSLog(@"分享成功");
         }
         else if (state == SSResponseStateFail)
         {
             NSLog(@"分享失败，错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
         }
     }];
}
@end
