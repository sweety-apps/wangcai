//
//  CommonTaskTableViewCell.h
//  wangcai
//
//  Created by Lee Justin on 13-12-15.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee_UIImageView.h"

typedef NSInteger CommonTaskTableViewCellShowType;

#define CommonTaskTableViewCellShowTypeRedTextUp (0)
#define CommonTaskTableViewCellShowTypeRedTextDown (1)

@interface CommonTaskTableViewCell : UITableViewCell
{
    BeeUIImageView* _leftIcon;
    UIImageView* _finshedIcon;
    UIImageView* _redBagIcon;
    UIImageView* _bottomLineImage;
    UILabel* _redLabel;
    UILabel* _blackLabel;
    UILabel* _finishedLabel;
    NSInteger _taskCellType;
}

@property (nonatomic,assign) NSInteger taskCellType;

- (NSString*)getUpText;
- (void)setUpText:(NSString*)text;

- (NSString*)getDownText;
- (void)setDownText:(NSString*)text;

- (void)setRedBagIcon:(NSString*)imageName;
- (void)setLeftIconUrl:(NSString*)imageUrl;
- (void)setLeftIconNamed:(NSString*)imageName;

- (void)setFinishedIcon:(NSString*)imageName;
- (void)hideFinishedIcon:(BOOL)hidden;
- (BOOL)isFinishedIconHidden;

- (UILabel*)getUpLabel;
- (UILabel*)getDownLabel;

@end
