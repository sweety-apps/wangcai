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
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        self.backgroundColor = [UIColor clearColor];
        UIImage *bg = [UIImage imageNamed:@"alertbg.png"];
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-bg.size.width/2)/2.f, (self.frame.size.height-bg.size.height/2)/2.f,bg.size.width/2.f, bg.size.height/2.f)];
        alertBg.image = bg;
        [self addSubview:alertBg];
         [alertBg release];

        
        UIImage *closeimage = [UIImage imageNamed:@"app_tip_close.png"];
        
        UIButton *closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closebtn setBackgroundImage:closeimage forState:UIControlStateNormal];
        closebtn.frame = CGRectMake(270, version>7.0?110:70, closeimage.size.width, closeimage.size.height);
        [closebtn addTarget:target action:cancel forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closebtn];
       
       
        
        UIButton *go = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"alertButtonnormal.png"];
        [go setBackgroundImage:image forState:UIControlStateNormal];
        go.frame = CGRectMake((self.frame.size.width-image.size.width/2)/2.f,version>7.0?360:320, image.size.width/2, image.size.height/2);
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
        
        
        BeeUIImageView *game = [[BeeUIImageView alloc]init];
        UIImage* cachedImage = [[BeeImageCache sharedInstance] imageForURL:iconurl];
        if (cachedImage != nil)
        {
            [game setBackgroundImage:cachedImage];
        }
        else
        {
            [game GET:iconurl useCache:YES];
        }
        
        game.frame = CGRectMake(10, 70, 80, 80);
        game.contentMode = UIViewContentModeScaleAspectFit;
        
        [alertBg addSubview:game];
        [game release];
        
        UILabel *gamename = [[UILabel alloc]initWithFrame:CGRectMake(-3, 70, alertBg.frame.size.width, 20)];
        gamename.backgroundColor = [UIColor clearColor];
        gamename.font = [UIFont boldSystemFontOfSize:20.f];
        [alertBg addSubview:gamename];
        gamename.text = atitle;
        gamename.textAlignment = UITextAlignmentCenter;
        [gamename release];
        
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 170, 40)];
        label.numberOfLines = 6;
        label.text = desc;
        CGSize size = CGSizeMake(170, 120);
        CGSize labelSize = [label.text sizeWithFont:label.font
                                  constrainedToSize:size
                                      lineBreakMode:UILineBreakModeClip];
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y,
                                 label.frame.size.width, labelSize.height);
        [alertBg addSubview:label];
        label.textColor = [UIColor blueColor];
        label.backgroundColor = [UIColor clearColor];
        [label release];
    }
    return self;
}

@end
