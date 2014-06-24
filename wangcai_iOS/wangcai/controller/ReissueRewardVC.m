//
//  ReissueRewardVC.m
//  wangcai
//
//  Created by NPHD on 14-6-23.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "ReissueRewardVC.h"
#import "CommonTaskList.h"
#import "MBHUDView.h"
#import "Common.h"
#import "Config.h"

@interface ReissueRewardVC ()
{
    UITableView *table;
    NSMutableArray *selectIndex;
    BOOL hasRedExplanation;
    UIButton *submit;
}
@end

@implementation ReissueRewardVC

- (id)initWithItems:(NSArray *)aitems
{
    self = [super init];
    if(self)
    {
        items = [aitems copy];
//        items = [[NSMutableArray alloc]init];
//        for (int i = 0; i != 41; i++) {
//            CommonTaskInfo *info = [[CommonTaskInfo alloc]init];
//            info.taskAppId = [NSString stringWithFormat:@"%d",i];
//            info.taskTitle = [NSString stringWithFormat:@"%d",i];
//            [items addObject:info];
//            [info release];
//        }
        
    }
    return self;
}
- (void)setUIStack:(BeeUIStack*) stack {
    _beeUIStack = stack;
    [_beeUIStack retain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 64)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 100, 64)];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = UITextAlignmentCenter;
    
    title.text = @"补发红包";
    title.font = [UIFont systemFontOfSize:20.f];
    [header addSubview:title];
    [title release];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"back@2x.png"];
    [back setBackgroundImage:image forState:UIControlStateNormal];
    CGRect frame = CGRectMake(20, 22, image.size.width/2.f, image.size.height/2.f);
    back.frame = frame;
    [header addSubview:back];
    header.backgroundColor = [UIColor colorWithRed:12/255.f green:90/255.f blue:189/255.f alpha:1.f];
    [self.view addSubview:header];
    [header release];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, header.frame.size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-header.frame.size.height) style:UITableViewStyleGrouped];
    table.backgroundColor = [UIColor colorWithRed:223/255.f green:223/255.f blue:228/255.f alpha:1.f];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    table.separatorColor = [UIColor clearColor];
    NSLog(@"table retainCount = %d",[table retainCount]);
    [table release];
     NSLog(@"table retainCount = %d",[table retainCount]);
    hasRedExplanation = NO;
//    if(!items)
//    {
//        items = [[NSMutableArray alloc]init];
//        [items addObject:@"迅雷"];
//        [items addObject:@"窃听风云"];
//        [items addObject:@"信用卡特惠"];
//        [items addObject:@"特实惠"];
//    }
    selectIndex = [[NSMutableArray alloc]init];
}
- (void)goback
{
    [_beeUIStack popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 1) return 80;
    if(indexPath.section == 1 && indexPath.row == 0) return 30;
    if(indexPath.section == 0 && indexPath.row == 0) return 30;
    if(indexPath.section == 1 && indexPath.row == 0) return 60;
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        int count = items.count;
        if(count%2 == 0)
            return count/2+1;
        return count/2 + 2;
    }
    if(section == 1) return 3;
    return 1;
}

- (UIView*)compentWithImage :(UIImage*)image
                       title:(NSString*)title
                     bgFrame:(CGRect)bgframe
                  imageFrame:(CGRect)imframe
                  textFrame :(CGRect)textfrmale
                      target:(id)target
                      action:(SEL)act
{
    UIView *bg = [[UIView alloc]init];
    bg.frame = bgframe;
    UILabel *text = [[UILabel alloc]initWithFrame:textfrmale];
    text.text = title;
    text.textColor = [UIColor lightGrayColor];
    [bg addSubview:text];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = imframe;
    [bg addSubview:imageView];
    

    [imageView release];
    [text release];
    return bg;
}

- (void)tapAction:(UITapGestureRecognizer*)atap
{
    
    CGPoint point=[atap locationInView:table];
    NSIndexPath *path=[table indexPathForRowAtPoint:point];
    if(path.section != 0) return;
     
    NSString *taskAppId = @"";
    if(point.x > 160 ){
        if(path.row*2-1 >= items.count) return;
        CommonTaskInfo *info = [items objectAtIndex:path.row*2-1];
        taskAppId = info.taskAppId;
    }else{
        CommonTaskInfo *info = [items objectAtIndex:path.row*2-2];
        taskAppId = info.taskAppId;
    }
    UITableViewCell *cell = [table cellForRowAtIndexPath:path];
    UIView *view = [cell.contentView viewWithTag:[taskAppId integerValue]+10];
    if([self isRowSelect:taskAppId])
    {
        [self deslectIndex:taskAppId];
        for (UIView *sub in view.subviews)
        {
            if([sub isKindOfClass:[UIImageView class]])
            {
                UIImageView *imageVew = (UIImageView*)sub;
                imageVew.image = [UIImage imageNamed:@"单选-normal.png"];
                return;
            }
        }
    }else
    {
        if(!selectIndex) selectIndex = [[NSMutableArray alloc]init];
        [selectIndex addObject:taskAppId];
        for (UIView *sub in view.subviews)
        {
            if([sub isKindOfClass:[UIImageView class]])
            {
                UIImageView *imageVew = (UIImageView*)sub;
                imageVew.image = [UIImage imageNamed:@"单选down.png"];
                return;
            }
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        
    }
    cell.textLabel.text = nil;
    [cell.contentView removeAllSubviews];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
    for (UIGestureRecognizer *ges in cell.gestureRecognizers)
    {
        [cell removeGestureRecognizer:ges];
    }
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"请选择未发放红包的任务";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15.f];
        }else
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            tap.cancelsTouchesInView = NO;
            [cell addGestureRecognizer:tap];
            [tap release];
            
            CommonTaskInfo *info = [items objectAtIndex:(2*indexPath.row-2)];
            UIImage *image = [self isRowSelect:info.taskAppId]?[UIImage imageNamed:@"单选down.png"]:[UIImage imageNamed:@"单选-normal.png"];
            
            UIView *compent = [self compentWithImage:image title:info.taskTitle bgFrame:CGRectMake(20, 10, 135, 20) imageFrame: CGRectMake(0, 10, 20, 20) textFrame:CGRectMake(30, 10, 105, 20) target:self action:@selector(tapAction:)];
            compent.tag = [info.taskAppId integerValue]+10;
            [cell.contentView addSubview:compent];
            if(indexPath.row*2-1 < items.count)
            {
                CommonTaskInfo *info_bro = [items objectAtIndex:(indexPath.row*2-1)];
                UIImage *image_bro = [self isRowSelect:info_bro.taskAppId]?[UIImage imageNamed:@"单选down.png"]:[UIImage imageNamed:@"单选-normal.png"];
                
                UIView *compent_bro = [self compentWithImage:image_bro title:info_bro.taskTitle bgFrame:CGRectMake(165, 10, 135, 20) imageFrame: CGRectMake(0, 10, 20, 20) textFrame:CGRectMake(30, 10, 105, 20) target:self action:@selector(tapAction:)];
                compent_bro.tag = [info_bro.taskAppId integerValue]+10;
                [cell.contentView addSubview:compent_bro];
                [compent_bro release];
            }
            [compent release];
        }


    }else if(indexPath.section == 1)
    {
         cell.backgroundColor = [UIColor colorWithRed:223/255.f green:223/255.f blue:228/255.f alpha:1.f];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"补发说明：";
                cell.textLabel.font = [UIFont boldSystemFontOfSize:16.f];
                break;
            case 1:
               
                cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.textColor = [UIColor colorWithRed:168/255.f green:167/255.f blue:172/255.f alpha:1.f];
                cell.textLabel.font = [UIFont systemFontOfSize:15.f];
                cell.textLabel.text = @"旺财官方任务保证100%返回，如您以按照正常流程完成任务但并未收到红包，提交申请后系统会核实，并在3日内完成红包补发。";
                break;
                
            default:
            {
                cell.textLabel.font = [UIFont boldSystemFontOfSize:16.f];
                UIImageView *view = [[UIImageView alloc]initWithImage:hasRedExplanation?[UIImage imageNamed:@"单选down.png"]:[UIImage imageNamed:@"单选-normal.png"]];
                view.tag = 101;
                view.frame = CGRectMake(17, 10, 20, 20);
                [cell.contentView addSubview:view];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(47, 10, 130, 20)];
                label.text = @"我已阅读说明";
                label.font = [UIFont boldSystemFontOfSize:15.f];
                [cell.contentView addSubview:label];
                [label release];
            }
            break;
        }
    }else if (indexPath.section == 2)
    {
        if(!submit)
        {
            submit = [UIButton buttonWithType:UIButtonTypeCustom];
            [submit retain];
        }
        [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:@"提交问题-normal.png"];
        CGRect frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - image.size.width/2)/2, (cell.frame.size.height-image.size.height/2)/2, image.size.width/2, image.size.height/2);
        submit.frame = frame;
        [submit setImage:image forState:UIControlStateNormal];
        cell.backgroundColor = [UIColor colorWithRed:223/255.f green:223/255.f blue:228/255.f alpha:1.5];
        [cell.contentView addSubview:submit];
    }
    
    return cell;
}
- (void)deslectIndex :(NSString*)index
{
    for (NSString *select in selectIndex)
    {
        if([index isEqualToString:select])
        {
            [selectIndex removeObject:select];
            return;
        }
    }
}
- (BOOL)isRowSelect :(NSString*)index
{
    for (NSString *select in selectIndex)
    {
        if([index isEqualToString:select])
            return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(indexPath.section == 1)
    {
        if(indexPath.row == 2)
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if(!hasRedExplanation)
            {
                hasRedExplanation = YES;
                [[cell.contentView viewWithTag:101] removeFromSuperview];
                UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"单选down.png"]];
                view.tag = 102;
                view.frame = CGRectMake(17, 10, 20, 20);
                [cell.contentView addSubview:view];
            }else
            {
                hasRedExplanation = NO;
                [[cell.contentView viewWithTag:102] removeFromSuperview];
                UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"单选-normal.png"]];
                view.tag = 101;
                view.frame = CGRectMake(17, 10, 20, 20);
                [cell.contentView addSubview:view];
            }
        }
    }
}
- (void) showLoading:(NSString*) tip {
    [MBHUDView hudWithBody:tip type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
}
- (void) hideLoading {
    [MBHUDView dismissCurrentHUD];
}
- (void) submit {
    if(!hasRedExplanation)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请阅读说明" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(selectIndex.count <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择任务" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    submit.enabled = NO;
    if ( _bRequest )
    {
        return ;
    }
    
    _bRequest = YES;
    
    [self showLoading:@"请等待..."];
    
    if ( _request != nil )
    {
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
    submit.enabled = YES;
     [self hideLoading];
    if ( _request != nil && [request isEqual:_request] )
    {
        [_request release];
        
        if ( httpCode == 200 )
        {
             [_beeUIStack popViewControllerAnimated:YES];
            
        }
        
    }
    
    _bRequest = NO;
}
- (void)dealloc
{
    if(submit)
    {
        [submit release];
    }
    [_beeUIStack release];
    [selectIndex release];
    [items release];
    [super dealloc];
}
@end