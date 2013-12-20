//
//  ExchangeController.m
//  wangcai
//
//  Created by 1528 on 13-12-18.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "ExchangeController.h"
#import "ExchangeControllerCell.h"
#import "WebPageController.h"
#import "Config.h"
#import "PhoneValidationController.h"

@interface ExchangeController ()

@end

@implementation ExchangeController
@synthesize _cell;
@synthesize _tableView;
@synthesize _cellEnd;

- (void) setUIStack :(BeeUIStack*) stack {
    _beeStack = stack;
}

- (id)init
{
    self = [super initWithNibName:@"ExchangeController" bundle:nil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeController" owner:self options:nil] firstObject];
        
        _tableView.separatorStyle = NO;

        CGRect rect = [[UIScreen mainScreen]bounds];
        rect.origin.y = 102;
        rect.size.height -= 102;
        _tableView.frame = rect;
        
        _noattachView = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeController" owner:self options:nil] lastObject];
        rect = _noattachView.frame;
        rect.origin.y = 54;
        _noattachView.frame = rect;
        
        [self.view addSubview:_noattachView];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBack:(id)sender {
    [self postNotification:@"showMenu"];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if ( row == 0 ) {
        return _cell;
    } else if ( row == 10 ) {
        return _cellEnd;
    } else {
        ExchangeControllerCell* cell = [tableView dequeueReusableCellWithIdentifier:@"exchangeCell"];
        if (cell == nil)
        {
            cell = [[[ExchangeControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"exchangeCell"] autorelease];
        }
        
        if ( cell ) {
            if ( row % 2 == 1 ) {
                [cell setBkgColor:[UIColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1]];
            } else {
                [cell setBkgColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
            }
        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if ( row == 0 ) {
        return 40;
    }
    
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (IBAction)clickExchangeInfo:(id)sender {
    WebPageController* controller = [[WebPageController alloc] init:@"交易详情" Url:WEB_EXCHANGE_INFO Stack:_beeStack];
    [_beeStack pushViewController:controller animated:YES];
}

- (IBAction)clickAttachPhone:(id)sender {
    PhoneValidationController* phoneVal = [[PhoneValidationController alloc]initWithNibName:@"PhoneValidationController" bundle:nil];
    
    [self->_beeStack pushViewController:phoneVal animated:YES];
}

@end
