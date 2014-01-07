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

@implementation BalanceInfo
@synthesize _newBalance;
@synthesize _oldBalance;
@end

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
    self->_delegate = nil;
    self->loginStatus = Login_Error;
    self->_phoneNum = nil;
    self->_delegateArray = [[NSMutableArray alloc]init];
    self->_delegateBalanceArray = [[NSMutableArray alloc]init];
    self->_balance = 0;
    
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
                
                NSNumber* num = [dict valueForKey:@"balance"];
                _balance = [num floatValue] / 100;
                num = [dict valueForKey:@"income"];
                _income = [num floatValue] / 100;
                
                num = [dict valueForKey:@"outgo"];
                _outgo = [num floatValue] / 100;
                
                num = [dict valueForKey:@"recent_income"];
                _recentIncome = [num floatValue] / 100;
                
                _inviter = [[dict valueForKey:@"inviter"] copy];
                _invite_code = [[dict valueForKey:@"invite_code"] copy];
                
                // test
                //_phoneNum = @"13632729763";
                //_balance = 100;
                //
                
                [self setLoginStatus:Login_Success HttpCode:req.responseStatusCode Msg:nil];
            } else {
                NSString* err = [[dict valueForKey:@"msg"] copy];
                [self setLoginStatus:Login_Error HttpCode:req.responseStatusCode Msg:err];
            }
        }
    }
}

-(void) increaseBalance:(float) inc {
    float oldBalance = _balance;
    _balance = _balance + inc;
    
    [self fire_balanceChanged:oldBalance New:_balance];
}

-(void) setBalance:(float) balance {
    if ( balance != _balance ) {
        float oldBalance = _balance;
        _balance = balance;
    
        [self fire_balanceChanged:oldBalance New:_balance];
    }
}

-(void) fire_balanceChanged:(float) old New:(float) balance {
    BalanceInfo* info = [[BalanceInfo alloc]init];
    info._newBalance = balance;
    info._newBalance = old;
    [self postNotification:@"balanceChanged" withObject:info];
    [info release];
    
    for ( int i = 0; i < [_delegateBalanceArray count]; i ++ ) {
        id delegate = [_delegateBalanceArray objectAtIndex:i];
        [delegate balanceChanged:old New:balance];
    }
}

-(void) fire_bindPhoneEvent {
    for ( int i = 0; i < [_delegateArray count]; i ++ ) {
        id delegate = [_delegateArray objectAtIndex:i];
        [delegate bindPhoneCompeted];
    }
}

-(void) attachBindPhoneEvent : (id) delegate {
    [_delegateArray addObject:[delegate retain]];
}

-(void) detachBindPhoneEvent : (id) delegate {
    [_delegateArray removeObject:delegate];
    [delegate release];
}

-(void) attachBalanceChangeEvent : (id) delegate {
    [_delegateBalanceArray addObject:[delegate retain]];
}

-(void) detachBalanceChangeEvent : (id) delegate {
    [_delegateBalanceArray removeObject:delegate];
    [delegate release];
}

-(void) attachPhone : (NSString*) phoneNum UserId:(NSString*) userid InviteCode:(NSString*) inviteCode {
    if ( _invite_code != nil ) {
        [_invite_code release];
    }
    
    _invite_code = [inviteCode copy];
    
    if ( _phoneNum != nil ) {
        [_phoneNum release];
    }
    
    _phoneNum = [phoneNum copy];
    
    if ( _userid != nil ) {
        [_userid release];
    }
    
    _userid = [userid copy];
    
    [self fire_bindPhoneEvent];
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

-(float) getBalance {
    return _balance;
}

-(NSString*) getInviteCode {
    if ( self->_invite_code== nil ) {
        return nil;
    }
    return [self->_invite_code copy];
}

-(NSString*) getInviter {
    if ( self->_inviter== nil ) {
        return nil;
    }
    return [self->_inviter copy];
}

-(float) getIncome {
    return _income;
}

-(float) getOutgo {
    return _outgo;
}

-(void) setIncome:(float) income {
    _income = income;
}

-(void) setOutgo:(float) outgo {
    _outgo = outgo;
}

-(float) getRecentIncome {
    return _recentIncome;
}

@end
