//
//  MyWangcaiViewController.m
//  wangcai
//
//  Created by Lee Justin on 14-2-15.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "MyWangcaiViewController.h"
#import "MyWangcaiSkillCellViewController.h"
#import "LoginAndRegister.h"
#import "MobClick.h"
#import "PhoneValidationController.h"

@interface MyWangcaiViewController ()
{
    NSArray* _iconImages;
}

@end

@implementation MyWangcaiViewController

@synthesize tableView;
@synthesize dogImageView;
@synthesize jingyanView;
@synthesize jingyan2View;
@synthesize dengjiNumLabel;
@synthesize jiachengInfoLabel;
@synthesize bingphoneTipsView;
@synthesize dogCell;

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
    
    _iconImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"mywangcai_cell_baifabaizhong"],[UIImage imageNamed:@"mywangcai_cell_haoyunlianlian"],[UIImage imageNamed:@"mywangcai_cell_dianshichengjin"], nil];
    
    [self setLevel:12];
    [self setEXP:1.0f withAnimation:NO];
    
    jingyan2View = [[UIImageView alloc] initWithFrame:self.jingyanView.frame];
    jingyan2View.image = jingyanView.image;
    jingyan2View.contentMode = jingyanView.contentMode;
    [dogCell addSubview:jingyan2View];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideBindTips:NO];
    [self setEXP:0.0f withAnimation:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(onViewInit) withObject:nil afterDelay:0.1];
}

- (void)onViewInit
{
    if ([[[LoginAndRegister sharedInstance] getPhoneNum] length]> 0)
    {
        [self hideBindTips:NO];
    }
    else
    {
        [self showBindTips:YES];
    }
    
    [self playDogAnimation];
    [self setEXP:1.0f withAnimation:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [tableView release];
    [dogImageView release];
    [jingyanView release];
    [dengjiNumLabel release];
    [jiachengInfoLabel release];
    [bingphoneTipsView release];
    [dogCell release];
    [_iconImages release];
    [jingyan2View release];
    [super dealloc];
}

- (void)setUIStack : (BeeUIStack*) beeStack {
    self->_beeStack = beeStack;
}

- (IBAction)onPressedBindPhone:(id)sender
{
    // 绑定手机
    [MobClick event:@"click_bind_phone" attributes:@{@"currentpage":@"我的旺财"}];
    PhoneValidationController* phoneVal = [PhoneValidationController shareInstance];
    [self->_beeStack pushViewController:phoneVal animated:YES];
}

- (IBAction)onPressedBack:(id)sender
{
    [[BeeUIRouter sharedInstance] open:@"wc_main" animated:YES];
}

- (void)showBindTips:(BOOL)animated;
{
    self.bingphoneTipsView.frame = CGRectMake(0, 5, self.bingphoneTipsView.frame.size.width, self.bingphoneTipsView.frame.size.height);
    
    void (^block)(void) = ^(){
        self.bingphoneTipsView.frame = CGRectMake(0, 52, self.bingphoneTipsView.frame.size.width, self.bingphoneTipsView.frame.size.height);
    };
    
    if (animated)
    {
        [UIView animateWithDuration:1.0 animations:block];
    }
    else
    {
        block();
    }
}

- (void)hideBindTips:(BOOL)animated;
{
    void (^block)(void) = ^(){
        self.bingphoneTipsView.frame = CGRectMake(0, 5, self.bingphoneTipsView.frame.size.width, self.bingphoneTipsView.frame.size.height);
    };
    
    if (animated)
    {
        [UIView animateWithDuration:1.0 animations:block];
    }
    else
    {
        block();
    }
}

- (void)playDogAnimation
{
    [self.dogImageView stopAnimating];
    
    NSMutableArray* imageArray = [NSMutableArray array];
    
    for (int i = 0; i < 14; ++i)
    {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"mywangcai_dog_%d",i+1]];
        [imageArray addObject:image];
    }
    
    self.dogImageView.animationImages = imageArray;
    self.dogImageView.animationDuration = 1.4;
    self.dogImageView.animationRepeatCount = 0;
    [self.dogImageView startAnimating];
}

- (void)setLevel:(int)level
{
    self.dengjiNumLabel.text = [NSString stringWithFormat:@"%d",level];
    self.jiachengInfoLabel.text = [NSString stringWithFormat:@"可获得额外%d%@的红包",level,@"%"];
}

//经验：0-1
- (void)setEXP:(float)EXP withAnimation:(BOOL)animated
{
    float length = 138.f;
    
    length *= EXP;
    
    CGRect rectEXP = self.jingyanView.frame;
    rectEXP.size.width = 0.f;
    self.jingyan2View.frame = rectEXP;
    
    rectEXP.size.width = length;
    
    void (^block)(void) = ^(){
        self.jingyan2View.frame = rectEXP;
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.3f animations:block];
    }
    else
    {
        block();
    }
}

#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1+[_iconImages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell* cell = nil;
    if (row == 0)
    {
        cell = self.dogCell;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell"];
        if (cell == nil)
        {
            MyWangcaiSkillCellViewController* ctrl = [[[MyWangcaiSkillCellViewController alloc] initWithNibName:@"MyWangcaiSkillCellViewController" bundle:nil] autorelease];
            cell = ctrl.view;
        }
        
        MyWangcaiSkillCell* skillCell = (MyWangcaiSkillCell*)cell;
        skillCell.icon.image = [_iconImages objectAtIndex:row-1];
    }
    
    return cell;
}

#pragma mark <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0)
    {
        return self.dogCell.frame.size.height;
    }
    else
    {
        return 80.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
