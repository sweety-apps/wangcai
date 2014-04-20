//
//  CommonTaskTableViewCell.m
//  wangcai
//
//  Created by Lee Justin on 13-12-15.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "CommonTaskTableViewCell.h"

@implementation CommonTaskTableViewCell

@synthesize taskCellType = _taskCellType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _taskCellType = CommonTaskTableViewCellShowTypeRedTextUp;
        _leftIcon = [[BeeUIImageView alloc] initWithFrame:CGRectZero];
        _bottomLineImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _redBagIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _finshedIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _redLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _blackLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _finishedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _bottomLineImage.image = [UIImage imageNamed:@"table_view_cell_line"];
        
        
        _leftIcon.contentMode = UIViewContentModeScaleToFill;
        
        //_redLabel.textColor = [UIColor colorWithRed:255.f/255.f green:102.f/255.f blue:0.f/255.f alpha:1.0];
        _redLabel.textColor = RGB(0, 0, 0);
        _redLabel.backgroundColor = [UIColor clearColor];
        _redLabel.textAlignment = NSTextAlignmentLeft;
        _redLabel.font = [UIFont systemFontOfSize:16];
        
        _blackLabel.textColor = RGB(156, 156, 156);
        _blackLabel.backgroundColor = [UIColor clearColor];
        _blackLabel.textAlignment = NSTextAlignmentLeft;
        _blackLabel.font = [UIFont systemFontOfSize:9];
        
        _finishedLabel.backgroundColor = [UIColor clearColor];
        _finishedLabel.text = @"已完成";
        _finishedLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        _finishedLabel.textAlignment = NSTextAlignmentLeft;
        
        //抗锯齿
        //_leftIcon.layer.shouldRasterize = YES;
        //_leftIcon.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
        //_leftIcon.layer.masksToBounds = YES;
        
        //_redBagIcon.layer.shouldRasterize = YES;
        //_redBagIcon.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
        //_redBagIcon.layer.masksToBounds = YES;
        
        _redBagIcon.contentMode = UIViewContentModeCenter;
        
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_bottomLineImage];
        [self.contentView addSubview:_leftIcon];
        [self.contentView addSubview:_redBagIcon];
        [self.contentView addSubview:_redLabel];
        [self.contentView addSubview:_blackLabel];
        [self.contentView addSubview:_finshedIcon];
        [self.contentView addSubview:_finishedLabel];
        
        _taskState = CommonTaskTableViewCellStateUnfinish;
        
        [self resetSubViews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_leftIcon release];
    [_redLabel release];
    [_finshedIcon release];
    [_blackLabel release];
    [_redBagIcon release];
    [_bottomLineImage release];
    [super dealloc];
}

- (void)resetSubViews
{
    CGRect rectFrame = CGRectZero;
    
    rectFrame = CGRectMake(14, 21, 39, 39);
    _leftIcon.frame = rectFrame;
    
    rectFrame = CGRectMake(0, 73, 320, 1);
    _bottomLineImage.frame = rectFrame;
    
    rectFrame = CGRectMake(224, 10, 79, 60);
    _redBagIcon.frame = rectFrame;
    
    rectFrame = CGRectMake(250, 24, 60, 30);
    _finishedLabel.frame = rectFrame;
    
    if (_taskCellType == CommonTaskTableViewCellShowTypeRedTextUp)
    {
        rectFrame = CGRectMake(77, 25, 170, 16);
        _redLabel.frame = rectFrame;
        rectFrame = CGRectMake(77, 48, 170, 9);
        _blackLabel.frame = rectFrame;
    }
    else
    {
        rectFrame = CGRectMake(77, 25, 170, 9);
        _blackLabel.frame = rectFrame;
        rectFrame = CGRectMake(77, 41, 170, 16);
        _redLabel.frame = rectFrame;
    }
    
    switch (_taskState)
    {
        case CommonTaskTableViewCellStateUnfinish:
        case CommonTaskTableViewCellStateDoing:
            [self getUpLabel].textColor = RGB(0, 0, 0);
            [self getDownLabel].textColor = RGB(156, 156, 156);
            _finishedLabel.textColor = RGB(156, 156, 156);
            _finishedLabel.hidden = YES;
            _redBagIcon.hidden = NO;
            break;
            
        case CommonTaskTableViewCellStateFinished:
            [self getUpLabel].textColor = RGB(156, 156, 156);
            [self getDownLabel].textColor = RGB(156, 156, 156);
            _finishedLabel.textColor = RGB(156, 156, 156);
            _finishedLabel.hidden = NO;
            _redBagIcon.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (NSString*)getUpText
{
    if (_taskCellType == CommonTaskTableViewCellShowTypeRedTextUp)
    {
        return _redLabel.text;
    }
    else
    {
        return _blackLabel.text;
    }
}

- (void)setUpText:(NSString*)text
{
    if (_taskCellType == CommonTaskTableViewCellShowTypeRedTextUp)
    {
        _redLabel.text = text;
    }
    else
    {
        _blackLabel.text = text;
    }
}

- (NSString*)getDownText
{
    if (_taskCellType == CommonTaskTableViewCellShowTypeRedTextUp)
    {
        return _blackLabel.text;
    }
    else
    {
        return _redLabel.text;
    }
}

- (void)setDownText:(NSString*)text
{
    if (_taskCellType == CommonTaskTableViewCellShowTypeRedTextUp)
    {
        _blackLabel.text = text;
    }
    else
    {
        _redLabel.text = text;
    }
}

- (void)setRedBagIcon:(NSString*)imageName
{
    [_redBagIcon setImage:[UIImage imageNamed:imageName]];
}

- (void)setLeftIconUrl:(NSString*)imageUrl
{
    UIImage* cachedImage = [[BeeImageCache sharedInstance] imageForURL:imageUrl];
    _leftIcon.layer.cornerRadius = 8.0f;
    if (cachedImage != nil)
    {
        [_leftIcon setImage:cachedImage];
    }
    else
    {
        [_leftIcon GET:imageUrl useCache:YES];
    }
}

- (void)setLeftIconNamed:(NSString*)imageName
{
    _leftIcon.layer.cornerRadius = 0.0f;
    [_leftIcon setImage:[UIImage imageNamed:imageName]];
}

- (void)setFinishedIcon:(NSString*)imageName
{
    [_finshedIcon setImage:[UIImage imageNamed:imageName]];
}

- (void)hideFinishedIcon:(BOOL)hidden
{
    _finshedIcon.hidden = hidden;
    _finishedLabel.hidden = hidden;
}

- (BOOL)isFinishedIconHidden
{
    return _finshedIcon.hidden;
}

- (void)setTaskCellType:(NSInteger)taskCellType
{
    _taskCellType = taskCellType;
    [self resetSubViews];
}

- (UILabel*)getUpLabel
{
    if (_taskCellType == CommonTaskTableViewCellShowTypeRedTextUp)
    {
        return _redLabel;
    }
    return _blackLabel;
}

- (UILabel*)getDownLabel
{
    if (_taskCellType == CommonTaskTableViewCellShowTypeRedTextUp)
    {
        return _blackLabel;
    }
    return _redLabel;
}

- (CommonTaskTableViewCellState)getCellState
{
    return _taskState;
}

- (void)setCellState:(CommonTaskTableViewCellState)state
{
    _taskState = state;
    [self resetSubViews];
}

@end
