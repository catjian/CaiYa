//
//  MM_HomePageTabController.m
//  SchollMateChat
//
//  Created by zhang jian on 15/4/13.
//  Copyright (c) 2015年 com.zhangjian.App.Account. All rights reserved.
//

#import "MM_HomePageTabController.h"
#import "FirsterViewController.h"
#import "ProfitViewController.h"
#import "UserCenterViewController.h"

static MM_HomePageTabController *homePageTb = nil;

@interface MM_HomePageTabController ()

@end

@implementation MM_HomePageTabController
{
    NSMutableArray *_buttonArray;
    UIView *_butsView;
}

+ (MM_HomePageTabController *)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        homePageTb = [[MM_HomePageTabController alloc] init];
    });
    return homePageTb;
}

- (id)init
{
    self = [self initWithNibName:nil bundle:nil];
    if (self)
    {
        
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        [self.tabBar setHidden:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewControllers];
    [self initTabButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public interface

-(void)showTabBar:(BOOL)isShow
{
    [UIView animateWithDuration:(isShow?0.3:1) animations:^{
        if (isShow)
        {
            [_butsView setTop:SCREEN_Height-60];
        }
        else
        {
            [_butsView setTop:SCREEN_Height];
        }
    }];
}

-(void)selectButtonInteger:(NSInteger)tag
{
    NSArray *backgroundImages = @[@"main_tab_home",@"main_tab_profit",@"main_tab_user"];
    NSArray *backgroundHighlightedImages = @[@"main_tab_home_press",@"main_tab_profit_press",@"main_tab_user_press"];
    for (int i = 0; i < _buttonArray.count; i++)
    {
        UIButton *tabBarButton = (UIButton *)[_buttonArray objectAtIndex:i];
        if (tag == i)
        {
            [tabBarButton setSelected:YES];
            [tabBarButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [tabBarButton setImage:[UIImage imageNamed:backgroundHighlightedImages[i]] forState:UIControlStateNormal];
        }
        else
        {
            [tabBarButton setSelected:NO];
            [tabBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBarButton setImage:[UIImage imageNamed:backgroundImages[i]] forState:UIControlStateNormal];
        }
    }
    self.selectedIndex = tag;
}

#pragma mark - private 
#pragma mark - init Function

-(void)initViewControllers
{
    NSArray *ViewNames = @[@"FirsterViewController", @"ProfitViewController", @"UserCenterViewController"];
    NSMutableArray *viewCons = [[NSMutableArray alloc] initWithCapacity:3];
    for(NSString *vName in ViewNames)
    {
        Class className = NSClassFromString(vName);
        UIViewController *viewCon = [[className alloc] initWithNibName:nil bundle:nil];
        MM_BaseNavigationController *navCon = [[MM_BaseNavigationController alloc] initWithRootViewController:viewCon];
        [viewCons addObject:navCon];
        viewCon = nil;
    }
    
    [self setViewControllers:viewCons];
}

-(void)initTabButtons
{
    if (!_butsView)
    {
        _butsView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_Height-60, SCREEN_Width, 60)];
        [_butsView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_butsView];
    }
    UILabel *horizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _butsView.width, 1)];
    [horizontalLine setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    [_butsView addSubview:horizontalLine];
    
    NSArray *backgroundTitles = @[@"首页",@"收益",@"个人"];
    NSArray *backgroundImages = @[@"main_tab_home",@"main_tab_profit",@"main_tab_user"];
    NSArray *backgroundHighlightedImages = @[@"main_tab_home_press",@"main_tab_profit_press",@"main_tab_user_press"];
    
    if (!_buttonArray)
    {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    float space = 0;
    for (int i=0; i<backgroundTitles.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(space+i*SCREEN_Width/backgroundTitles.count, 0, SCREEN_Width/backgroundTitles.count, _butsView.height)];
        button.tag = i+10;
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:backgroundTitles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:backgroundImages[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:backgroundHighlightedImages[i]] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        if (i == 0)
        {
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:backgroundHighlightedImages[i]] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(selectTabButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.imageEdgeInsets = UIEdgeInsetsMake(14,(button.width-20)/2,26,(button.width-20)/2);
        button.titleEdgeInsets = UIEdgeInsetsMake(30, -48, 0, 0);
        [_buttonArray addObject:button];
        [_butsView addSubview:button];
        
        if (i != backgroundHighlightedImages.count-1)
        {
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(button.right, button.top+18, 1, button.height-36)];
            [line setImage:[UIImage imageNamed:@"h-line.png"]];
            [_butsView addSubview:line];
        }
    }
}

-(void)selectTabButtonAction:(UIButton *)button
{
    NSArray *backgroundImages = @[@"main_tab_home",@"main_tab_profit",@"main_tab_user"];
    NSArray *backgroundHighlightedImages = @[@"main_tab_home_press",@"main_tab_profit_press",@"main_tab_user_press"];
    for (int i = 0; i < _buttonArray.count; i++)
    {
        UIButton *tabBarButton = (UIButton *)[_buttonArray objectAtIndex:i];
        if (tabBarButton == button)
        {
            [tabBarButton setSelected:YES];
            [tabBarButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [tabBarButton setImage:[UIImage imageNamed:backgroundHighlightedImages[i]] forState:UIControlStateNormal];
        }
        else
        {
            [tabBarButton setSelected:NO];
            [tabBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tabBarButton setImage:[UIImage imageNamed:backgroundImages[i]] forState:UIControlStateNormal];
        }
    }
    self.selectedIndex = button.tag-10;
}

@end
