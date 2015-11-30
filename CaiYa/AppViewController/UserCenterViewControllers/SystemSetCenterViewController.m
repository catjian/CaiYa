//
//  SystemSetCenterViewController.m
//  MicroMakeMoney
//
//  Created by zhang jian on 15/8/15.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "SystemSetCenterViewController.h"
#import "resetPasswordViewController.h"

@interface SystemSetCenterViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SystemSetCenterViewController
{
    UITableView *_tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTarBarTitle:@"系统设置"];
    [self setBackItem];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, SCREEN_Height-64)
                                              style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    [self.view addSubview:_tableView];
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

- (void)logOutButtonAction:(UIButton *)button
{
    [[MM_Tools shareTools] set:nil KeyString:LOGIN_ACTION_RESPINFO];
    [[MM_Tools shareTools] set:nil KeyString:WEICHAT_LOGIN_ACTION_RESPINFO];
    [[MM_Tools shareTools] set:nil KeyString:WXAPI_SENDREP_TYPE];
    [[AppDelegate shared] showLoginViewController];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[MM_HomePageTabController shared] selectButtonInteger:0];
    [[MM_NetInstanceInterface sharedNetInstaceInterface] logoutActionWithSuccessBlock:^(id respInfo) {
        
    } FailuerBlock:^(NSDictionary *error) {
        
    }];
}

#pragma mark - tableView Delegate DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"CELL_IDENTIFER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    [cell.textLabel setText:@"修改密码"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    resetPasswordViewController *vc = [[resetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, 50)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(10, 10, SCREEN_Width-20, 40)];
    [button setTag:21];
    [button setTitle:@"注销登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.layer setCornerRadius:3];
    [button addTarget:self action:@selector(logOutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    return view;
}

@end
