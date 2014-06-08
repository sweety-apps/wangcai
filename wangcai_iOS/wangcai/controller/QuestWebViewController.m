//
//  QuestWebViewController.m
//  wangcai
//
//  Created by NPHD on 14-5-23.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "QuestWebViewController.h"
#import "MBHUDView.h"
#import "Config.h"

@interface QuestWebViewController ()

@end

@implementation QuestWebViewController
@synthesize _webView;
@synthesize _loadingView;
@synthesize _errBtn;
@synthesize _errText;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _info = nil;
    }
    return self;
}

- (void) setQuestInfo : (SurveyInfo*) info {
    _info = info;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    _alertView = nil;
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    rect.origin.y = 54;
    rect.size.height -= 54;
    
    _webView.delegate = self;
    [_webView setFrame:rect];
    
    if ( _info != nil ) {
        NSURL* nsurl = [[NSURL alloc] initWithString:_info.url];
        [_webView loadRequest:[NSURLRequest requestWithURL:nsurl]];
        [nsurl release];
    }
}

- (void)dealloc {
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBack:(id)sender {
    QuestViewController* controller = [QuestViewController sharedInstance];
    [self.navigationController popToViewController:controller animated:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* query = [request.mainDocumentURL query];
    
    if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/alert"] ) {
        NSString* title = [self getValueFromQuery:query Key:@"title"];
        NSString* info = [self getValueFromQuery:query Key:@"info"];
        NSString* btntext = [self getValueFromQuery:query Key:@"btntext"];
        
        title = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        info = [info stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        btntext = [btntext stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:info delegate:nil cancelButtonTitle:btntext otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
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
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/commit"] ) {
        // 把数据提交到服务器
        NSMutableDictionary* tmp = [self buildParams:query];
        NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease];
        
        NSString* json = [tmp JSONString];
        
        NSString* sid = [NSString stringWithFormat:@"%@", _info.sid];
        [params setObject:sid forKey:@"id"];
        [params setObject:json forKey:@"survey"];
        
        [self commitData:params];
        return NO;
    }
    
    return YES;
}

- (void) commitData:(NSMutableDictionary*) params {
    [self showLoading];
    
    HttpRequest* req = [[HttpRequest alloc] init:self];
    
    [req request:HTTP_TASK_SURVEY Param:params method:@"post"];
}

- (void) showLoading {
    [MBHUDView hudWithBody:@"请等待..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
}

- (void) hideLoading {
    [MBHUDView dismissCurrentHUD];
}



-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    [self hideLoading];
    
    if (httpCode == 200)
    {
        int result = [[body objectForKey:@"res"] intValue];
        if ( result != 0 ) {   // 返回失败了。。。
            NSString* msg = [body objectForKey:@"msg"];
            UIAlertView* view = [[[UIAlertView alloc] initWithTitle:@"错误" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
            [view show];
        } else {
            // 请求完成
            QuestViewController* controller = [QuestViewController sharedInstance];
            [controller requestList];
            
            _alertView = [[[UIAlertView alloc] initWithTitle:@"问卷已提交" message:@"提交后6小时，人工审核后方可获得红包" delegate:self cancelButtonTitle:@"返回问卷中心" otherButtonTitles:nil, nil] autorelease];
            [_alertView show];
        }
    } else {
        UIAlertView* view = [[[UIAlertView alloc] initWithTitle:@"错误" message:@"提交失败，连接服务器错误！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [view show];
    }
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

- (void) parseParam:(NSMutableDictionary*) params param:(NSString*) param {
    NSRange range = [param rangeOfString:@"="];
    if ( range.length != 0 ) {
        NSString* key = [param substringToIndex:range.location];
        NSString* value = [param substringFromIndex:(range.location + range.length)];
        value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:value forKey:key];
    }
}

- (NSMutableDictionary*) buildParams:(NSString*) query {
    NSMutableDictionary* params = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString* tmpParams = [NSString stringWithString:query];
    while ( YES ) {
        NSRange range = [tmpParams rangeOfString:@"&"];
        if ( range.length == 0 ) {
            // 没有参数了
            [self parseParam:params param:tmpParams];
            break;
        } else {
            NSString* param = [tmpParams substringToIndex:range.location];
            tmpParams = [tmpParams substringFromIndex:(range.location + range.length)];
            
            [self parseParam:params param:param];
        }
    }
    
    return params;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( [alertView isEqual:_alertView] ) {
        // 返回
        QuestViewController* controller = [QuestViewController sharedInstance];
        [self.navigationController popToViewController:controller animated:YES];
    }
}



- (IBAction)onRequest:(id)sender {
    NSURL* nsurl = [[NSURL alloc] initWithString:_info.url];
    [self->_webView loadRequest:[NSURLRequest requestWithURL:nsurl]];
    [nsurl release];
}



- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_webView setHidden:YES];
    [_loadingView setHidden:NO];
    [_errBtn setHidden:YES];
    [_errText setHidden:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_webView setHidden:NO];
    [_loadingView setHidden:YES];
    [_errBtn setHidden:YES];
    [_errText setHidden:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_webView setHidden:YES];
    [_loadingView setHidden:YES];
    [_errBtn setHidden:NO];
    [_errText setHidden:NO];
}


@end
