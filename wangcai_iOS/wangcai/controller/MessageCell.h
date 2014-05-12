//
//  MessageCell.h
//  wangcai
//
//  Created by zhangc on 14-5-12.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomAlertView.h"

@interface MessageCell : UITableViewCell <UIAlertViewDelegate> {
    BeeUIImageView* _imageView;
    UILabel*        _title;
    UILabel*        _date;
    UILabel*        _desc;
    UIImageView*    _newImage;
    UIButton*       _btnOpen;
    
    UIImageView*    _line;
    
    NSDictionary*   _info;
    
    UIAlertView* _alertLevel;
    
    NSString*    _installUrl;
    
    UICustomAlertView* _alertInstallApp;
}

- (void) setInfo:(NSDictionary*) info;

+ (int) getHeight:(NSDictionary*) info;
@end
