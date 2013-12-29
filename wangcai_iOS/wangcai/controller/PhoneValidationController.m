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

@synthesize _imageArrow;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _bSend = NO;
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"PhoneValidationController" owner:self options:nil] firstObject];
        _token = nil;
        
        self->_timer = nil;
        self->_viewInputNum = [[[NSBundle mainBundle] loadNibNamed:@"PhoneValidationController" owner:self options:nil] objectAtIndex:2];
        self->_viewCheckNum = [[[NSBundle mainBundle] loadNibNamed:@"PhoneValidationController" owner:self options:nil] objectAtIndex:1];
        self->_viewRegSuccess = [[[NSBundle mainBundle] loadNibNamed:@"PhoneValidationController" owner:self options:nil] objectAtIndex:3];
        
        CGRect rect = CGRectMake( 0.0f, 153.0f, self->_viewInputNum.frame.size.width, self->_viewInputNum.frame.size.height);
        _viewInputNum.frame = rect;
        _viewCheckNum.frame = rect;
        _viewRegSuccess.frame = rect;
       
        self->_tab1 = (UIImageView*)[self.view viewWithTag:54];
        self->_tab2 = (UIImageView*)[self.view viewWithTag:55];
        self->_tab3 = (UIImageView*)[self.view viewWithTag:56];
        self->_phoneLabel = (UILabel*)[_viewCheckNum viewWithTag:51];
        
        self->_tabController = [[TabController alloc] init:nil];
        
        btnCheckNum = (UIButton*)[_viewCheckNum viewWithTag:71];
        nextNumBtn = (UIButton*)[_viewInputNum viewWithTag:71];
        
        UIView* viewTab = self->_tabController.view;
        CGRect rectTab = viewTab.frame;
        rectTab.origin.y = 54;
        viewTab.frame = rectTab;
        
        [self.view addSubview:viewTab];
        
        [self.view addSubview:self->_viewInputNum];
        [self.view addSubview:self->_viewCheckNum];
        [self.view addSubview:self->_viewRegSuccess];
        
        [self->_tabController setTabInfo:@"输入手机号" Tab2:@"输入验证码" Tab3:@"领取" Purse:1];
        
        [self showFirstPage];
        
        textNum = (UITextField*)[_viewInputNum viewWithTag:72];
        textNum.delegate = self;
        
        
        textCheck1 = (UITextField*)[_viewCheckNum viewWithTag:15];
        textCheck2 = (UITextField*)[_viewCheckNum viewWithTag:16];
        textCheck3 = (UITextField*)[_viewCheckNum viewWithTag:17];
        textCheck4 = (UITextField*)[_viewCheckNum viewWithTag:18];
        textCheck5 = (UITextField*)[_viewCheckNum viewWithTag:19];
        
        textCheck1.delegate = self;
        textCheck2.delegate = self;
        textCheck3.delegate = self;
        textCheck4.delegate = self;
        textCheck5.delegate = self;

        textCheck1.clearsOnBeginEditing = YES;
        textCheck2.clearsOnBeginEditing = YES;
        textCheck3.clearsOnBeginEditing = YES;
        textCheck4.clearsOnBeginEditing = YES;
        textCheck5.clearsOnBeginEditing = YES;
        
        self->phoneValidation = [[PhoneValidation alloc] init];
        
        //[self.textNum becomeFirstResponder];
    }
    return self;
}

- (void)setBackType:(BOOL)bSend {
    _bSend = bSend;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) hideKeyboard {
    if ( [textNum isFirstResponder] ) {
        [textNum resignFirstResponder];
    }
    
    if ( [textCheck1 isFirstResponder] ) {
        [textCheck1 resignFirstResponder];
    }
    
    if ( [textCheck2 isFirstResponder] ) {
        [textCheck2 resignFirstResponder];
    }
    
    if ( [textCheck3 isFirstResponder] ) {
        [textCheck3 resignFirstResponder];
    }
    
    if ( [textCheck4 isFirstResponder] ) {
        [textCheck4 resignFirstResponder];
    }
    
    if ( [textCheck5 isFirstResponder] ) {
        [textCheck5 resignFirstResponder];
    }
}

- (IBAction)clickBack:(id)sender {
    // 收起键盘
    
    if ( _bSend ) {
        [self postNotification:@"showMenu"];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) dealloc {
    _viewInputNum = nil;
    _viewCheckNum = nil;
    _viewRegSuccess = nil;
    
    if ( _token != nil ) {
        [_token release];
        _token = nil;
    }
    
    if ( _phoneNum != nil ) {
        [_phoneNum release];
        _phoneNum = nil;
    }
    textNum = nil;
    nextNumBtn = nil;
    textCheck1 = nil;
    textCheck2 = nil;
    textCheck3 = nil;
    textCheck4 = nil;
    textCheck5 = nil;
    
    btnCheckNum = nil;
    self._imageArrow = nil;
    self->_tab1 = nil;
    self->_tab2 = nil;
    self->_tab3 = nil;
    self->_timer = nil;
    self->_tabController = nil;
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
    [self attachEvent];
}

- (void)viewWillDisappear:(BOOL)animated { // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    [self detachEvent];
}

-(void)attachEvent {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)detachEvent {
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
        newViewFrame = _viewInputNum.frame;
        newViewFrame.origin.y = _viewInputNum.frame.origin.y - 98; // 头部高度98
        
        newBtnFrame = nextNumBtn.frame;
        newBtnFrame.origin.y = nextNumBtn.frame.origin.y - 78;
        [self._imageArrow setHidden:YES];
    } else if ( self->curState == 1 ) {
        newViewFrame = _viewCheckNum.frame;
        newViewFrame.origin.y = _viewCheckNum.frame.origin.y - 98; // 头部高度98
        
        newBtnFrame = btnCheckNum.frame;
        newBtnFrame.origin.y = btnCheckNum.frame.origin.y - 78;
        [self._imageArrow setHidden:YES];
        [[_viewCheckNum viewWithTag:31] setHidden:YES];
    }
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    if ( self->curState == 0 ) {
        _viewInputNum.frame = newViewFrame;
        
        if ( !DEVICE_IS_IPHONE5 ) {
            nextNumBtn.frame = newBtnFrame;
        }
    } else if ( self->curState == 1 ) {
        _viewCheckNum.frame = newViewFrame;
        
        if ( !DEVICE_IS_IPHONE5 ) {
            btnCheckNum.frame = newBtnFrame;
        
            for (int i = 27; i <= 29; i ++ ) {
                CGRect rect = [_viewCheckNum viewWithTag:i].frame;
                rect.origin.y -= 44;
                [_viewCheckNum viewWithTag:i].frame = rect;
            }
            for (int i = 50; i <= 54; i ++ ) {
                CGRect rect = [_viewCheckNum viewWithTag:i].frame;
                rect.origin.y -= 20;
                [_viewCheckNum viewWithTag:i].frame = rect;
            }
            for (int i = 10; i <= 19; i ++ ) {
                CGRect rect = [_viewCheckNum viewWithTag:i].frame;
                rect.origin.y -= 36;
                [_viewCheckNum viewWithTag:i].frame = rect;
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
        newViewFrame = _viewInputNum.frame;
        newViewFrame.origin.y = 98 + _viewInputNum.frame.origin.y;
    
        newBtnFrame = nextNumBtn.frame;
        newBtnFrame.origin.y = 78 + nextNumBtn.frame.origin.y;
        
        _viewInputNum.frame = newViewFrame;
        if ( !DEVICE_IS_IPHONE5 ) {
            nextNumBtn.frame = newBtnFrame;
        }
        [self._imageArrow setHidden:NO];
    } else {
        newViewFrame = _viewCheckNum.frame;
        newViewFrame.origin.y = 98 + _viewCheckNum.frame.origin.y;
        
        newBtnFrame = btnCheckNum.frame;
        newBtnFrame.origin.y = 78 + btnCheckNum.frame.origin.y;
        
        _viewCheckNum.frame = newViewFrame;
        
        if ( !DEVICE_IS_IPHONE5 ) {
            btnCheckNum.frame = newBtnFrame;
            [[_viewCheckNum viewWithTag:31] setHidden:NO];
        
            for (int i = 27; i <= 29; i ++ ) {
                CGRect rect = [_viewCheckNum viewWithTag:i].frame;
                rect.origin.y += 44;
                [_viewCheckNum viewWithTag:i].frame = rect;
            }
            for (int i = 50; i <= 54; i ++ ) {
                CGRect rect = [_viewCheckNum viewWithTag:i].frame;
                rect.origin.y += 20;
                [_viewCheckNum viewWithTag:i].frame = rect;
            }
            for (int i = 10; i <= 19; i ++ ) {
                CGRect rect = [_viewCheckNum viewWithTag:i].frame;
                rect.origin.y += 36;
                [_viewCheckNum viewWithTag:i].frame = rect;
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
        
        if ( textNum.text.length + string.length <= 11 ) {
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
    [[_viewCheckNum viewWithTag:53] setHidden:YES];
    [[_viewCheckNum viewWithTag:54] setHidden:YES];
    
    [self->phoneValidation sendCheckNumToPhone:self->_token delegate:self ];
    [self showLoading];
}

- (IBAction)clickNext:(id)sender {
    if ( self->curState == 0 ) {
        NSString* phoneNum = textNum.text;
        if ( [self checkPhoneNum : phoneNum] ) {
            // 发送验证码，进入loading
            self->_phoneNum = [phoneNum copy];
            [self->phoneValidation attachPhone:phoneNum delegate:self];
            [self showLoading];
        
            return ;
        }
        
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
            UILabel* statusText = (UILabel*)[_viewCheckNum viewWithTag:29];
            statusText.text = @"正在验证验证码...";
            
            [self showLoading];
            // 给服务器发送验证请求
            [self->phoneValidation checkSmsCode:checkNum Token:_token delegate:self];
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
    if ( textCheck1.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:textCheck1.text];
    }
    
    if ( textCheck2.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:textCheck2.text];
    }
    
    if ( textCheck3.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:textCheck3.text];
    }
    
    if ( textCheck4.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:textCheck4.text];
    }
    
    if ( textCheck5.text.length == 1 ) {
        checkNum = [checkNum stringByAppendingString:textCheck5.text];
    }
    
    return [[checkNum copy]autorelease];
}

- (void)fieldTextChanged: (NSNotification*) notification {
    if ( self->curState == 1 ) {
        UITextField* field =  notification.object;
        if ( field.text.length >= 1 ) {
            if ( [field isEqual:textCheck1] ) {
                [textCheck2 becomeFirstResponder];
            } else if ( [field isEqual:textCheck2] ) {
                [textCheck3 becomeFirstResponder];
            } else if ( [field isEqual:textCheck3] ) {
                [textCheck4 becomeFirstResponder];
            } else if ( [field isEqual:textCheck4] ) {
                [textCheck5 becomeFirstResponder];
            }
        }
        
        NSString* code = [self getCheckCode];
        if ( code.length == 5 ) {
            [self hideWarn:YES];
        } else {
            [self hideWarn:NO];
            UILabel* statusText = (UILabel*)[_viewCheckNum viewWithTag:29];
            statusText.text = @"请输入手机验证码";
        }
    }
}

- (void) hideWarn : (BOOL) hide {
    [[_viewCheckNum viewWithTag:27] setHidden:hide];
    [[_viewCheckNum viewWithTag:28] setHidden:hide];
    [[_viewCheckNum viewWithTag:29] setHidden:hide];
}

- (void) selectTab : (int)index {
    [self->_tabController selectTab:index];
    
    if ( index == 2 ) {
        self->_phoneLabel.text = textNum.text;
    }
}

- (void) showFirstPage {
    [_viewCheckNum setHidden:YES];
    [_viewInputNum setHidden:NO];
    [_viewRegSuccess setHidden:YES];
    
    [UIView beginAnimations:@"view curldown" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self->_viewInputNum cache:YES];
    
    self->curState = 0;
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    [self selectTab:1];
}

- (void) showThirdPage {
    [_viewCheckNum setHidden:YES];
    [_viewInputNum setHidden:YES];
    [_viewRegSuccess setHidden:NO];
    
    [UIView beginAnimations:@"view curldown" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self->_viewRegSuccess cache:YES];
    
    self->curState = 3;
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    [self selectTab:3];
}

- (void) showSecondPage {
    [self->_viewCheckNum setHidden:NO];
    [self->_viewInputNum setHidden:YES];
    [self->_viewRegSuccess setHidden:YES];

    [UIView beginAnimations:@"view curlup" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:_viewCheckNum cache:YES];
    
    self->curState = 1;
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    [self selectTab:2];
    
    UILabel* statusText = (UILabel*)[_viewCheckNum viewWithTag:29];
    statusText.text = @"请输入手机验证码";
    
    textCheck1.text = @"";
    textCheck2.text = @"";
    textCheck3.text = @"";
    textCheck4.text = @"";
    textCheck5.text = @"";
    
    [self hideWarn:NO];
}

- (void) beginTime {
    self->_nTime = 120;
    self->_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[_viewCheckNum viewWithTag:53] setHidden:YES];
    [[_viewCheckNum viewWithTag:54] setHidden:NO];
    
    UILabel* label = (UILabel*)[_viewCheckNum viewWithTag:54];
    NSString *text = [[NSString alloc] initWithFormat:@"120秒后重发"];
    label.text = text;
    [text release];
}

- (void) endTime {
    if ( self->_timer != nil ) {
        [self->_timer invalidate];
        self->_timer = nil;
    }
    
    [[_viewCheckNum viewWithTag:53] setHidden:NO];
    [[_viewCheckNum viewWithTag:54] setHidden:YES];
}

- (void) timerTick :(NSTimer *)timer {
    self->_nTime --;
    if ( self->_nTime <= 0 ) {
        [self endTime];
    }
    
    UILabel* label = (UILabel*)[_viewCheckNum viewWithTag:54];
    NSString *text = [[NSString alloc] initWithFormat:@"%d秒后重发", self->_nTime];
    
    label.text = text;
    [text release];
}

- (void) checkSmsCodeCompleted : (BOOL) suc errMsg:(NSString*) errMsg UserId:(NSString*) userId InviteCode:(NSString *)inviteCode {
    [self hideLoading];
    if ( suc ) {
        // 发送完成，进入下一步
        [[LoginAndRegister sharedInstance] attachPhone:_phoneNum UserId:userId InviteCode:inviteCode];
        
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
        
        UILabel* statusText = (UILabel*)[_viewCheckNum viewWithTag:29];
        statusText.text = @"验证码错误请重新输入";
    }
}

-(void) attachPhoneCompleted : (BOOL) suc Token:(NSString*)token errMsg:(NSString*)errMsg {
    [self hideLoading];
    if ( suc ) {
        // 成功发送了验证码
        if ( _token != nil ) {
            [_token release];
        }
        _token = [token copy];
        [self showSecondPage];
        [self beginTime];
    } else {
        if ( errMsg == nil ) {
            errMsg = @"手机号不正确";
        }
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:errMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void) sendSMSCompleted : (BOOL) suc errMsg:(NSString*) errMsg  token:(NSString*) token {
    [self hideLoading];
    if ( suc ) {
        // 发送完成，进入下一步
        if ( _token != nil ) {
            [_token release];
        }
        
        _token = [token copy];
        
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
@end
