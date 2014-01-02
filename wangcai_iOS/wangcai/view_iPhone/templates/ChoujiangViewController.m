//
//  ChoujiangViewController.m
//  wangcai
//
//  Created by Lee Justin on 13-12-30.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "ChoujiangViewController.h"

@interface ChoiceMoveNode : NSObject

@property (nonatomic,assign) float timeSec;
@property (nonatomic,assign) int fromIndex;
@property (nonatomic,assign) int toIndex;

@end

@implementation ChoiceMoveNode

@end


@interface ChoujiangViewController () {
    NSArray* _choiceViews;
    int _beilv;
    NSMutableArray* _animaNodes;
    int _shineCount;
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
    srand(time(NULL));
    int target = rand()%12;
    [self startChoiceAnimations:target];
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
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"恭喜您中奖了！" message:@"中了好多好多钱啊！！！" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    
    [alertView show];
}

#pragma mark -- <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
@end
