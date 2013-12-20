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
        _view = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeControllerCell" owner:self options:nil] firstObject];
        [self addSubview:_view];

        _imageView = (UIImageView*)[self viewWithTag:1];
        _labelTitle = (UILabel*)[self viewWithTag:2];
        _labelPrice = (UILabel*)[self viewWithTag:3];
        _labelNum = (UILabel*)[self viewWithTag:4];
        
        //test
        _labelTitle.text = @"小米3 F码 购买资格";
        _imageView.image = [UIImage imageNamed:@"menu-icon-red"];
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
    _imageView = nil;
    _labelTitle = nil;
    _labelPrice = nil;
    _labelNum = nil;
    _btnExchange = nil;
    _view = nil;
    
    [super dealloc];
}

- (void)setBkgColor:(UIColor*) clr {
    [_view setBackgroundColor:clr];
}


- (IBAction)onClick:(id)sender {
    
}

@end
