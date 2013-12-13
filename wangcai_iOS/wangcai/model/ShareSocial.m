//
//  ShareSocial.m
//  wangcai
//
//  Created by 1528 on 13-12-11.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "ShareSocial.h"

@implementation ShareSocial

-(id) init : (id) delegate {
    self = [super init];
    if (self) {
        self->_delegate = delegate;
    }
    
    return self;
}

-(void) share : (NSString*)imagePath Context:(NSString*)context Title:(NSString*)title Url:(NSString*)url Description:(NSString*)desc {
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:context
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:title
                                                  url:url
                                          description:desc
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    if (self->_delegate != nil ) {
                                        [self->_delegate ShareCompleted:self State:SSResponseStateSuccess Err:nil];
                                    }
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    if (self->_delegate != nil ) {
                                        [self->_delegate ShareCompleted:self State:SSResponseStateSuccess Err:error];
                                    }
                                }
                                else if (state == SSResponseStateCancel)
                                {
                                    if (self->_delegate != nil ) {
                                        [self->_delegate ShareCompleted:self State:SSResponseStateCancel Err:nil];
                                    }
                                }
                            }];
}

-(void)dealloc {
    [self->_delegate release];
    [super dealloc];
}
@end
