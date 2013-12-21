//
//  PhoneValidation.h
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PhoneValidationDelegate <NSObject>
-(void) sendSMSCompleted : (BOOL) suc errMsg:(NSString*) errMsg  token:(NSString*) token;

-(void) checkSmsCodeCompleted : (BOOL) suc errMsg:(NSString*) errMsg UserId:(NSString*) userId Nickname:(NSString*)nickname;

-(void) attachPhoneCompleted : (BOOL) suc errMsg:(NSString*)errMsg;
@end

@interface PhoneValidation : NSObject {
    id _smsDelegate;
    int _status; //0-绑定手机号, 1-校验短信验证码, 2-发送短信验证码
    NSString* _phoneNum;
}

- (void) attachPhone : (NSString*) phoneNum delegate:(id) del;

- (void) sendCheckNumToPhone : (NSString*) phoneNum delegate : (id) del;
- (void) checkSmsCode : (NSString*)phoneNum smsCode:(NSString*)code Token:(NSString*)token delegate:(id)del;
@end
