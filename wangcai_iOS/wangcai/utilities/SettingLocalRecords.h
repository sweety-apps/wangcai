//
//  SettingLocalRecords.h
//  wangcai
//
//  Created by Lee Justin on 14-1-12.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingLocalRecords : NSObject

+ (void)saveLastCheckInDateTime:(NSDate*)dateTime;
+ (NSDate*)getLastCheckInDateTime;

+ (void)saveLastShareDateTime:(NSDate*)dateTime;
+ (NSDate*)getLastShareDateTime;

+ (void)saveOfferWallAlertViewShowed:(BOOL)showed;
+ (BOOL)getOfferWallAlertViewShowed;

+ (BOOL)hasCheckInYesterday;
+ (BOOL)hasCheckInToday;
+ (BOOL)hasShareToday;

+ (int)getDomobPoint;
+ (void)setDomobPoint:(int) point;
@end
