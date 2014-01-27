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
#define kRatedApp @"ratedApp"
#define kCheckIn @"checkIn"
#define kMusicOnOff @"musicOnOff"
#define kInstallWangcaiAlertView @"installWangcaiAlertView"
//#define kLastOfferWallAlertView @"offerWallClearPoint"

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

+ (void)setRatedApp:(BOOL)rated
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:rated] forKey:NKEY(kRatedApp)];
    BOOL syned = [[NSUserDefaults standardUserDefaults] synchronize];
    if (!syned)
    {
        NSLog(@"[[ERROR]] rated saved false!");
    }
}

+ (BOOL)getRatedApp
{
    BOOL ret = NO;
    NSNumber* boolNum = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kRatedApp)];
    if (boolNum)
    {
        ret = [boolNum boolValue];
    }
    return ret;
}

+ (void)setCheckIn:(BOOL)checkedIn
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:checkedIn] forKey:NKEY(kCheckIn)];
    BOOL syned = [[NSUserDefaults standardUserDefaults] synchronize];
    if (!syned)
    {
        NSLog(@"[[ERROR]] checked In saved false!");
    }
}

+ (BOOL)getCheckIn
{
    BOOL ret = NO;
    NSNumber* boolNum = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kCheckIn)];
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

+ (int)getDomobPoint
{
    NSNumber* point = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kLastOfferWallAlertView)];
    
    return [point intValue];
}

+ (void)setDomobPoint:(int) point
{
    NSNumber* number = [NSNumber numberWithInt:point];
    
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:NKEY(kLastOfferWallAlertView)];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setMusicEnable:(BOOL)enabled
{
    NSNumber* number = [NSNumber numberWithBool:enabled];
    
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:kMusicOnOff];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getMusicEnabled
{
    BOOL ret = YES;
    NSNumber* boolNum = [[NSUserDefaults standardUserDefaults] objectForKey:kMusicOnOff];
    if (boolNum)
    {
        ret = [boolNum boolValue];
    }
    return ret;
}

+ (void)setPopedInstallWangcaiAlertView:(BOOL)alerted
{
    NSNumber* number = [NSNumber numberWithBool:alerted];
    
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:kInstallWangcaiAlertView];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)hasInstallWangcaiAlertViewPoped
{
    BOOL ret = NO;
    NSNumber* boolNum = [[NSUserDefaults standardUserDefaults] objectForKey:kInstallWangcaiAlertView];
    if (boolNum)
    {
        ret = [boolNum boolValue];
    }
    return ret;
}

@end
