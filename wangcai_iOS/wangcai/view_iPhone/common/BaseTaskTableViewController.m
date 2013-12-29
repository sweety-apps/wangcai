//
//  BaseTaskTableViewController.m
//  wangcai
//
//  Created by Lee Justin on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "BaseTaskTableViewController.h"
#import "CommonTaskTableViewCell.h"
#import "UserInfoEditorViewController.h"
#import "CommonTaskList.h"
#import "MBHUDView.h"
#import "TaskController.h"

@interface BaseTaskTableViewController () <CommonTaskListDelegate>

@end

@implementation BaseTaskTableViewController

@synthesize bounceHeader = _bounceHeader;
@synthesize zhanghuYuEHeaderCell = _zhanghuYuEHeaderCell;
@synthesize infoCell = _infoCell;
@synthesize containTableView = _containTableView;
@synthesize containTableViewFooterView = _containTableViewFooterView;
@synthesize containTableViewFooterViewTextLabel = _containTableViewFooterViewTextLabel;
@synthesize containTableViewFooterViewButton = _containTableViewFooterViewButton;
@synthesize containTableViewFooterJuhuaView = _containTableViewFooterJuhuaView;
@synthesize tableViewFrame = _tableViewFrame;
@synthesize beeStack = _beeStack;
@synthesize staticCells = _staticCells;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _curCellCount = 0;
    _hisCellCount = 0;
    
    self.staticCells = [NSMutableArray array];
    _bounceHeader = NO;
    _hasLoadedHistoricalFinishedList = NO;
    [self resetFooter];
    [self performSelector:@selector(resetTableViewFrame) withObject:nil afterDelay:0.05];
    [self resetStaticCells];
    
    [self.infoCell setJinTianHaiNengZhuanNumLabelTextNum:[[CommonTaskList sharedInstance] allMoneyCanBeEarnedInRMBYuan]];
    
    //[self performSelector:@selector(refreshTaskList) withObject:nil afterDelay:2.0f];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.zhanghuYuEHeaderCell = nil;
    self.infoCell = nil;
    self.containTableView = nil;
    self.containTableViewFooterView = nil;
    self.containTableViewFooterViewTextLabel = nil;
    self.containTableViewFooterJuhuaView = nil;
    self.containTableViewFooterViewButton = nil;
    self.staticCells = nil;
    [super dealloc];
}

-(void)setTableViewFrame:(CGRect)tableViewFrame
{
    //if (self.containTableView)
    //{
        //self.containTableView.frame = tableViewFrame;
    //}
    _tableViewFrame = tableViewFrame;
}

-(void)resetTableViewFrame
{
    if (!CGRectIsEmpty(_tableViewFrame))
    {
        self.containTableView.frame = _tableViewFrame;
        self.containTableView.clipsToBounds = NO;
    }
}

-(void)refreshTaskList
{
    [[CommonTaskList sharedInstance] fetchTaskList:self];
}

-(void)resetStaticCells
{
    [_staticCells removeAllObjects];
    
    [_staticCells addObject:self.zhanghuYuEHeaderCell];
    [_staticCells addObject:self.infoCell];
}

- (void)onLoadHistoricalFinishedList
{
    //这里加载领取过的红包
    
    [self endFooter];
    _hasLoadedHistoricalFinishedList = YES;
    [self.containTableView reloadData];
}

- (IBAction)onPressedLoadHisButton:(id)sender
{
    [self onLoadHistoricalFinishedList];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_hasLoadedHistoricalFinishedList)
    {
        return [self.staticCells  count] + _curCellCount + [[[CommonTaskList sharedInstance] getUnfinishedTaskList] count];
    }
    return [self.staticCells  count] + _hisCellCount + _curCellCount + [[[CommonTaskList sharedInstance] getAllTaskList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    NSInteger row = indexPath.row;
    NSInteger rowExceptStaticCells = row - [_staticCells count];
    
    if (row < [_staticCells count])
    {
        cell = [_staticCells objectAtIndex:row];
    }
    else
    {
        CommonTaskTableViewCell* comCell = [tableView dequeueReusableCellWithIdentifier:@"taskCell"];
        if (comCell == nil)
        {
            comCell = [[[CommonTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"taskCell"] autorelease];
        } 
        
        /*
        if (rowExceptStaticCells == 0)
        {
            [comCell setTaskCellType:CommonTaskTableViewCellShowTypeRedTextUp];
            [comCell setUpText:@"补充个人信息"];
            [comCell setDownText:@"让旺财知道你喜欢什么，赚更多的红包"];
            [comCell setRedBagIcon:@"package_icon_one"];
            [comCell setLeftIconNamed:@"person_info_icon"];
            [comCell hideFinishedIcon:YES];
        }
        else if (rowExceptStaticCells == 1)
        {
            [comCell setTaskCellType:CommonTaskTableViewCellShowTypeRedTextUp];
            [comCell setUpText:@"关注旺财"];
            [comCell setDownText:@"用微信随时随地领红包"];
            [comCell setRedBagIcon:@"package_icon_8"];
            [comCell setLeftIconNamed:@"about_wangcai_cell_icon"];
            [comCell hideFinishedIcon:YES];
        }
         */
        if (0)
        {
            
        }
        else
        {
            CommonTaskInfo* task = [[[CommonTaskList sharedInstance] getAllTaskList] objectAtIndex:rowExceptStaticCells];
            [comCell setTaskCellType:CommonTaskTableViewCellShowTypeRedTextUp];
            [comCell setUpText:task.taskTitle];
            [comCell setDownText:task.taskDesc];
            float moneyInYuan = [task.taskMoney floatValue]/100.f;
            NSString* pic = nil;
            if (moneyInYuan >= 0.5f && moneyInYuan < 1.0f)
            {
                pic = @"package_icon_half";
            }
            if (moneyInYuan >= 1.0f && moneyInYuan < 3.0f)
            {
                pic = @"package_icon_one";
            }
            if (moneyInYuan >= 3.0f && moneyInYuan < 8.0f)
            {
                pic = @"package_icon_3";
            }
            if (moneyInYuan >= 8.0f)
            {
                pic = @"package_icon_8";
            }
            
            [comCell setRedBagIcon:pic];
            [comCell setLeftIconNamed:@"table_view_cell_icon_bg"];
            if (task.taskIsLocalIcon)
            {
                [comCell setLeftIconNamed:task.taskIconUrl];
            }
            else
            {
                [comCell setLeftIconUrl:task.taskIconUrl];
            }
            
            if ([task.taskStatus intValue] == 1)
            {
                [comCell setCellState:CommonTaskTableViewCellStateFinished];
            }
            else
            {
                [comCell setCellState:CommonTaskTableViewCellStateUnfinish];
            }
        }
        
        cell = comCell;
    }
    
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    /*
    if (row == 0)
    {
        return 134.0f;
    }
    else if (row == 1)
    {
        return 64.0f;
    }
     */
    if (row < [_staticCells count])
    {
        UITableViewCell* cell = [_staticCells objectAtIndex:row];
        //CGFloat height = cell.frame.size.height;
        return cell.frame.size.height;
    }
    return 74.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    if (row < [_staticCells count])
    {
        
    }
    else
    {
        int taskIndex = row - [_staticCells count];
        CommonTaskInfo* task = [[[CommonTaskList sharedInstance] taskList] objectAtIndex:taskIndex];
        switch ([task.taskType intValue])
        {
            case kTaskTypeUserInfo:
            {
                UserInfoEditorViewController* userInfoCtrl = [[UserInfoEditorViewController alloc] initWithNibName:@"UserInfoEditorViewController" bundle:nil];
                if (self.beeStack == nil)
                {
                    NSLog(@"靠！！！stack空的");
                }
                [self.beeStack pushViewController:userInfoCtrl animated:YES];
            }
                break;
            case kTaskTypeInstallWangcai:
            case kTaskTypeIntallApp:
            {
                NSString* tabs[3] = {0};
                for (int i = 0; i < 3; ++i)
                {
                    if ([task.taskStepStrings count] > i)
                    {
                        tabs[i] = [task.taskStepStrings objectAtIndex:i];
                    }
                }
                TaskController* taskCtrl = [[[TaskController alloc] init:task.taskId Tab1:tabs[0] Tab2:tabs[1] Tab3:tabs[2] Purse:[task.taskMoney floatValue]] autorelease];
                [self.beeStack pushViewController:taskCtrl animated:YES];
            }
                break;
            case kTaskTypeEverydaySign:
                
                break;
            case kTaskTypeInviteFriends:
                
                break;
                
            default:
                break;
        }
        
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 100)
    {
        if (_bounceHeader)
        {
            self.containTableView.bounces = YES;
        }
        else
        {
            self.containTableView.bounces = NO;
        }
    }
    else
    {
        self.containTableView.bounces = YES;
    }
    
    if (!_isUIZhuanJuhuaing && (scrollView.contentOffset.y+scrollView.frame.size.height) > scrollView.contentSize.height)
    {
        self.containTableViewFooterJuhuaView.hidden = NO;
        [self.containTableViewFooterJuhuaView startAnimating];
        _isUIZhuanJuhuaing = YES;
        [self performSelector:@selector(onLoadHistoricalFinishedList) withObject:nil afterDelay:2.0];
        //[self onLoadHistoricalFinishedList];
    }
}

#pragma mark - other

- (void)resetFooter
{
    self.containTableViewFooterJuhuaView.hidden = YES;
    self.containTableView.tableFooterView = self.containTableViewFooterView;
    if (self.containTableView.contentSize.height < self.containTableView.frame.size.height)
    {
        self.containTableViewFooterViewTextLabel.text = @"点击查看已领取的红包";
    }
    else
    {
        self.containTableViewFooterViewTextLabel.text = @"继续向上拖动查看已领取的红包";
    }
    _isUIZhuanJuhuaing = NO;
}

- (void)endFooter
{
    self.containTableViewFooterJuhuaView.hidden = YES;
    self.containTableViewFooterView.hidden = YES;
    //self.containTableView.tableFooterView = nil;
}

#pragma mark <CommonTaskListDelegate>

- (void)onFinishedFetchTaskList:(CommonTaskList*)taskList resultCode:(NSInteger)result
{
    if (result >= 0)
    {
        [self.containTableView reloadData];
        [self.infoCell setJinTianHaiNengZhuanNumLabelTextNum:[taskList allMoneyCanBeEarnedInRMBYuan]];
        [self resetFooter];
    }
    else
    {
        [MBHUDView hudWithBody:@":(\n拉取失败" type:MBAlertViewHUDTypeImagePositive  hidesAfter:2.0 show:YES];
    }
}


@end
