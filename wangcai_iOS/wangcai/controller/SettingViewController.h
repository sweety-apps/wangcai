//
//  SettingViewController.h
//  wangcai
//
//  Created by 1528 on 13-12-25.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    UITableView* _tableView;
    IBOutlet UITableViewCell* _logoCell;
    IBOutlet UITableViewCell* _msgCell;
    IBOutlet UITableViewCell* _bellCell;
    IBOutlet UITableViewCell* _gradeCell;
    
    IBOutlet UISwitch*        _msgSwitch;
}

@property (nonatomic, retain) IBOutlet UITableViewCell* _logoCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* _msgCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* _bellCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* _gradeCell;
@property (nonatomic, retain) IBOutlet UISwitch* _msgSwitch;

- (id)init;

- (IBAction)clickBack:(id)sender;

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
