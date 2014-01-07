//
//  ChoujiangViewController.m
//  wangcai
//
//  Created by Lee Justin on 13-12-30.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "ChoujiangViewController.h"
#import "ChoujiangLogic.h"
#import "MBHUDView.h"
#import <ShareSDK/ShareSDK.h>

@interface ChoiceMoveNode : NSObject

@property (nonatomic,assign) float timeSec;
@property (nonatomic,assign) int fromIndex;
@property (nonatomic,assign) int toIndex;

@end

@implementation ChoiceMoveNode

@end


@interface ChoujiangViewController () <ChoujiangLogicDelegate> {
    NSArray* _choiceViews;
    int _beilv;
    NSMutableArray* _animaNodes;
    int _shineCount;
    int _choiceIndex;
}

@end

@implementation ChoujiangViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _choiceViews = [[NSArray arrayWithObjects:self.choice0,self.choice1,self.choice2,self.choice3,self.choice4,self.choice5,self.choice6,self.choice7,self.choice8,self.choice9,self.choice10,self.choice11, nil] retain];
    _beilv = 1;
    
    self.choiceBorder.hidden = YES;
    self.choiceCover.hidden = YES;
    
    [self resetViews];
}

- (void)dealloc
{
    [_choiceViews release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBeiLv:(int)beilvNum
{
    _beilv = beilvNum;
}

- (int)getBeiLv
{
    return _beilv;
}

- (IBAction)onPressedStartButton:(id)sender
{
    if ([[ChoujiangLogic sharedInstance] getAwardCode] == kGetAwardTypeNotGet)
    {
        self.startButton.enabled = NO;
        [MBHUDView hudWithBody:@"" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:10000000000.f show:YES];
        [[ChoujiangLogic sharedInstance] requestChoujiang:self];
    }
    else
    {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"您今天已经签到过了" message:@"明天记得再来签到哟！" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

- (IBAction)onPressedBackButton:(id)sender
{
    [self.stack popViewControllerAnimated:YES];
}

- (void)resetViews
{
    //倍率
    NSString* beilvs[3] = {@"choujiang_x1",@"choujiang_x2",@"choujiang_x3"};
    if (_beilv > 0)
    {
        beilvs[_beilv-1]= [beilvs[_beilv - 1] stringByAppendingString:@"selected"];
    }
    self.beilv1x.image = [UIImage imageNamed:beilvs[0]];
    self.beilv2x.image = [UIImage imageNamed:beilvs[1]];
    self.beilv3x.image = [UIImage imageNamed:beilvs[2]];
    
    //奖项
    NSString* jiangxiang[12] = {
        @"choujiang_shaxuan",
        @"choujiang_5mao",
        @"choujiang_thanks1",
        @"choujiang_baojie",
        @"choujiang_8yuan",
        @"choujiang_thanks2",
        @"choujiang_thanks1",
        @"choujiang_3yuan",
        @"choujiang_thanks3",
        @"choujiang_xiaomi",
        @"choujiang_1mao",
        @"choujiang_thanks4"
    };
    
    for (int i = 0; i < [_choiceViews count]; ++i)
    {
        UIImageView* choiceView = [_choiceViews objectAtIndex:i];
        choiceView.image = [UIImage imageNamed:jiangxiang[i]];
    }
}

- (void)startChoiceAnimations:(int)targetNum
{
    if (!_hasStarted)
    {
        _hasStarted = YES;
        _choiceIndex = targetNum;
        srand(time(NULL));
        int round = rand()%2;
        round += 3;
        
        float startInterval = 0.15f;
        float endInterval = 1.8f;
        
        NSMutableArray* animaNodes = [NSMutableArray array];
        
#define startRounds (3)
        
        for (int i = 0; i < startRounds; ++i)
        {
            for (int j = 0; j < [_choiceViews count]; ++j)
            {
                ChoiceMoveNode* node = [[[ChoiceMoveNode alloc] init] autorelease];
                node.timeSec = startInterval;
                node.fromIndex = j % [_choiceViews count];
                node.toIndex = (j+1) % [_choiceViews count];
                [animaNodes addObject:node];
            }
        }
        
        round -= startRounds;
        
        int  moveSteps = round * [_choiceViews count] + targetNum;
        float increaseStep = (endInterval - startInterval) / ((float)moveSteps);
        float currentInterval = startInterval;
        for (int i = 0; i < moveSteps; ++i)
        {
            ChoiceMoveNode* node = [[[ChoiceMoveNode alloc] init] autorelease];
            node.timeSec = currentInterval;
            node.fromIndex = i % [_choiceViews count];
            node.toIndex = (i+1) % [_choiceViews count];
            [animaNodes addObject:node];
            
            currentInterval += increaseStep;
        }
        
        if (_animaNodes)
        {
            [_animaNodes release];
            _animaNodes = nil;
        }
        _animaNodes = [animaNodes retain];
        
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(onAnimaNodeStep) userInfo:nil repeats:NO];
    }
}

- (void)onAnimaNodeStep
{
    if ([_animaNodes count]>0)
    {
        ChoiceMoveNode* node = [[_animaNodes objectAtIndex:0] retain];
        self.choiceBorder.hidden = YES;
        self.choiceCover.hidden = NO;
        
        CGRect rectChoiceIndex = ((UIImageView*)[_choiceViews objectAtIndex:node.toIndex]).frame;
        self.choiceCover.frame = rectChoiceIndex;
        
        [_animaNodes removeObjectAtIndex:0];
        
        [NSTimer scheduledTimerWithTimeInterval:node.timeSec target:self selector:@selector(onAnimaNodeStep) userInfo:nil repeats:NO];
        
        [node release];
    }
    else if ([_animaNodes count] == 0)
    {
        [self onFinishedAnima];
    }
}

- (void)onFinishedAnima
{
    self.choiceCover.hidden = YES;
    self.choiceBorder.hidden = NO;
    
    CGRect rect = self.choiceCover.frame;
    rect.origin.x -= 4;
    rect.origin.y -= 4;
    rect.size.width = self.choiceBorder.frame.size.width;
    rect.size.height = self.choiceBorder.frame.size.height;
    self.choiceBorder.frame = rect;
    _shineCount = 4;
    
    [self onShineBlock0];
}

- (void)onShineBlock0
{
    if (_shineCount > 0)
    {
        self.choiceBorder.image = [UIImage imageNamed:@"choujiang_border_selected1"];
        _shineCount --;
        [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(onShineBlock1) userInfo:nil repeats:NO];
    }
    else
    {
        [self onFinishedChoice];
    }
}

- (void)onShineBlock1
{
    self.choiceBorder.image = [UIImage imageNamed:@"choujiang_border_selected2"];
    [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(onShineBlock0) userInfo:nil repeats:NO];
}

- (void)onFinishedChoice
{
    NSString* title = @"";
    NSString* msg = @"";
    switch (_choiceIndex)
    {
        case 2:
        case 5:
        case 6:
        case 8:
        case 11:
            //没中
            title = @"旺财你不给力啊:(";
            msg = @"两手空空";
            break;
        case 10:
            //1毛
            title = @"恭喜您中奖了！";
            msg = @"1毛";
            break;
        case 1:
            //5毛
            title = @"恭喜您中奖了！";
            msg = @"5毛";
            break;
        case 7:
            //3元
            title = @"恭喜您中奖了！";
            msg = @"3元";
            break;
        case 4:
            //8元
            title = @"恭喜您中奖了！";
            msg = @"8元";
            break;
            
        default:
            break;
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"返回" otherButtonTitles:/*@"分享",*/ nil];
    
    [alertView show];
}


#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            //返回
            [self onPressedBackButton:self.backButton];
            break;
        case 1:
            //分享
        {
            id<ISSContent> publishContent = [ShareSDK content:@"http://wangcai.meme-da.com" defaultContent:@"http://wangcai.meme-da.com" image: nil title: @"旺财分享" url:@"http://wangcai.meme-da.com" description: @"旺财分享" mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK showShareActionSheet: nil shareList: nil content: publishContent statusBarTips: YES authOptions: nil shareOptions: nil result: ^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
             {
                 if (state == SSResponseStateSuccess)
                 {
                     // todo 分享成功
                 }
                 else if (state == SSResponseStateFail)
                 {
                     // todo 分享失败
                 }
             }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - <ChoujiangLogicDelegate>

- (void)onFinishedChoujiangRequest:(ChoujiangLogic*)logic isRequestSucceed:(BOOL)isSucceed awardCode:(GetAwardType)awardCode resultCode:(NSInteger)result msg:(NSString*)msg
{
    [MBHUDView dismissCurrentHUD];
    if (isSucceed)
    {
        if (result == 0)
        {
            if (awardCode == kGetAwardTypeAlreadyGot)
            {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"您今天已经签到过了" message:@"明天记得再来签到哟！" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil] autorelease];
                [alert show];
            }
            else
            {
                int target = 0;
                switch (awardCode)
                {
                    case kGetAwardTypeNothing:
                    {
                        int indexs[5] = {2,5,6,8,11};
                        srand(time(NULL));
                        target = indexs[rand()%5];
                    }
                        break;
                    case kGetAwardType1Mao:
                    {
                        int indexs[1] = {10};
                        srand(time(NULL));
                        target = indexs[rand()%1];
                    }
                        break;
                    case kGetAwardType5Mao:
                    {
                        int indexs[1] = {1};
                        srand(time(NULL));
                        target = indexs[rand()%1];
                    }
                        break;
                    case kGetAwardType3Yuan:
                    {
                        int indexs[1] = {7};
                        srand(time(NULL));
                        target = indexs[rand()%1];
                    }
                        break;
                    case kGetAwardType8Yuan:
                    {
                        int indexs[1] = {4};
                        srand(time(NULL));
                        target = indexs[rand()%1];
                    }
                        break;
                        
                    default:
                        break;
                }
                [self startChoiceAnimations:target];
            }
        }
        else
        {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"请求失败" message:msg delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
    else
    {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"网络请求失败" message:@"网络有点问题，请过一会儿再试:(" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

@end
