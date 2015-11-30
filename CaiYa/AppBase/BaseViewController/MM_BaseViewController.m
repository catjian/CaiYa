//
//  MM_BaseViewController.m
//  phoneBank
//
//  Created by long gang on 14-2-19.
//  Copyright (c) 2014年 ccrt. All rights reserved.
//

#import "MM_BaseViewController.h"

@interface MM_BaseViewController ()

@end

@implementation MM_BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]}];
    if(is_IOS7 || is_IOS8)
    {
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
    else
    {
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    }
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.view endEditing:YES];
    [super viewDidDisappear:animated];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark interface
- (void)setNavTarBarTitle:(NSString *)title
{
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_Width-100)/2.0, 0,100,44)];
    [lab setText:title];
    [lab setTextColor:[UIColor whiteColor]];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setFont:[UIFont boldSystemFontOfSize:20]];
    [self.navigationItem setTitleView:lab];
}

- (void)loadViewController:(NSString *)viewController
{
    [self loadViewController:viewController hidesBottomBarWhenPushed:NO];
}

- (void)loadViewController:(NSString *)viewController hidesBottomBarWhenPushed:(BOOL)ishide
{
    UIViewController *vc = [[NSClassFromString(viewController) alloc]init];
    [vc setHidesBottomBarWhenPushed:ishide];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setBackItem
{
    UIImage *btnImage = [UIImage imageNamed:@"Nav_Back.png"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 25, 18)];
    [leftBtn setBackgroundImage:[btnImage stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setBackItemWithTitle:(NSString *)title
{
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:nil];
    if (title)
    {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:leftBtn.titleLabel.font}];
        [leftBtn setFrame:CGRectMake(10, 0, size.width+10, 30)];
        [leftBtn setTitle:title forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [leftBtn addTarget:self action:@selector(backBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

- (void)setLeftItem
{
    UIImage *btnImage = [UIImage imageNamed:@"Button-leftNav.png"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, btnImage.size.width, btnImage.size.height)];
    [leftBtn setImage:btnImage forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setRightItem
{
    UIImage *btnImage=[UIImage imageNamed:@"Button-rightNav.png"];
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBut setFrame:CGRectMake(10, 0, btnImage.size.width, btnImage.size.height)];
    [rightBut setImage:btnImage forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setRightItemWithTitle:(NSString *)title
{
    if (title)
    {
        UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBut.titleLabel setFont:[UIFont systemFontOfSize:14]];
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:rightBut.titleLabel.font}];
        [rightBut setFrame:CGRectMake(10, 0, size.width+10, 30)];
        [rightBut setBackgroundColor:[UIColor clearColor]];
        [rightBut setTitle:title forState:UIControlStateNormal];
        [rightBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBut setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [rightBut.layer setBorderWidth:1];
        [rightBut.layer setCornerRadius:5];
        [rightBut.layer setBorderColor:[UIColor whiteColor].CGColor];
        [rightBut addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBut];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)backBarButtonItemAction:(UIButton *)btn
{
    //reload in subclass
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftBarButtonItemAction:(UIButton *)btn
{
    //reload in subclass
}

- (void)rightBarButtonItemAction:(UIButton *)but
{
    //reload in SubClass
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
