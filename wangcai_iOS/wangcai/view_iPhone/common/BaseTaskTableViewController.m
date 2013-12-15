//
//  BaseTaskTableViewController.m
//  wangcai
//
//  Created by Lee Justin on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "BaseTaskTableViewController.h"
#import "CommonTaskTableViewCell.h"

@interface BaseTaskTableViewController ()

@end

@implementation BaseTaskTableViewController

@synthesize infoCell = _infoCell;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.infoCell = nil;
    [super dealloc];
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
    if (row == 0)
    {
        cell = _infoCell;
    }
    else
    {
        CommonTaskTableViewCell* comCell = [tableView dequeueReusableCellWithIdentifier:@"taskCell"];
        if (comCell == nil)
        {
            comCell = [[[CommonTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"taskCell"] autorelease];
        }
        
        if (row < 4)
        {
            [comCell setTaskCellType:CommonTaskTableViewCellShowTypeRedTextUp];
            [comCell setUpText:@"关注旺财"];
            [comCell setDownText:@"用微信关注旺财"];
            [comCell setRedBagIcon:@"package_icon_8"];
            [comCell setLeftIconUrl:@"http://a1.mzstatic.com/us/r30/Purple/v4/a6/dc/ee/a6dceea2-ae77-1746-0dc3-1f6f7"];
        }
        else
        {
            [comCell setTaskCellType:CommonTaskTableViewCellShowTypeRedTextDown];
            [comCell setUpText:@"安装窃听风云"];
            [comCell setDownText:@"安装并使用3分钟"];
            [comCell setRedBagIcon:@"package_icon_half"];
            [comCell setLeftIconUrl:@"http://a1.mzstatic.com/us/r30/Purple/v4/a6/dc/ee/a6dceea2-ae77-1746-0dc3-1f6f7a988a0d/icon170x170.png"];
        }
        
        
        
        cell = comCell;
    }
    
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0)
    {
        return 64.0f;
    }
    return 74.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
