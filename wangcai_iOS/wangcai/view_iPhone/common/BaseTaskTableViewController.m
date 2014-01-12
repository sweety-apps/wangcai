//
//  BaseTaskTableViewController.m
//  wangcai
//
//  Created by Lee Justin on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BaseTaskTableViewController.h"
#import "CommonTaskTableViewCell.h"
#import "UserInfoEditorViewController.h"
#import "CommonTaskList.h"
#import "MBHUDView.h"
#import "TaskController.h"
#import "ChoujiangViewController.h"
#import "ChoujiangLogic.h"
#import "NSString+FloatFormat.h"
#import "PhoneValidationController.h"
#import "SettingLocalRecords.h"

static BOOL gNeedReloadTaskList = NO;

@interface BaseTaskTableViewController () <CommonTaskListDelegate>
{
    NSTimer* _checkOfferWallTimer;
    BOOL _justOnePage;
}

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
    _justOnePage = NO;
    _curCellCount = 0;
    _hisCellCount = 0;
    
    self.staticCells = [NSMutableArray array];
    _bounceHeader = NO;
    _alertBalanceTip = nil;
    
    _hasLoadedHistoricalFinishedList = NO;
    
    [self addHeader];
    [self resetFooter];
    [self performSelector:@selector(resetTableViewFrame) withObject:nil afterDelay:0.05];
    [self resetStaticCells];
    
    [self.infoCell setJinTianHaiNengZhuanNumLabelTextNum:[[CommonTaskList sharedInstance] allMoneyCanBeEarnedInRMBYuan]];
    
    [self.zhanghuYuEHeaderCell.yuENumView setNum:[[LoginAndRegister sharedInstance] getBalance]];
    
    _checkOfferWallTimer = [NSTimer scheduledTimerWithTimeInterval:15.f target:self selector:@selector(checkDMOfferWall) userInfo:nil repeats:NO];
    
    
    //[self performSelector:@selector(refreshTaskList) withObject:nil afterDelay:2.0f];
}

- (void)checkDMOfferWall
{
    [OnlineWallViewController sharedInstance].delegate = self;
    [[OnlineWallViewController sharedInstance] requestAndConsumePoint];
    _checkOfferWallTimer = [NSTimer scheduledTimerWithTimeInterval:15.f target:self selector:@selector(checkDMOfferWall) userInfo:nil repeats:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [OnlineWallViewController sharedInstance].delegate = self;
    [[OnlineWallViewController sharedInstance] requestAndConsumePoint];
    
    [self checkBalanceAndAnimateYuE];
    
    // 超过5元
    if ( _alertBalanceTip == nil ) {
        if ( [[LoginAndRegister sharedInstance] getBalance] >= 500 ) {
            _alertBalanceTip = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的余额超过5元，为了您的帐号安全，推荐您绑定手机" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"绑定手机", nil];
            
            [_alertBalanceTip show];
        }
    }
    
    if (gNeedReloadTaskList)
    {
        [self refreshTaskList];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == 1 ) {
        if ( [alertView isEqual:_alertBalanceTip] ) {
            // 绑定手机
            PhoneValidationController* phoneVal = [PhoneValidationController shareInstance];
            
            [self.beeStack pushViewController:phoneVal animated:YES];
        }
    }
}

- (void)checkBalanceAndAnimateYuE
{
    if ([[LoginAndRegister sharedInstance] getBalance] > [self.zhanghuYuEHeaderCell.yuENumView getNum])
    {
        NSIndexPath* pathTop = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.containTableView scrollToRowAtIndexPath:pathTop atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self setYuENumberWithAnimationFrom:[self.zhanghuYuEHeaderCell.yuENumView getNum] toNum:[[LoginAndRegister sharedInstance] getBalance]];
    }
    else
    {
        [self.zhanghuYuEHeaderCell.yuENumView setNum:[[LoginAndRegister sharedInstance] getBalance]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[ChoujiangLogic sharedInstance] getAwardCode] == kGetAwardTypeNotGet)
    {
        [self enableQiandaoButton:YES];
    }
    else
    {
        [self enableQiandaoButton:NO];
    }
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
    [_checkOfferWallTimer invalidate];
    
    if ( _alertBalanceTip != nil ) {
        [_alertBalanceTip release];
        _alertBalanceTip = nil;
    }
    
    [super dealloc];
}

- (void)addHeader
{
    UIView* longView = [[[UIView alloc] initWithFrame:CGRectMake(0, -300, 320, 370)] autorelease];
    longView.backgroundColor = RGB(25, 138, 191);
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.backgroundColor = RGB(25, 138, 191);
    [header insertSubview:longView atIndex:0];
    //self.containTableView.backgroundColor = RGB(25, 138, 191);
    header.scrollView = self.containTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block

        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        //[self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        [self refreshTaskList];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    //[header beginRefreshing];
    _header = header;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.containTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
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
    [MBHUDView hudWithBody:@"" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:10000000000.f show:YES];
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

- (IBAction)onPressedQiandaoChoujiangButton:(id)sender
{
    if ([ChoujiangLogic sharedInstance].getAwardCode == kGetAwardTypeNotGet) {
        ChoujiangViewController* choujiangCtrl = [[ChoujiangViewController alloc] init];
        [self.beeStack pushViewController:choujiangCtrl animated:YES];
    }
    else
    {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"您今天已签到" message:@"明天记得再来签到哟！" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

- (IBAction)onPressedTiquxianjinButton:(id)sender
{
    [[BeeUIRouter sharedInstance] open:@"second" animated:YES];
}

- (void)enableQiandaoButton:(BOOL)enabled
{
    //self.zhanghuYuEHeaderCell.qiandaoButton.enabled = enabled;
    BOOL hidden = enabled ? NO : YES;
    self.zhanghuYuEHeaderCell.qiandaoRedDotBubble.hidden = hidden;
    //self.zhanghuYuEHeaderCell.qiandaoIcon.hidden = hidden;
    //self.zhanghuYuEHeaderCell.qiandaoLabel.hidden = hidden;
}

- (void)enableTixianButton:(BOOL)enabled
{
    //self.zhanghuYuEHeaderCell.tixianButton.enabled = enabled;
    BOOL hidden = enabled ? NO : YES;
    //self.zhanghuYuEHeaderCell.tixianIcon.hidden = hidden;
    //self.zhanghuYuEHeaderCell.tixianLabel.hidden = hidden;
}

//带动画和声音设置余额
- (void)setYuENumberWithAnimationFrom:(int)oldNum toNum:(int)newNum
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gotcoins" ofType:@"aiff"];
    
    
    if (path) {
        SystemSoundID soundID;
        
        NSURL* pathUrl = [NSURL fileURLWithPath:path];
        
        
        AudioServicesCreateSystemSoundID((CFURLRef)pathUrl,&soundID);
        
        AudioServicesPlaySystemSound(soundID);
    }
    
    
    [self.zhanghuYuEHeaderCell.yuENumView animateNumFrom:oldNum to:newNum withAnimation:YES];
}

+ (void)setNeedReloadTaskList
{
    gNeedReloadTaskList = YES;
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
            
            if ([task.taskStatus intValue] == CommonTaskTableViewCellStateFinished)
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
        //测试数字动画
        //[self setYuENumberWithAnimationFrom:0.1 toNum:29.8];
    }
    else
    {
        int taskIndex = row - [_staticCells count];
        CommonTaskInfo* task = [[[CommonTaskList sharedInstance] taskList] objectAtIndex:taskIndex];
        if ([task.taskStatus intValue] == 0)
        {
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
                case kTaskTypeOfferWall:
                {
                    if (![SettingLocalRecords getOfferWallAlertViewShowed])
                    {
                        [[OnlineWallViewController sharedInstance] showWithModal];
                        [SettingLocalRecords saveOfferWallAlertViewShowed:YES];
                    }
                    else
                    {
                        [[OnlineWallViewController sharedInstance] clickConinue:nil];
                    }
                    
                }
                    break;
                case kTaskTypeInstallWangcai:
                case kTaskTypeIntallApp:
                case kTaskTypeCommon:
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
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
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
     */
    
    if (!_justOnePage && !_isUIZhuanJuhuaing && (scrollView.contentOffset.y+scrollView.frame.size.height) > scrollView.contentSize.height)
    {
        self.containTableViewFooterJuhuaView.hidden = NO;
        [self.containTableViewFooterJuhuaView startAnimating];
        _isUIZhuanJuhuaing = YES;
        [self performSelector:@selector(onLoadHistoricalFinishedList) withObject:nil afterDelay:0.5];
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
        _justOnePage = YES;
        self.containTableViewFooterViewTextLabel.text = @"点击查看已领取的红包";
    }
    else
    {
        _justOnePage = NO;
        self.containTableViewFooterViewTextLabel.text = @"继续向上拖动查看已领取的红包";
    }
    _isUIZhuanJuhuaing = NO;
    
    if ([[[CommonTaskList sharedInstance] getAllTaskList] count] <= 5)
    {
        [self onLoadHistoricalFinishedList];
    }
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
    [MBHUDView dismissCurrentHUD];
    gNeedReloadTaskList = NO;
    if (result >= 0)
    {
        [self.containTableView reloadData];
        [self.infoCell setJinTianHaiNengZhuanNumLabelTextNum:[taskList allMoneyCanBeEarnedInRMBYuan]];
        [self.zhanghuYuEHeaderCell.yuENumView setNum:[[LoginAndRegister sharedInstance] getBalance]];
        [self doneWithView:_header];
        [self resetFooter];
        [self.containTableView reloadData];
    }
    else
    {
        [MBHUDView hudWithBody:@":(\n拉取失败" type:MBAlertViewHUDTypeImagePositive  hidesAfter:2.0 show:YES];
    }
}

#pragma mark <OnlineWallViewControllerDelegate>

- (void) onRequestAndConsumePointCompleted : (BOOL) suc Consume:(NSInteger) consume
{
    if (suc && consume > 0)
    {
        [[LoginAndRegister sharedInstance] increaseBalance:consume];
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"收到应用体验红包 %@ 元！",[NSString stringWithFloatRoundToPrecision:((float)consume)/100.f precision:1 ignoreBackZeros:YES]] message:@"" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil] autorelease];
        [alert show];
        [self checkBalanceAndAnimateYuE];
    }
}

@end
