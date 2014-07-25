//
//  InstallAppAlertView.m
//  wangcai
//
//  Created by NPHD on 14-6-27.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "InstallAppAlertView.h"
#import "Bee.h"

@implementation InstallAppAlertView

- (id)initWithIcon:(NSString *)iconurl
             title:(NSString *)atitle
              desc:(NSString *)desc
            target:(id)target
           install:(SEL)install
            cancel:(SEL)cancel
             money:(NSString *)money
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        UIImage *bg = [UIImage imageNamed:@"alertbg.png"];
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-bg.size.width/2)/2.f, (self.frame.size.height-bg.size.height/2)/2.f,bg.size.width/2.f, bg.size.height/2.f)];
        alertBg.image = bg;
        [self addSubview:alertBg];
         [alertBg release];

        
        UIImage *closeimage = [UIImage imageNamed:@"app_tip_close.png"];
        
        UIButton *closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closebtn setBackgroundImage:closeimage forState:UIControlStateNormal];
        closebtn.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-alertBg.frame.size.width)/2.f+alertBg.frame.size.width-closeimage.size.width/2.f-5, 70, closeimage.size.width, closeimage.size.height);
        [closebtn addTarget:target action:cancel forControlEvents:UIControlEventTouchUpInside];
        if([[UIScreen mainScreen] bounds].size.height > 480)
        {
            CGRect frame = closebtn.frame;
            frame.origin.y = 70+([[UIScreen mainScreen] bounds].size.height-480)/2.f;
            closebtn.frame = frame;
        }
        [self addSubview:closebtn];
       
       
        
        UIButton *go = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"alertButtonnormal.png"];
        [go setBackgroundImage:image forState:UIControlStateNormal];
        go.frame = CGRectMake((self.frame.size.width-image.size.width/2)/2.f,320, image.size.width/2, image.size.height/2);
        
        
        if([[UIScreen mainScreen] bounds].size.height > 480)
        {
            CGRect frame = go.frame;
            frame.origin.y = 320+([[UIScreen mainScreen] bounds].size.height-480)/2.f;
            go.frame = frame;
        }
        [self addSubview:go];
        [go addTarget:target action:install forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *mo = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, go.frame.size.width, go.frame.size.height-7)];
        mo.text = [NSString stringWithFormat:@"      新装体验            %@元",money];
        mo.backgroundColor = [UIColor clearColor];
        [go addSubview:mo];
        mo.textColor = [UIColor whiteColor];
        mo.font = [UIFont systemFontOfSize:22.f];
        mo.backgroundColor = [UIColor clearColor];
        [mo release];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, alertBg.frame.size.width, 30)];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont boldSystemFontOfSize:22.f];
        [alertBg addSubview:title];
        title.text = @"特别机会";
        title.textAlignment = UITextAlignmentCenter;
        [title release];
        
        
        BeeUIImageView *appIcon = [[BeeUIImageView alloc]init];
        UIImage* cachedImage = [[BeeImageCache sharedInstance] imageForURL:iconurl];
         appIcon.contentMode = UIViewContentModeScaleAspectFit;
        if (cachedImage != nil)
        {
            [appIcon setBackgroundImage:cachedImage];
        }
        else
        {
            [appIcon GET:iconurl useCache:YES placeHolder:[UIImage imageNamed:@"Icon.png"]];
        }
        
        appIcon.frame = CGRectMake(10, 70, 80, 80);
        [alertBg addSubview:appIcon];
        [appIcon release];
        
        UILabel *appName = [[UILabel alloc]initWithFrame:CGRectMake(100, 70, alertBg.frame.size.width, 20)];
        appName.backgroundColor = [UIColor clearColor];
        appName.font = [UIFont boldSystemFontOfSize:20.f];
        [alertBg addSubview:appName];
        appName.text = atitle;
        [appName release];
        
        
        
        UILabel *appDesc = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 170, 40)];
        appDesc.numberOfLines = 6;
        appDesc.text = desc;
        CGSize size = CGSizeMake(170, 120);
        CGSize labelSize = [appDesc.text sizeWithFont:appDesc.font
                                  constrainedToSize:size
                                      lineBreakMode:UILineBreakModeClip];
        appDesc.frame = CGRectMake(appDesc.frame.origin.x, appDesc.frame.origin.y,
                                 appDesc.frame.size.width, labelSize.height);
        [alertBg addSubview:appDesc];
        appDesc.textColor = [UIColor blueColor];
        appDesc.backgroundColor = [UIColor clearColor];
        [appDesc release];
    }
    return self;
}
- (void)dealloc
{
    [self removeAllSubviews];
    [super dealloc];
}
@end