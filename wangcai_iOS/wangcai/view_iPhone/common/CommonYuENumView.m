//
//  CommonYuENumView.m
//  wangcai
//
//  Created by Lee Justin on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "CommonYuENumView.h"

#define kStepInterval (0.05f)

@implementation CommonYuENumView

- (void)initClassVars
{
    _digitDict = [[NSMutableDictionary dictionaryWithObjectsAndKeys:@"yue_0",@"0",@"yue_1",@"1",@"yue_2",@"2",@"yue_3",@"3",@"yue_4",@"4",@"yue_5",@"5",@"yue_6",@"6",@"yue_7",@"7",@"yue_8",@"8",@"yue_9",@"9",@"yue_dot",@".", nil] retain];
    _num = 0.f;
    _animaArray = [[NSMutableArray array] retain];
    self.backgroundColor = [UIColor clearColor];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initClassVars];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initClassVars];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initClassVars];
    }
    return self;
}

- (void)dealloc
{
    [_digitDict release];
    [_animaArray release];
    [super dealloc];
}

-(void)refreshView
{
    [self _refreshViewWithNum:_num];
}

-(void)_refreshViewWithNum:(float)num
{
    [self removeAllSubviews];
    NSString* numString = [NSString stringWithFormat:@"%.1f",num];
    CGFloat offsetX = self.frame.size.width;
    for (int i = [numString length] - 1; i >= 0; i--)
    {
        NSRange range = {0};
        range.location = i;
        range.length = 1;
        NSString* digitKey = [numString substringWithRange:range];
        
        NSString* imageName = [_digitDict objectForKey:digitKey];
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
        CGRect rect = imageView.frame;
        if ([digitKey isEqualToString:@"."])
        {
            offsetX -= rect.size.width*0.5;
            rect.origin.x = offsetX-rect.size.width*0.25;
        }
        else
        {
            offsetX -= rect.size.width;
            rect.origin.x = offsetX;
        }
        imageView.frame = rect;
        [self addSubview:imageView];
    }
}

- (void)animateStep
{
    if ([_animaArray count] > 0)
    {
        NSNumber* number = [_animaArray objectAtIndex:0];
        [self _refreshViewWithNum:[number floatValue]];
        [_animaArray removeObjectAtIndex:0];
        [NSTimer scheduledTimerWithTimeInterval:kStepInterval target:self selector:@selector(animateStep) userInfo:nil repeats:NO];
    }
}

-(void)setNum:(float)num
{
    [self setNum:num withAnimation:NO];
}

-(void)setNum:(float)num withAnimation:(BOOL)animated
{
    if (animated)
    {
        int count = abs((int)(num * 10.f) - (int)(_num * 10.f));
        if (count > 0)
        {
            float currentNum = _num;
            for (int i = 0; i < count; ++i)
            {
                if (num > _num)
                {
                    currentNum += 0.1;
                }
                else
                {
                    currentNum -= 0.1;
                }
                NSNumber* number = [NSNumber numberWithFloat:currentNum];
                [_animaArray addObject:number];
            }
        }
        _num = num;
        [NSTimer scheduledTimerWithTimeInterval:kStepInterval target:self selector:@selector(animateStep) userInfo:nil repeats:NO];
    }
    else
    {
        _num = num;
        [self refreshView];
    }
}

-(void)animateNumFrom:(float)oldNum to:(float)num withAnimation:(BOOL)animated
{
    [self setNum:oldNum];
    [self setNum:num withAnimation:animated];
}

-(float)getNum
{
    return _num;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
