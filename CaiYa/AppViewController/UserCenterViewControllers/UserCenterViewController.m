//
//  UserCenterViewController.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/5.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserMessageViewController.h"
#import "MyForwardViewController.h"
#import "ApplyMoneyViewController.h"
#import "SystemSetCenterViewController.h"
#import "AboutAppViewController.h"
#import "RecommendedAwardViewController.h"

@interface UserCenterViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation UserCenterViewController
{
    UITableView *_tableView;
    NSArray *_tableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTarBarTitle:@"用户中心"];
    // Do any additional setup after loading the view.
    _tableData = @[@[@{@"title":@"个人资料",@"icon":@"user_data"}],
                   @[
//  @{@"title":@"我的转发",@"icon":@"my_task"},
                      @{@"title":@"财富中心",@"icon":@"my_account"},
                      @{@"title":@"推荐有奖",@"icon":@"my_account"}],
                   @[@{@"title":@"系统设置",@"icon":@"system_set"},@{@"title":@"关于菜牙",@"icon":@"about_app"}]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_Width, SCREEN_Height-60-20)
                                              style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 30, 0)];
    [_tableView setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - tableView Delegate DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 180;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"CELL_IDENTIFER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 54-20, 54-20)];
        [imageView setTag:10];
        [cell.contentView addSubview:imageView];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+10, imageView.top,
                                                                 SCREEN_Width-imageView.right-30, imageView.height)];
        [lab setTag:11];
        [cell.contentView addSubview:lab];
    }
    NSDictionary *dic = [_tableData[indexPath.section] objectAtIndex:indexPath.row];
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:10];
    UILabel *lab = (UILabel *)[cell.contentView viewWithTag:11];
    [image setImage:[UIImage imageNamed:dic[@"icon"]]];
    [lab setText:dic[@"title"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        UserMessageViewController *umVC = [[UserMessageViewController alloc] init];
        [self.navigationController pushViewController:umVC animated:YES];
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
//            {
//                MyForwardViewController *viewC = [[MyForwardViewController alloc] init];
//                [self.navigationController pushViewController:viewC  animated:YES];
//            }
//                break;
            case 1:
            {
                ApplyMoneyViewController *viewC = [[ApplyMoneyViewController alloc] initWithData:nil];
                [self.navigationController pushViewController:viewC animated:YES];
            }
                break;
            case 2:
            {
                RecommendedAwardViewController *viewC = [[RecommendedAwardViewController alloc] init];
                [self.navigationController pushViewController:viewC animated:YES];
            }
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 2)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                SystemSetCenterViewController *viewC = [[SystemSetCenterViewController alloc] init];
                [self.navigationController pushViewController:viewC animated:YES];
            }
                break;
            case 1:
            {
                AboutAppViewController *viewC = [[AboutAppViewController alloc] init];
                [self.navigationController pushViewController:viewC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        NSDictionary *loginDic = [[MM_Tools shareTools] getObjectForKey:LOGIN_ACTION_RESPINFO];
        NSDictionary *wxUserInfo = [[MM_Tools shareTools] getObjectForKey:WEICHAT_LOGIN_ACTION_RESPINFO];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, 180)];
        UIImageView *backimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, 180)];
        [backimage setImage:[UIImage imageNamed:@"my_center_bg"]];
        [view addSubview:backimage];
        
        NSString *headimgurl = loginDic[@"headimgurl"];
        if (headimgurl.length <= 0 || [headimgurl rangeOfString:@"null"].location != NSNotFound)
        {
            headimgurl = wxUserInfo[@"headimgurl"];
            if (headimgurl.length <= 0 || [headimgurl rangeOfString:@"null"].location != NSNotFound)
            {
                headimgurl = @"";
            }
        }
        CGFloat offset_width = 100;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_Width-offset_width)/2, 20, offset_width, offset_width)];
        [imageView.layer setCornerRadius:offset_width/2];
        [imageView setImageWithURL:[NSURL URLWithString:headimgurl]
                  placeholderImage:[UIImage imageNamed:@"user_icon"]];
        [imageView.layer setCornerRadius:offset_width/2];
        [imageView.layer setMasksToBounds:YES];
        [view addSubview:imageView];
        
        NSString *name = loginDic[@"name"];
        if (name.length <= 0 || [name rangeOfString:@"null"].location != NSNotFound)
        {
            name = wxUserInfo[@"nickname"];
            if (name.length <= 0 || [name rangeOfString:@"null"].location != NSNotFound)
            {
                name = @"";
            }
        }
        UILabel *name_lab = [[UILabel alloc] initWithFrame:CGRectMake(10, imageView.bottom+10, SCREEN_Width-20, 30)];
        [name_lab setText:name];
        [name_lab setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:name_lab];
        return view;
    }
    return nil;
}

@end
