//
//  ComplainViewController.h
//  wangcai
//
//  Created by NPHD on 14-6-23.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegister.h"
#import "HttpRequest.h"

@interface ComplainViewController : UIViewController <HttpRequestDelegate> {
    UIScrollView* _scrollView;
    int _nCount;
}

- (IBAction) clickBack:(id)sender;

- (IBAction) clickComplain:(id)sender;

@property (nonatomic, retain) IBOutlet UIView* _contentView;
@property (nonatomic, retain) IBOutlet UILabel* _labelNum;

@end
