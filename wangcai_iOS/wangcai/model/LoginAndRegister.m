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
    return self;
}

- (void) dealloc {
    [self->idArray dealloc];
    [super dealloc];
}

// 如果不是返回成功，可以attach事件，然后调用login接口，完成后回调，然后再调用相应的接口从服务器取数据
-(LoginStatus) getLoginStatus {
    return self->loginStatus;
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

-(void) login : (NSString*)phoneNum {
    // 发起登录或注册请求
    if ( self->loginStatus == Login_Success || self->loginStatus == Login_In ) {
        return ;
    }
    
    self->loginStatus = Login_In;
    self.HTTP_POST(HTTP_LOGIN_AND_REGISTER);
    if ( phoneNum != nil ) {
        self.PARAM(@"Phone", phoneNum);
    }
    
    self.PARAM(@"Idfa", [Common getIDFAAddress]);
    self.PARAM(@"Mac", [Common getMACAddress]);
    self.PARAM(@"Timestamp", [Common getTimestamp]);
    
    self.TIMEOUT(10);
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
        [self setLoginStatus:Login_Success];
    }
}

@end
