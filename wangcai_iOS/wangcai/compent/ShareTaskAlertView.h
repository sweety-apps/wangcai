//
//  ShareTaskAlertView.h
//  wangcai
//
//  Created by NPHD on 14-7-24.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareTaskAlertView : UIView

- (id)initWithCheckCount :(int)count
               totalCount:(int)totalCount
              shareTarget:(id)shareTarget
              shareAction:(SEL)shareAction
            previewTarget:(id)previewTarget
            previewAction:(SEL)previewAction
              closeTarget:(id)closeTarget
              closeAction:(SEL)closeAction;

@end
