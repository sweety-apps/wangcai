//
//  ShareTaskAlertView.m
//  wangcai
//
//  Created by NPHD on 14-7-24.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "ShareTaskAlertView.h"

@implementation ShareTaskAlertView

- (id)initWithCheckCount :(int)count
               totalCount:(int)totalCount
              shareTarget:(id)shareTarget
              shareAction:(SEL)shareAction
            previewTarget:(id)previewTarget
            previewAction:(SEL)previewAction
              closeTarget:(id)closeTarget
              closeAction:(SEL)closeAction
{
     self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        UIImage *bg = [UIImage imageNamed:@"share__alert_bg.png"];
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-bg.size.width/2)/2.f, (self.frame.size.height-bg.size.height/2)/2.f,bg.size.width/2.f, bg.size.height/2.f)];
        alertBg.image = bg;
        [self addSubview:alertBg];
        [alertBg release];
        
        UIImage *closeimage = [UIImage imageNamed:@"app_tip_close.png"];
        
        UIButton *closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closebtn setBackgroundImage:closeimage forState:UIControlStateNormal];
        closebtn.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-alertBg.frame.size.width)/2.f+alertBg.frame.size.width-closeimage.size.width/2.f-5, 110, closeimage.size.width, closeimage.size.height);
        [closebtn addTarget:closeTarget action:closeAction forControlEvents:UIControlEventTouchUpInside];
        if([[UIScreen mainScreen] bounds].size.height > 480)
        {
            CGRect frame = closebtn.frame;
            frame.origin.y += ([[UIScreen mainScreen] bounds].size.height-480)/2.f;
            closebtn.frame = frame;
        }
        [self addSubview:closebtn];
        
       
        
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(25, 35, alertBg.frame.size.width-25, 40)];
        content.backgroundColor = [UIColor clearColor];
        content.font = [UIFont boldSystemFontOfSize:20.f];
        content.text = [NSString stringWithFormat:@"分享并被好友查看%d次",totalCount];
        content.textColor = [UIColor colorWithRed:190/255.f green:0 blue:8/255.f alpha:1.f];
        [alertBg addSubview:content];
        [content release];
        
        
        
        UILabel *progress = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, alertBg.frame.size.width, 80)];
        progress.backgroundColor = [UIColor clearColor];
        progress.font = [UIFont boldSystemFontOfSize:60.f];
        progress.text = [NSString stringWithFormat:@"%d/%d",count,totalCount];
        progress.textColor = [UIColor colorWithRed:195/255.f green:0 blue:8/255.f alpha:1.f];
        progress.textAlignment = UITextAlignmentCenter;
        [alertBg addSubview:progress];
        [progress release];
        
        UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
        [share setBackgroundImage:[UIImage imageNamed:@"fenxiang"]];
        [share addTarget:shareTarget action:shareAction forControlEvents:UIControlEventTouchUpInside];
        share.backgroundColor = [UIColor colorWithRed:9/255.f green:62/255.f blue:178/255.f alpha:1.f];
        share.enabled = YES;
        share.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-alertBg.frame.size.width)/2.f+15, 290, 120, 40);
        if([[UIScreen mainScreen] bounds].size.height > 480)
        {
            CGRect frame = share.frame;
            frame.origin.y += ([[UIScreen mainScreen] bounds].size.height-480)/2.f;
            share.frame = frame;
        }
        [self addSubview:share];
        
        
        UIButton *preview = [UIButton buttonWithType:UIButtonTypeCustom];
        //[preview setTitle:@"预览" forState:UIControlStateNormal];
        [preview setBackgroundImage:[UIImage imageNamed:@"liulan"]];
        [preview addTarget:previewTarget action:previewAction forControlEvents:UIControlEventTouchUpInside];
        preview.backgroundColor = [UIColor colorWithRed:9/255.f green:62/255.f blue:178/255.f alpha:1.f];
        preview.enabled = NO;
        preview.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-alertBg.frame.size.width)/2.f+15+share.frame.size.width+15, 290, 120, 40);
        if([[UIScreen mainScreen] bounds].size.height > 480)
        {
            CGRect frame = preview.frame;
            frame.origin.y += ([[UIScreen mainScreen] bounds].size.height-480)/2.f;
            preview.frame = frame;
        }
        [self addSubview:preview];
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
    NSLog(@"dealloc");
}
@end
