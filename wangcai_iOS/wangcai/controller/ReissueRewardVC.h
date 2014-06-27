//
//  ReissueRewardVC.h
//  wangcai
//
//  Created by NPHD on 14-6-23.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequest.h"

@interface ReissueRewardVC : UIViewController<UITableViewDelegate,UITableViewDataSource,HttpRequestDelegate,UIAlertViewDelegate>
{
     BeeUIStack* _beeUIStack;
     NSMutableArray *items;
    HttpRequest* _request;
    BOOL _bRequest;
}
- (void)setUIStack:(BeeUIStack*) stack;
- (id)initWithItems :(NSArray*)aitems;
@end
