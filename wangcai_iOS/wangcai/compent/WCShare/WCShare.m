//
//  CIShare.m
//  CIShareDemo
//
//  Created by zhao on 14-5-12.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "WCShare.h"
#import "SharedInstanceGCD.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import <RennSDK/RennClient.h>


@implementation WCShare
@synthesize imageURL = _imageURL;

SHARED_INSTANCE_GCD_USING_BLOCK(^{
    return [[self alloc]init];
})
- (void)setImageURL:(NSString *)imageURL
{
    if (![_imageURL isEqualToString:imageURL])
    {
        [_imageURL release];
        [imageURL retain];
        _imageURL = imageURL;
    }
    
}
- (id)init
{
    self = [super init];
    if(self)
    {
        shareItems = [[NSMutableArray alloc]init];
    }
    return self;
}



- (void)makeShareContent :(NSString *)content
            defaultConent:(NSString *)defaultContent
                    title:(NSString *)title
                  jumpUrl:(NSString *)jumpUrl
              description:(NSString *)description
                imagePath:(NSString *)imagePath
{
    publishContent = [ShareSDK content:content
                        defaultContent:defaultContent
                                 image:[ShareSDK imageWithPath:imagePath]
                                 title:title
                                   url:jumpUrl
                           description:defaultContent
                             mediaType:SSPublishContentMediaTypeNews];
     
    
}
- (id<ISSShareActionSheetItem>)makeItem :(ShareType)atype
                                    icon:(UIImage*)icon
                            shareSuccess:(void (^)(void))success
                             shareFailed:(void (^)(id<ICMErrorInfo>))fail
{
    id<ISSShareActionSheetItem> wxsItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:atype] icon:[ShareSDK getClientIconWithType:atype] clickHandler:^{
        if(atype == ShareTypeRenren)
        {
            
            [ShareSDK showShareViewWithType:ShareTypeRenren
                                  container:[ShareSDK container]
                                    content:publishContent
                              statusBarTips:YES
                                authOptions:nil
                               shareOptions:nil
                                     result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                if(state == SSResponseStateSuccess && success)
                {
                    success();
                }
                if(state == SSResponseStateFail && fail)
                {
                   fail(error);
                }
            }];
            
        }else if(atype == ShareTypeSinaWeibo)
        {
            [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
                                  container:nil
                                    content:publishContent
                              statusBarTips:YES
                                authOptions:nil
                               shareOptions:nil
                                     result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                if(state == SSResponseStateSuccess && success)
                {
                    success();
                }
                if(state == SSResponseStateFail && fail)
                {
                    fail(error);
                }
                                         
                
            }];

        }
        else
        {
            
            [ShareSDK clientShareContent:publishContent type:atype statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                if (state == SSPublishContentStateSuccess)
                {
                    if(success)
                    {
                        success();
                    }
                }else if (state == SSPublishContentStateFail)
                {
                    if(fail)
                    {
                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                        fail(error);
                    }
                }
            }];
        }
       
    }];
    return wxsItem;
}
- (void)addRenrenWithShareHandler:(void (^)(void))success shareFailed:(void (^)(id<ICMErrorInfo>))fail
{
    
    [shareItems addObject:[self makeItem :ShareTypeRenren icon:nil shareSuccess:success shareFailed:fail]];
}
- (void)addQQWithShareHandler:(void (^)(void))success shareFailed:(void (^)(id<ICMErrorInfo>))fail
{
    [publishContent addQQUnitWithType:[NSNumber numberWithInt:SSPublishContentMediaTypeNews] content:INHERIT_VALUE title:INHERIT_VALUE url:INHERIT_VALUE image:[ShareSDK imageWithUrl:_imageURL]];
    [shareItems addObject:[self makeItem :ShareTypeQQ icon:nil shareSuccess:success shareFailed:fail]];
}
- (void)addSinaWBShareHandler:(void (^)(void))success shareFailed:(void (^)(id<ICMErrorInfo>))fail
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Icon@2x" ofType:@"png"];
    [publishContent addSinaWeiboUnitWithContent:INHERIT_VALUE image:[ShareSDK imageWithPath:path]];
    [shareItems addObject:[self makeItem:ShareTypeSinaWeibo icon:nil shareSuccess:success shareFailed:fail]];
}
- (void)addQQSpaceWithShareHandler:(void (^)(void))success shareFailed:(void (^)(id<ICMErrorInfo>))fail
{
    [publishContent addQQSpaceUnitWithTitle:INHERIT_VALUE url:INHERIT_VALUE site:INHERIT_VALUE fromUrl:INHERIT_VALUE comment:INHERIT_VALUE summary:INHERIT_VALUE image:[ShareSDK imageWithUrl:_imageURL] type:[NSNumber numberWithInt:SSPublishContentMediaTypeNews] playUrl:INHERIT_VALUE nswb:INHERIT_VALUE];
     [shareItems addObject:[self makeItem :ShareTypeQQSpace icon:nil shareSuccess:success shareFailed:fail]];
}
- (void)addWXTimelineWithShareHandler:(void (^)(void))success  shareFailed:(void (^)(id<ICMErrorInfo>))fail
{
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInt:SSPublishContentMediaTypeNews] content:INHERIT_VALUE title:INHERIT_VALUE url:INHERIT_VALUE image:[ShareSDK imageWithUrl:_imageURL] musicFileUrl:nil extInfo:nil fileData:nil emoticonData:nil];
    [shareItems addObject:[self makeItem :ShareTypeWeixiTimeline icon:nil shareSuccess:success shareFailed:fail]];
}
- (void)addWXChatWithShareHandler :(void (^)(void))success shareFailed:(void (^)(id<ICMErrorInfo> error))fail
{
    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInt:SSPublishContentMediaTypeNews] content:INHERIT_VALUE title:INHERIT_VALUE url:INHERIT_VALUE image:[ShareSDK imageWithUrl:_imageURL] musicFileUrl:nil extInfo:nil fileData:nil emoticonData:nil];
    [shareItems addObject:[self makeItem :ShareTypeWeixiSession icon:nil shareSuccess:success shareFailed:fail]];
}

- (NSArray*)createShareList
{
    NSMutableArray *shareList = [[[NSMutableArray alloc]init] autorelease];
    for (id item in shareItems)
    {
        NSArray *shareItem = [ShareSDK customShareListWithType:
                              item,
                              nil];
        [shareList addObjectsFromArray:shareItem];
        
    }
    [shareItems removeAllObjects];
    return shareList;
}
- (void)showShareItems
{
    NSArray *shareList = [self createShareList];
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                     NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

@end
