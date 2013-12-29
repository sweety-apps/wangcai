//
//  HttpRequest.h
//  wangcai
//
//  Created by 1528 on 13-12-21.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginAndRegister.h"

@protocol HttpRequestDelegate <NSObject>
-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body;
@end

@interface HttpRequest : NSObject {
    id _delegate;
    BeeHTTPRequest* _request;
    BOOL    _relogin;
    NSString* _url;
    NSString* _param;
}

@property (nonatomic,retain) id extensionContext;

- (id) init : (id) delegate;
- (void) request : (NSString*) url Param:(NSDictionary*) params;//使用POST
- (void) request : (NSString*) url Param:(NSDictionary*) params method:(NSString*)getOrPost;
@end
