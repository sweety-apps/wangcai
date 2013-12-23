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

- (void)dealloc {
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
    NSString* path = request.mainDocumentURL.relativePath;
    
    if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/query_attach_phone"] ) {
        // 查询手机是否已经绑定
        [self notifyPhoneStatus:NO Phone:@"但是发生地发生地"];
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
    }
    
    return YES;
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
