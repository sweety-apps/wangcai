//
//  InstallAppAlertView.h
//  wangcai
//
//  Created by NPHD on 14-6-27.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstallAppAlertView : UIView


- (id)initWithIcon :(NSString*)iconurl
              title:(NSString*)title
               desc:(NSString*)desc
             target:(id)target
            install:(SEL)install
             cancel:(SEL)cancel
              money:(NSString*)money;
@end
