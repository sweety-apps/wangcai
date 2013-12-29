//
//  UserInfoEditorViewController.h
//  wangcai
//
//  Created by Lee Justin on 13-12-21.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bee.h"
#import "IZValueSelectorView.h"

@interface UserInfoEditorViewController : BeeUIBoard <IZValueSelectorViewDataSource,IZValueSelectorViewDelegate>
{
    CGRect _rectSelectBgView;
}

@property (nonatomic,retain) IBOutlet UIView* upSectionView;
@property (nonatomic,retain) IBOutlet UIView* downSectionView;
@property (nonatomic,retain) IBOutlet UIScrollView* scrollView;

@property (nonatomic,retain) IBOutlet IZValueSelectorView* ageSelectorView;
@property (nonatomic,retain) IBOutlet UIView* selectionContainerView;

@property (nonatomic,retain) IBOutlet UIButton* sexMaleButton;
@property (nonatomic,retain) IBOutlet UIButton* sexFamaleButton;
@property (nonatomic,retain) NSMutableArray* hobbySelectorViews;

- (IBAction)onPressedAttachPhone:(id)btn;
- (IBAction)onPressedBackPhone:(id)btn;

- (IBAction)onPressedMaleButton:(id)btn;
- (IBAction)onPressedFamaleButton:(id)btn;

- (void)showUpSectionView:(BOOL)shouldShow;

@end
