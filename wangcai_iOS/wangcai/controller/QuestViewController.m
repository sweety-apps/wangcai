//
//  QuestViewController.m
//  wangcai
//
//  Created by NPHD on 14-5-21.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "QuestViewController.h"
#import "MBHUDView.h"
#import "Common.h"
#import "Config.h"
#import "CommonTaskTableViewCell.h"
#import "QuestCaptionViewController.h"

@interface QuestViewController ()

@end


@implementation SurveyInfo

@synthesize sid;
@synthesize title;
@synthesize url;
@synthesize status;
@synthesize money;
@synthesize level;
@synthesize intro;
@end


@implementation QuestViewController
@synthesize tbView;

static QuestViewController* _sharedInstance = nil;

+ (QuestViewController*) sharedInstance {
    if ( _sharedInstance == nil ) {
        _sharedInstance = [[QuestViewController alloc] initWithNibName:nil bundle:nil];
    }
    return _sharedInstance;
}

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
    
    _firstRequest = YES;
    _request = nil;
    _list = nil;
    _bShow = NO;
    _alertLevel = nil;
    _alertInstallApp = nil;
    _installUrl = nil;
    _bRequest = NO;
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    rect.origin.y = 54;
    rect.size.height -= 54;
    
    [tbView setFrame:rect];
    tbView.delegate = self;
    tbView.dataSource = self;
    
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    CGRect rt = CGRectMake(0.0f,
                           0.0f-tbView.bounds.size.height,
                           tbView.frame.size.width,
                           tbView.frame.size.height);
    EGORefreshTableHeaderView* view1 = [[EGORefreshTableHeaderView alloc]
                                        initWithFrame:rt];
    view1.delegate = self;
    [tbView addSubview:view1];
    _refreshHeaderView = view1;
    [view1 release];
    
    [self requestList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _bShow = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _bShow = NO;
}

- (void)setUIStack:(BeeUIStack*) stack {
    self->_beeUIStack = stack;
}

- (IBAction)clickBack:(id)sender {
    [self->_beeUIStack popViewControllerAnimated:YES];
}

- (void) showLoading:(NSString*) tip {
    [MBHUDView hudWithBody:tip type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
}

- (void) hideLoading {
    [MBHUDView dismissCurrentHUD];
}

- (void) requestList {
    if ( _bRequest ) {
        return ;
    }
    
    _bRequest = YES;
    
    if ( _firstRequest ) {
        [self showLoading:@"请等待..."];
    }
    
    if ( _request != nil ) {
        [_request release];
    }
    
    _request = [[HttpRequest alloc] init:self];
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    NSString* timestamp = [Common getTimestamp];
    [dictionary setObject:timestamp forKey:@"stamp"];
    NSDictionary* dic = [[NSBundle mainBundle] infoDictionary];
    NSString* appVersion = [dic valueForKey:@"CFBundleVersion"];
    [dictionary setObject:appVersion forKey:@"ver"];
    [dictionary setObject:APP_NAME forKey:@"app"];
    
    [_request request:HTTP_TASK_SURVEY_LIST Param:dictionary method:@"get"];
}


-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    if ( _request != nil && [request isEqual:_request] ) {
        if ( _firstRequest ) {
            [self hideLoading];
            _firstRequest = NO;
        }
        
        if ( httpCode == 200 ) {
            // 获取到返回的列表
            NSNumber* res = [body valueForKey: @"res"];
            int nRes = [res intValue];
            if (nRes == 0) {
                NSArray* list = [body valueForKey: @"survey_list"];
                if ( _list != nil ) {
                    [_list release];
                }
                
                _list = [self copyList:list];
            }
        }
        
        [self doneLoadingTableViewData];
    }
    
    _bRequest = NO;
}

- (NSArray*) copyList:(NSArray*) list {
    NSMutableArray* unfinished = [[NSMutableArray alloc] init];
    NSMutableArray* finished = [[NSMutableArray alloc] init];
    
    for ( int i = 0; i < [list count]; i ++ ) {
        NSDictionary* taskDict = [list objectAtIndex:i];
        
        SurveyInfo* task = [[[SurveyInfo alloc] init] autorelease];
        
        task.sid = [taskDict objectForKey:@"id"];
        task.title = [taskDict objectForKey:@"title"];
        task.status = [taskDict objectForKey:@"status"];
        task.money = [taskDict objectForKey:@"money"];
        task.level = [taskDict objectForKey:@"level"];
        task.intro = [taskDict objectForKey:@"intro"];
        task.url = [taskDict objectForKey:@"url"];
        
        if ( [task.status intValue] != 0 ) {
            [finished addObject:task];
        } else {
            [unfinished addObject:task];
        }
    }
    
    [unfinished addObjectsFromArray:finished];
    
    [finished release];
    
    return unfinished;
}

- (void) reloadTableViewDataSource{
    _reloading = NO;
    //这里引用你加载数据的方法
    
    [self requestList];
}

//加载结束事件
- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if ( _list != nil ) {
        [tbView reloadData];
    }else {
        if ( _bShow ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用，请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tbView];
}

#pragma mark -#pragma mark UIScrollViewDelegate Methods
//table也是scrollview所以只要滚动就会调用这个方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

//滚动结束就会调用这个方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

//释放更新
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    //
    //  [self reloadTableViewDataSource];
    [NSThread detachNewThreadSelector:@selector(reloadTableViewDataSource) toTarget:self withObject:nil];
    //  [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading; // should return if data source model is reloading
}



- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    CommonTaskTableViewCell* comCell = [tableView dequeueReusableCellWithIdentifier:@"wangcaiTaskCell"];
    if (comCell == nil)
    {
        comCell = [[[CommonTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wangcaiTaskCell"] autorelease];
    }
    
    SurveyInfo* task = [_list objectAtIndex:row];
    [comCell setTaskCellType:CommonTaskTableViewCellShowTypeRedTextUp];
    [comCell setUpText:task.title];
    [comCell setDownText:task.intro];
    float moneyInYuan = [task.money floatValue]/100.f;
    NSString* pic = nil;
    if (moneyInYuan >= 0.001f && moneyInYuan < 0.5) {
        pic = @"package_icon_1mao";
    }
    if (moneyInYuan >= 0.5f && moneyInYuan < 1.0f) {
        pic = @"package_icon_half";
    }
    if (moneyInYuan >= 1.0f && moneyInYuan < 1.5f) {
        pic = @"package_icon_one";
    }
    if (moneyInYuan >= 1.5f && moneyInYuan < 2.0f) {
        pic = @"package_icon_1_5";
    }
    if (moneyInYuan >= 2.0f && moneyInYuan < 2.5f) {
        pic = @"package_icon_2";
    }
    if (moneyInYuan >= 2.5f && moneyInYuan < 3.0f) {
        pic = @"package_icon_2_5";
    }
    if (moneyInYuan >= 3.0f && moneyInYuan < 8.0f) {
        pic = @"package_icon_3";
    }
    if (moneyInYuan >= 8.0f && moneyInYuan < 9.0f) {
        pic = @"package_icon_8";
    }
    if (moneyInYuan >= 9.0f) {
        pic = @"package_icon_many";
    }
    
    [comCell setRedBagIcon:pic];
    [comCell setLeftIconNamed:@"table_view_cell_icon_bg"];
    [comCell setLeftIconNamed:@"quest_icon"];
    
    if ([task.status intValue] == 0) {
        [comCell setCellState:CommonTaskTableViewCellStateUnfinish];
    } else {
        [comCell setCellState:CommonTaskTableViewCellStateFinished];
    }
    
    return comCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( _list == nil ) {
        return 0;
    }
    
    return [_list count];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    
    SurveyInfo* task = [_list objectAtIndex:row];
    
    int nLevel = [[LoginAndRegister sharedInstance] getUserLevel];
    int nNeedLevel = [task.level intValue];
    
    if ( nLevel < nNeedLevel ) {
        // 等级不够
        if ( _alertLevel != nil ) {
            [_alertLevel release];
        }
        
        _alertLevel = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"该任务需要等级达到%d级才能进行", nNeedLevel] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"我的等级", nil];
        [_alertLevel show];
        
        return ;
    }
    
    if ( [task.status intValue] == 0 ) {
        QuestCaptionViewController* controller = [[[QuestCaptionViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        [controller setQuestInfo:task];
        [_beeUIStack pushViewController:controller animated:YES];
    }
}


#pragma mark <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( _alertLevel != nil && [_alertLevel isEqual:alertView] ) {
        if ( buttonIndex == 1 ) {
            // 显示我的旺财
            [[BeeUIRouter sharedInstance] open:@"my_wangcai" animated:YES];
        }
    }
}

@end