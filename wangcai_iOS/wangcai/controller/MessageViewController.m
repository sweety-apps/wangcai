//
//  MessageViewController.m
//  wangcai
//
//  Created by zhangc on 14-5-9.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "OnlineWallViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController
@synthesize tbView;

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
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    rect.origin.y = 54;
    rect.size.height -= 54;
    
    //[_tableView setHeight:rect.size.height];
    
    [[MessageMgr sharedInstance] attachEvent:self];
    
    [tbView setFrame:rect];
    
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _msgList = [[MessageMgr sharedInstance] getMsgList];
    
    [[OnlineWallViewController sharedInstance] pushViewController:self];
}

- (void)dealloc {
    [[MessageMgr sharedInstance] detachEvent:self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUIStack:(BeeUIStack*) stack {
    self->_beeUIStack = stack;
}

- (IBAction)clickBack:(id)sender {
    [[OnlineWallViewController sharedInstance] popViewController];
    
    int nCurMaxID = [[MessageMgr sharedInstance] getCurMaxID];
    [[MessageMgr sharedInstance] saveClickId:nCurMaxID];
    
    [self->_beeUIStack popViewControllerAnimated:YES];
}

- (void) messageUpdated {
    if ( _msgList != nil ) {
        [_msgList release];
    }
    _msgList = [[MessageMgr sharedInstance] getMsgList];
    
    [tbView reloadData];
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    MessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    
    if ( cell == nil ) {
        cell = [[[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"] autorelease];
    }
    
    NSDictionary* info = (NSDictionary*)[_msgList objectAtIndex:row];
    [cell setInfo:info];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSDictionary* info = (NSDictionary*)[_msgList objectAtIndex:row];
    
    return [MessageCell getHeight:info];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( _msgList == nil ) {
        return 0;
    }
    return [_msgList count];
}

@end
