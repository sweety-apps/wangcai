//
//  CommonTaskList.h
//  wangcai
//
//  Created by Lee Justin on 13-12-26.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "HttpRequest.h"

#define kTaskTypeInstallWangcai (1)
#define kTaskTypeUserInfo (2)
#define kTaskTypeInviteFriends (3)
#define kTaskTypeEverydaySign (4)
#define kTaskTypeOfferWall (5)
#define kTaskTypeIntallApp (10000)
#define kTaskTypeCommon (10001)

@class CommonTaskList;

@protocol CommonTaskListDelegate <NSObject>

- (void)onFinishedFetchTaskList:(CommonTaskList*)taskList resultCode:(NSInteger)result;

@end

@interface CommonTaskInfo : NSObject

@property (nonatomic,retain) NSNumber* taskId;
@property (nonatomic,retain) NSNumber* taskType;
@property (nonatomic,retain) NSString* taskTitle;
@property (nonatomic,retain) NSString* taskIconUrl;
@property (nonatomic,retain) NSString* taskIntro;
@property (nonatomic,retain) NSString* taskDesc;
@property (nonatomic,retain) NSArray* taskStepStrings;
@property (nonatomic,retain) NSNumber* taskStatus;
@property (nonatomic,retain) NSNumber* taskMoney;
@property (nonatomic,assign) BOOL taskIsLocalIcon;
//@property (nonatomic,retain) NSNumber* taskStartTime;
//@property (nonatomic,retain) NSNumber* taskEndTime;

@end

@interface CommonTaskList : NSObject <HttpRequestDelegate> 

+ (CommonTaskList*)sharedInstance;
- (void)fetchTaskList:(id<CommonTaskListDelegate>)delegate;

@property (nonatomic,retain) NSArray* taskList;//item type = CommonTaskInfo

- (NSArray*)getUnfinishedTaskList;
- (NSArray*)getAllTaskList;
- (float)allMoneyCanBeEarnedInRMBYuan;
- (BOOL)containsUnfinishedUserInfoTask;

@end
