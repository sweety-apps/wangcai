//
//  MessageCell.m
//  wangcai
//
//  Created by zhangc on 14-5-12.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "MessageCell.h"
#import "MessageMgr.h"
#import "OnlineWallViewController.h"
#import "CommonTaskList.h"
#import "Common.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _imageView = [[BeeUIImageView alloc] initWithFrame:CGRectMake(16, 20, 35, 34)];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _info = nil;
        _alertLevel = nil;
        _alertInstallApp = nil;
        _installUrl = nil;
        
        [self.contentView addSubview:_imageView];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(62, 20, 230, 20)];
        [_title setTextAlignment:NSTextAlignmentLeft];
        [_title setFont:[UIFont systemFontOfSize:16]];
        [self.contentView addSubview:_title];
        
        _date = [[UILabel alloc] initWithFrame:CGRectMake(72, 20, 230, 20)];
        [_date setTextAlignment:NSTextAlignmentRight];
        [_date setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:_date];
        [_date setBackgroundColor:[UIColor clearColor]];
        [_date setTextColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
        
        _desc = [[UILabel alloc] initWithFrame:CGRectMake(62, 46, 240, 32)];
        [_desc setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:_desc];
        
        _desc.lineBreakMode = UILineBreakModeWordWrap;
        _desc.numberOfLines = 0;
        
        [_desc setTextColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
        
        _newImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
        [_newImage setImage:[UIImage imageNamed:@"left_new"]];
        [self.contentView addSubview:_newImage];
        
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        [_line setImage:[UIImage imageNamed:@"msg_line"]];
        [self.contentView addSubview:_line];
        
        _btnOpen = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 104, 34)];
        [self.contentView addSubview:_btnOpen];
        
        [_btnOpen addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)dealloc {
    [_info release];
    [_imageView release];
    [_title release];
    [_desc release];
    [_newImage release];
    [_btnOpen release];
    [_date release];
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (int) getHeight:(NSDictionary*) info {
    int type = [[info objectForKey:@"type"] intValue];
    
    int nHeight = 64;   // 标题加上上下边距
    // 描述文字的高度
    NSString* desc = [info objectForKey:@"intro"];
    
    CGSize size = CGSizeMake(230, MAXFLOAT);
    
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize descSize = [desc sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    nHeight = nHeight + descSize.height + 10;
    
    if ( type != 0 ) {
        // 添加一个按钮
        nHeight += 40;
    }
    
    if ( nHeight < 94 ) {
        nHeight = 94;
    }
    return nHeight;
}

- (void) setInfo:(NSDictionary*) info {
    if ( _info != nil ) {
        [_info release];
    }
    
    _info = [info copy];
    
    NSString* iconUrl = [info objectForKey:@"icon"];
    int mid = [[info objectForKey:@"id"] intValue];
    
    if ( mid > [[MessageMgr sharedInstance] getClickMaxID] ) {
        [_newImage setHidden:NO];
    } else {
        [_newImage setHidden:YES];
    }
    
    UIImage* cachedImage = [[BeeImageCache sharedInstance] imageForURL:iconUrl];
    if (cachedImage != nil)
    {
        [_imageView setImage:cachedImage];
    }
    else
    {
        [_imageView GET:iconUrl useCache:YES];
    }
    
    NSString* title = [info objectForKey:@"title"];
    [_title setText:title];
    
    NSString* desc = [info objectForKey:@"intro"];
    [_desc setText:desc];
    
    CGSize size = CGSizeMake(230, MAXFLOAT);
    CGSize descSize = [desc sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:size];
    if ( descSize.height < 32 ) {
        descSize.height = 32;
    }
    [_desc setFrame:CGRectMake(62, 46, 240, descSize.height)];
    
    NSString* time = [info objectForKey:@"time"];
    NSRange range = [time rangeOfString:@" "];
    time = [time substringToIndex:range.location];
    
    [_date setText:time];
    
    int nHeight = [MessageCell getHeight:info];
    CGRect rect = _line.frame;
    rect.origin.y = nHeight - 1;
    [_line setFrame:rect];
    
    int type = [[info objectForKey:@"type"] intValue];
    if ( type == 0 ) {
        [_btnOpen setHidden:YES];
    } else {
        [_btnOpen setHidden:NO];
        
        rect = _btnOpen.frame;
        rect.origin.y = nHeight - 52;
        
        [_btnOpen setFrame:rect];
        
        if ( type == 1 ) {
            [_btnOpen setImage:[UIImage imageNamed:@"btn_open_onlinewall"] forState:UIControlStateNormal];
        } else {
            [_btnOpen setImage:[UIImage imageNamed:@"open_app"] forState:UIControlStateNormal];
        }
    }
}

- (void) onClick:(id) sender {
    int type = [[_info objectForKey:@"type"] intValue];
    NSString* extra = [_info objectForKey:@"extra"];
    if ( type == 1 ) {
        // 打开积分强
        [[OnlineWallViewController sharedInstance] open:extra];
    } else {
        // 自有任务
        NSArray* taskList = [[CommonTaskList sharedInstance] taskList];
        for ( int i = 0; i < [taskList count]; i ++ ) {
            CommonTaskInfo* task = (CommonTaskInfo*)[taskList objectAtIndex:i];
            if ( [task.taskId intValue] == [extra intValue] ) {
                if ( [task.taskStatus intValue] == 0 ) {
                    // 这个任务可以做
                    [self clickTask:task];
                    return ;
                }
            }
        }
    }
}

- (void) clickTask:(CommonTaskInfo*) task {
    int nLevel = [[LoginAndRegister sharedInstance] getUserLevel];
    int nNeedLevel = [task.taskLevel intValue];
    
    if ( nLevel < nNeedLevel ) {
        // 等级不够
        if ( _alertLevel != nil ) {
            [_alertLevel release];
        }
        
        _alertLevel = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"该任务需要等级达到%d级才能进行", nNeedLevel] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [_alertLevel show];
        
        return ;
    }
    
    [self onClickInstallApp:task];
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

- (void)onClickCancelInstall:(id)sender {
    if ( _alertInstallApp != nil ) {
        [_alertInstallApp hideAlertView];
    }
}

- (void)onClickInstall:(id)sender {
    if ( _alertInstallApp != nil ) {
        [_alertInstallApp hideAlertView];
    }
    
    // 安装app
    NSURL* url = [NSURL URLWithString:_installUrl];
    [[UIApplication sharedApplication] openURL:url];
}

@end
