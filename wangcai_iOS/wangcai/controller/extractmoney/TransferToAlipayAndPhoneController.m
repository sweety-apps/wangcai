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

// type=1 支付宝  2 话费充值  3 qq币
- (id) init:(int) type BeeUIStack:(BeeUIStack*) stack
{
    self = [super initWithNibName:@"TransferToAlipayAndPhoneController" bundle:nil];
    if (self) {
        // Custom initialization
        self->_type = type;
        //self->_nDiscount = nDiscount;
        //self->_nAmount = nAmount;
        self->_alertBindPhone = nil;
        self->_alertView = nil;
        self->_orderId = nil;
        self->_beeStack = stack;
        
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"TransferToAlipayAndPhoneController" owner:self options:nil] firstObject];

        UILabel* label = (UILabel*)[self.view viewWithTag:1];
        if ( _type == 1 ) {
            label.text = @"现金提取";
            self._containerView = [[[NSBundle mainBundle] loadNibNamed:@"TransferToAlipayAndPhoneController" owner:self options:nil] objectAtIndex:2];
        } else if ( _type == 2 ) {
            label.text = @"话费充值";
            self._containerView = [[[NSBundle mainBundle] loadNibNamed:@"TransferToAlipayAndPhoneController" owner:self options:nil] objectAtIndex:1];
        } else if ( _type == 3 ) {
            label.text = @"腾讯Q币";
            self._containerView = [[[NSBundle mainBundle] loadNibNamed:@"TransferToAlipayAndPhoneController" owner:self options:nil] objectAtIndex:3];
        }
        
        self._completeView = [[[NSBundle mainBundle] loadNibNamed:@"TransferToAlipayAndPhoneController" owner:self options:nil] objectAtIndex:4];
        
        CGRect rect = CGRectMake( 0.0f, 54.0f, self._containerView.frame.size.width, self._containerView.frame.size.height);
        self._containerView.frame = rect;
        self._completeView.frame = rect;
        
        [self.view insertSubview:self._containerView atIndex:0];
        [self.view addSubview:self._completeView];
        
        [self._completeView setHidden:YES];
        [self._containerView setHidden:NO];

        self._textField = (UITextField*)[self._containerView viewWithTag:71];
        self._textCheck = (UITextField*)[self._containerView viewWithTag:72];
        
        self._textFieldTip = (UILabel*)[self._containerView viewWithTag:51];
        self._textCheckTip = (UILabel*)[self._containerView viewWithTag:52];
        
        if ( _type == 1 ) {
            self._textName = (UITextField*)[self._containerView viewWithTag:73];
            self._textNameTip = (UILabel*)[self._containerView viewWithTag:53];
        }
        
        [self initBtn];
    }
    
    return self;
}

- (void)initBtn {
    CGRect rect;
    rect.size.height = 50;
    rect.size.width = 95;
    
    if ( _type == 1 ) {
        rect.origin.y = 252;
    } else if ( _type == 2 ) {
        rect.origin.y = 200;
    } else if ( _type == 3 ) {
        rect.origin.y = 200;
    }
    
    _btn1 = [[UIPayButton alloc] initWithNibName:@"UIPayButton" bundle:nil];
    _btn2 = [[UIPayButton alloc] initWithNibName:@"UIPayButton" bundle:nil];
    _btn3 = [[UIPayButton alloc] initWithNibName:@"UIPayButton" bundle:nil];
    
    rect.origin.x = 10;
    [_btn1.view setFrame:rect];
    
    rect.origin.x = 113;
    [_btn2.view setFrame:rect];
    
    rect.origin.x = 216;
    [_btn3.view setFrame:rect];
    
    [self._containerView addSubview:_btn1.view];
    [self._containerView addSubview:_btn2.view];
    [self._containerView addSubview:_btn3.view];
    
    NSArray* payInfo = nil;
    if ( _type == 1 ) {
        payInfo = [[LoginAndRegister sharedInstance] getAlipay];
    } else if ( _type == 2 ) {
        payInfo = [[LoginAndRegister sharedInstance] getPhonePay];
    } else if ( _type == 3 ) {
        payInfo = [[LoginAndRegister sharedInstance] getQbiPay];
    }
    
    if ( [payInfo count] != 3 ) {
        [_btn1 setAmount:1000 Reward:0 Hot:NO Delegate:self];
        [_btn2 setAmount:3000 Reward:300 Hot:YES Delegate:self];
        [_btn3 setAmount:5000 Reward:1000 Hot:NO Delegate:self];
    } else {
        NSDictionary* dict = [payInfo objectAtIndex:0];
        int nAmount = [[dict objectForKey:@"amount"] intValue];
        int nPrice = [[dict objectForKey:@"price"] intValue];
        BOOL bHot = [[dict objectForKey:@"hot"] boolValue];
        
        [_btn1 setAmount:nAmount Reward:(nAmount-nPrice) Hot:bHot Delegate:self];
        
        dict = [payInfo objectAtIndex:1];
        nAmount = [[dict objectForKey:@"amount"] intValue];
        nPrice = [[dict objectForKey:@"price"] intValue];
        bHot = [[dict objectForKey:@"hot"] boolValue];
        
        [_btn2 setAmount:nAmount Reward:(nAmount-nPrice) Hot:bHot Delegate:self];
        
        dict = [payInfo objectAtIndex:2];
        nAmount = [[dict objectForKey:@"amount"] intValue];
        nPrice = [[dict objectForKey:@"price"] intValue];
        bHot = [[dict objectForKey:@"hot"] boolValue];
        
        [_btn3 setAmount:nAmount Reward:(nAmount-nPrice) Hot:bHot Delegate:self];
    }
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



- (void)viewWillAppear:(BOOL)animated {    // Called when the view is about to made visible. Default does nothing
    // 绑定键盘事件
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated { // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}




- (void)keyboardWillShow: (NSNotification*) notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = self._containerView.frame;
    rect.origin.y = 4;
    [self._containerView setFrame:rect];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide: (NSNotification*) notification {
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = self._containerView.frame;
    rect.origin.y = 54;
    [self._containerView setFrame:rect];
    
    [UIView commitAnimations];
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
    
    [_btn1 release];
    [_btn2 release];
    [_btn3 release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if ( _type == 1 ) {
        // 手机充值
        NSString* str = [string trim];
        if ( [str length] == 0 && [string length] != 0 ) {
            return NO;
        }
        
        return YES;
    } else if ( _type == 2 ) {
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
    } else {
        return YES;
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
    
    if ( _type == 1 && [textField isEqual:self._textName] ) {
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

        if ( _type == 1 && [textField isEqual:self._textName] ) {
            [self._textNameTip setHidden:NO];
        }
    } else {
        if ( [textField isEqual:self._textField] ) {
            [self._textFieldTip setHidden:YES];
        }
        
        if ( [textField isEqual:self._textCheck] ) {
            [self._textCheckTip setHidden:YES];
        }
        
        if ( _type == 1 && [textField isEqual:self._textName] ) {
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

- (BOOL) checkQQNum : qq {
    for (NSUInteger i = 0; i < [qq length]; i ++ ) {
        unichar uc = [qq characterAtIndex:i];
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
    
    if ( _type==1 && [text3 length] == 0 ) {
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
    
    if ( _type == 1 ) {
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
    } else if ( _type == 2 ) {
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
    } else {
        // QQ币
        if ( ![self checkQQNum:text1] ) {
            // 输入的QQ号不正确
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入有效的QQ号码" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
            return ;
        }
        
        NSString* info1 = [[NSString alloc] initWithFormat:@"充值QQ号：%@", text1];
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
    
    if ( _type == 1 ) {
        NSString* account = self._textField.text;
        
        [dictionary setObject:account forKey:@"alipay_account"];
        
        [request request:HTTP_ALIPAY_PAY Param:dictionary];
    } else if ( _type == 2 ) {
        NSString* phoneNum = self._textField.text;
        
        [dictionary setObject:phoneNum forKey:@"phone_num"];
        
        [request request:HTTP_PHONE_PAY Param:dictionary];
    } else {
        // QQ币
        NSString* qq = self._textField.text;
        
        [dictionary setObject:qq forKey:@"qq"];
        [dictionary setObject:discount forKey:@"price"];
        
        [request request:HTTP_QQ_PAY Param:dictionary];
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
    if ( _type == 1 ) {
        [MobClick event:@"money_get_from_all" attributes:@{@"RMB":[NSString stringWithFormat:@"%d",(-1*self->_nDiscount)],@"FROM":@"淘宝提现"}];
    } else if ( _type == 2 ) {
        [MobClick event:@"money_get_from_all" attributes:@{@"RMB":[NSString stringWithFormat:@"%d",(-1*self->_nDiscount)],@"FROM":@"充话费"}];
    } else {
        [MobClick event:@"money_get_from_all" attributes:@{@"RMB":[NSString stringWithFormat:@"%d",(-1*self->_nDiscount)],@"FROM":@"QQ币"}];
    }
    
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

- (void) onClickPay:(int)amount Reward:(int)reward {
    [self hideKeyboard];
    if ( [self checkBalanceAndBindPhone:(amount / 100)] ) {
        self->_nDiscount = amount - reward;
        self->_nAmount = amount;
        
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
