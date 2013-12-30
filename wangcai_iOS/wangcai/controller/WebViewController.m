//
//  WebViewController.m
//  wangcai
//
//  Created by 1528 on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "WebViewController.h"
#import "PhoneValidationController.h"
#import "TransferToAlipayAndPhoneController.h"
#import "WebPageController.h"
#import "Config.h"
#import "Common.h"
#import "MBHUDView.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)init
{
    self = [super initWithNibName:@"WebViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"WebViewController" owner:self options:nil] firstObject];
        self->_webView = (UIWebView*)[self.view viewWithTag:11];
        self->_webView.delegate = self;
        _delegate = nil;
        self->_loadingView = [[[NSBundle mainBundle] loadNibNamed:@"WebViewController" owner:self options:nil] lastObject];
        [self.view addSubview:self->_loadingView];
        
        [self->_webView setHidden:YES];
        
        _alert = nil;
        _nsCallback = nil;
        _nsBtn2ID = nil;
        
        //
        [[LoginAndRegister sharedInstance] attachBindPhoneEvent:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)setBeeUIStack:(BeeUIStack*) beeStack {
    _beeStack = beeStack;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) bindPhoneCompeted {
    NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
    [self notifyPhoneStatus:YES Phone:phoneNum];
    [phoneNum release];
}

- (void)dealloc {
    [[LoginAndRegister sharedInstance] detachBindPhoneEvent:self];
    
    self->_webView = nil;
    self->_url = nil;
    if (_url)
    {
        [_url release];
        _url = nil;
    }
    self->_loadingView = nil;
    self->_beeStack = nil;
    _delegate = nil;
    
    if ( _alert != nil ) {
        [_alert release];
    }
    if ( _nsCallback != nil ) {
        [_nsCallback release];
    }
    if ( _nsCallback != nil ) {
        [_nsBtn2ID release];
    }
    
    [super dealloc];
}

- (void)setNavigateUrl:(NSString*)url {
    if (_url)
    {
        [_url release];
        _url = nil;
    }
    _url = [url retain];
    
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self->_webView.frame = rect;
    
    NSURL* nsurl = [[NSURL alloc] initWithString:url];
    [self->_webView loadRequest:[NSURLRequest requestWithURL:nsurl]];
    [nsurl release];
}

-(NSString*) getValueFromQuery:(NSString*) query Key:(NSString*) key {
    NSString* findKey = [[NSString alloc]initWithFormat:@"%@=", key];
    NSRange range = [query rangeOfString:findKey];
    [findKey release];
    if ( range.length != 0 ) {
        NSString* tmp = [query substringFromIndex:(range.location + range.length)];
        range = [tmp rangeOfString:@"&"];
        if ( range.length != 0 ) {
            tmp = [tmp substringToIndex:range.location];
        }
        
        return [[tmp copy]autorelease];
    }
    
    return nil;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* query = [request.mainDocumentURL query];
    
    if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/query_attach_phone"] ) {
        // 查询手机是否已经绑定
        NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
        if ( phoneNum == nil || [phoneNum isEqualToString:@""] ) {
            if ( phoneNum != nil ) {
                [phoneNum release];
            }
            
            [self notifyPhoneStatus:NO Phone:@""];
        } else {
            [self notifyPhoneStatus:YES Phone:phoneNum];
            [phoneNum release];
        }
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/attach_phone"] ) {
        // 点击了绑定手机
        [self onAttachPhone];

        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/pay_to_alipay"] ) {
        NSString* value = [self getValueFromQuery:query Key:@"coin"];
        float fCoin = [value floatValue];
        [self onPayToAlipay:fCoin];
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/pay_to_phone"] ) {
        NSString* value = [self getValueFromQuery:query Key:@"coin"];
        float fCoin = [value floatValue];
        [self onPayToPhone:fCoin];

        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/order_info"] ) {
        NSString* value = [self getValueFromQuery:query Key:@"num"];
        [self onShowOrder:value];
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/copy_to_clip"] ) {
        NSString* value = [self getValueFromQuery:query Key:@"context"];
        
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = value;
        // 复制完成
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"复制完成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/install_app"] ) {
        NSString* value = [self getValueFromQuery:query Key:@"appid"];
        
        if ( _delegate != nil ) {
            [_delegate openAppWithIdentifier:value];
        }

        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/open_url"] ) {
        NSString* value = [self getValueFromQuery:query Key:@"url"];
        
        if ( _delegate != nil ) {
            [_delegate openUrl:value];
        }
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/service_center"] ) {
        NSString* num = [[LoginAndRegister sharedInstance] getPhoneNum];
        if ( num == nil ) {
            num = @"";
        }
        NSString* url = [[NSString alloc] initWithFormat:@"%@?mobile=%@&mobile_num=%@---%@",
                         HTTP_SERVICE_CENTER, num, [Common getMACAddress], [Common getIDFAAddress] ];
        
        WebPageController* webController = [[[WebPageController alloc] init:@"客户服务" Url:url Stack:_beeStack]autorelease];
        
        [self->_beeStack pushViewController:webController animated:YES];
        return NO;
        
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/open_url_inside"] ) {
        NSString* value = [self getValueFromQuery:query Key:@"url"];
        NSString* title = [self getValueFromQuery:query Key:@"title"];
        
        title = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        WebPageController* webController = [[[WebPageController alloc] init:title Url:value Stack:_beeStack]autorelease];
        
        [self->_beeStack pushViewController:webController animated:YES];
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/exchange_info"] ) {
        WebPageController* controller = [[WebPageController alloc] init:@"交易详情" Url:WEB_EXCHANGE_INFO Stack:_beeStack];
        [_beeStack pushViewController:controller animated:YES];
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/alert"] ) {
        NSString* title = [self getValueFromQuery:query Key:@"title"];
        NSString* info = [self getValueFromQuery:query Key:@"info"];
        NSString* btntext = [self getValueFromQuery:query Key:@"btntext"];
        
        title = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        info = [info stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        btntext = [btntext stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString* btn2 = [self getValueFromQuery:query Key:@"btn2"];
        if ( btn2 != nil ) {
            btn2 = [btn2 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString* btn2Id = [self getValueFromQuery:query Key:@"btn2id"];
            NSString* callback = [self getValueFromQuery:query Key:@"callback"];
            
            if ( _alert != nil ) {
                [_alert release];
            }
            if ( _nsCallback != nil ) {
                [_nsCallback release];
            }
            if ( _nsCallback != nil ) {
                [_nsBtn2ID release];
            }
            
            _nsCallback = [callback copy];
            _nsBtn2ID = [btn2Id copy];
            
            _alert = [[UIAlertView alloc] initWithTitle:title message:info delegate:self cancelButtonTitle:btntext otherButtonTitles:btn2, nil];
            
            [_alert show];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:info delegate:nil cancelButtonTitle:btntext otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/alert_loading"] ) {
        NSString* show = [self getValueFromQuery:query Key:@"show"];
        if ( [show isEqualToString:@"1"] ) {
            NSString* info = [self getValueFromQuery:query Key:@"info"];
            info = [info stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            // 显示loading
            [MBHUDView hudWithBody:info type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
        } else {
            [MBHUDView dismissCurrentHUD];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( _alert != nil ) {
        if ( [_alert isEqual:alertView] ) {
            if ( buttonIndex == 1 ) {
                NSString* js = [[NSString alloc] initWithFormat:@"%@(%@)", self->_nsCallback, _nsBtn2ID];
                [_webView stringByEvaluatingJavaScriptFromString:js];
                [js release];
            }
        }
    }
}

- (void) setDelegate:(id) delegate {
    _delegate = delegate;
}

- (void)notifyPhoneStatus:(BOOL)isAttach Phone:(NSString*)phone {
    NSString* js;
    if ( isAttach ) {
        js = [NSString stringWithFormat:@"notifyPhoneStatus(true, \"%@\")", phone];
    } else {
        js = [NSString stringWithFormat:@"notifyPhoneStatus(false)"];
    }
    [self->_webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self->_loadingView setHidden:NO];
    [self->_webView setHidden:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self->_loadingView setHidden:YES];
    [self->_webView setHidden:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self->_loadingView setHidden:YES];
    [self->_webView setHidden:NO];
}

-(void) onAttachPhone {
    PhoneValidationController* phoneVal = [[[PhoneValidationController alloc]initWithNibName:@"PhoneValidationController" bundle:nil] autorelease];
    
    [self->_beeStack pushViewController:phoneVal animated:YES];
}

-(void) onPayToAlipay:(float) fCoin {
    // 转帐到支付宝
    
    TransferToAlipayAndPhoneController* controller = [[[TransferToAlipayAndPhoneController alloc]init:YES] autorelease];
    
    [self->_beeStack pushViewController:controller animated:YES];
}

-(void) onPayToPhone:(float) fCoin {
    // 花费充值
    TransferToAlipayAndPhoneController* controller = [[[TransferToAlipayAndPhoneController alloc]init:NO] autorelease];
    
    [self->_beeStack pushViewController:controller animated:YES];
}

-(void) onShowOrder:(NSString*) orderNum {
    NSString* url = [[WEB_ORDER_INFO copy] autorelease];
    url = [url stringByAppendingFormat:@"?ordernum=%@", orderNum];
    
    WebPageController* controller = [[[WebPageController alloc] initOrder:orderNum Url:url Stack:_beeStack] autorelease];
    [_beeStack pushViewController:controller animated:YES];
}
@end
