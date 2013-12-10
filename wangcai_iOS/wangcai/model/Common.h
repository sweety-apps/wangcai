//
//  Common.h
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+ (void) openUrl:(NSString*) url;
+ (NSString*) getIDFAAddress;
+ (NSString*) getMACAddress;
+ (NSString*) getTimestamp;
@end
