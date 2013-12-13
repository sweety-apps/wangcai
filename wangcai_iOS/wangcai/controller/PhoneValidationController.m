//
//  PhoneValidationController.m
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "PhoneValidationController.h"
#import "MBHUDView.h"
#import "Common.h"

@interface PhoneValidationController ()
@end

@implementation PhoneValidationController
@synthesize _viewInputNum;
@synthesize _viewCheckNum;
@synthesize textNum;
@synthesize nextNumBtn;
@synthesize textCheck1;
@synthesize textCheck2;
@synthesize textCheck3;
@synthesize textCheck4;
@synthesize textCheck5;

@synthesize btnCheckNum;
@synthesize _imageArrow;
@synthesize _viewRegSuccess;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"PhoneValidationController" owner:self options:nil] firstObject];
        self->_timer = nil;
        self._viewInputNum = [[[NSBundle mainBundle] loadNibNamed:@"PhoneValidationController" owner:self options:nil] objectAtIndex:2];
        self._viewCheckNum = [[[NSBundle mainBundle] loadNibNamed:@"PhoneValidationController" owner:self options:nil] objectAtIndex:1];
        self._viewRegSuccess = [[[NSBundle mainBundle] loadNibNamed:@"PhoneValidationController" owner:self options:nil] objectAtIndex:3];
        
        self->_tab1 = (UIImageView*)[self.view viewWithTag:54];
        self->_tab2 = (UIImageView*)[self.view viewWithTag:55];
        self->_tab3 = (UIImageView*)[self.view viewWithTag:56];
        self->_phoneLabel = (UILabel*)[self._viewCheckNum viewWithTag:51];
        
        [self showFirstPage];
        
        self.textNum.delegate = self;
        
        self.textCheck1.delegate = self;
        self.textCheck2.delegate = self;
        self.textCheck3.delegate = self;
        self.textCheck4.delegate = self;
        self.textCheck5.delegate = self;
     
        self.textCheck1.clearsOnBeginEditing = YES;
        self.textCheck2.clearsOnBeginEditing = YES;
        self.textCheck3.clearsOnBeginEditing = YES;
        self.textCheck4.clearsOnBeginEditing = YES;
        self.textCheck5.clearsOnBeginEditing = YES;
        
        self->phoneValidation = [[PhoneValidation alloc] init];
        
        //[self.textNum becomeFirstResponder];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dealloc {
    self._viewInputNum = nil;
    self._viewCheckNum = nil;
    self._viewRegSuccess = nil;
    
    self.textNum = nil;
    self.nextNumBtn = nil;
    self.textCheck1 = nil;
    self.textCheck2 = nil;
    self.textCheck3 = nil;
    self.textCheck4 = nil;
    self.textCheck5 = nil;
    
    self.btnCheckNum = nil;
    self._imageArrow = nil;
    self->_tab1 = nil;
    self->_tab2 = nil;
    self->_tab3 = nil;
    self->_timer = nil;
    [self->phoneValidation dealloc];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {    // Called when the view is about to made visible. Default does nothing
    // 绑定键盘事件
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated { // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)keyboardWillShow: (NSNotification*) notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];

    CGRect newViewFrame;
    CGRect newBtnFrame;
    
    if ( self->curState == 0 ) {
        newViewFrame = self._viewInputNum.frame;
        newViewFrame.origin.y = self._viewInputNum.frame.origin.y - 98; // 头部高度98
        
        newBtnFrame = self.nextNumBtn.frame;
        newBtnFrame.origin.y = self.nextNumBtn.frame.origin.y - 78;
        [self._imageArrow setHidden:YES];
    } else if ( self->curState == 1 ) {
        newViewFrame = self._viewCheckNum.frame;
        newViewFrame.origin.y = self._viewCheckNum.frame.origin.y - 98; // 头部高度98
        
        newBtnFrame = self.btnCheckNum.frame;
        newBtnFrame.origin.y = self.btnCheckNum.frame.origin.y - 78;
        [self._imageArrow setHidden:YES];
        [[self._viewCheckNum viewWithTag:31] setHidden:YES];
    }
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    if ( self->curState == 0 ) {
        self._viewInputNum.frame = newViewFrame;
        
        if ( !DEVICE_IS_IPHONE5 ) {
            self.nextNumBtn.frame = newBtnFrame;
        }
    } else if ( self->curState == 1 ) {
        self._viewCheckNum.frame = newViewFrame;
        
        if ( !DEVICE_IS_IPHONE5 ) {
            self.btnCheckNum.frame = newBtnFrame;
        
            for (int i = 27; i <= 29; i ++ ) {
                CGRect rect = [self._viewCheckNum viewWithTag:i].frame;
                rect.origin.y -= 44;
                [self._viewCheckNum viewWithTag:i].frame = rect;
            }
            for (int i = 50; i <= 54; i ++ ) {
                CGRect rect = [self._viewCheckNum viewWithTag:i].frame;
                rect.origin.y -= 20;
                [self._viewCheckNum viewWithTag:i].frame = rect;
            }
            for (int i = 10; i <= 19; i ++ ) {
                CGRect rect = [self._viewCheckNum viewWithTag:i].frame;
                rect.origin.y -= 36;
                [self._viewCheckNum viewWithTag:i].frame = rect;
            }
        }
    }
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide: (NSNotification*) notification {
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect newViewFrame;
    CGRect newBtnFrame;
    if ( self->curState == 0 ) {
        newViewFrame = self._viewInputNum.frame;
        newViewFrame.origin.y = 98 + self._viewInputNum.frame.origin.y;
    
        newBtnFrame = self.nextNumBtn.frame;
        newBtnFrame.origin.y = 78 + self.nextNumBtn.frame.origin.y;
        
        self._viewInputNum.frame = newViewFrame;
        if ( !DEVICE_IS_IPHONE5 ) {
            self.nextNumBtn.frame = newBtnFrame;
        }
        [self._imageArrow setHidden:NO];
    } else {
        newViewFrame = self._viewCheckNum.frame;
        newViewFrame.origin.y = 98 + self._viewCheckNum.frame.origin.y;
        
        newBtnFrame = self.btnCheckNum.frame;
        newBtnFrame.origin.y = 78 + self.btnCheckNum.frame.origin.y;
        
        self._viewCheckNum.frame = newViewFrame;
        
        if ( !DEVICE_IS_IPHONE5 ) {
            self.btnCheckNum.frame = newBtnFrame;
            [[self._viewCheckNum viewWithTag:31] setHidden:NO];
        
            for (int i = 27; i <= 29; i ++ ) {
                CGRect rect = [self._viewCheckNum viewWithTag:i].frame;
                rect.origin.y += 44;
                [self._viewCheckNum viewWithTag:i].frame = rect;
            }
            for (int i = 50; i <= 54; i ++ ) {
                CGRect rect = [self._viewCheckNum viewWithTag:i].frame;
                rect.origin.y += 20;
                [self._viewCheckNum viewWithTag:i].frame = rect;
            }
            for (int i = 10; i <= 19; i ++ ) {
                CGRect rect = [self._viewCheckNum viewWithTag:i].frame;
                rect.origin.y += 36;
                [self._viewCheckNum viewWithTag:i].frame = rect;
            }
        }
    }
    
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {  // return NO to not change text
    if ( self->curState == 0 ) {
        if ( [string isEqualToString:@""] ) {
            return YES;
        }
        
        if ( self.textNum.text.length + string.length <= 11 ) {
            return YES;
        }
    } else if ( self->curState == 1 ) {
        if ( string.length > 1 || range.location >= 1 ) {
            return NO;
        }
        
        return YES;
    }

    return NO;
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

- (IBAction)clickResend:(id)sender {
    [[self._viewCheckNum viewWithTag:53] setHidden:YES];
    [[self._viewCheckNum viewWithTag:54] setHidden:YES];
    
    [self->phoneValidation sendCheckNumToPhone:self->_phoneNum delegate:self ];
    [self showLoading];
}

- (IBAction)clickNext:(id)sender {
    if ( self->curState == 0 ) {
        NSString* phoneNum = self.textNum.text;
        if ( [self checkPhoneNum : phoneNum] ) {
            // 发送验证码，进入loading
            [self->phoneValidation sendCheckNumToPhone:phoneNum delegate:self ];
            [self showLoading];
        
            return ;
        }
    
        self->_phoneNum = phoneNum;
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入有效的手机号码" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    } else if ( self->curState == 1 ) {
        NSString* checkNum = [self getCheckCode];
        
        if ( checkNum.length != 5 ) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入5位数的验证码" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        } else {
            //
            UILabel* statusText = (UILabel*)[self._viewCheckNum viewWithTag:29];
            statusText.text = @"正在验证验证码...";
            
            [self showLoading];
            // 给服务器发送验证请求
            [self->phoneValidation checkSmsCode:self->_phoneNum smsCode:checkNum Token:self->_token delegate:self];
        }
    }
}

- (void) showLoading {
    [MBHUDView hudWithBody:@"请等待..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
}

- (void) hideLoading {
    [MBHUDView dismissCurrentHUD];
}

- (NSString*) getCheckCode {
    NSString* checkNum = @"";
    if ( self.textCheck1.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:self.textCheck1.text];
    }
    
    if ( self.textCheck2.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:self.textCheck2.text];
    }
    
    if ( self.textCheck3.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:self.textCheck3.text];
    }
    
    if ( self.textCheck4.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:self.textCheck4.text];
    }
    
    if ( self.textCheck5.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:self.textCheck5.text];
    }
    
    return [[checkNum copy]autorelease];
}

- (void)fieldTextChanged: (NSNotification*) notification {
    if ( self->curState == 1 ) {
        UITextField* field =  notification.object;
        if ( field.text.length >= 1 ) {
            if ( [field isEqual:self.textCheck1] ) {
                [self.textCheck2 becomeFirstResponder];
            } else if ( [field isEqual:self.textCheck2] ) {
                [self.textCheck3 becomeFirstResponder];
            } else if ( [field isEqual:self.textCheck3] ) {
                [self.textCheck4 becomeFirstResponder];
            } else if ( [field isEqual:self.textCheck4] ) {
                [self.textCheck5 becomeFirstResponder];
            }
        }
        
        NSString* code = [self getCheckCode];
        if ( code.length == 5 ) {
            [self hideWarn:YES];
        } else {
            [self hideWarn:NO];
            UILabel* statusText = (UILabel*)[self._viewCheckNum viewWithTag:29];
            statusText.text = @"请输入手机验证码";
        }
    }
}

- (void) hideWarn : (BOOL) hide {
    [[self._viewCheckNum viewWithTag:27] setHidden:hide];
    [[self._viewCheckNum viewWithTag:28] setHidden:hide];
    [[self._viewCheckNum viewWithTag:29] setHidden:hide];
}

- (void) selectTab : (int)index {
    if ( index == 1 ) {
        [self->_tab1 setHighlighted:YES];
        [self->_tab2 setHighlighted:NO];
        [self->_tab3 setHighlighted:NO];
    } else if ( index == 2 ) {
        [self->_tab1 setHighlighted:NO];
        [self->_tab2 setHighlighted:YES];
        [self->_tab3 setHighlighted:NO];
    
        self->_phoneLabel.text = self.textNum.text;
    } else {
        [self->_tab1 setHighlighted:NO];
        [self->_tab2 setHighlighted:NO];
        [self->_tab3 setHighlighted:YES];
    }
}

- (void) showFirstPage {
    [self._viewCheckNum setHidden:YES];
    [self._viewInputNum setHidden:NO];
    [self._viewRegSuccess setHidden:NO];
    
    self._viewInputNum.frame = CGRectMake( 0.0f, 160.0f, self->_viewInputNum.frame.size.width, self->_viewInputNum.frame.size.height);

    [UIView beginAnimations:@"view curldown" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self->_viewInputNum cache:YES];
    
    self->curState = 0;
    [self.view addSubview:self->_viewInputNum];
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    [self selectTab:1];
}

- (void) showThirdPage {
    [self._viewCheckNum setHidden:YES];
    [self._viewInputNum setHidden:YES];
    [self._viewRegSuccess setHidden:NO];
    
    self._viewRegSuccess.frame = CGRectMake( 0.0f, 160.0f, self->_viewRegSuccess.frame.size.width, self->_viewRegSuccess.frame.size.height);
    
    [UIView beginAnimations:@"view curldown" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self->_viewRegSuccess cache:YES];
    
    self->curState = 3;
    [self.view addSubview:self->_viewRegSuccess];
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    [self selectTab:3];
}

- (void) showSecondPage {
    [self._viewCheckNum setHidden:NO];
    [self._viewInputNum setHidden:YES];
    [self._viewRegSuccess setHidden:YES];
    
    self._viewCheckNum.frame = CGRectMake( 0.0f, 160.0f, self->_viewCheckNum.frame.size.width, self->_viewCheckNum.frame.size.height);
    
    [UIView beginAnimations:@"view curlup" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self._viewCheckNum cache:YES];
    
    self->curState = 1;
    [self.view addSubview:self._viewCheckNum];
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    [self selectTab:2];
    
    UILabel* statusText = (UILabel*)[self._viewCheckNum viewWithTag:29];
    statusText.text = @"请输入手机验证码";
    
    self.textCheck1.text = @"";
    self.textCheck2.text = @"";
    self.textCheck3.text = @"";
    self.textCheck4.text = @"";
    self.textCheck5.text = @"";
    
    [self hideWarn:NO];
}

- (void) sendSMSCompleted : (BOOL) suc errMsg:(NSString*) errMsg  token:(NSString*) token {
    [self hideLoading];
    if ( suc ) {
        // 发送完成，进入下一步
        self->_token = [token copy];
        if ( self->curState != 1 ) {
            [self showSecondPage];
        }
        
        [self beginTime];
    } else {
        // 发送失败，错误提示
        if ( errMsg == nil ) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"发送验证短信失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:errMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
        [self endTime];
    }
}

- (void) beginTime {
    self->_nTime = 30;
    self->_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[self._viewCheckNum viewWithTag:53] setHidden:YES];
    [[self._viewCheckNum viewWithTag:54] setHidden:NO];
}

- (void) endTime {
    if ( self->_timer != nil ) {
        [self->_timer invalidate];
        self->_timer = nil;
    }
    
    [[self._viewCheckNum viewWithTag:53] setHidden:NO];
    [[self._viewCheckNum viewWithTag:54] setHidden:YES];
}

- (void) timerTick :(NSTimer *)timer {
    self->_nTime --;
    if ( self->_nTime <= 0 ) {
        [self endTime];
    }
    
    UILabel* label = (UILabel*)[self._viewCheckNum viewWithTag:54];
    NSString *text = [[NSString alloc] initWithFormat:@"%d秒后重发", self->_nTime];
    
    label.text = text;
    [text release];
}

- (void) checkSmsCodeCompleted : (BOOL) suc errMsg:(NSString*) errMsg UserId:(NSString*) userId Nickname:(NSString*)nickname {
    [self hideLoading];
    if ( suc ) {
        // 发送完成，进入下一步
        [self showThirdPage];
    } else {
        // 发送失败，错误提示
        [self hideWarn:NO];
        
        if ( errMsg == nil ) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"发送验证短信失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:errMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
        UILabel* statusText = (UILabel*)[self._viewCheckNum viewWithTag:29];
        statusText.text = @"验证码错误请重新输入";
    }
}

@end
