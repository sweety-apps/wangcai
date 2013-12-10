//
//  PhoneValidation.m
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "PhoneValidation.h"
#import "Config.h"

@implementation PhoneValidation

- (void) sendCheckNumToPhone : (NSString*) phoneNum delegate : (id) del {
    self->_smsDelegate = del;
    self->_sendSmsCode = NO;
    
    self.HTTP_POST(HTTP_SEND_SMS_CODE);
    self.PARAM(@"phone_num", phoneNum);
    
    self.TIMEOUT(10);
}


- (void) checkSmsCode : (NSString*)phoneNum smsCode:(NSString*)code Token:(NSString*)token delegate:(id)del {
    self->_smsDelegate = del;
    self->_sendSmsCode = YES;
    
    self.HTTP_POST(HTTP_CHECK_SMS_CODE);
    self.PARAM(@"sms_code", code);
    self.PARAM(@"token", token);
    
    self.TIMEOUT(10);
}

- (void) handleRequest:(BeeHTTPRequest *)req {
    if ( self->_sendSmsCode ) {
        if ( req.failed ) {
            [self->_smsDelegate checkSmsCodeCompleted:NO errMsg:@"访问服务器错误" UserId:nil Nickname:nil];
        } else if ( req.succeed ) {
            NSData* response = req.responseData;
            
            NSData* aData = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
            NSString* res = [[aData asNSDictionary] objectForKey:@"res"];
            if ( [res isEqualToString:@"0"] ) {
                // 返回成功
                [self->_smsDelegate checkSmsCodeCompleted:YES
                                                   errMsg:nil
                                                   UserId:[[aData asNSDictionary] objectForKey:@"userId"]
                                                   Nickname:[[aData asNSDictionary] objectForKey:@"nickname"]];
            } else {
                // 返回失败
                [self->_smsDelegate checkSmsCodeCompleted:NO
                                                   errMsg:[[aData asNSDictionary] objectForKey:@"msg"]
                                                   UserId:nil Nickname:nil];
            }
        }
    } else {
        if ( req.failed ) {
            [self->_smsDelegate sendSMSCompleted:NO errMsg:@"访问服务器错误" token:nil];
        } else if ( req.succeed ) {
            NSData* response = req.responseData;
        
            NSData* aData = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
            NSString* res = [[aData asNSDictionary] objectForKey:@"res"];
            if ( [res isEqualToString:@"0"] ) {
                // 返回成功
                [self->_smsDelegate sendSMSCompleted:YES
                                          errMsg:nil
                                           token:[[aData asNSDictionary] objectForKey:@"token"]];
            } else {
                // 返回失败
                [self->_smsDelegate sendSMSCompleted:NO
                                          errMsg:[[aData asNSDictionary] objectForKey:@"msg"]
                                           token:[[aData asNSDictionary] objectForKey:@"token"]];
            }
        }
    }
}

- (void) dealloc {
    [super dealloc];
}

@end
