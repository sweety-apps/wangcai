//
//  ExchangeController.h
//  wangcai
//
//  Created by 1528 on 13-12-18.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    UITableViewCell* _cell;
    UITableView* _tableView;
    BeeUIStack* _beeStack;
    
    UIView*  _noattachView;
}

- (id)init;

- (void) setUIStack :(BeeUIStack*) stack;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickExchangeInfo:(id)sender;
- (IBAction)clickAttachPhone:(id)sender;

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
@end