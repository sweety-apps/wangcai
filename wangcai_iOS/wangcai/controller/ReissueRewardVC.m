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
#define kBGColor [UIColor colorWithRed:223/255.f green:223/255.f blue:228/255.f alpha:1.f]
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 2)
        return 0;
    return 0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        UIView *header = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 20)] autorelease];
        header.backgroundColor = kBGColor;
        return header;
    }
//    if(section == 2)
//    {
//        UIView *header = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 40)] autorelease];
//        header.backgroundColor = kBGColor;
//        return header;
//    }
    return nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:229/255.f green:229/255.f blue:233/255.f alpha:1.f];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 54)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 100, 54)];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = UITextAlignmentCenter;
    
    title.text = @"补发红包";
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:20.f];
    [header addSubview:title];
    [title release];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [back addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"back.png"];
    //[back setBackgroundImage:image forState:UIControlStateNormal];
    [back setImage:image forState:UIControlStateNormal];
    //CGRect frame = CGRectMake(20, (54-image.size.height)/2.f, image.size.width, image.size.height);
    CGRect frame = CGRectMake(0, 12, 46, 30);
    back.frame = frame;
    [header addSubview:back];
    header.backgroundColor = [UIColor colorWithRed:12/255.f green:90/255.f blue:189/255.f alpha:1.f];
    [self.view addSubview:header];
    [header release];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, header.frame.size.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-header.frame.size.height) style:UITableViewStylePlain];
    table.backgroundColor = [UIColor colorWithRed:229/255.f green:229/255.f blue:233/255.f alpha:1.f];
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
    if(indexPath.section == 1 && indexPath.row == 1)
        return 60;
    
    if(indexPath.section == 1 && indexPath.row == 0)
        return 20;
    
    if(indexPath.section == 0) {
        int nLines = items.count/2+1;
        if( items.count%2 != 0) {
            nLines = items.count/2 + 2;
        }
        
        if ( indexPath.row == 0 ) {
            return 49;
        } else if ( indexPath.row == (nLines-1) ) {
            return 39;
        }
        return 30;
    }
    
    if(indexPath.section == 2)
        return 60;
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
    
    if(section == 1)
        return 3;
    if(section == 2)
        return 2;
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
    text.backgroundColor = [UIColor clearColor];
    text.text = title;
    text.textColor = [UIColor colorWithRed:114/255.f green:114/255.f blue:114/255.f alpha:1.f];
    text.font = [UIFont systemFontOfSize:14.f];
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
        taskAppId = [NSString stringWithFormat:@"%d",[info.taskId integerValue]];
    }else{
        CommonTaskInfo *info = [items objectAtIndex:path.row*2-2];
        taskAppId = [NSString stringWithFormat:@"%d",[info.taskId integerValue]];
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
                imageVew.image = [UIImage imageNamed:@"singleselectnormal.png"];
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
                imageVew.image = [UIImage imageNamed:@"singleselectdown.png"];
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
            cell.contentView.backgroundColor = [UIColor colorWithRed:229/255.f green:229/255.f blue:233/255.f alpha:1.f];
            
            UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"center.png"]] autorelease];
            [imageView setFrame:CGRectMake(0, 10, 320, 39)];
            [cell.contentView addSubview:imageView];
            
            imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top.png"]] autorelease];
            [imageView setFrame:CGRectMake(0, 10, 320, 9)];
            [cell.contentView addSubview:imageView];
            
            UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(20, 22, 250, 22)] autorelease];
            label.font = [UIFont boldSystemFontOfSize:16.f];
            label.text = @"请选择未发放红包的任务";

            label.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:label];
        }else {
            UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"center.png"]] autorelease];
            [imageView setFrame:CGRectMake(0, 0, 320, 30)];
            [cell.contentView addSubview:imageView];
            
            int nLines = items.count/2+1;
            if( items.count%2 != 0) {
                nLines = items.count/2 + 2;
            }
            
            if ( nLines - 1 == indexPath.row ) {
                imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom.png"]] autorelease];
                [imageView setFrame:CGRectMake(0, 30, 320, 9)];
                [cell.contentView addSubview:imageView];
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            tap.cancelsTouchesInView = NO;
            [cell addGestureRecognizer:tap];
            [tap release];
            
            CommonTaskInfo *info = [items objectAtIndex:(2*indexPath.row-2)];
            UIImage *image = [self isRowSelect:[NSString stringWithFormat:@"%d",[info.taskId integerValue]]]?[UIImage imageNamed:@"singleselectdown.png"]:[UIImage imageNamed:@"singleselectnormal.png"];
            
            UIView *compent = [self compentWithImage:image title:info.taskTitle bgFrame:CGRectMake(20, 5, 135, 20) imageFrame: CGRectMake(0, 0, 20, 20) textFrame:CGRectMake(30, 0, 105, 20) target:self action:@selector(tapAction:)];
            compent.tag = [info.taskId integerValue]+10;
            [cell.contentView addSubview:compent];
            if(indexPath.row*2-1 < items.count)
            {
                CommonTaskInfo *info_bro = [items objectAtIndex:(indexPath.row*2-1)];
                UIImage *image_bro = [self isRowSelect:[NSString stringWithFormat:@"%d",[info_bro.taskId integerValue]]]?[UIImage imageNamed:@"singleselectdown.png"]:[UIImage imageNamed:@"singleselectnormal.png"];
                
                UIView *compent_bro = [self compentWithImage:image_bro title:info_bro.taskTitle bgFrame:CGRectMake(165, 5, 135, 20) imageFrame: CGRectMake(0, 0, 20, 20) textFrame:CGRectMake(30, 0, 105, 20) target:self action:@selector(tapAction:)];
                compent_bro.tag = [info_bro.taskId integerValue]+10;
                [cell.contentView addSubview:compent_bro];
                [compent_bro release];
            }
            [compent release];
        }


    }else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            //UILabel *shuoming = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 320, cell.frame.size.height)];
            float version = [[[UIDevice currentDevice] systemVersion] floatValue];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, version<7.0?12:5, 100, 15)];
            label.backgroundColor = [UIColor clearColor];
            label.text = @"补发说明：";
            label.font = [UIFont boldSystemFontOfSize:12.f];
            [cell.contentView addSubview:label];
            [label release];
            //[cell.contentView addSubview:shuoming];
        }else if(indexPath.row == 1)
        {
            //UILabel *remind = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 320, cell.frame.size.height)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, -20, 300, 40)];
            label.numberOfLines = 3;
            label.text = @"旺财官方任务保证100%返回，如您以按照正常流程完成任务但并未收到红包，提交申请后系统会核实，并在3日内完成红包补发。";
            CGSize size = CGSizeMake(170, 120);
            CGSize labelSize = [label.text sizeWithFont:label.font
                                      constrainedToSize:size
                                          lineBreakMode:UILineBreakModeClip];
            label.font = [UIFont systemFontOfSize:12.f];
            label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y,
                                     label.frame.size.width, labelSize.height);
            label.textColor = [UIColor colorWithRed:176/255.f green:176/255.f blue:176.f/255.f alpha:1.f];
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            //[cell.contentView addSubview:remind];
            //[remind release];
            
        }else
        {
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16.f];
            UIImageView *view = [[UIImageView alloc]initWithImage:hasRedExplanation?[UIImage imageNamed:@"singleselectdown.png"]:[UIImage imageNamed:@"singleselectnormal"]];
            view.tag = 101;
            view.frame = CGRectMake(20, 10, 20, 20);
            [cell.contentView addSubview:view];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(47, 10, 130, 20)];
            label.text = @"我已阅读说明";
            label.font = [UIFont boldSystemFontOfSize:16.f];
            [cell.contentView addSubview:label];
            label.backgroundColor = [UIColor clearColor];
            [label release];
        }
    
        cell.backgroundColor = [UIColor clearColor];
    }else if (indexPath.section == 2)
    {
        if(indexPath.row == 1)
        {
            if(!submit)
            {
                submit = [UIButton buttonWithType:UIButtonTypeCustom];
                [submit retain];
            }
            [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
            UIImage *image = [UIImage imageNamed:@"submitnormal.png"];
            CGRect frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - image.size.width/2)/2, (60-image.size.height/2)/2, image.size.width/2, image.size.height/2);
            submit.frame = frame;
            [submit setImage:image forState:UIControlStateNormal];
            [cell.contentView addSubview:submit];
            
            cell.backgroundColor = [UIColor clearColor];
        }else
        {
            cell.backgroundColor = [UIColor clearColor];
        }
        
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
                UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"singleselectdown.png"]];
                view.tag = 102;
                view.frame = CGRectMake(17, 10, 20, 20);
                [cell.contentView addSubview:view];
            }else
            {
                hasRedExplanation = NO;
                [[cell.contentView viewWithTag:102] removeFromSuperview];
                UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"singleselectnormal.png"]];
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
- (NSString*)getTaskId
{
    NSString *dest = @"";
    for (NSString *taskid in selectIndex)
    {
        if(taskid.length > 0)
        {
            if(dest.length <= 0){
                dest = taskid;
            }else
            {
                dest = [dest stringByAppendingString:@","];
                dest = [dest stringByAppendingString:taskid];
            }
        }
    }
    return dest;
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
    //223 223 228 215
    _request = [[HttpRequest alloc] init:self];
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];

    NSString *taskIds = [self getTaskId];
    [dictionary setObject:taskIds forKey:@"task_ids"];
    
    
    [_request request:HTTP_REISSUE_REWARD Param:dictionary method:@"POST"];
}
-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    submit.enabled = YES;
     [self hideLoading];
    if ( _request != nil && [request isEqual:_request] )
    {
        [_request release];
        _request = nil;
        
        if ( httpCode == 200 )
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提交成功!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发生错误，请重试!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
    }
    
    _bRequest = NO;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     [_beeUIStack popViewControllerAnimated:YES];
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
