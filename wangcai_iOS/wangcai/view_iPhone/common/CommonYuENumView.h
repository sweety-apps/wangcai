//
//  CommonYuENumView.h
//  wangcai
//
//  Created by Lee Justin on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonYuENumView : UIView
{
    float _num;
    NSMutableDictionary* _digitDict;
}

-(void)setNum:(float)num;
-(float)getNum;

@end
