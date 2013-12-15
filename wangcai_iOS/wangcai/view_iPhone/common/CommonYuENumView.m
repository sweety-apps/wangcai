//
//  CommonYuENumView.m
//  wangcai
//
//  Created by Lee Justin on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "CommonYuENumView.h"

@implementation CommonYuENumView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _digitDict = [[NSMutableDictionary dictionaryWithObjectsAndKeys:@"yue_0",@"0",@"yue_1",@"1",@"yue_2",@"2",@"yue_3",@"3",@"yue_4",@"4",@"yue_5",@"5",@"yue_6",@"6",@"yue_7",@"7",@"yue_8",@"8",@"yue_9",@"9",@"yue_dot",@".", nil] retain];
        _num = 0.f;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void)refreshView
{
    [self removeAllSubviews];
    NSString* numString = [NSString stringWithFormat:@"%.1f",_num];
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

-(void)setNum:(float)num
{
    _num = num;
    [self refreshView];
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
