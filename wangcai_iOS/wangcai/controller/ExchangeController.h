//
//  ExchangeController.h
//  wangcai
//
//  Created by 1528 on 13-12-18.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegister.h"
#import "UICustomAlertView.h"
#import "ExchangeControllerCell.h"

@interface ExchangeController : UIViewController<UITableViewDataSource, UITableViewDelegate,
            BindPhoneDelegate, ExchangeControllerCellDelegate, UIAlertViewDelegate> {
    UITableView* _tableView;
    BeeUIStack* _beeStack;
    
    UIView*  _noattachView;
    UILabel* _labelBalance;
    
    UICustomAlertView* _alertView;
    
    UIAlertView*    _alertBindPhone;
    UIAlertView*    _alertNoBalance;
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
