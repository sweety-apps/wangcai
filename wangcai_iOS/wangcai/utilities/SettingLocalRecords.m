//
//  SettingLocalRecords.m
//  wangcai
//
//  Created by Lee Justin on 14-1-12.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "SettingLocalRecords.h"
#import "LoginAndRegister.h"

#define kLastCheckInTime @"lastCheckInTime"
#define kLastShareTime @"lastShareTime"
#define kLastOfferWallAlertView @"offerWallAlertView"

#define NKEY(x) ([SettingLocalRecords getUserNamedKey:(x)])

@implementation SettingLocalRecords

+ (NSString*)getUserNamedKey:(NSString*)key
{
    id userid = [[LoginAndRegister sharedInstance] getUserId];
    id deviceid = [[LoginAndRegister sharedInstance] getDeviceId];
    NSString* newKey = [NSString stringWithFormat:@"%@_%@_%@",
                          key, deviceid, userid];
    return newKey;
}

+ (void)saveLastCheckInDateTime:(NSDate*)dateTime
{
    if (dateTime)
    {
        [[NSUserDefaults standardUserDefaults] setObject:dateTime forKey:NKEY(kLastCheckInTime)];
        BOOL syned = [[NSUserDefaults standardUserDefaults] synchronize];
        if (!syned)
        {
            NSLog(@"[[ERROR]] saveLastCheckInDateTime saved false!");
        }
    }
}

+ (NSDate*)getLastCheckInDateTime
{
    NSDate* ret = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kLastCheckInTime)];
    return ret;
}

+ (void)saveLastShareDateTime:(NSDate*)dateTime
{
    if (dateTime)
    {
        [[NSUserDefaults standardUserDefaults] setObject:dateTime forKey:NKEY(kLastShareTime)];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSDate*)getLastShareDateTime
{
    NSDate* ret = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kLastShareTime)];
    return ret;
}

+ (void)saveOfferWallAlertViewShowed:(BOOL)showed
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:showed] forKey:kLastOfferWallAlertView];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getOfferWallAlertViewShowed
{
    BOOL ret = NO;
    NSNumber* boolNum = [[NSUserDefaults standardUserDefaults] objectForKey:kLastOfferWallAlertView];
    if (boolNum)
    {
        ret = [boolNum boolValue];
    }
    return ret;
}

+ (BOOL)hasCheckInYesterday
{
    NSDate* today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate * refDate = [SettingLocalRecords getLastCheckInDateTime];
    
    if (refDate == nil)
    {
        return NO;
    }
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:yesterdayString])
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)hasCheckInToday
{
    NSDate* today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate * refDate = [SettingLocalRecords getLastCheckInDateTime];
    
    if (refDate == nil)
    {
        return NO;
    }
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString])
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)hasShareToday
{
    NSDate* today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate * refDate = [SettingLocalRecords getLastShareDateTime];
    
    if (refDate == nil)
    {
        return NO;
    }
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString])
    {
        return YES;
    }
    
    return NO;
}

@end