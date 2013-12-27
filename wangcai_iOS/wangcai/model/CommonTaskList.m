//
//  CommonTaskList.m
//  wangcai
//
//  Created by Lee Justin on 13-12-26.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "CommonTaskList.h"
#import "Config.h"

@interface CommonTaskInfoContext : NSObject

@property (nonatomic,retain) id<CommonTaskListDelegate> delegate;

@end

@implementation CommonTaskInfoContext

@synthesize delegate;

- (void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

@end

@implementation CommonTaskInfo

@synthesize taskId;
@synthesize taskType;
@synthesize taskTitle;
@synthesize taskIconUrl;
@synthesize taskIntro;
@synthesize taskStatus;
@synthesize taskMoney;
@synthesize taskDesc;
@synthesize taskStepStrings;
//@synthesize taskStartTime;
//@synthesize taskEndTime;

- (void)dealloc
{
    self.taskId = nil;
    self.taskType = nil;
    self.taskTitle = nil;
    self.taskIconUrl = nil;
    self.taskIntro = nil;
    self.taskStatus = nil;
    self.taskMoney = nil;
    self.taskDesc = nil;
    self.taskStepStrings = nil;
    //self.taskStartTime = nil;
    //self.taskEndTime = nil;
    [super dealloc];
}

@end

static CommonTaskList* gInstance = nil;


@interface CommonTaskList ()

@property (nonatomic,retain) NSMutableArray* unfinishedTaskList;

@end

@implementation CommonTaskList

@synthesize taskList;
@synthesize unfinishedTaskList;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    self.taskList = nil;
    self.unfinishedTaskList = nil;
    [super dealloc];
}

+ (CommonTaskList*)sharedInstance
{
    if (gInstance == nil)
    {
        gInstance = [[CommonTaskList alloc] init];
    }
    return gInstance;
}

- (void)fetchTaskList:(id<CommonTaskListDelegate>)delegate
{
    HttpRequest* req = [[HttpRequest alloc] init:self];
    CommonTaskInfoContext* context = [[[CommonTaskInfoContext alloc] init]autorelease];
    context.delegate = delegate;
    req.extensionContext = context;
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    [req request:HTTP_READ_TASK_LIST Param:dictionary method:@"get"];
}

- (NSArray*)getUnfinishedTaskList
{
    return self.unfinishedTaskList;
}

- (NSArray*)getAllTaskList
{
    return self.taskList;
}

- (float)allMoneyCanBeEarnedInRMBYuan
{
    if ([self.taskList count] > 0)
    {
        float allRMBFen = 0.0f;
        for (CommonTaskInfo* task in self.unfinishedTaskList)
        {
            allRMBFen += [task.taskMoney floatValue];
        }
        return allRMBFen/100.0f;
    }
    return 0.0f;
}

#pragma mark <HttpRequestDelegate>

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    CommonTaskInfoContext* context = ((HttpRequest*)request).extensionContext;
    id<CommonTaskListDelegate> delegate = context.delegate;
    
    NSNumber* result = [NSNumber numberWithInt:-1];
    NSString* msg = @"";
    
    if (httpCode == 200)
    {
        result = [body objectForKey:@"res"];
        msg = [body objectForKey:@"msg"];
        if ([result integerValue] == 0)
        {
            NSArray* taskList = [body objectForKey:@"task_list"];
            NSMutableArray* resultTaskList = [NSMutableArray array];
            NSMutableArray* unfinishedTaskList = [NSMutableArray array];
            for (NSDictionary* taskDict in taskList)
            {
                CommonTaskInfo* task = [[[CommonTaskInfo alloc] init] autorelease];
                task.taskId = [taskDict objectForKey:@"id"];
                task.taskType = [taskDict objectForKey:@"type"];
                task.taskTitle = [taskDict objectForKey:@"title"];
                task.taskStatus = [taskDict objectForKey:@"status"];
                task.taskMoney = [taskDict objectForKey:@"money"];
                task.taskIconUrl = [taskDict objectForKey:@"icon"];
                task.taskIntro = [taskDict objectForKey:@"intro"];
                task.taskDesc = [taskDict objectForKey:@"desc"];
                task.taskStepStrings = [taskDict objectForKey:@"steps"];
                [resultTaskList addObject:task];
                if ([task.taskStatus intValue] == 0)
                {
                    [unfinishedTaskList addObject:task];
                }
            }
            self.taskList = resultTaskList;
            self.unfinishedTaskList = unfinishedTaskList;
        }
    }
    
    if (delegate)
    {
        [delegate onFinishedFetchTaskList:self resultCode:[result integerValue]];
    }
}


@end