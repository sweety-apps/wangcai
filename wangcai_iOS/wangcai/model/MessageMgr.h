//
//  MessageMgr.h
//  wangcai
//
//  Created by NPHD on 14-5-10.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"

@protocol MessageMgrDelegate <NSObject>
-(void) messageUpdated;
@end

@interface MessageMgr : NSObject <HttpRequestDelegate> {
    int _nCurMaxID;
    int _nClickMaxID;
    
    BOOL _request;
    
    NSArray* _listInfo;
    
    NSMutableArray* _delegates;
}

+ (MessageMgr*) sharedInstance;

- (void) saveClickId:(int) mid;
- (int) getClickMaxID;

- (int) getCurMaxID;
- (void) updateMsg;

- (BOOL) hasNewMsg;

- (void) attachEvent:(id) delegate;
- (void) detachEvent:(id) delegate;

- (NSArray*) getMsgList;
@end
