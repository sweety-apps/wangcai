//
//  ScreenShots.m
//  wangcai
//
//  Created by NPHD on 14-6-27.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "ScreenShots.h"
#import "Config.h"
#import "Common.h"

@implementation ScreenShots

static ScreenShots* _sShots = nil;

+ (ScreenShots*) sharedInstance {
    if ( _sShots == nil ) {
        _sShots = [[ScreenShots alloc] init];
    }
    return _sShots;
}

- (void) start {
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer) userInfo:nil repeats:NO];
}

- (void)onTimer
{
    [self fullScreenshots];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer) userInfo:nil repeats:NO];
}


- (void) fullScreenshots {
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
    
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
    [self uploadImage:viewImage];
}

- (void) uploadImage:(UIImage*) image {
    NSData* data = UIImageJPEGRepresentation(image, 0);
    
    NSMutableData *imageData = [NSMutableData dataWithData:data];//ASIFormDataRequest 的setPostBody 方法需求的为NSMutableData类型
    if ( [imageData length] == _oldDataSize ) {
        return ;
    }
    _oldDataSize = [imageData length];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    NSString* surl = [Common buildURL:WEB_FULLSUCCESSSHOTS Params:dict];
    
    [dict release];
    
    NSURL *url = [NSURL URLWithString:surl];
    ASIFormDataRequest *aRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    [aRequest setDelegate:self];//代理
    
    [aRequest setRequestMethod:@"POST"];
    [aRequest setPostBody:imageData];
    [aRequest addRequestHeader:@"Content-Type" value:@"binary/octet-stream"];//这里的value值 需与服务器端 一致
    [aRequest startAsynchronous];//开始。异步
    [aRequest release];
}

@end
