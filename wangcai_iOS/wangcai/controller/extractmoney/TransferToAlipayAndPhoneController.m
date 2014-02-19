//
//  PhoneValidationController.m
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "TransferToAlipayAndPhoneController.h"
#import "MBHUDView.h"
#import "Common.h"
#import "UICustomAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "Config.h"
#import "WebPageController.h"
#import "MobClick.h"
#import "PhoneValidationController.h"

@interface TransferToAlipayAndPhoneController ()
@end

@implementation TransferToAlipayAndPhoneController

- (id) init:(BOOL) isAlipay BeeUIStack:(BeeUIStack*) stack
{
    self = [super initWithNibName:@"TransferToAlipayAndPhoneController" bundle:nil];
    if (self) {
        // Custom initialization
        self->_bAlipay = isAlipay;
        //self->_nDiscount = nDiscount;
        //self->_nAmount = nAmount;
        self->_alertBindPhone = nil;
        self->_alertView = nil;
        self->_orderId = nil;
        self->_beeStack = stack;
        
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"TransferToAlipayAndPhoneController" owner:self options:nil] firstObject];

        UILabel* label = (UILabel*)[self.view viewWithTag:1];
        if ( isAlipay ) {
            label.text = @"现金提取";
            self._containerView = [[[NSBundle mainBundle] loadNibNamed:@"TransferToAlipayAndPhoneController" owner:self options:nil] objectAtIndex:2];
        } else {
            label.text = @"话费充值";
            self._containerView = [[[NSBundle mainBundle] loadNibNamed:@"TransferToAlipayAndPhoneController" owner:self options:nil] objectAtIndex:1];
        }
        
        self._completeView = [[[NSBundle mainBundle] loadNibNamed:@"TransferToAlipayAndPhoneController" owner:self options:nil] objectAtIndex:3];
        
        CGRect rect = CGRectMake( 0.0f, 54.0f, self._containerView.frame.size.width, self._containerView.frame.size.height);
        self._containerView.frame = rect;
        self._completeView.frame = rect;
        
        [self.view addSubview:self._containerView];
        [self.view addSubview:self._completeView];
        
        [self._completeView setHidden:YES];
        [self._containerView setHidden:NO];
        
        self._textField = (UITextField*)[self._containerView viewWithTag:71];
        self._textCheck = (UITextField*)[self._containerView viewWithTag:72];
        
        self._textFieldTip = (UILabel*)[self._containerView viewWithTag:51];
        self._textCheckTip = (UILabel*)[self._containerView viewWithTag:52];
        
        if ( isAlipay ) {
            self._textName = (UITextField*)[self._containerView viewWithTag:73];
            self._textNameTip = (UILabel*)[self._containerView viewWithTag:53];
        }
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)hideKeyboard:(id)sender
{
    [self hideKeyboard];
}

- (void) hideKeyboard {
    if ( [self._textField isFirstResponder] ) {
        [self._textField resignFirstResponder];
    }
    
    if ( [self._textCheck isFirstResponder] ) {
        [self._textCheck resignFirstResponder];
    }
    
    if ( [self._textName isFirstResponder] ) {
        [self._textName resignFirstResponder];
    }
}

- (IBAction)clickBack:(id)sender {
    // 收起键盘
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dealloc {
    if ( _alertView != nil ) {
        [_alertView release];
        _alertView = nil;
    }
    
    if ( _orderId != nil ) {
        [_orderId release];
        _orderId = nil;
    }
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {    // Called when the view is about to made visible. Default does nothing
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) showLoading {
    [MBHUDView hudWithBody:@"请等待..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
}

- (void) hideLoading {
    [MBHUDView dismissCurrentHUD];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {  // return NO to not change text
    if ([@"\n" isEqualToString:string] ) {
        [textField resignFirstResponder];
        return NO;
    }
    
    if ( self->_bAlipay ) {
        // 手机充值
        NSString* str = [string trim];
        if ( [str length] == 0 && [string length] != 0 ) {
            return NO;
        }
        
        return YES;
    } else {
        // 话费充值
        if ( [string isEqualToString:@""] ) {
            return YES;
        }
        
        // 不能输入空格
        NSString* str = [string trim];
        if ( [str length] == 0 ) {
            return NO;
        }
        
        if ( textField.text.length + string.length <= 11 ) {
            return YES;
        }
        
        return NO;
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ( [textField isEqual:self._textField] ) {
        [self._textFieldTip setHidden:YES];
        [[self._containerView viewWithTag:81] setHidden:NO];
    } else {
        [[self._containerView viewWithTag:81] setHidden:YES];
    }
  
    if ( [textField isEqual:self._textCheck] ) {
        [self._textCheckTip setHidden:YES];
        [[self._containerView viewWithTag:82] setHidden:NO];
    } else {
        [[self._containerView viewWithTag:82] setHidden:YES];
    }
    
    if ( _bAlipay && [textField isEqual:self._textName] ) {
        [self._textNameTip setHidden:YES];
        [[self._containerView viewWithTag:83] setHidden:NO];
    } else {
        [[self._containerView viewWithTag:83] setHidden:YES];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString* text = textField.text;
    NSUInteger n = text.length;
    if ( n == 0 ) {
        if ( [textField isEqual:self._textField] ) {
            [self._textFieldTip setHidden:NO];
        }
        
        if ( [textField isEqual:self._textCheck] ) {
            [self._textCheckTip setHidden:NO];
        }

        if ( _bAlipay && [textField isEqual:self._textName] ) {
            [self._textNameTip setHidden:NO];
        }
    } else {
        if ( [textField isEqual:self._textField] ) {
            [self._textFieldTip setHidden:YES];
        }
        
        if ( [textField isEqual:self._textCheck] ) {
            [self._textCheckTip setHidden:YES];
        }
        
        if ( _bAlipay && [textField isEqual:self._textName] ) {
            [self._textNameTip setHidden:YES];
        }
    }
    
    [[self._containerView viewWithTag:81] setHidden:YES];
    [[self._containerView viewWithTag:82] setHidden:YES];
    [[self._containerView viewWithTag:83] setHidden:YES];
}

- (BOOL) checkPhoneNum : phoneNum {
    if ( [phoneNum length] != 11 ) {
        // 长度不对
        return NO;
    }
    
    for (NSUInteger i = 0; i < [phoneNum length]; i ++ ) {
        unichar uc = [phoneNum characterAtIndex:i];
        if ( !isnumber(uc) ) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL) checkAlipay : alipay {
    for (NSUInteger i = 0; i < [alipay length]; i ++ ) {
        unichar uc = [alipay characterAtIndex:i];
        if ( uc == ' ' ) {
            return NO;
        }
    }
    
    return YES;
}

- (IBAction)clickClear1:(id)sender {
    [self._textField setText:@""];
}

- (IBAction)clickClear2:(id)sender {
    [self._textCheck setText:@""];
}

- (IBAction)clickClear3:(id)sender {
    [self._textName setText:@""];
}

- (void)clickNext {
    NSString* text1 = self._textField.text;
    NSString* text2 = self._textCheck.text;
    NSString* text3 = self._textName.text;
    
    if ( _bAlipay && [text3 length] == 0 ) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"支付宝名不能为空" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return ;
    }
    
    if ( ![text1 isEqualToString:text2] ) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"两次输入的信息不一致" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return ;
    }
    
    if ( [text1 length] == 0 || [text2 length] == 0 ) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"输入的信息不能为空" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return ;
    }
    
    if ( self->_bAlipay ) {
        if ( ![self checkAlipay:text1] ) {
            // 输入的手机号不正确
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入有效的支付宝帐号" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
            return ;
        }
        
        NSString* info1 = [[NSString alloc] initWithFormat:@"提现帐号：%@", text1];
        NSString* info2 = nil;
        
        if ( self->_nAmount == self->_nDiscount ) {
            info2 = [[NSString alloc] initWithFormat:@"提现金额：%.0f元", (1.0*self->_nDiscount/100)];
        } else {
            info2 = [[NSString alloc]initWithFormat:@"提现金额：%.0f元，返现%.0f元", (1.0*self->_nAmount/100), (1.0*(self->_nAmount-self->_nDiscount)/100)];
        }
        
        [self checkExchange:info1 Text:info2 Tip:@"注：提现在一个工作日内到账，请耐心等待" Button:@"确认提现"];
        
        [info1 release];
        [info2 release];
    } else {
        if ( ![self checkPhoneNum:text1] ) {
            // 输入的手机号不正确
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入有效的手机号码" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
            return ;
        }
        
        NSString* info1 = [[NSString alloc] initWithFormat:@"充值帐号：%@", text1];
        NSString* info2 = nil;
        
        if ( self->_nAmount == self->_nDiscount ) {
            info2 = [[NSString alloc] initWithFormat:@"充值金额：%.0f元", (1.0*self->_nAmount/100)];
        } else {
            info2 = [[NSString alloc]initWithFormat:@"充值金额：%.0f元，返现%.0f元", (1.0*self->_nAmount/100), (1.0*(self->_nAmount-self->_nDiscount)/100)];
        }
        
        [self checkExchange:info1 Text:info2 Tip:@"注：提现在一个工作日内到账，请耐心等待" Button:@"确认充值"];
        
        [info1 release];
        [info2 release];
    }
}

-(void) checkExchange:(NSString*) text1 Text:(NSString*) text2 Tip:(NSString*) tip Button:(NSString*) btnText {
    if ( _alertView != nil ) {
        [_alertView release];
    }
    
    UIView* view = [[[[NSBundle mainBundle] loadNibNamed:@"TransferToAlipayAndPhoneController" owner:self options:nil] lastObject] autorelease];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10.0;
    view.layer.borderWidth = 0.0;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UIColor *color = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1];
    
    UIButton* btn = (UIButton*)[view viewWithTag:11];
    [btn.layer setBorderWidth:0.5];
    [btn.layer setBorderColor:[color CGColor]];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    
    btn = (UIButton*)[view viewWithTag:12];
    [btn.layer setBorderWidth:0.5];
    [btn.layer setBorderColor:[color CGColor]];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    
    [btn setTitle:btnText forState:UIControlStateNormal];
    
    ((UILabel*)[view viewWithTag:21]).text = text1;
    ((UILabel*)[view viewWithTag:22]).text = text2;
    ((UILabel*)[view viewWithTag:23]).text = tip;
    
    _alertView = [[UICustomAlertView alloc]init:view];
    
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
    
    // 发起请求
    [self sendRequest];
}

- (IBAction)clickOrderInfo:(id)sender {
    NSString* url = [[WEB_ORDER_INFO copy] autorelease];
    url = [url stringByAppendingFormat:@"?ordernum=%@", _orderId];
    
    BeeUIStack* stack = self.stack;
    WebPageController* controller = [[[WebPageController alloc] initOrder:_orderId Url:url Stack:stack] autorelease];
    [stack pushViewController:controller animated:YES];
}

- (void) sendRequest {
    [self showLoading];
    
    HttpRequest* request = [[HttpRequest alloc] init:self];
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    
    NSString* discount = [[NSString alloc] initWithFormat:@"%d", self->_nDiscount];
    NSString* amount = [[NSString alloc] initWithFormat:@"%d", self->_nAmount];

    [dictionary setObject:discount forKey:@"discount"];
    [dictionary setObject:amount forKey:@"amount"];
    
    if ( self->_bAlipay ) {
        NSString* account = self._textField.text;
        
        [dictionary setObject:account forKey:@"alipay_account"];
        
        [request request:HTTP_ALIPAY_PAY Param:dictionary];
    } else {
        NSString* phoneNum = self._textField.text;
        
        [dictionary setObject:phoneNum forKey:@"phone_num"];
        
        [request request:HTTP_PHONE_PAY Param:dictionary];
    }
    
    [dictionary release];
}

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    [self hideLoading];
    
    if ( httpCode == 200 ) {
        // 请求成功
        NSNumber* res = [body valueForKey:@"res"];
        int nRes = [res intValue];
        if ( nRes == 0 ) {
            // 调用成功
            NSString* orderId = [[body valueForKey:@"order_id"] copy];
            [self onRequestSuccessed:orderId];
        } else {
            NSString* err = [body valueForKey:@"msg"];
            [self onRequestFailed:err];
        }
    } else {
        // 请求失败
        [self onRequestFailed:@"连接服务器失败"];
    }
}

- (void) onRequestFailed:(NSString*) err {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:err delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void) onRequestSuccessed:(NSString*) orderId {
    // 切换显示
    if ( _orderId != nil ) {
        [_orderId release];
    }
    
    //统计
    [MobClick event:@"money_get_from_all" attributes:@{@"RMB":[NSString stringWithFormat:@"%d",(-1*self->_nDiscount)],@"FROM":self->_bAlipay?@"淘宝提现":@"充话费"}];
    
    [[LoginAndRegister sharedInstance] increaseBalance:(-1*self->_nDiscount)];
    _orderId = [orderId copy];
    
    UIButton* btn = (UIButton*)[self._completeView viewWithTag:33];
    [btn setTitle:_orderId forState:UIControlStateNormal];
    
    [UIView beginAnimations:@"view curldown" context:nil];
    [UIView setAnimationDuration:0.5];
    
    [self._completeView setHidden:NO];
    [self._containerView setHidden:YES];
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
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
        UIAlertView* balanceAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的余额不足以支付" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [balanceAlert show];
        [balanceAlert release];
        return NO;
    }
    
    return YES;
}

- (IBAction)clickPhone10:(id)sender {
    [self hideKeyboard];
    if ( [self checkBalanceAndBindPhone:10] ) {
        self->_nDiscount = 1000;
        self->_nAmount = 1000;
    
        [self clickNext];
    }
}

- (IBAction)clickPhone30:(id)sender {
    [self hideKeyboard];
    if ( [self checkBalanceAndBindPhone:30] ) {
        self->_nDiscount = 2700;
        self->_nAmount = 3000;
    
        [self clickNext];
    }
}

- (IBAction)clickPhone50:(id)sender {
    [self hideKeyboard];
    if ( [self checkBalanceAndBindPhone:50] ) {
        self->_nDiscount = 4000;
        self->_nAmount = 5000;
    
        [self clickNext];
    }
}

- (IBAction)clickAlipay10:(id)sender {
    [self hideKeyboard];
    if ( [self checkBalanceAndBindPhone:10] ) {
        self->_nDiscount = 1000;
        self->_nAmount = 1000;
    
        [self clickNext];
    }
}

- (IBAction)clickAlipay30:(id)sender {
    [self hideKeyboard];
    if ( [self checkBalanceAndBindPhone:30] ) {
        self->_nDiscount = 2700;
        self->_nAmount = 3000;
    
        [self clickNext];
    }
}

- (IBAction)clickAlipay50:(id)sender {
    [self hideKeyboard];
    if ( [self checkBalanceAndBindPhone:50] ) {
        self->_nDiscount = 4000;
        self->_nAmount = 5000;
    
        [self clickNext];
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
    // 绑定手机
    [MobClick event:@"click_bind_phone" attributes:@{@"currentpage":@"网页"}];
    PhoneValidationController* phoneVal = [PhoneValidationController shareInstance];
    [self->_beeStack pushViewController:phoneVal animated:YES];
}

@end
