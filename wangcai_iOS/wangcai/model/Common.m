//
//  Common.m
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "Common.h"

#include <sys/types.h>
#include <sys/param.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <netinet/in.h>
#include <net/if_dl.h>
#include <sys/sysctl.h>
#include <AdSupport/AdSupport.h>
#import "ALSystem.h"
#include "LoginAndRegister.h"
#import "SettingLocalRecords.h"

static AVPlayer* gPlayer = nil;//播放赚钱声音

@implementation Common


void GetMACAddress(unsigned char *mac)
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return ;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return ;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return ;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return ;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    memcpy(mac,ptr, 6);
    free(buf);
}


NSString * macaddress()
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    
    return [outstring uppercaseString];
}


+ (void) openUrl:(NSString*) url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (NSString*) getIDFAAddress {
    NSString* adid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    return [[adid copy] autorelease];
}

+ (NSString*) getMACAddress {
    NSString* macAddr = macaddress();
    
    return [[macAddr copy] autorelease];
}

+ (NSString*) getTimestamp {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970]*1000;
    NSString* timeString = [NSString stringWithFormat:@"%d", (int)(a / 1000)];
    
    return [[timeString copy] autorelease];
}

+ (NSString*) buildURL:(NSString*) url Params:(NSMutableDictionary*) params {
    id userid = [[LoginAndRegister sharedInstance] getUserId];
    id sessionid = [[LoginAndRegister sharedInstance]getSessionId];
    id deviceid = [[LoginAndRegister sharedInstance] getDeviceId];
    
    NSString* newUrl = [[NSString alloc] initWithFormat:@"%@?session_id=%@&device_id=%@&userid=%@", url, sessionid, deviceid, userid];
    
    if ( params != nil ) {
        NSArray* keys = [params allKeys];
        int nCount = [keys count];
        for (int i = 0; i < nCount; i ++ ) {
            id key = [keys objectAtIndex:i];
            id value = [params objectForKey:key];
        
            newUrl = [newUrl stringByAppendingFormat:@"&%@=%@", key, value];
        }
    }
    
    return newUrl;
}

+ (SecIdentityRef) getSecIdentityRef {
    SecIdentityRef identity = NULL;
    SecTrustRef trust = NULL;
    
    //绑定证书，证书放在Resources文件夹中
    NSString* path = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"];
    
    NSData *PKCS12Data = [NSData dataWithContentsOfFile:path];
    [self extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data];
    
    return identity;
}


+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR("WangCai@1528"); //证书密码
    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys,values, 1,NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    //securityError = SecPKCS12Import((CFDataRef)inPKCS12Data,(CFDictionaryRef)optionsDictionary,&items);
    securityError = SecPKCS12Import((CFDataRef)inPKCS12Data,optionsDictionary,&items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failed with error code %d",(int)securityError);
        return NO;
    }
    return YES;
}

+ (NSString *)localIPAddress
{
    NSString *localIP = nil;
    struct ifaddrs *addrs;
    if (getifaddrs(&addrs)==0) {
        const struct ifaddrs *cursor = addrs;
        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                //NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                //if ([name isEqualToString:@"en0"]) // Wi-Fi adapter
                {
                    localIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    break;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return localIP;
}

+ (NSString*)deviceModel
{
    NSString* model = [[ALSystem systemInformations] objectForKey:ALHardware_platformType];
    if ([model length] == 0)
    {
        model = [UIDevice currentDevice].model;
    }
    return model;
}

+ (void)_initAudioPlayer
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gotcoins" ofType:@"aiff"];
    
    
    if (path) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
        [session setActive:YES error:nil];
        
        NSURL *audioUrl = [NSURL fileURLWithPath:path];
        gPlayer = [[AVPlayer playerWithURL:audioUrl] retain];
        if (gPlayer == NULL)
        {
            NSLog(@"fail to play audio :(");
            return;
        }
    }
}

+ (void)playAddCoinSound
{
    if (gPlayer == nil)
    {
        [[self class] _initAudioPlayer];
    }
    [gPlayer seekToTime:CMTimeMakeWithSeconds(0, 1)];
    if ([SettingLocalRecords getMusicEnabled])
    {
        [gPlayer play];
    }
}

@end
