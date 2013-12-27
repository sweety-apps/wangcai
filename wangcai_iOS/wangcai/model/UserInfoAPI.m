//
//  UserInfoAPI.m
//  wangcai
//
//  Created by Lee Justin on 13-12-26.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "UserInfoAPI.h"
#import "LoginAndRegister.h"
#import "Config.h"

@interface UserInfoAPIRequestContext : NSObject

@property (nonatomic,retain) id<UserInfoAPIDelegate> delegate;
@property (nonatomic,retain) NSString* type;

@end

@implementation UserInfoAPIRequestContext

@synthesize delegate;
@synthesize type;

- (void)dealloc
{
    self.delegate = nil;
    self.type = nil;
    [super dealloc];
}

@end


static UserInfoAPI* gDefaultUserInfo = nil;

@implementation UserInfoAPI

@synthesize uiUserid;
@synthesize uiSex;
@synthesize uiAge;
@synthesize uiArea;
@synthesize uiJob;
@synthesize uiInterest;

+ (void)mapRelation
{
    [super mapRelation];
    [self mapPropertyAsKey:@"uiUserid"];
    [self mapProperty:@"uiSex"];
    [self mapProperty:@"uiAge"];
    [self mapProperty:@"uiArea"];
    [self mapProperty:@"uiJob"];
    [self mapProperty:@"uiInterest"];
}


-(void)load
{
    [super load];
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    self.uiUserid = nil;
    self.uiSex = nil;
    self.uiAge = nil;
    self.uiArea = nil;
    self.uiJob = nil;
    self.uiInterest = nil;
    [super dealloc];
}

+(UserInfoAPI*)loginedUserInfo
{
    if (gDefaultUserInfo == nil)
    {
        NSNumber* userId = [[LoginAndRegister sharedInstance] getUserId];
        gDefaultUserInfo = [[UserInfoAPI recordWithKey:userId] retain];
        if (gDefaultUserInfo == nil)
        {
            gDefaultUserInfo = [[UserInfoAPI record] retain];
        }
    }
    return gDefaultUserInfo;
}

- (void)saveUserInfoToLocal
{
    //self.primaryID = self.uiUserid;
    if (self.uiUserid)
    {
        self.SAVE();
    }
}

- (void)fetchUserInfo:(id<UserInfoAPIDelegate>)delegate
{
    HttpRequest* req = [[HttpRequest alloc] init:self];
    UserInfoAPIRequestContext* context = [[[UserInfoAPIRequestContext alloc] init]autorelease];
    context.delegate = delegate;
    context.type = @"fetchUserInfo";
    req.extensionContext = context;
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    [req request:HTTP_READ_ACCOUNT_INFO_CODE Param:dictionary method:@"get"];
}

- (void)updateUserInfo:(id<UserInfoAPIDelegate>)delegate
{
    
}

#pragma mark <HttpRequestDelegate> 

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    UserInfoAPIRequestContext* context = ((HttpRequest*)request).extensionContext;
    id<UserInfoAPIDelegate> delegate = context.delegate;
    if ( [context.type isEqualToString:@"fetchUserInfo"] ) {
        NSNumber* result = [body objectForKey:@"Res"];
        self.uiAge = [body objectForKey:@""];
        
    } else  {
        
    }
}

@end
