//
//  Encryption.h
//  wangcai
//
//  Created by 1528 on 14-1-16.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密
- (NSString *)newStringInBase64FromData;            //追加64编码
+ (NSString*)base64encode:(NSString*)str;           //同上64编码


@end