//
//  WangcaiTaskViewController.m
//  wangcai
//
//  Created by NPHD on 14-5-21.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "WangcaiTaskViewController.h"
#import "MBHUDView.h"
#import "Common.h"
#import "Config.h"
#import "CommonTaskList.h"
#import "CommonTaskTableViewCell.h"
#import "ReissueRewardVC.h"

@interface WangcaiTaskViewController ()

@end

@implementation WangcaiTaskViewController
@synthesize tbView;

static WangcaiTaskViewController* _sharedInstance = nil;

+ (WangcaiTaskViewController*) sharedInstance {
    if ( _sharedInstance == nil ) {
        _sharedInstance = [[WangcaiTaskViewController alloc] initWithNibName:nil bundle:nil];
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
    rect.size.height -= 98;
    
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
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height-44, [[UIScreen mainScreen] bounds].size.width, 44)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 24)];
    label.text = @"官方任务：100% 红包发放";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15.f];
    label.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [UIColor colorWithRed:126/255.f green:127/255.f blue:126/255.f alpha:1.f];
    [view addSubview:label];
    
    
    
    UIButton *feedback = [UIButton buttonWithType:UIButtonTypeCustom];
    [feedback addTarget:self action:@selector(feedback) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"omissionnormal.png"];
    [feedback setBackgroundImage:image forState:UIControlStateNormal];
    feedback.frame = CGRectMake(230, 10, image.size.width/2.f, image.size.height/2.f);
    [view addSubview:feedback];
    [self.view addSubview:view];
    
    [label release];
    [view release];
    
    
}
- (void)feedback
{
    ReissueRewardVC *vc = [[ReissueRewardVC alloc]initWithItems:_list];
    [vc setUIStack:_beeUIStack];
    [_beeUIStack pushViewController:vc animated:YES];
    [vc release];
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
    
    [_request request:HTTP_TASK_APP_LIST Param:dictionary method:@"get"];
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
                NSArray* list = [body valueForKey: @"task_list"];
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
        
        CommonTaskInfo* task = [[[CommonTaskInfo alloc] init] autorelease];

        task.taskId = [taskDict objectForKey:@"id"];
        task.taskType = [taskDict objectForKey:@"type"];
        task.taskTitle = [taskDict objectForKey:@"title"];
        task.taskStatus = [taskDict objectForKey:@"status"];
        task.taskMoney = [taskDict objectForKey:@"money"];
        task.taskIconUrl = [taskDict objectForKey:@"icon"];
        task.taskIntro = [taskDict objectForKey:@"intro"];
        task.taskDesc = [taskDict objectForKey:@"desc"];
        task.taskStepStrings = [taskDict objectForKey:@"steps"];
        task.taskLevel = [taskDict objectForKey:@"level"];
        task.taskRediectUrl = [taskDict objectForKey:@"rediect_url"];
        task.taskAppId = [taskDict objectForKey:@"appid"];

        if ( [task.taskStatus intValue] == CommonTaskTableViewCellStateFinished ) {
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

    CommonTaskInfo* task = [_list objectAtIndex:row];
    [comCell setTaskCellType:CommonTaskTableViewCellShowTypeRedTextUp];
    [comCell setUpText:task.taskTitle];
    [comCell setDownText:task.taskDesc];
    float moneyInYuan = [task.taskMoney floatValue]/100.f;
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
    [comCell setLeftIconUrl:task.taskIconUrl];
    
    if ([task.taskStatus intValue] == CommonTaskTableViewCellStateFinished) {
        [comCell setCellState:CommonTaskTableViewCellStateFinished];
    } else {
        [comCell setCellState:CommonTaskTableViewCellStateUnfinish];
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

    CommonTaskInfo* task = [_list objectAtIndex:row];
        
    int nLevel = [[LoginAndRegister sharedInstance] getUserLevel];
    int nNeedLevel = [task.taskLevel intValue];
        
    if ( nLevel < nNeedLevel ) {
        // 等级不够
        if ( _alertLevel != nil ) {
            [_alertLevel release];
        }
            
        _alertLevel = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"该任务需要等级达到%d级才能进行", nNeedLevel] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"我的等级", nil];
        [_alertLevel show];
            
        return ;
    }

    if ([task.taskStatus intValue] == 0) {
        [self onClickInstallApp:task];
    }
}


- (void) onClickInstallApp: (CommonTaskInfo* ) task {
    if ( _alertInstallApp != nil ) {
        [_alertInstallApp release];
    }
    
    if ( _installUrl != nil ) {
        [_installUrl release];
        _installUrl = nil;
    }
    
    UIView* view = [[[[NSBundle mainBundle] loadNibNamed:@"AppInstallTipView" owner:self options:nil] lastObject] autorelease];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10.0;
    view.layer.borderWidth = 0.0;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UIColor *color = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1];
    
    UIButton* btn = (UIButton*)[view viewWithTag:11];
    [btn.layer setBorderWidth:0.5];
    [btn.layer setBorderColor:[color CGColor]];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onClickCancelInstall:) forControlEvents:UIControlEventTouchUpInside];
    
    btn = (UIButton*)[view viewWithTag:12];
    [btn.layer setBorderWidth:0.5];
    [btn.layer setBorderColor:[color CGColor]];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onClickInstall:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* text = [NSString stringWithFormat:@"安装%@赚取%.1f元红包", task.taskTitle, [task.taskMoney intValue]*1.0/100];
    
    NSString* text2 = [NSString stringWithFormat:@"提示：%@", task.taskIntro];
    ((UILabel*)[view viewWithTag:21]).text = text;
    ((UILabel*)[view viewWithTag:22]).text = text2;
    
    NSRange range = [task.taskRediectUrl rangeOfString:@"?"];
    NSString* urlHeader = nil;
    if ( range.length == 0 ) {
        // 没有?
        urlHeader = [NSString stringWithFormat:@"%@?", task.taskRediectUrl];
    } else {
        // 有?
        urlHeader = [NSString stringWithFormat:@"%@&", task.taskRediectUrl];
    }
    
    NSString* deviceId = [[LoginAndRegister sharedInstance] getDeviceId];
    NSString* mac = [Common getMACAddress];
    NSString* idfa = [Common getIDFAAddress];
    NSString* idfv = [Common getIDFV];
    
    NSString* md5param = [NSString stringWithFormat:@"appid=%@&deviceid=%@&idfa=%@&idfv=%@&mac=%@&cf1618a14ef2f600f89092fb3ccd7cf3", task.taskAppId, deviceId, idfa, idfv, mac];
    
    const char* cStr = [md5param UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    NSMutableString* hash = [NSMutableString string];
    for (int i = 0; i < 16; i ++ ) {
        [hash appendFormat:@"%02x", result[i]];
    }
    
    NSString* param = [NSString stringWithFormat:@"appid=%@&deviceid=%@&idfa=%@&idfv=%@&mac=%@&sign=%@", task.taskAppId, deviceId, idfa, idfv, mac, [hash lowercaseString]];
    
    [deviceId release];
    
    _installUrl = [[NSString alloc] initWithFormat:@"%@%@", urlHeader, param];
    
    
    _alertInstallApp = [[UICustomAlertView alloc]init:view];
    
    [_alertInstallApp show];
}


- (void) onClickInstall:(id) sender {
    if ( _alertInstallApp != nil ) {
        [_alertInstallApp hideAlertView];
    }
    
    // 安装app
    NSURL* url = [NSURL URLWithString:_installUrl];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) onClickCancelInstall:(id) sender {
    if ( _alertInstallApp != nil ) {
        [_alertInstallApp hideAlertView];
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
