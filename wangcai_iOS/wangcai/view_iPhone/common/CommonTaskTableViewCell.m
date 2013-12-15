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
        _backLabelImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _redBagIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _redLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _blackLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _backLabelImage.image = [UIImage imageNamed:@"table_view_cell_label_bg"];
        
        _redLabel.textColor = [UIColor colorWithRed:255.f/255.f green:102.f/255.f blue:0.f/255.f alpha:1.0];
        _redLabel.backgroundColor = [UIColor clearColor];
        _redLabel.textAlignment = NSTextAlignmentLeft;
        _redLabel.font = [UIFont systemFontOfSize:16];
        
        _blackLabel.textColor = [UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:1.0];
        _blackLabel.backgroundColor = [UIColor clearColor];
        _blackLabel.textAlignment = NSTextAlignmentLeft;
        _blackLabel.font = [UIFont systemFontOfSize:9];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        
        [self.contentView addSubview:_backLabelImage];
        [self.contentView addSubview:_leftIcon];
        [self.contentView addSubview:_redBagIcon];
        [self.contentView addSubview:_redLabel];
        [self.contentView addSubview:_blackLabel];
        
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
    [_blackLabel release];
    [_redBagIcon release];
    [_backLabelImage release];
    [super dealloc];
}

- (void)resetSubViews
{
    CGRect rectFrame = CGRectZero;
    
    rectFrame = CGRectMake(14, 21, 39, 39);
    _leftIcon.frame = rectFrame;
    
    rectFrame = CGRectMake(56, 21, 253, 50);
    _backLabelImage.frame = rectFrame;
    
    rectFrame = CGRectMake(250, 3, 53, 60);
    _redBagIcon.frame = rectFrame;
    
    if (_taskCellType == CommonTaskTableViewCellShowTypeRedTextUp)
    {
        rectFrame = CGRectMake(77, 25, 260, 16);
        _redLabel.frame = rectFrame;
        rectFrame = CGRectMake(77, 50, 260, 9);
        _blackLabel.frame = rectFrame;
    }
    else
    {
        rectFrame = CGRectMake(77, 25, 260, 9);
        _blackLabel.frame = rectFrame;
        rectFrame = CGRectMake(77, 41, 260, 16);
        _redLabel.frame = rectFrame;
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
    [_leftIcon GET:imageUrl useCache:YES placeHolder:[UIImage imageNamed:@"table_view_cell_icon_bg"]];
}

- (void)setTaskCellType:(NSInteger)taskCellType
{
    _taskCellType = taskCellType;
    [self resetSubViews];
}

@end
