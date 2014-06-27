//
//  ScreenShots.h
//  wangcai
//
//  Created by NPHD on 14-6-27.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScreenShots : NSObject  {
    NSTimer* _timer;
    int      _oldDataSize;
}

+ (ScreenShots*) sharedInstance;

- (void) start;

@end
