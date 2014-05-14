//
//  MessageMgr.m
//  wangcai
//
//  Created by NPHD on 14-5-10.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "MessageMgr.h"
#import "SettingLocalRecords.h"
#import "HttpRequest.h"
#import "Config.h"
#import "CommonTaskList.h"

@implementation MessageMgr

static MessageMgr* _instance = nil;

+ (MessageMgr*) sharedInstance {
    if ( _instance == nil ) {
        _instance = [[MessageMgr alloc] init];
    }
    
    return _instance;
}

- (id) init {
    [super init];
    
    _request = NO;
    _nCurMaxID = 0; // 当前记录的最大值
    _nClickMaxID = [SettingLocalRecords getClickMaxID]; // 当前点击之后的最大值
    _listInfo = nil;
    _delegates = nil;
    
    [self updateMsg];
    
    return self;
}

- (int) getCurMaxID {
    return _nCurMaxID;
}

- (BOOL) hasNewMsg {
    if ( _nCurMaxID > _nClickMaxID ) {
        return YES;
    }
    return NO;
}

- (void) updateMsg {
    if ( _request ) {
        return ;
    }
    
    _request = YES; //
    
    HttpRequest* request = [[HttpRequest alloc] init:self];
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [request request:HTTP_MSG_LIST Param:dictionary method:@"get"];
}

- (void) attachEvent:(id) delegate {
    if ( _delegates == nil ) {
        _delegates = [[NSMutableArray alloc] init];
    }
    
    [_delegates addObject:delegate];
}

- (void) detachEvent:(id) delegate {
    if ( _delegates != nil ) {
        [_delegates removeObject:delegate];
    }
}

- (void) Fire_Event {
    if ( _delegates != nil ) {
        for (int i = 0; i < [_delegates count]; i ++ ) {
            id delegate = [_delegates objectAtIndex:i];
            [delegate messageUpdated];
        }
    }
}

- (BOOL) canInstall:(int) taskId {
    NSArray* taskList = [[CommonTaskList sharedInstance] taskList];
    for ( int i = 0; i < [taskList count]; i ++ ) {
        CommonTaskInfo* task = (CommonTaskInfo*)[taskList objectAtIndex:i];
        if ( [task.taskId intValue] == taskId ) {
            if ( [task.taskStatus intValue] == 0 ) {
                return YES;
            }
        }
    }
    return NO;
}

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    if ( httpCode == 200 ) {
        int res = [[body objectForKey:@"res"] intValue];
        if ( res == 0 ) {
            NSArray* list = (NSArray*)[body objectForKey:@"msg_list"];
            NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [list count]; i ++ ) {
                NSDictionary* info = (NSDictionary*)[list objectAtIndex:i];
                
                int mid = [[info objectForKey:@"id"] intValue];
                if ( _nCurMaxID < mid ) {
                    _nCurMaxID = mid;
                }
                
                int nType = [[info objectForKey:@"type"] intValue];
                if ( nType == 2 ) {
                    // 自有任务
                    int nExtra = [[info objectForKey:@"extra"] intValue];
                    if ( [self canInstall:nExtra] ) {
                        [tmpArray addObject:info];
                    }
                } else {
                    [tmpArray addObject:info];
                }
            }
            
            if ( _listInfo != nil ) {
                [_listInfo release];
            }
            
            _listInfo = tmpArray;
            
            [self Fire_Event];
        }
    }
    
    _request = NO;
}

- (void) saveClickId:(int) mid {
    _nClickMaxID = mid;
    
    [SettingLocalRecords setClickMaxID:_nClickMaxID];
}

- (NSArray*) getMsgList {
    if ( _listInfo == nil ) {
        return nil;
    }
    return [_listInfo retain];
}

- (int) getClickMaxID {
    return _nClickMaxID;
}

@end
