//
//  ShareSocial.h
//  wangcai
//
//  Created by 1528 on 13-12-11.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <shareSDK/ShareSDK.h>

@protocol ShareSocialDelegate <NSObject>
-(void) ShareCompleted : (id) share State:(SSResponseState) state Err:(id<ICMErrorInfo>) error;
@end

@interface ShareSocial : NSObject {
    id _delegate;
}
-(id) init : (id) delegate;
-(void) share : (NSString*)imagePath Context:(NSString*)context Title:(NSString*)title Url:(NSString*)url Description:(NSString*)desc;
@end
