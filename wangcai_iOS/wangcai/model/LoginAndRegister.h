//
//  LoginAndRegister.h
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum LoginStatus {
    Login_Timeout,  // session超时，需要重新登录
    Login_Error,    // 登录失败
    Login_Success,  // 登录成功
    Login_In        // 登录中
} LoginStatus;

@protocol LoginAndRegisterDelegate <NSObject>
-(void) loginCompleted : (LoginStatus) status HttpCode:(int)httpCode Msg:(NSString*)msg;
@end

@protocol BindPhoneDelegate <NSObject>
-(void) bindPhoneCompeted;
@end

@interface LoginAndRegister : NSObject {
    id          _delegate;
    LoginStatus loginStatus;
    NSString*   _phoneNum;
    NSNumber*   _userid;
    NSString*   _session_id;
    NSString*   _nickname;
    NSString*   _device_id;
    float       _balance;
    NSString*   _invite_code;
    NSString*   _inviter;
    
    NSMutableArray* _delegateArray;
}

+(id) sharedInstance;

// 如果不是返回成功，可以attach事件，然后调用login接口，完成后回调，然后再调用相应的接口从服务器取数据
-(LoginStatus) getLoginStatus;
// session超时后，需要先设置超时，然后login
-(void) setTimeout; // 修改登录状态为已超时
-(void) login;

-(void) login: (id) delegate;

-(NSString*) getPhoneNum;
-(NSNumber*) getUserId;
-(NSString*) getSessionId;
-(NSString*) getNickName;
-(NSString*) getDeviceId;
-(float) getBalance;
-(NSString*) getInviteCode;
-(NSString*) getInviter;

-(void) attachPhone : (NSString*) phoneNum UserId:(NSString*) userid InviteCode:(NSString*) inviteCode;

-(void) attachBindPhoneEvent : (id) delegate;
-(void) detachBindPhoneEvent : (id) delegate;
@end
