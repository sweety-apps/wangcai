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
    _delegate = nil;
    self->loginStatus = Login_Error;
    self->_phoneNum = nil;
    
    return self;
}

- (void) dealloc {
    if ( _delegate != nil ) {
        [_delegate release];
    }
    
    [super dealloc];
}

// session超时后，需要先设置超时，然后login
-(void) setTimeout { // 修改登录状态为已超时
    self->loginStatus = Login_Timeout;
}

-(void) sendEvent : (LoginStatus) status HttpCode:(int)httpCode Msg:(NSString*)msg {
    if (_delegate != nil ) {
        [_delegate loginCompleted:status HttpCode:httpCode Msg:msg];
    }
}

-(void) login: (id) delegate {
    [self login];
    _delegate = [delegate retain];
}

-(void) login {
    // 发起登录或注册请求
    if ( _delegate != nil ) {
        [_delegate release];
        _delegate = nil;
    }
    
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

- (void) setLoginStatus : (LoginStatus) status HttpCode:(int)code Msg:(NSString*) msg {
    self->loginStatus = status;
    
    [self sendEvent:status HttpCode:code Msg:msg];
}

- (void) handleRequest:(BeeHTTPRequest *)req {
    if ( req.sending) {
    } else if ( req.recving ) {
    } else if ( req.failed ) {
        [self setLoginStatus:Login_Error HttpCode:req.responseStatusCode Msg:nil];
    } else if ( req.succeed ) {
        // 判断返回数据是
        NSError* error;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:req.responseData options:NSJSONReadingMutableLeaves error:&error];
        if ( dict == nil || [dict count] == 0 ) {
            [self setLoginStatus:Login_Error HttpCode:req.responseStatusCode Msg:nil];
        } else {
            NSNumber* res = [dict valueForKey:@"res"];
            if ( [res intValue] == 0 ) {
                _userid = [[dict valueForKey:@"userid"] copy];
                _session_id = [[dict valueForKey:@"session_id"] copy];
                _nickname = [[dict valueForKey:@"nickname"] copy];
                _device_id = [[dict valueForKey:@"device_id"] copy];
                _phoneNum = [[dict valueForKey:@"phone"] copy];
                _balance = [[dict valueForKey:@"balance"] copy];
            
                [self setLoginStatus:Login_Success HttpCode:req.responseStatusCode Msg:nil];
            } else {
                NSString* err = [[dict valueForKey:@"msg"] copy];
                [self setLoginStatus:Login_Error HttpCode:req.responseStatusCode Msg:err];
            }
        }
    }
}

-(NSString*) getPhoneNum {
    if ( self->_phoneNum == nil ) {
        return nil;
    }
    return [self->_phoneNum copy];
}

-(NSNumber*) getUserId  {
    if ( self->_userid == nil ) {
        return nil;
    }
    return [self->_userid copy];
}

-(NSString*) getSessionId  {
    if ( self->_session_id == nil ) {
        return nil;
    }
    return [self->_session_id copy];
}

-(NSString*) getNickName  {
    if ( self->_nickname == nil ) {
        return nil;
    }
    return [self->_nickname copy];
}

-(NSString*) getDeviceId  {
    if ( self->_device_id == nil ) {
        return nil;
    }
    return [self->_device_id copy];
}

-(NSNumber*) getBalance {
    if ( self->_balance== nil ) {
        return nil;
    }
    return [self->_balance copy];
}

@end
