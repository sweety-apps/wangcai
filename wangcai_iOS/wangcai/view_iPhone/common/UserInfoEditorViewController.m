//
//  UserInfoEditorViewController.m
//  wangcai
//
//  Created by Lee Justin on 13-12-21.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "UserInfoEditorViewController.h"
#import "PhoneValidationController.h"

@interface UserInfoEditorViewController ()

@end

@implementation UserInfoEditorViewController

@synthesize upSectionView;
@synthesize downSectionView;
@synthesize scrollView;

@synthesize segmentView;
@synthesize ageSelectorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.ageSelectorView.backgroundColor = [UIColor clearColor];
    self.ageSelectorView.horizontalScrolling = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideNavigationBarAnimated:NO];
}


- (void)showUpSectionView:(BOOL)shouldShow
{
    
}

- (IBAction)onPressedAttachPhone:(id)btn
{
    if (self.stack)
    {
        PhoneValidationController* phoneVal = [[PhoneValidationController alloc]initWithNibName:@"PhoneValidationController" bundle:nil];
        
        [self.stack pushViewController:phoneVal animated:YES];
    }
}

- (IBAction)onPressedBackPhone:(id)btn
{
    if (self.stack)
    {
        [self.stack popBoardAnimated:YES];
    }
}

#pragma IZValueSelector dataSource
- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector {
    return 99;
}



//ONLY ONE OF THESE WILL GET CALLED (DEPENDING ON the horizontalScrolling property Value)
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector {
    return 30;
}

- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector {
    return 40;
}


- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index {
    UILabel * label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, self.ageSelectorView.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%d",index+1];
    label.textAlignment =  NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (UIView*)selectorViewForSelectorView:(IZValueSelectorView *)valueSelector
{
    UIView* selectorView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)] autorelease];
    selectorView.backgroundColor = RGBA(255, 0, 0, 0.5f);
    return selectorView;
}

#pragma IZValueSelector delegate
- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index {
    NSLog(@"Selected index %d",index);
}

@end
