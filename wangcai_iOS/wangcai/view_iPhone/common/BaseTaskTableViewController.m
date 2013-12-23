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

@interface BaseTaskTableViewController ()

@end

@implementation BaseTaskTableViewController

@synthesize bounceHeader = _bounceHeader;
@synthesize zhanghuYuEHeaderCell = _zhanghuYuEHeaderCell;
@synthesize infoCell = _infoCell;
@synthesize containTableView = _containTableView;
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
    self.staticCells = [NSMutableArray array];
    _bounceHeader = NO;
    [self performSelector:@selector(resetTableViewFrame) withObject:nil afterDelay:0.05];
    [self resetStaticCells];
    if (_bounceHeader)
    {
        self.containTableView.bounces = YES;
    }
    else
    {
        self.containTableView.bounces = NO;
    }
    //[self performSelectorOnMainThread:@selector(resetTableViewFrame) withObject:nil waitUntilDone:NO];
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

-(void)resetStaticCells
{
    [_staticCells removeAllObjects];
    
    [_staticCells addObject:self.zhanghuYuEHeaderCell];
    [_staticCells addObject:self.infoCell];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    NSInteger row = indexPath.row;
    NSInteger rowExceptStaticCells = row - [_staticCells count];
    
    if (row < [_staticCells count])
    {
        cell = [_staticCells objectAtIndex:row];
        if (_bounceHeader)
        {
            tableView.bounces = YES;
        }
        else
        {
            tableView.bounces = NO;
        }
    }
    else
    {
        CommonTaskTableViewCell* comCell = [tableView dequeueReusableCellWithIdentifier:@"taskCell"];
        if (comCell == nil)
        {
            comCell = [[[CommonTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"taskCell"] autorelease];
        }
        
        if (rowExceptStaticCells == 0)
        {
            [comCell setTaskCellType:CommonTaskTableViewCellShowTypeRedTextUp];
            [comCell setUpText:@"补充个人信息"];
            [comCell setDownText:@"让旺财知道你喜欢什么，赚更多的红包"];
            [comCell setRedBagIcon:@"package_icon_one"];
            [comCell setLeftIconNamed:@"person_info_icon"];
        }
        else if (rowExceptStaticCells == 1)
        {
            [comCell setTaskCellType:CommonTaskTableViewCellShowTypeRedTextUp];
            [comCell setUpText:@"关注旺财"];
            [comCell setDownText:@"用微信随时随地领红包"];
            [comCell setRedBagIcon:@"package_icon_8"];
            [comCell setLeftIconNamed:@"about_wangcai_cell_icon"];
        }
        else
        {
            [comCell setTaskCellType:CommonTaskTableViewCellShowTypeRedTextUp];
            [comCell setUpText:@"安装窃听风云"];
            [comCell setDownText:@"安装并使用3分钟"];
            [comCell setRedBagIcon:@"package_icon_half"];
            [comCell setLeftIconNamed:@"table_view_cell_icon_bg"];
            [comCell setLeftIconUrl:@"http://a1.mzstatic.com/us/r30/Purple/v4/a6/dc/ee/a6dceea2-ae77-1746-0dc3-1f6f7a988a0d/icon170x170.png"];
        }
        
        cell = comCell;
        
        tableView.bounces = _bounceHeader;
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
        UserInfoEditorViewController* userInfoCtrl = [[UserInfoEditorViewController alloc] initWithNibName:@"UserInfoEditorViewController" bundle:nil];
        if (self.beeStack == nil)
        {
            NSLog(@"靠！！！stack空的");
        }
        [self.beeStack pushViewController:userInfoCtrl animated:YES];
    }
}

@end
