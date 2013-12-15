//
//  WebViewController.m
//  wangcai
//
//  Created by 1528 on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "WebViewController.h"
#import "PhoneValidationController.h"

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

- (void)dealloc {
    self->_webView = nil;
    self->_url = nil;
    self->_delegate = nil;
    [super dealloc];
}

- (void)setNavigateUrl:(NSString*)url {
    self->_url = url;
    
    NSURL* nsurl = [[NSURL alloc] initWithString:url];
    [self->_webView loadRequest:[NSURLRequest requestWithURL:nsurl]];
}

- (void)viewDidAppear:(BOOL)animated {
    self->_webView.frame = self.view.frame;
}

- (void)setDelegate:(id)delegate {
    self->_delegate = delegate;
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
        [self notifyPhoneStatus:NO Phone:@"但是发生地发生地"];
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/attach_phone"] ) {
        // 点击了绑定手机
        if ( self->_delegate != nil ) {
            [self->_delegate onAttachPhone];
        }
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/pay_to_alipay"] ) {
        NSString* value = [self getValueFromQuery:query Key:@"coin"];
        float fCoin = [value floatValue];
        if ( self->_delegate != nil ) {
            [self->_delegate onPayToAlipay:fCoin];
        }
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/pay_to_phone"] ) {
        NSString* value = [self getValueFromQuery:query Key:@"coin"];
        float fCoin = [value floatValue];
        if ( self->_delegate != nil ) {
            [self->_delegate onPayToPhone:fCoin];
        }
        
        return NO;
    }
    
    return YES;
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

@end
