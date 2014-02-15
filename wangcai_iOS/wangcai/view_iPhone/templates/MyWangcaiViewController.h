//
//  MyWangcaiViewController.h
//  wangcai
//
//  Created by Lee Justin on 14-2-15.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWangcaiViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    BeeUIStack* _beeStack;
}

- (void)setUIStack : (BeeUIStack*) beeStack;

@property (nonatomic,retain) IBOutlet UITableView* tableView;
@property (nonatomic,retain) IBOutlet UIImageView* dogImageView;
@property (nonatomic,retain) IBOutlet UIImageView* jingyanView;
@property (nonatomic,retain) IBOutlet UIImageView* jingyan2View;
@property (nonatomic,retain) IBOutlet UILabel* dengjiNumLabel;
@property (nonatomic,retain) IBOutlet UILabel* jiachengInfoLabel;
@property (nonatomic,retain) IBOutlet UIView* bingphoneTipsView;
@property (nonatomic,retain) IBOutlet UITableViewCell* dogCell;

- (IBAction)onPressedBindPhone:(id)sender;
- (IBAction)onPressedBack:(id)sender;

- (void)setLevel:(int)level;
- (void)setEXP:(float)EXP withAnimation:(BOOL)animated; //经验：0-1

@end
