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

- (void) setUIStack :(BeeUIStack*) stack {
    _beeStack = stack;
}

- (id)init
{
    self = [super initWithNibName:@"ExchangeController" bundle:nil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeController" owner:self options:nil] firstObject];
        self->_alertView = nil;
        self->_alertBindPhone = nil;
        self->_alertNoBalance = nil;
        
        _labelBalance = (UILabel*) [self.view viewWithTag:55];
        _tableView = (UITableView*)[self.view viewWithTag:89];
        _tableView.separatorStyle = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        CGRect rect = [[UIScreen mainScreen]bounds];
        rect.origin.y = 101;
        rect.size.height -= 101;
        
        //[_tableView setHeight:rect.size.height];
        
        [_tableView setFrame:rect];

        
        NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
        if ( phoneNum == nil || [phoneNum isEqualToString:@""] ) {
            _noattachView = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeController" owner:self options:nil] objectAtIndex:3];
            rect = _noattachView.frame;
            rect.origin.y = 54;
            _noattachView.frame = rect;
            
            [self.view addSubview:_noattachView];
        } else {
            _noattachView = nil;
        }
        
        if ( phoneNum != nil ) {
            [phoneNum release];
        }
        
        float fBalance = (1.0*[[LoginAndRegister sharedInstance] getBalance]) / 100;
        NSString* balance = [[NSString alloc] initWithFormat:@"%.1f", fBalance];
        [_labelBalance setText:balance];
        [balance release];
        
        [[LoginAndRegister sharedInstance] attachBindPhoneEvent:self];
        [[LoginAndRegister sharedInstance] attachBalanceChangeEvent:self];
        
        CGRect rt = CGRectMake(0.0f,
                                 0.0f-_tableView.bounds.size.height,
                                 _tableView.frame.size.width,
                                 _tableView.frame.size.height);
        EGORefreshTableHeaderView* view1 = [[EGORefreshTableHeaderView alloc]
                                            initWithFrame:rt];
        view1.delegate = self;
        [_tableView addSubview:view1];
        _refreshHeaderView = view1;
        [view1 release];
        
        [_refreshHeaderView refreshLastUpdatedDate];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) balanceChanged:(int) oldBalance New:(int) balance {
    float fBalance = (1.0*balance) / 100;
    NSString* bal = [[NSString alloc] initWithFormat:@"%.1f", fBalance];
    [_labelBalance setText:bal];
    [bal release];
}

- (void) dealloc {
    [[LoginAndRegister sharedInstance] detachBalanceChangeEvent:self];
    [[LoginAndRegister sharedInstance] detachBindPhoneEvent:self];
    
    _refreshHeaderView = nil;
    
    if ( _noattachView != nil ) {
        [_noattachView release];
    }
    
    if ( _alertView != nil ) {
        [_alertView release];
        _alertView = nil;
    }
    
    if ( _alertBindPhone != nil ) {
        [_alertBindPhone release];
    }
    
    if ( _alertNoBalance != nil ) {
        [_alertNoBalance release];
    }
    
    [super dealloc];
}

-(void) bindPhoneCompeted {
    NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
    float fBalance = (1.0*[[LoginAndRegister sharedInstance] getBalance]) / 100;
    
    NSString* balance = [[NSString alloc] initWithFormat:@"%.1f", fBalance];
    [_labelBalance setText:balance];
    [balance release];
    
    if ( _noattachView != nil ) {
        [_noattachView setHidden:YES];
    }
    
    [phoneNum release];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBack:(id)sender {
	[[BeeUIRouter sharedInstance] open:@"wc_main" animated:YES];
    //[self postNotification:@"showMenu"];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if ( row == 0 ) {
        UITableViewCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeController" owner:self options:nil] objectAtIndex:1];
        
        return cell;
    } else {
        ExchangeControllerCell* cell = [tableView dequeueReusableCellWithIdentifier:@"exchangeCell"];
        if (cell == nil)
        {
            cell = [[[ExchangeControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"exchangeCell"] autorelease];
            cell.delegate = self;
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
    return 10;
}

- (IBAction)clickExchangeInfo:(id)sender {
    WebPageController* controller = [[WebPageController alloc] init:@"交易详情" Url:WEB_EXCHANGE_INFO Stack:_beeStack];
    [_beeStack pushViewController:controller animated:YES];
}

- (IBAction)clickAttachPhone:(id)sender {
    PhoneValidationController* phoneVal = [PhoneValidationController shareInstance];
    
    [self->_beeStack pushViewController:phoneVal animated:YES];
}


-(void) checkExchange:(NSString*) text1 Text:(NSString*) text2 Tip:(NSString*) tip Button:(NSString*) btnText {
    if ( _alertView != nil ) {
        [_alertView release];
    }
    
    UIView* view = [[[NSBundle mainBundle] loadNibNamed:@"TransferToAlipayAndPhoneController" owner:self options:nil] lastObject];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10.0;
    view.layer.borderWidth = 0.0;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UIColor *color = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1];
    
    UIButton* btn = (UIButton*)[view viewWithTag:11];
    [btn.layer setBorderWidth:0.5];
    [btn.layer setBorderColor:[color CGColor]];
    
    btn = (UIButton*)[view viewWithTag:12];
    [btn.layer setBorderWidth:0.5];
    [btn.layer setBorderColor:[color CGColor]];
    
    
    [btn setTitle:btnText forState:UIControlStateNormal];
    
    ((UILabel*)[view viewWithTag:21]).text = text1;
    ((UILabel*)[view viewWithTag:22]).text = text2;
    ((UILabel*)[view viewWithTag:23]).text = tip;
    
    _alertView = [[UICustomAlertView alloc]init:view];
    
    [view release];
    [_alertView show];
}

- (IBAction)clickCancel:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
}

- (IBAction)clickContinue:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
}



-(BOOL) checkBalanceAndBindPhone :(float) fCoin {
    NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
    if ( phoneNum == nil || [phoneNum isEqualToString:@""] ) {
        // 没有绑定手机号
        if ( _alertBindPhone != nil ) {
            [_alertBindPhone release];
        }
        
        _alertBindPhone = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定手机，请先绑定手机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定手机", nil];
        
        [_alertBindPhone show];
        
        if ( phoneNum != nil ) {
            [phoneNum release];
        }
        return NO;
    }
    
    [phoneNum release];
    
    float balance = (1.0*[[LoginAndRegister sharedInstance] getBalance]) / 100;
    if ( fCoin > balance ) {
        if ( _alertNoBalance != nil ) {
            [_alertNoBalance release];
        }
        
        _alertNoBalance = [[UIAlertView alloc] initWithTitle:@"提示" message:@"现金不足，无法完成该操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [_alertNoBalance show];
        
        return NO;
    }
    
    return YES;
}

-(void) onClickExchange : (id) sender {
    int nDiscount = 100;
    
    if ( [self checkBalanceAndBindPhone:(1.0*nDiscount/100)] ) {
        [self checkExchange:@"产品：小米3激活码" Text:@"价格：150元" Tip:@"兑换需要3个工作日，请耐心等待" Button:@"继续兑换"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( _alertBindPhone != nil ) {
        if ( [_alertBindPhone isEqual:alertView] ) {
            if ( buttonIndex == 1 ) {
                [self onAttachPhone];
            }
        }
    }
}

-(void) onAttachPhone {
    PhoneValidationController* phoneVal = [PhoneValidationController shareInstance];
    [self->_beeStack pushViewController:phoneVal animated:YES];
}

@end
