//
//  LoginAndRegister.m
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "LoginAndRegister.h"
#import "Config.h"
#import "Common.h"

@implementation LoginAndRegister
static LoginAndRegister* _sharedInstance;

+(id) sharedInstance {
    if ( _sharedInstance == nil ) {
        _sharedInstance = [[LoginAndRegister alloc]init];
    }
    return _sharedInstance;
}

- (id) init {
    [super init];
    self->idArray = [[NSMutableArray alloc]init];
    self->loginStatus = Login_Error;
    self->_phoneNum = nil;
    
    return self;
}

- (void) dealloc {
    [self->idArray dealloc];
    [super dealloc];
}

// session超时后，需要先设置超时，然后login
-(void) setTimeout { // 修改登录状态为已超时
    self->loginStatus = Login_Timeout;
}

-(void) attachCompleteEvent : (id) dele {
    [self->idArray addObject:dele];
}

-(void) deattchCompleteEvent : (id) dele {
    [self->idArray removeObject:dele];
}


-(void) sendEvent : (LoginStatus) status {
    NSMutableArray* array = [self->idArray copy];
    for ( int i = 0; i < [array count]; i ++) {
        id dele = [array objectAtIndex:i];
        if ( dele != nil ) {
            [dele loginCompleted:status];
        }
    }
    
    [array release];
}

-(void) login {
    // 发起登录或注册请求
    self->loginStatus = Login_In;

    BeeHTTPRequest* req = self.HTTP_POST(HTTP_LOGIN_AND_REGISTER);
    NSString* nsParam = [[NSString alloc]init];
    
    if ( _phoneNum != nil ) {
        // 应该在登录成功后设置
        nsParam = [nsParam stringByAppendingFormat:@"phone=%@&", _phoneNum];
    }
    
    
    NSString* idfa = [Common getIDFAAddress];
    nsParam = [nsParam stringByAppendingFormat:@"idfa=%@&", idfa];

    NSString* mac = [Common getMACAddress];
    nsParam = [nsParam stringByAppendingFormat:@"mac=%@&", mac];
    
    NSString* timestamp = [Common getTimestamp];
    nsParam = [nsParam stringByAppendingFormat:@"timestamp=%@&", timestamp];

    NSMutableData* data = [[NSMutableData alloc] init];
    
    
    NSString* encodedString = [nsParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //[nsParam release];
    
    const char * a =[encodedString UTF8String];

    req.HEADER(@"Content-Type", @"application/x-www-form-urlencoded");
    [data appendBytes:a length:strlen(a)];
    
    req.postBody = [[data copy] autorelease];
    
    req.TIMEOUT(10);
    
    [data release];
}

- (void) setLoginStatus : (LoginStatus) status {
    self->loginStatus = status;
    
    [self sendEvent:status];
}

- (void) handleRequest:(BeeHTTPRequest *)req {
    if ( req.sending) {
    } else if ( req.recving ) {
    } else if ( req.failed ) {
        [self setLoginStatus:Login_Error];
    } else if ( req.succeed ) {
        // 判断返回数据是
        NSError* error;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:req.responseData options:NSJSONReadingMutableLeaves error:&error];
        if ( dict == nil || [dict count] == 0 ) {
            [self setLoginStatus:Login_Error];
        } else {
            _userid = [dict valueForKey:@"userid"];
            _session_id = [dict valueForKey:@"session_id"];
            _nickname = [dict valueForKey:@"nickname"];
            _device_id = [dict valueForKey:@"device_id"];
            _phoneNum = [dict valueForKey:@"phone"];
            [self setLoginStatus:Login_Success];
        }
    }
}

-(NSString*) getPhoneNum {
    if ( self->_phoneNum == nil ) {
        return nil;
    }
    return [[self->_phoneNum copy] autorelease];
}

-(NSString*) getUserId  {
    if ( self->_userid == nil ) {
        return nil;
    }
    return [[self->_userid copy] autorelease];
}

-(NSString*) getSessionId  {
    if ( self->_session_id == nil ) {
        return nil;
    }
    return [[self->_session_id copy] autorelease];
}

-(NSString*) getNickName  {
    if ( self->_nickname == nil ) {
        return nil;
    }
    return [[self->_nickname copy] autorelease];
}

-(NSString*) getDeviceId  {
    if ( self->_device_id == nil ) {
        return nil;
    }
    return [[self->_device_id copy] autorelease];
}

@end
