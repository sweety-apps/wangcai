//
//  BaseTaskTableViewController.h
//  wangcai
//
//  Created by Lee Justin on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfoTableViewCell.h"

@interface BaseTaskTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    TaskInfoTableViewCell* _infoCell;
}

@property (nonatomic,retain) IBOutlet TaskInfoTableViewCell* infoCell;

@end
