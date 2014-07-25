//
//  CIShare.h
//  CIShareDemo
//
//  Created by zhao on 14-5-12.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@interface WCShare : NSObject
{
    @private
    NSMutableArray *shareItems;
    id<ISSContent> publishContent;
}

@property(nonatomic,retain) NSString *imageURL;

+ (instancetype)sharedInstance;

- (void)addWXTimelineWithShareHandler :(void (^)(void))success
                           shareFailed:(void (^)(id<ICMErrorInfo> error))fail;
- (void)addWXChatWithShareHandler :(void (^)(void))success
                       shareFailed:(void (^)(id<ICMErrorInfo> error))fail;
- (void)addRenrenWithShareHandler :(void (^)(void))success
                       shareFailed:(void (^)(id<ICMErrorInfo> error))fail;
- (void)addQQWithShareHandler:(void (^)(void))success
                  shareFailed:(void (^)(id<ICMErrorInfo>))fail;

- (void)addQQSpaceWithShareHandler:(void (^)(void))success
                       shareFailed:(void (^)(id<ICMErrorInfo>))fail;

- (void)addSinaWBShareHandler:(void (^)(void))success
                  shareFailed:(void (^)(id<ICMErrorInfo>))fail;


/**
 * @brief 构造分享内容
 * @param content  分享的内容
 * @param defaultContent 当content为空的时候展示的内容
 * @param title 分享的标题
 * @param jumpUrl 跳转地址
 * @param description 描述
 */
- (void)makeShareContent :(NSString *)content
            defaultConent:(NSString *)defaultContent
                    title:(NSString *)title
                  jumpUrl:(NSString *)jumpUrl
              description:(NSString *)description
                imagePath:(NSString *)imagePath;

- (void)showShareItems;
@end
