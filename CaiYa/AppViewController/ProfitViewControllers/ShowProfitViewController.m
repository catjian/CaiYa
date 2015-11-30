//
//  ShowProfitViewController.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/9.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "ShowProfitViewController.h"

@interface ShowProfitViewController ()

@end

@implementation ShowProfitViewController
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
    [self setNavTarBarTitle:@"晒单"];
    [self setBackItem];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MM_HomePageTabController shared] showTabBar:NO];
}

- (void)backBarButtonItemAction:(UIButton *)btn
{
    [[MM_HomePageTabController shared] showTabBar:YES];
    [super backBarButtonItemAction:btn];
}

@end
