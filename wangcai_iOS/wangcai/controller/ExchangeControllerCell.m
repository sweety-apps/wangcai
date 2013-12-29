//
//  ExchangeControllerCell.m
//  wangcai
//
//  Created by 1528 on 13-12-18.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "ExchangeControllerCell.h"

@implementation ExchangeControllerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
        [self addSubview:_view];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 48, 48)];
        [_view addSubview:_imageView];
        
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(66, 9, 160, 20)];
        [_view addSubview:_labelTitle];
        _labelTitle.font = [UIFont systemFontOfSize:12];
        
        _labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(66, 37, 76, 20)];
        [_view addSubview:_labelPrice];
        _labelPrice.font = [UIFont systemFontOfSize:12];
        [_labelPrice setTextColor:[UIColor colorWithRed:164.0/255 green:164.0/255 blue:164.0/255 alpha:1]];
        
        _labelNum = [[UILabel alloc] initWithFrame:CGRectMake(150, 37, 76, 20)];
        [_view addSubview:_labelNum];
        _labelNum.font = [UIFont systemFontOfSize:12];
        [_labelNum setTextColor:[UIColor colorWithRed:164.0/255 green:164.0/255 blue:164.0/255 alpha:1]];
        
        _btnExchange = [[UIButton alloc]initWithFrame:CGRectMake(225, 12, 75, 27)];
        [_view addSubview:_btnExchange];
        
        [_btnExchange setImage:[UIImage imageNamed:@"exchange_btn"] forState:UIControlStateNormal];
        
        
        _imageView.image = [UIImage imageNamed:@"menu-icon-red"];
        _labelTitle.text = @"小米3 F码 购买资格";
        _labelNum.text = @"剩余：56个";
        _labelPrice.text = @"价格：150";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_imageView release];
    _imageView = nil;
    
    [_btnExchange release];
    _btnExchange = nil;
    
    [_labelTitle release];
    _labelTitle = nil;
    
    [_labelNum release];
    _labelNum = nil;
    
    [_labelPrice release];
    _labelPrice = nil;
    
    [_view release];
    _view = nil;
    
    [super dealloc];
}

- (void)setBkgColor:(UIColor*) clr {
    [_view setBackgroundColor:clr];
}


- (IBAction)onClick:(id)sender {
    
}

@end
