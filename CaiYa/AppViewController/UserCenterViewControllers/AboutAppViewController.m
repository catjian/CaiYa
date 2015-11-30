//
//  AboutAppViewController.m
//  MicroMakeMoney
//
//  Created by zhang jian on 15/8/15.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "AboutAppViewController.h"
#import "AboutWebViewController.h"

@interface AboutAppViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation AboutAppViewController
{
    UITableView *_tableView;
    NSDictionary *_tableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTarBarTitle:@"系统设置"];
    [self setBackItem];
    
    _tableData = @{@"功能介绍":@"/f/view-103-1001.html", @"帮助中心":@"/f/view-103-1000.html", @"版本检测":@"/f/view-103-1003.html"};
    
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

#pragma mark - tableView Delegate DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData.allKeys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"CELL_IDENTIFER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UILabel *horizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_Width, 1)];
        [horizontalLine setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
        [cell.contentView addSubview:horizontalLine];
    }
    
    [cell.textLabel setText:_tableData.allKeys[indexPath.row]];
    if (indexPath.row == _tableData.count-1)
    {
        [cell.detailTextLabel setText:[[MM_Tools shareTools] AppVersion]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == _tableData.count - 1)
    {
        [[MM_NetInstanceInterface sharedNetInstaceInterface] getLastVersionWithParameter:@{@"platform":@"ios"}
                                                                            SuccessBlock:^(id respInfo) {
                                                                                if (respInfo[@"version"])
                                                                                {
                                                                                    NSMutableString *message = [[NSMutableString alloc] init];
                                                                                    [message appendFormat:@"最新版本:%@\n",respInfo[@"version"]];
                                                                                    [message appendFormat:@"发布时间:%@\n",respInfo[@"publishDate"]];
                                                                                    [message appendFormat:@"更新说明:%@\n",respInfo[@"brief"]];
                                                                                    [[MM_Tools shareTools] AlertViewWithTitle:@"有新版本" MessageString:@"" CancelButton:@"取消" AlertBlock:^(NSInteger buttonTag) {
                                                                                        if (buttonTag == 1)
                                                                                        {
                                                                                            AboutWebViewController *vc = [[AboutWebViewController alloc] initWithWebUrl:_tableData[cell.textLabel.text]];
                                                                                            [vc setNavTarBarTitle:cell.textLabel.text];
                                                                                            [self.navigationController pushViewController:vc animated:YES];
                                                                                        }
                                                                                    }];
                                                                                }
        }
                                                                            FailuerBlock:^(NSDictionary *error) {
            
        }];
    }
    else
    {
        AboutWebViewController *vc = [[AboutWebViewController alloc] initWithWebUrl:_tableData[cell.textLabel.text]];
        [vc setNavTarBarTitle:cell.textLabel.text];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
