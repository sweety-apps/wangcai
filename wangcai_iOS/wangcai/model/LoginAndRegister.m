//
//  LoginAndRegister.m
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "LoginAndRegister.h"
#import "Config.h"
#import "Common.h"
#import "CommonTaskList.h"
#import "../JPushlib/APService.h"
#import "MobClick.h"
#import "Common.h"
#import "ALSystem.h"
#import "Reachability.h"
#import "YouMiConfig.h"
#import "UtilityFunctions.h"
#import "ECManager.h"
#import "EcomConfig.h"
#import "QuestViewController.h"
#import "WangcaiTaskViewController.h"
#import "AppDelegate.h"

@implementation BalanceInfo
@synthesize _newBalance;
@synthesize _oldBalance;
@end

@implementation LoginAndRegister
static LoginAndRegister* _sharedInstance = nil;

+(id) sharedInstance {
    if ( _sharedInstance == nil ) {
        _sharedInstance = [[LoginAndRegister alloc]init];
    }
    return _sharedInstance;
}

- (id) init {
    [super init];
    self->_delegate = nil;
    self->loginStatus = Login_Error;
    self->_phoneNum = nil;
    self->_delegateArray = [[NSMutableArray alloc]init];
    self->_delegateBalanceArray = [[NSMutableArray alloc]init];
    self->_balance = 0;
    self->_firstLogin = YES;
    
    self->_phonePay = nil;
    self->_aliPay = nil;
    self->_qbiPay = nil;
    
    self->_badRateYesterday = nil;
    self->_badRateLastWeek = nil;
    
    _tipsString = @"";
    
    return self;
}

- (void) dealloc {
    if ( _delegate != nil ) {
        [_delegate release];
    }
    
    [super dealloc];
}

-(LoginStatus) getLoginStatus {
    return loginStatus;
}

// session超时后，需要先设置超时，然后login
-(void) setTimeout { // 修改登录状态为已超时
    self->loginStatus = Login_Timeout;
}

-(void) sendEvent : (LoginStatus) status HttpCode:(int)httpCode ErrCode:(int)errCode Msg:(NSString*)msg {
    if (_delegate != nil ) {
        [_delegate loginCompleted:status HttpCode:httpCode ErrCode:errCode Msg:msg];
    }
}

-(void) login: (id) delegate {
    [self login];
    _delegate = [delegate retain];
}

- (NSString*) getNetworkInfo {
    Reachability* r = [Reachability reachabilityWithHostName:@"app.getwangcai.com"];
    NSInteger state = [r currentReachabilityStatus];
    if ( state == ReachableViaWiFi ) {
        return [[@"wifi" copy] autorelease];
    } else if ( state == ReachableViaWWAN ) {
        return [[@"3g" copy] autorelease];
    }
    
    return [[@"none" copy] autorelease];
}

- (NSHTTPCookie*) getCookie {
    NSMutableDictionary* properties = [[[NSMutableDictionary alloc] init] autorelease];
    
    [properties setValue:@".getwangcai.com" forKey:NSHTTPCookieDomain];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
    [properties setValue:@"/asi-http-request/wangcai" forKey:NSHTTPCookiePath];
    
    [properties setValue:@"p" forKey:NSHTTPCookieName];
    
    NSString* sysModel = [Common deviceModel];
    NSString* sysVer = [[UIDevice currentDevice] systemVersion];
    NSDictionary* dic = [[NSBundle mainBundle] infoDictionary];
    NSString* appVersion = [dic valueForKey:@"CFBundleVersion"];
    NSString* network = [self getNetworkInfo];
    NSString* localIP = [Common localIPAddress];
    
    NSString* info = [[[NSString alloc] initWithFormat:@"%@_%@; app=%@; ver=%@; net=%@;  local_ip=%@", sysModel, sysVer, APP_NAME, appVersion, network, localIP] autorelease];
    [properties setValue:info forKey:NSHTTPCookieValue];
    
    NSHTTPCookie* cookie = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];
    
    return cookie;
}

-(void) login {
    // 发起登录或注册请求
    if ( _delegate != nil ) {
        [_delegate release];
        _delegate = nil;
    }
    
    self->loginStatus = Login_In;

    BeeHTTPRequest* req = self.HTTP_POST(HTTP_LOGIN_AND_REGISTER);
    NSString* nsParam = [[NSString alloc]init];
    
    NSHTTPCookie* cookie = [self getCookie];
    [req setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
    
    if ( _phoneNum != nil ) {
        // 应该在登录成功后设置
        nsParam = [nsParam stringByAppendingFormat:@"phone=%@&", _phoneNum];
    }
    
    
    NSString* idfa = [Common getIDFAAddress];
    nsParam = [nsParam stringByAppendingFormat:@"idfa=%@&", idfa];

    NSString* mac = [Common getMACAddress];
    nsParam = [nsParam stringByAppendingFormat:@"mac=%@&", mac];
    
    NSString* timestamp = [Common getTimestamp];
    nsParam = [nsParam stringByAppendingFormat:@"timestamp=%@", timestamp];

#if TARGET_VERSION_LITE == 2 
    // 亲友版带上openudid
    NSString* openUdid = [OpenUDID value];
    nsParam = [nsParam stringByAppendingFormat:@"&openudid=%@", openUdid];
#endif
    
    NSString* md5param = [NSString stringWithFormat:@"%@a576ccd7-29dc-ccaa-c0db-168ea82ca7fb", nsParam];
    
    const char* cStr = [md5param UTF8String];
    
    NSData *tmpData = [NSData dataWithBytes:cStr length:strlen(cStr)];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(tmpData.bytes, tmpData.length, digest);
    
    NSMutableString* hash = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    
    NSRange range;
    range.length = 32;
    range.location = 2;
    
    nsParam = [nsParam stringByAppendingFormat:@"&sig=%@", [hash substringWithRange:range]];
    
    NSMutableData* data = [[NSMutableData alloc] init];
    
    
    NSString* encodedString = [nsParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //[nsParam release];
    
    const char * a =[encodedString UTF8String];

    req.HEADER(@"Content-Type", @"application/x-www-form-urlencoded");
    [data appendBytes:a length:strlen(a)];
    
    // 设置https访问证书
    [req setValidatesSecureCertificate:NO];
    //[req setClientCertificates:[NSArray arrayWithObject:(id)cert]];
    //[req setClientCertificateIdentity: [Common getSecIdentityRef]];
    //
    
    req.postBody = [[data copy] autorelease];
    
    req.TIMEOUT(10);
    
    [data release];
    
    
    _offwallArray = [[NSArray alloc] initWithObjects:@"miidi", @"youmi", @"mopan", @"punchbox", @"dianru", @"waps", @"adwo", nil];
    
    _offwallShow = [[NSMutableDictionary alloc] init];
    _offwallOrder = [[NSMutableArray alloc] init];
}

- (void) setLoginStatus : (LoginStatus) status HttpCode:(int)code ErrCode:(int) errCode Msg:(NSString*) msg {
    self->loginStatus = status;
    
    [self sendEvent:status HttpCode:code ErrCode:errCode Msg:msg];
}

-(int) getIndexFromArray:(NSArray*) array name:(NSString*) name {
    int n = 999;
    for ( int i = 0; i < [array count]; i ++ ) {
        NSString* tmp = [array objectAtIndex:i];
        if ( [tmp isEqualToString:name] ) {
            n = i;
            break;
        }
    }
    return n;
}

-(void) adjustOrder:(NSDictionary*) response order:(NSMutableArray*) order {
    NSMutableArray* orderArray = [[[NSMutableArray alloc] init] autorelease];
    NSArray* sort = nil;
    
    if ( [[response allKeys] containsObject:@"__sort"] ) {
        sort = (NSArray*)[response objectForKey:@"__sort"];
    }
    
    for ( int i = 0; i < [_offwallArray count]; i ++ ) {
        NSString* name = [_offwallArray objectAtIndex:i];
        
        if ( [[response allKeys] containsObject:name] ) {
            [orderArray addObject:name];
        }
    }
    
    NSArray* sortedArray = [orderArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int nIndex1 = [self getIndexFromArray:sort name:obj1];
        int nIndex2 = [self getIndexFromArray:sort name:obj2];
        
        if ( nIndex1 < nIndex2 ) {
            return -1;
        } else {
            return 1;
        }
    }];
    
    for ( int i = 0; i < [sortedArray count]; i ++ ) {
        NSString* value = [sortedArray objectAtIndex:i];
        
        [order addObject:value];
    }
}

- (void) handleRequest:(BeeHTTPRequest *)req {
    if ( req.sending) {
    } else if ( req.recving ) {
    } else if ( req.failed ) {
        //统计]
        [MobClick event:@"http_request_failed" attributes:@{@"url":[req.url absoluteString],@"status_code":[NSString stringWithFormat:@"%d",req.responseStatusCode]}];
        [MobClick event:@"login_failed" attributes:@{@"reason":@"服务器状态码错误",@"status_code":[NSString stringWithFormat:@"%d",req.responseStatusCode]}];
        
        //
        [self setLoginStatus:Login_Error HttpCode:req.responseStatusCode ErrCode:0 Msg:nil];
    } else if ( req.succeed ) {
        // 判断返回数据是
        
        NSError* error;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:req.responseData options:NSJSONReadingMutableLeaves error:&error];
        if ( dict == nil || [dict count] == 0 ) {
            [self setLoginStatus:Login_Error HttpCode:req.responseStatusCode ErrCode:0 Msg:nil];
        } else {
            NSNumber* res = [dict valueForKey:@"res"];
            if ( [res intValue] == 0 ) {
                _userid = [[dict valueForKey:@"userid"] copy];
                _session_id = [[dict valueForKey:@"session_id"] copy];
                _nickname = [[dict valueForKey:@"nickname"] copy];
                _device_id = [[dict valueForKey:@"device_id"] copy];
                _phoneNum = [[dict valueForKey:@"phone"] copy];
                _tipsString = [[dict valueForKey:@"tips"] copy];
                if ([_tipsString length] == 0)
                {
                    _tipsString = @"";
                }
                
                NSNumber* num = [dict valueForKey:@"balance"];
                int nOldBalance = _balance;
                
                _balance = [num intValue];
                num = [dict valueForKey:@"income"];
                _income = [num intValue];
                
                num = [dict valueForKey:@"outgo"];
                _outgo = [num intValue];
                
                num = [dict valueForKey:@"recent_income"];
                _recentIncome = [num intValue];
                
                _inviter = [[dict valueForKey:@"inviter"] copy];
                _invite_code = [[dict valueForKey:@"invite_code"] copy];
                
                _inviteIncome = [[dict valueForKey:@"shared_income"] intValue];
                _force_update = [[dict valueForKey:@"force_update"] intValue];
                
                _nowithdraw = [[dict valueForKey:@"no_withdraw"] intValue];
                
                _inReview = [[dict valueForKey:@"in_review"] intValue];
              
                _offerwallIncome = [[dict valueForKey:@"offerwall_income"] intValue];
                
                _pollingInterval = [[dict valueForKey:@"polling_interval"] intValue];
                
                if ( _badRateLastWeek != nil ) {
                    [_badRateLastWeek release];
                }
                if ( _badRateYesterday != nil ) {
                    [_badRateYesterday release];
                }
                
                NSDictionary* _badRatingList = [dict valueForKey:@"bad_rating_list"];
                if ( _badRatingList != nil ) {
                    _badRateYesterday = [[_badRatingList valueForKey:@"yesterday"] copy];
                    _badRateLastWeek = [[_badRatingList valueForKey:@"week"] copy];
                }
                
                if ( [[dict allKeys] containsObject:@"umeng_key"] ) {
                    NSString* umengKey = (NSString*)[dict valueForKey:@"umeng_key"];
                    if ( [umengKey length] == 0 ) {
                        [MobClick startWithAppkey:UMENG_KEY];
                    } else {
                        [MobClick startWithAppkey:umengKey];
                        
                        NSString* param = [NSString stringWithFormat:@"%d", _inReview];
                        [MobClick event:@"login" attributes:@{@"param":param}];
                    }
                } else {
                    [MobClick startWithAppkey:UMENG_KEY];
                }
                AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                if(delegate.isLaunchFromLocalNotification)
                {
                    [MobClick event:@"launch_from_notification"];
                }
                if ( _pollingInterval < 5 ) {
                    _pollingInterval = 5;
                }

                if ( _inReview == 1 ) {
                    [YouMiConfig setIsTesting:YES];
                    // 初始化电商墙
                    [EcomConfig setIsTesting:NO];
                    [EcomConfig setUserID:@"thisisuser"];
                    [EcomConfig launchWithAppID:@"76f21df6134acdee" appSecret:@"b914719dcac278e9"];
                    
                    [ECManager ecWallPreload];
                }
                
                if ( _offwallOrder != nil ) {
                    [_offwallOrder release];
                }
                if ( _offwallShow != nil ) {
                    [_offwallShow release];
                }
                
                _offwallShow = [[NSMutableDictionary alloc] init];
                _offwallOrder = [[NSMutableArray alloc] init];
                
                NSDictionary* offerwall = [dict valueForKey:@"offerwall"];
                [self adjustOrder:offerwall order:_offwallOrder];
                
                for ( int i = 0; i < [_offwallOrder count]; i ++ ) {
                    NSString* name = [_offwallOrder objectAtIndex:i];
                    int nValue = [[offerwall valueForKey:name] intValue];
                    [_offwallShow setObject:[NSNumber numberWithInt:nValue] forKey:name];
                }
                
                // todo: test
                [self test];
                //
                
                
                [self initWithDraw:dict];
                
                int userLevel = [[dict valueForKey:@"level"] intValue];
                int currentEXP = [[dict valueForKey:@"exp_current"] intValue];
                int nextLevelEXP = [[dict valueForKey:@"exp_next_level"] intValue];
                int benefit = [[dict valueForKey:@"benefit"] intValue];
                
                if (userLevel > 0)
                {
                    [[LoginAndRegister sharedInstance] setUserLevel:userLevel];
                    [[LoginAndRegister sharedInstance] setCurrentExp:currentEXP];
                    [[LoginAndRegister sharedInstance] setNextLevelExp:nextLevelEXP];
                    if (benefit > 0)
                    {
                        [[LoginAndRegister sharedInstance] setBenefit:benefit];
                    }
                }
                
                NSArray* taskList = [dict objectForKey:@"task_list"];
                
                [[CommonTaskList sharedInstance] resetTaskListWithJsonArray:taskList];

                
                [[QuestViewController sharedInstance] requestList];
                [[WangcaiTaskViewController sharedInstance] requestList];
                
                [self RegisterDeviceIDToAPService];
                if ( _inReview != 1 ) {
                    [[QuestViewController sharedInstance] requestList];
                    [[WangcaiTaskViewController sharedInstance] requestList];
                    [self RegisterDeviceIDToAPService];
                }
                
                [self setLoginStatus:Login_Success HttpCode:req.responseStatusCode ErrCode:[res intValue] Msg:nil];
                
                if ( _firstLogin ) {
                    _firstLogin = NO;
                } else {
                    // 钱币变化的通知
                    if ( nOldBalance != _balance ) {
                        [self fire_balanceChanged:nOldBalance New:_balance];
                    }
                }
            } else {
                NSString* err = [[dict valueForKey:@"msg"] copy];
                
                [MobClick event:@"login_failed" attributes:@{@"reason":[err length]==0?@"服务器状态码错误":err,@"device_idfa":[Common getIDFAAddress],@"res":[res stringValue]}];
                
                [self setLoginStatus:Login_Error HttpCode:req.responseStatusCode ErrCode:[res intValue] Msg:err];
            }
        }
    }
}

-(void) test {
    //[_offwallOrder pushHead:@"adwo"];
    //[_offwallShow setObject:[NSNumber numberWithInt:1] forKey:@"adwo"];
    
    //[_offwallShow setObject:[NSNumber numberWithInt:3] forKey:@"waps"];
    
    //[_offwallShow setObject:[NSNumber numberWithInt:0] forKey:@"youmi"];
    
    //[_offwallOrder pushHead:@"dianru"];
    //[_offwallShow setObject:[NSNumber numberWithInt:1] forKey:@"dianru"];
}

-(NSArray*) getOfferwallList {
    return _offwallOrder;
}

- (void) initWithDraw:(NSDictionary*) dict {
    NSArray* withDraw = (NSArray*)[dict valueForKey:@"withdraw_config"];
    if ( withDraw == nil ) {
        return ;
    }
    
    if ( _aliPay != nil ) {
        [_aliPay release];
    }
    if ( _qbiPay != nil ) {
        [_qbiPay release];
    }
    if ( _phonePay != nil ) {
        [_phonePay release];
    }
    
    for (int i = 0; i < [withDraw count]; i ++ ) {
        NSDictionary* item = (NSDictionary*)[withDraw objectAtIndex:i];
        int nType = [[item objectForKey:@"type"] intValue];
        if ( nType == 1 ) {
            // 支付宝
            _aliPay = [(NSArray*)[item objectForKey:@"info"] copy];
        } else if ( nType == 2 ) {
            // 话费
            _phonePay = [(NSArray*)[item objectForKey:@"info"] copy];
        } else if ( nType == 4 ) {
            // Q币
            _qbiPay = [(NSArray*)[item objectForKey:@"info"] copy];
        }
    }
}

-(NSArray*) getBadRateYesterday {
    return _badRateYesterday;
}

-(NSArray*) getBadRateLastWeek {
    return _badRateLastWeek;
}

-(int) getPollingInterval {
    return _pollingInterval;
}

-(int) getUserLevel
{
    return _userLevel;
}

-(void) setUserLevel:(int)level
{
    if (_userLevel != 0 && level > _userLevel)
    {
        _hasLevelUp = YES;
    }
    if (_benefit == 0)
    {
        _benefit = level;
    }
    _userLevel = level;
}

-(int) getCurrentExp
{
    return _currentEXP;
}

-(void) setCurrentExp:(int)exp
{
    _currentEXP = exp;
}

-(int) getNextLevelExp
{
    return _nextLevelEXP;
}

-(void) setNextLevelExp:(int)exp
{
    _nextLevelEXP = exp;
}

-(int) getBenefit
{
    return _benefit;
}

-(void) setBenefit:(int)benefit
{
    _benefit = benefit;
}

-(BOOL)checkAndConsumeLevel
{
    BOOL ret = NO;
    if (_hasLevelUp)
    {
        ret = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameLevelUp object:nil];
    }
    _hasLevelUp = NO;
    return ret;
}

-(BOOL) isInReview {
    if ( _inReview == 1 ) {
        return YES;
    }
    return NO;
}

-(void)RegisterDeviceIDToAPService {
    NSString* deviceid = [[LoginAndRegister sharedInstance] getDeviceId];
    if ( deviceid != nil ) {
        [APService setTags:[NSSet setWithObjects:nil] alias:deviceid callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
    }
    
    if ( deviceid != nil ) {
        [deviceid release];
    }
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    /*
    if (DEBUG_PUSH)
    {
        [UtilityFunctions debugAlertView:@"推送测试（正式版不出现）" content:[NSString stringWithFormat:@"[Push] 收到通知, tags:\[{\n%@\n}]\",\n alias:\[{\n%@\n}]\"",tags,alias]];
    }
     */
}

-(int) getForceUpdate {
    return _force_update;
}

-(void) increaseBalance:(int) inc {
    int oldBalance = _balance;
    _balance = _balance + inc;
    
    if ( inc > 0 ) { //总收入
        _income = _income + inc;
    } else {
        _outgo = _outgo - inc;
    }
    
    [self fire_balanceChanged:oldBalance New:_balance];
}

-(void) setBalance:(int) balance {
    if ( balance != _balance ) {
        int oldBalance = _balance;
        _balance = balance;
    
        [self fire_balanceChanged:oldBalance New:_balance];
    }
}

-(void) setShareIncome:(int) nShareIncome {
    self->_inviteIncome = nShareIncome;
}
-(void) setInviter:(NSString*) inviter {
    if ( inviter ==nil || [inviter length] == 0 ) {
        return ;
    }
    
    if ( _inviter != nil ) {
        [_inviter release];
    }
    _inviter = [inviter copy];
}

-(void) fire_balanceChanged:(int) old New:(int) balance {
    BalanceInfo* info = [[BalanceInfo alloc]init];
    info._newBalance = balance;
    info._newBalance = old;
    [self postNotification:@"balanceChanged" withObject:info];
    [info release];
    
    for ( int i = 0; i < [_delegateBalanceArray count]; i ++ ) {
        id delegate = [_delegateBalanceArray objectAtIndex:i];
        [delegate balanceChanged:old New:balance];
    }
}

-(void) fire_bindPhoneEvent {
    for ( int i = 0; i < [_delegateArray count]; i ++ ) {
        id delegate = [_delegateArray objectAtIndex:i];
        [delegate bindPhoneCompeted];
    }
}

-(void) attachBindPhoneEvent : (id) delegate {
    [_delegateArray addObject:[delegate retain]];
}

-(void) detachBindPhoneEvent : (id) delegate {
    [_delegateArray removeObject:delegate];
    [delegate release];
}

-(void) attachBalanceChangeEvent : (id) delegate {
    [_delegateBalanceArray addObject:[delegate retain]];
}

-(void) detachBalanceChangeEvent : (id) delegate {
    [_delegateBalanceArray removeObject:delegate];
    [delegate release];
}

-(void) attachPhone : (NSString*) phoneNum UserId:(NSString*) userid InviteCode:(NSString*) inviteCode {
    if ( _invite_code != nil ) {
        [_invite_code release];
    }
    
    _invite_code = [inviteCode copy];
    
    if ( _phoneNum != nil ) {
        [_phoneNum release];
    }
    
    _phoneNum = [phoneNum copy];
    
    if ( _userid != nil ) {
        [_userid release];
    }
    
    _userid = [userid copy];
    
    [self fire_bindPhoneEvent];
}

-(NSString*) getPhoneNum {
    if ( self->_phoneNum == nil ) {
        return nil;
    }
    return [self->_phoneNum copy];
}

-(NSString*) getUserId  {
    if ( self->_userid == nil ) {
        return nil;
    }
    return [self->_userid copy];
}

-(NSString*) getSessionId  {
    if ( self->_session_id == nil ) {
        return nil;
    }
    return [self->_session_id copy];
}

-(NSString*) getNickName  {
    if ( self->_nickname == nil ) {
        return nil;
    }
    return [self->_nickname copy];
}

-(NSString*) getDeviceId  {
    if ( self->_device_id == nil ) {
        return nil;
    }
    return [self->_device_id copy];
}

-(int) getBalance {
    return _balance;
}

-(NSString*) getInviteCode {
    if ( self->_invite_code== nil ) {
        return nil;
    }
    return [self->_invite_code copy];
}

-(NSString*) getInviter {
    if ( self->_inviter== nil ) {
        return nil;
    }
    return [self->_inviter copy];
}

-(int) getIncome {
    return _income;
}

-(int) getOutgo {
    return _outgo;
}

-(void) setIncome:(int) income {
    _income = income;
}

-(void) setOutgo:(int) outgo {
    _outgo = outgo;
}

-(int) getRecentIncome {
    return _recentIncome;
}

-(int) getInviteIncome {
    return _inviteIncome;
}



-(BOOL) isShowOfferwall:(NSString*) offerwall {
    int nValue = [[_offwallShow objectForKey:offerwall] intValue];
    
    if ( nValue == 0 ) {
        return NO;
    }
    return YES;
}

-(BOOL) isInMoreOfferwall:(NSString*) offerwall {
    int nValue = [[_offwallShow objectForKey:offerwall] intValue];
    
    if ( nValue == 3 ) {
        return YES;
    }
    return NO;
    
}

-(BOOL) isRecommendOfferwall:(NSString*) offerwall {
    int nValue = [[_offwallShow objectForKey:offerwall] intValue];
    
    if ( nValue == 2 ) {
        return YES;
    }
    return NO;
}

-(int) getNoWithDraw {
    return _nowithdraw;
}

-(NSString*) getTipsStrings
{
    return _tipsString;
}

-(int) getOfferwallIncome {
    return _offerwallIncome;
}

-(NSArray*) getPhonePay {
    return _phonePay;
}

-(NSArray*) getAlipay {
    return _aliPay;
}

-(NSArray*) getQbiPay {
    return _qbiPay;
}

@end
