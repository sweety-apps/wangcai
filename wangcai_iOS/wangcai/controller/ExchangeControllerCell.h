//
//  ExchangeControllerCell.h
//  wangcai
//
//  Created by 1528 on 13-12-18.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExchangeControllerCellDelegate <NSObject>
-(void) onClickExchange : (id) sender;
@end

@interface ExchangeControllerCell : UITableViewCell {
    UIImageView* _imageView;
    UILabel* _labelTitle;
    UILabel* _labelPrice;
    UILabel* _labelNum;
    UIButton* _btnExchange;
    
    UIView* _view;
}

@property (assign, nonatomic) id delegate;

- (void)setBkgColor:(UIColor*) clr;

@end
