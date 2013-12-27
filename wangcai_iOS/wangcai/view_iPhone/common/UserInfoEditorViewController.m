//
//  UserInfoEditorViewController.m
//  wangcai
//
//  Created by Lee Justin on 13-12-21.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "UserInfoEditorViewController.h"
#import "PhoneValidationController.h"
#import "UserInfoAPI.h"

@interface UserInfoEditorViewController () <UserInfoAPIDelegate>
{
    UILabel* _labelAgeSelected;
}

@end

@implementation UserInfoEditorViewController

@synthesize upSectionView;
@synthesize downSectionView;
@synthesize scrollView;

@synthesize ageSelectorView;

@synthesize hobbySelectorViews;

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
    
    _rectSelectBgView = CGRectMake(110, 3, 37, 43);
    CGRect rect = CGRectOffset(_rectSelectBgView, self.ageSelectorView.frame.origin.x, self.ageSelectorView.frame.origin.y);
    UIImageView* selectorView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
    selectorView.contentMode = UIViewContentModeCenter;
    selectorView.clipsToBounds = NO;
    selectorView.image = [UIImage imageNamed:@"user_sex_selected"];
    [[self.ageSelectorView superview] insertSubview:selectorView belowSubview:self.ageSelectorView];
    
    [self buildSelectorViews];
    
    [self performSelector:@selector(_doAgeInitSelections) withObject:nil afterDelay:0.05];
    
}

-(void)_doAgeInitSelections
{
    [self.ageSelectorView selectItemAtIndex:17];
    [self selectSex:YES];
    
    [[UserInfoAPI loginedUserInfo] fetchUserInfo:self];
}

- (void)buildSelectorViews
{
    self.hobbySelectorViews = [NSMutableArray array];
    
    NSArray* selectorTexts = [NSArray arrayWithObjects:@"休闲游戏",@"升级打宝",@"打折促销",@"结交朋友",@"旅行生活",@"竞技游戏",@"强身健体",@"美丽达人", nil];
    
    CGRect rect = CGRectMake(15, 30, 140, 36);
    CGFloat maxY = 30.f;
    for (int i = 0; i < [selectorTexts count]; ++i)
    {
        NSString* selectText = [selectorTexts objectAtIndex:i];
        
        if (i%2 == 1)
        {
            rect.origin.x = CGRectGetMaxX(rect)+10;
        }
        else
        {
            rect.origin.x = 15;
            rect.origin.y = CGRectGetMaxY(rect)+15;
        }
        
        if (CGRectGetMaxY(rect) > maxY)
        {
            maxY = CGRectGetMaxY(rect);
        }
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = rect;
        
        [btn setBackgroundImage:[UIImage imageNamed:@"user_hobby_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"user_hobby_selected"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"user_hobby_selected"] forState:UIControlStateSelected];

        [btn setTitle:selectText forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(onPressedHobbySelect:) forControlEvents:UIControlEventTouchDown];
        
        [self.selectionContainerView addSubview:btn];
        [self.hobbySelectorViews addObject:btn];
    }
    
    maxY += 20.f;
    
    CGSize scrollViewSize = CGSizeMake(320, self.upSectionView.frame.size.height + self.selectionContainerView.frame.origin.y + maxY);
    
    self.scrollView.contentSize = scrollViewSize;
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

- (void)dealloc
{
    self.upSectionView = nil;
    self.downSectionView = nil;
    self.scrollView = nil;
    
    self.ageSelectorView = nil;
    self.selectionContainerView = nil;
    
    self.sexFamaleButton = nil;
    self.sexMaleButton = nil;
    self.hobbySelectorViews = nil;
    [super dealloc];
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

- (IBAction)onPressedMaleButton:(id)btn
{
    [self selectSex:YES];
}

- (IBAction)onPressedFamaleButton:(id)btn
{
    [self selectSex:NO];
}

- (void)selectSex:(BOOL)isMale
{
    if (isMale)
    {
        self.sexMaleButton.selected = YES;
        self.sexFamaleButton.selected = NO;
    }
    else
    {
        self.sexMaleButton.selected = NO;
        self.sexFamaleButton.selected = YES;
    }
}

- (void)onPressedHobbySelect:(UIButton*)hobbyButton
{
    if (!hobbyButton.selected)
    {
        hobbyButton.selected = YES;
    }
    else
    {
        hobbyButton.selected = NO;
    }
}

#pragma IZValueSelector dataSource
- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector {
    return 99;
}



//ONLY ONE OF THESE WILL GET CALLED (DEPENDING ON the horizontalScrolling property Value)
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector {
    return 43;
}

- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector {
    return 37;
}


- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index {
    UILabel * label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 37, self.ageSelectorView.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%d",index+1];
    label.textAlignment =  NSTextAlignmentCenter;
    label.textColor = RGB(156, 156, 156);
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (UIView*)selectorViewForSelectorView:(IZValueSelectorView *)valueSelector
{
    UIImageView* selectorView = [[[UIImageView alloc] initWithFrame:_rectSelectBgView] autorelease];
    selectorView.contentMode = UIViewContentModeCenter;
    selectorView.clipsToBounds = NO;
    selectorView.image = [UIImage imageNamed:@"user_sex_selected"];
    
    UILabel * label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, 37, self.ageSelectorView.frame.size.height)];
    label.text = @"";
    label.textAlignment =  NSTextAlignmentCenter;
    label.textColor = RGB(255, 255, 255);
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    [selectorView addSubview:label];
    _labelAgeSelected = label;
    
    return selectorView;
}

#pragma IZValueSelector delegate
- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index {
    _labelAgeSelected.text = [NSString stringWithFormat:@"%d",index+1];
    NSLog(@"Selected index %d",index);
}

#pragma mark <UserInfoAPIDelegate>

- (void)onFinishedFetchUserInfo:(UserInfoAPI*)userInfo isSucceed:(BOOL)succeed
{
    
}

- (void)onFinishedUpdateUserInfo:(UserInfoAPI*)userInfo isSucceed:(BOOL)succeed
{
    
}

@end
