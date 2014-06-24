//
//  ComplainViewController.m
//  wangcai
//
//  Created by NPHD on 14-6-23.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "ComplainViewController.h"
#import "SettingLocalRecords.h"

@interface ComplainViewController ()

@end

@implementation ComplainViewController
@synthesize _contentView;
@synthesize _labelNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _nCount = 3;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGSize size = [[UIScreen mainScreen] bounds].size;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 54, size.width, size.height-54)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:233.0/255 alpha:1];
    [self.view addSubview:_scrollView];
    
    [_scrollView setContentSize:_contentView.frame.size];
    
    [_scrollView addSubview:_contentView];
    
    int nCount = 3;
    int nTag = 11;
    NSArray* list = [[LoginAndRegister sharedInstance] getOfferwallList];
    for ( int i = 0; i < [list count]; i ++ ) {
        NSString* name = [list objectAtIndex:i];
        if ( [[LoginAndRegister sharedInstance] isShowOfferwall:name] ) {
            NSString* text = [self getTextFromName:name];
            UIButton* btn = (UIButton*)[_contentView viewWithTag:nTag];
            
            [btn setTitle:text forState:UIControlStateNormal];
            [btn setHidden:NO];
            
            if ( [SettingLocalRecords isOfferwallSelected:name] ) {
                // 今天已经被投诉过了
                [btn setBackgroundImage:[UIImage imageNamed:@"complain_btn_down.png"] forState:UIControlStateDisabled];
                [btn setEnabled:NO];
                nCount --;
            }
            nTag ++;
        }
    }
    
    for ( int i = nTag; i <= 18; i ++ ) {
        UIButton* btn = (UIButton*)[_contentView viewWithTag:i];
        [btn setHidden:YES];
    }
    
    if ( nCount <= 0 ) {
        nCount = 0;
        for ( int i = 11; i <= 18; i ++ ) {
            UIButton* btn = (UIButton*)[_contentView viewWithTag:i];
            [btn setEnabled:NO];
        }
    }

    _nCount = nCount;
    
    [_labelNum setText:[NSString stringWithFormat:@"%d", nCount]];
}

- (NSString*) getTextFromName:(NSString*) name {
    NSString* value = @"";
    
    if ( [name isEqualToString:@"domob"] ) {
        value = @"多盟";
    } else if ( [name isEqualToString:@"jupeng"] ) {
        value = @"巨朋";
    } else if ( [name isEqualToString:@"miidi"] ) {
        value = @"米迪";
    } else if ( [name isEqualToString:@"youmi"] ) {
        value = @"有米";
    } else if ( [name isEqualToString:@"limei"] ) {
        value = @"力美";
    } else if ( [name isEqualToString:@"mopan"] ) {
        value = @"磨盘";
    } else if ( [name isEqualToString:@"punchbox"] ) {
        value = @"触控";
    } else if ( [name isEqualToString:@"dianru"] ) {
        value = @"点入";
    } else if ( [name isEqualToString:@"waps"] ) {
        value = @"万普";
    } else if ( [name isEqualToString:@"adwo"] ) {
        value = @"安沃";
    }
    
    return [[value copy] autorelease];
}

- (NSString*) getNameFromText:(NSString*) text {
    NSString* value = @"";
    
    if ( [text isEqualToString:@"多盟"] ) {
        value = @"domob";
    } else if ( [text isEqualToString:@"巨朋"] ) {
        value = @"jupeng";
    } else if ( [text isEqualToString:@"米迪"] ) {
        value = @"miidi";
    } else if ( [text isEqualToString:@"有米"] ) {
        value = @"youmi";
    } else if ( [text isEqualToString:@"力美"] ) {
        value = @"limei";
    } else if ( [text isEqualToString:@"磨盘"] ) {
        value = @"mopan";
    } else if ( [text isEqualToString:@"触控"] ) {
        value = @"punchbox";
    } else if ( [text isEqualToString:@"点入"] ) {
        value = @"dianru";
    } else if ( [text isEqualToString:@"万普"] ) {
        value = @"waps";
    } else if ( [text isEqualToString:@"安沃"] ) {
        value = @"adwo";
    }
    
    return [[value copy] autorelease];
}

- (IBAction) clickComplain:(id)sender {
    if ( _nCount == 0 ) {
        return ;
    }
    UIButton* btn = (UIButton*) sender;
    NSString* name = [self getNameFromText:btn.titleLabel.text];
    
    [SettingLocalRecords selectOfferwall:name];
    [btn setBackgroundImage:[UIImage imageNamed:@"complain_btn_down.png"] forState:UIControlStateDisabled];
    [btn setEnabled:NO];
    
    _nCount --;
    if ( _nCount < 0 ) {
        _nCount = 0;
    }
    [_labelNum setText:[NSString stringWithFormat:@"%d", _nCount]];
    
    if ( _nCount == 0 ) {
        for ( int i = 11; i <= 18; i ++ ) {
            UIButton* btn = (UIButton*)[_contentView viewWithTag:i];
            [btn setEnabled:NO];
        }
    }
}

- (void)dealloc {
    [_scrollView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end