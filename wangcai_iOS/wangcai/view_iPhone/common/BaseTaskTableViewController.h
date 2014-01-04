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
    UIView* _containTableViewFooterView;
    UIActivityIndicatorView* _containTableViewFooterJuhuaView;
    CGRect _tableViewFrame;
    BeeUIStack* _beeStack;
    BOOL _bounceHeader;
    NSMutableArray* _staticCells;
    BOOL _isUIZhuanJuhuaing;
    BOOL _hasLoadedHistoricalFinishedList;
    NSInteger _curCellCount;
    NSInteger _hisCellCount;
}

@property (nonatomic,retain) IBOutlet CommonZhanghuYuETableViewCell* zhanghuYuEHeaderCell;
@property (nonatomic,retain) IBOutlet TaskInfoTableViewCell* infoCell;
@property (nonatomic,retain) IBOutlet UITableView* containTableView;
@property (nonatomic,retain) IBOutlet UIView* containTableViewFooterView;
@property (nonatomic,retain) IBOutlet UILabel* containTableViewFooterViewTextLabel;
@property (nonatomic,retain) IBOutlet UIButton* containTableViewFooterViewButton;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView* containTableViewFooterJuhuaView;
@property (nonatomic,assign) CGRect tableViewFrame;
@property (nonatomic,retain) BeeUIStack* beeStack;

@property (nonatomic,assign) BOOL bounceHeader;
@property (nonatomic,retain) NSMutableArray* staticCells;

- (IBAction)onPressedLoadHisButton:(id)sender;
- (IBAction)onPressedQiandaoChoujiangButton:(id)sender;
- (IBAction)onPressedTiquxianjinButton:(id)sender;

- (void)enableQiandaoButton:(BOOL)enabled;
- (void)enableTixianButton:(BOOL)enabled;

//带动画和声音设置余额
- (void)setYuENumberWithAnimationFrom:(float)oldNum toNum:(float)newNum;

@end
