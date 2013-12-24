//
//  BaseTaskTableViewController.h
//  wangcai
//
//  Created by Lee Justin on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfoTableViewCell.h"
#import "CommonZhanghuYuETableViewCell.h"

@interface BaseTaskTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    CommonZhanghuYuETableViewCell* _zhanghuYuEHeaderCell;
    TaskInfoTableViewCell* _infoCell;
    UITableView* _containTableView;
    CGRect _tableViewFrame;
    BeeUIStack* _beeStack;
    BOOL _bounceHeader;
    NSMutableArray* _staticCells;
}

@property (nonatomic,retain) IBOutlet CommonZhanghuYuETableViewCell* zhanghuYuEHeaderCell;
@property (nonatomic,retain) IBOutlet TaskInfoTableViewCell* infoCell;
@property (nonatomic,retain) IBOutlet UITableView* containTableView;
@property (nonatomic,assign) CGRect tableViewFrame;
@property (nonatomic,retain) BeeUIStack* beeStack;
@property (nonatomic,assign) BOOL bounceHeader;
@property (nonatomic,retain) NSMutableArray* staticCells;

@end
