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
-(void) loginCompleted : (LoginStatus) status HttpCode:(int)httpCode ErrCode:(int)errCode Msg:(NSString*)msg;
@end

@protocol BindPhoneDelegate <NSObject>
-(void) bindPhoneCompeted;
@end

@protocol BalanceChangeDelegate <NSObject>
-(void) balanceChanged:(int) oldBalance New:(int) balance;
@end

@interface BalanceInfo : NSObject {
}

@property float _oldBalance;
@property float _newBalance;
@end

@interface LoginAndRegister : NSObject {
    id          _delegate;
    LoginStatus loginStatus;
    NSString*   _phoneNum;
    NSString*   _userid;
    NSString*   _session_id;
    NSString*   _nickname;
    NSString*   _device_id;
    NSString*   _tipsString;
    int       _balance;
    int       _income;    // 总收入
    int       _outgo;     // 总支出
    int       _recentIncome;  // 最近赚到
    int       _offerwallIncome; // 积分墙总收入
    int       _inviteIncome;
    NSString*   _invite_code;
    NSString*   _inviter;
    
    NSMutableArray* _delegateArray;
    NSMutableArray* _delegateBalanceArray;
    
    int        _force_update;
    
    BOOL       _firstLogin;
    
    int        _nowithdraw;
    int        _showDomob;
    int        _showYoumi;
    
    int        _inReview;
    
    int        _pollingInterval;
}

+(id) sharedInstance;

// 如果不是返回成功，可以attach事件，然后调用login接口，完成后回调，然后再调用相应的接口从服务器取数据
-(LoginStatus) getLoginStatus;
// session超时后，需要先设置超时，然后login
-(void) setTimeout; // 修改登录状态为已超时
-(void) login;

-(void) login: (id) delegate;

-(NSString*) getPhoneNum;
-(NSString*) getUserId;
-(NSString*) getSessionId;
-(NSString*) getNickName;
-(NSString*) getDeviceId;
-(int) getBalance;
-(NSString*) getInviteCode;
-(NSString*) getInviter;

-(int) getIncome;
-(int) getOutgo;
-(int) getRecentIncome;

-(void) setIncome:(int) income;
-(void) setOutgo:(int) outgo;

-(void) attachPhone : (NSString*) phoneNum UserId:(NSString*) userid InviteCode:(NSString*) inviteCode;

-(void) attachBindPhoneEvent : (id) delegate;
-(void) detachBindPhoneEvent : (id) delegate;

-(void) attachBalanceChangeEvent : (id) delegate;
-(void) detachBalanceChangeEvent : (id) delegate;

-(void) increaseBalance:(int) inc;
-(void) setBalance:(int) balance;

-(int) getInviteIncome;
-(int) getForceUpdate;

-(void) setShareIncome:(int) nShareIncome;
-(void) setInviter:(NSString*) inviter;

-(BOOL) isShowDomob;
-(BOOL) isShowYoumi;

-(int)  getNoWithDraw;
-(NSString*) getTipsStrings;

-(BOOL) isInReview;
-(int) getOfferwallIncome;

-(int) getPollingInterval;
@end
