//
//  ApplySuccessViewController.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/9.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "ApplySuccessViewController.h"

@interface ApplySuccessViewController ()

@end

@implementation ApplySuccessViewController
{
    NSDictionary *_dicData;
}

- (id)initWithData:(NSDictionary *)data
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _dicData = data;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTarBarTitle:@"申请提现成功"];
    [self setBackItemWithTitle:nil];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
}

- (void)loadView
{
    [super loadView];
    UILabel *showMessageLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, SCREEN_Width-40, 100)];
    [showMessageLab setTag:10];
    [showMessageLab setNumberOfLines:0];
    [showMessageLab setLineBreakMode:NSLineBreakByCharWrapping];
    [showMessageLab setText:@"  恭喜您！本次提现申请已经成功，微挣钱审核通过后，会立刻将金额转入到您的微信钱包。"];
    [showMessageLab setTextColor:[UIColor blackColor]];
    [self.view addSubview:showMessageLab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(80, showMessageLab.bottom+40, SCREEN_Width-160, 40)];
    [button setTag:12];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.layer setBorderWidth:1];
    [button.layer setCornerRadius:5];
    [button addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)nextButtonAction:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[MM_HomePageTabController shared] showTabBar:YES];
}

@end
