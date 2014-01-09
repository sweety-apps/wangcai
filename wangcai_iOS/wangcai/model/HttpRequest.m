//
//  HttpRequest.m
//  wangcai
//
//  Created by 1528 on 13-12-21.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "HttpRequest.h"


@implementation HttpRequest

@synthesize extensionContext;

- (id) init : (id) delegate {
    self = [super init];
    if ( self ) {
        _delegate = [delegate retain];
        _request = nil;
        _relogin = NO;
        _param = nil;
        _url = nil;
    }
    return self;
}

- (void) dealloc {
    if ( _delegate != nil ) {
        [_delegate release];
    }
    if ( _param != nil ) {
        [_param release];
    }
    if ( _url != nil ) {
        [_url release];
    }
    self.extensionContext = nil;
    [super dealloc];
}

- (void) request : (NSString*) url Param:(NSDictionary*) params {
    [self request:url Param:params method:@"post"];
}



- (NSString*) getNetworkInfo {
    Reachability* r = [Reachability reachabilityWithHostName:@"app.getwangcai.com"];
    NSInteger state = [r currentReachabilityStatus];
    if ( state == 1 ) {
        return [[@"wifi" copy] autorelease];
    } else if ( state == 2 ) {
        return [[@"3g" copy] autorelease];
    }
    
    return [[@"none" copy] autorelease];
}

- (NSHTTPCookie*) getCookie {
    NSMutableDictionary* properties = [[[NSMutableDictionary alloc] init] autorelease];
    
    [properties setValue:@".getwangcai.com" forKey:NSHTTPCookieDomain];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
    [properties setValue:@"/asi-http-request/wangcai" forKey:NSHTTPCookiePath];
    
    [properties setValue:@"p" forKey:NSHTTPCookieName];
    
    NSString* sysModel = [[UIDevice currentDevice] model];
    NSString* sysVer = [[UIDevice currentDevice] systemVersion];
    NSDictionary* dic = [[NSBundle mainBundle] infoDictionary];
    NSString* appVersion = [dic valueForKey:@"CFBundleVersion"];
    NSString* network = [self getNetworkInfo];
    
    NSString* info = [[[NSString alloc] initWithFormat:@"%@_%@; app=%@; net=%@", sysModel, sysVer, appVersion, network] autorelease];
    [properties setValue:info forKey:NSHTTPCookieValue];
    
    NSHTTPCookie* cookie = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];
    
    return cookie;
}

- (void) request : (NSString*) url Param:(NSDictionary*) params method:(NSString*)getOrPost
{
    if ([getOrPost length] == 0)
    {
        getOrPost = @"post";
    }
    
    getOrPost = [getOrPost lowercaseString];
    NSString* newUrl = [[self BuildURL:url] autorelease];
    
    if ([getOrPost isEqualToString:@"get"] && params != nil ) {
        NSArray* keys = [params allKeys];
        int nCount = [keys count];
        for (int i = 0; i < nCount; i ++ ) {
            id key = [keys objectAtIndex:i];
            id value = [params objectForKey:key];
            
            newUrl = [newUrl stringByAppendingFormat:@"&%@=%@", key, value];
        }
    }
    
    if ([getOrPost isEqualToString:@"get"])
    {
        _request = self.HTTP_GET(newUrl);
    }
    else if([getOrPost isEqualToString:@"post"])
    {
        _request = self.HTTP_POST(newUrl);
    }
    else
    {
        _request = self.HTTP_POST(newUrl);
    }
    
    NSHTTPCookie* cookie = [self getCookie];
    [_request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
    
    _url = [url copy];
    if([getOrPost isEqualToString:@"post"]) {
        NSString* nsParam = [[NSString alloc]init];
    
        if ( params != nil ) {
            NSArray* keys = [params allKeys];
            int nCount = [keys count];
            for (int i = 0; i < nCount; i ++ ) {
                id key = [keys objectAtIndex:i];
                id value = [params objectForKey:key];
        
                if ( i == nCount - 1 ) {
                    nsParam = [nsParam stringByAppendingFormat:@"%@=%@", key, value];
                } else {
                    nsParam = [nsParam stringByAppendingFormat:@"%@=%@&", key, value];
                }
            }
        }
    
        _param = [nsParam copy];
    
        NSMutableData* data = [[[NSMutableData alloc] init] autorelease];
    
    
        NSString* encodedString = [nsParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
        const char * a =[encodedString UTF8String];
    
        _request.HEADER(@"Content-Type", @"application/x-www-form-urlencoded");
        [data appendBytes:a length:strlen(a)];
    
        _request.postBody = [[data copy] autorelease];
    }
    
    _request.TIMEOUT(10);
}


- (void) handleRequest:(BeeHTTPRequest *)req {
    if ( req.sending) {
    } else if ( req.recving ) {
    } else if ( req.failed ) {
        if ( _delegate != nil ) {
            [_delegate HttpRequestCompleted:self HttpCode:req.responseStatusCode Body:nil];
        }
    } else if ( req.succeed ) {
        // 判断返回数据是
        NSError* error;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:req.responseData options:NSJSONReadingMutableLeaves error:&error];
        if ( dict == nil || [dict count] == 0 ) {
            if ( _delegate != nil ) {
                [_delegate HttpRequestCompleted:self HttpCode:req.responseStatusCode Body:nil];
            }
        } else {
            NSNumber* res = [dict valueForKey:@"res"];
            if ( [res intValue] == 0 ) {
                if ( _delegate != nil ) {
                    [_delegate HttpRequestCompleted:self HttpCode:req.responseStatusCode Body:dict];
                }
            } else {
                if ( [res intValue] == 401 && !_relogin ) {
                    [self relogin];
                } else {
                    if ( _delegate != nil ) {
                        [_delegate HttpRequestCompleted:self HttpCode:req.responseStatusCode Body:dict];
                    }
                }
            }
        }
    }
    
    _relogin = NO;
}

-(void) relogin {
    [[LoginAndRegister sharedInstance] login:self];
}


- (NSString*) BuildURL :(NSString*) url {
    id userid = [[LoginAndRegister sharedInstance] getUserId];
    id sessionid = [[LoginAndRegister sharedInstance]getSessionId];
    id deviceid = [[LoginAndRegister sharedInstance] getDeviceId];
    
    NSString* newUrl = [[NSString alloc] initWithFormat:@"%@?session_id=%@&device_id=%@&userid=%@",
                        url, sessionid, deviceid, userid];
    
    [userid release];
    [sessionid release];
    [deviceid release];
    
    return newUrl;
}

- (void) request {
    NSString* url = [self BuildURL:_url];
    
    _request = self.HTTP_POST(url);
    
    NSMutableData* data = [[NSMutableData alloc] init];
    
    
    NSString* encodedString = [_param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    const char * a =[encodedString UTF8String];
    
    _request.HEADER(@"Content-Type", @"application/x-www-form-urlencoded");
    [data appendBytes:a length:strlen(a)];
    
    _request.postBody = [[data copy] autorelease];
    
    _request.TIMEOUT(10);
    
    [data release];
    [url release];
}


-(void) loginCompleted : (LoginStatus) status HttpCode:(int)httpCode Msg:(NSString*) msg {
    if ( status == Login_Success ) {
        // 重新请求
        _relogin = YES;
        [self request];
    } else {
        if ( _delegate != nil ) {
            [_delegate HttpRequestCompleted:self HttpCode:httpCode Body:nil];
        }
    }
}

@end
