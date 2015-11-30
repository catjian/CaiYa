//
//  UserMessageViewController.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/9.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "UserMessageViewController.h"
#import "RegisterViewController.h"

@interface UserMessageViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@end

@interface messageTableCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UILabel *contentLab;

@end

@implementation messageTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
        [self.titleLab setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:self.titleLab];
        
        self.faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_Width-70, 0, 60, 60)];
        [self.faceImageView setHidden:YES];
        [self.faceImageView.layer setCornerRadius:30];
        [self.faceImageView.layer setMasksToBounds:YES];
        [self.contentView addSubview:self.faceImageView];
        
        self.contentLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.right, 0, SCREEN_Width-20-self.titleLab.right, 40)];
        [self.contentLab setTextColor:[UIColor blackColor]];
        [self.contentLab setTextAlignment:NSTextAlignmentRight];
        [self.contentLab setHidden:YES];
        [self.contentView addSubview:self.contentLab];
    }
    return self;
}

@end

@implementation UserMessageViewController
{
    UITableView *_tableView;
    NSArray *_tableData;
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
    [self setNavTarBarTitle:@"个人资料"];
    [self setBackItem];
//    [self setRightItemWithTitle:@"更新"];
    
    [self loadTableViewDataSource];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.top, SCREEN_Width, SCREEN_Height-60)
                                              style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
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

- (void)rightBarButtonItemAction:(UIButton *)but
{
    for (NSDictionary *dic in _tableData)
    {
        if ([dic[@"title"] isEqualToString:@"姓名"])
        {
            NSString *name = dic[@"content"];
            if (name.length <= 0)
            {
                [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"姓名不能为空！"];
            }
            else
            {
                [[AppDelegate shared] upLoadUserInfoWithDictionry:@{@"name":name}];
            }
            break;
        }
    }
}

- (void)loadTableViewDataSource
{
    // Do any additional setup after loading the view.
    NSDictionary *loginDic = [[MM_Tools shareTools] getObjectForKey:LOGIN_ACTION_RESPINFO];
    NSDictionary *wxUserInfo = [[MM_Tools shareTools] getObjectForKey:WEICHAT_LOGIN_ACTION_RESPINFO];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    NSString *name = loginDic[@"name"];
    if (name.length <= 0 || [name rangeOfString:@"null"].location != NSNotFound)
    {
        name = wxUserInfo[@"name"];
        if (name.length <= 0 || [name rangeOfString:@"null"].location != NSNotFound)
        {
            name = @"";
        }
    }
    NSString *username = loginDic[@"username"];
    if (username.length <= 0 || [username rangeOfString:@"null"].location != NSNotFound)
    {
        username = wxUserInfo[@"username"];
        if (username.length <= 0 || [username rangeOfString:@"null"].location != NSNotFound)
        {
            username = @"";
        }
    }
    NSString *mobile = loginDic[@"mobile"];
    if (mobile.length <= 0 || [mobile rangeOfString:@"null"].location != NSNotFound)
    {
        mobile = wxUserInfo[@"mobile"];
        if (mobile.length <= 0 || [mobile rangeOfString:@"null"].location != NSNotFound)
        {
            mobile = @"";
        }
    }
    NSString *headimgurl = loginDic[@"headimgurl"];
    if (headimgurl.length <= 0 || [headimgurl rangeOfString:@"null"].location != NSNotFound)
    {
        headimgurl = wxUserInfo[@"headimgurl"];
        if (headimgurl.length <= 0 || [headimgurl rangeOfString:@"null"].location != NSNotFound)
        {
            headimgurl = @"";
        }
    }
    NSString *nickname = loginDic[@"nickname"];
    if (nickname.length <= 0 || [nickname rangeOfString:@"null"].location != NSNotFound)
    {
        nickname = wxUserInfo[@"nickname"];
        if (nickname.length <= 0 || [nickname rangeOfString:@"null"].location != NSNotFound)
        {
            nickname = @"";
        }
    }
    NSString *province = loginDic[@"province"];
    if (province.length <= 0 || [province rangeOfString:@"null"].location != NSNotFound)
    {
        province = wxUserInfo[@"province"];
        if (province.length <= 0 || [province rangeOfString:@"null"].location != NSNotFound)
        {
            province = @"";
        }
    }
    NSString *city = loginDic[@"city"];
    if (city.length <= 0 || [city rangeOfString:@"null"].location != NSNotFound)
    {
        city = wxUserInfo[@"city"];
        if (city.length <= 0 || [city rangeOfString:@"null"].location != NSNotFound)
        {
            city = @"";
        }
    }
    _tableData = @[@{@"title":@"用户头像", @"content":headimgurl},
//                   @{@"title":@"账户", @"content":username},
                   @{@"title":@"姓名", @"content":name},
                   @{@"title":@"电话", @"content":mobile},
                   @{@"title":@"昵称", @"content":nickname},
                   @{@"title":@"性别", @"content":[wxUserInfo[@"sex"] intValue] == 1?@"男":@"女" },
                   @{@"title":@"所在地区", @"content":[NSString stringWithFormat:@"%@ %@",province,city]}];
}

#pragma mark - tableView Delegate DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return 70;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"CELL_IDENTIFER";
    messageTableCell *cell = (messageTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell)
    {
        cell = [[messageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    [cell.contentLab setHidden:YES];
    [cell.faceImageView setHidden:YES];
    NSDictionary *dic = [_tableData objectAtIndex:indexPath.row];
    [cell.titleLab setText:dic[@"title"]];
    [cell.titleLab setTop:(44-cell.titleLab.height)/2];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [cell.faceImageView setHidden:NO];
        [cell.titleLab setTop:(70-cell.titleLab.height)/2];
        [cell.faceImageView setTop:(70-cell.faceImageView.height)/2];
        [cell.faceImageView setImageWithURL:[NSURL URLWithString:dic[@"content"]]
                           placeholderImage:[UIImage imageNamed:@"user_icon"]];
    }
    else
    {
        [cell.contentLab setTop:(44-cell.titleLab.height)/2];
        [cell.contentLab setHidden:NO];
        [cell.contentLab setText:dic[@"content"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageTableCell *cell = (messageTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.titleLab.text isEqualToString:@"姓名"])
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"修改姓名"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"保存", nil];
        [alerView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alerView show];
    }
    if ([cell.titleLab.text isEqualToString:@"电话"])
    {
        RegisterViewController *vc = [[RegisterViewController alloc] initWithType:Register_view_type_reset_mobile_action];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *name = [[alertView textFieldAtIndex:0] text];
        if (name.length <= 0)
        {
            name = @"";
        }
        NSMutableArray *data_array = [[NSMutableArray alloc] initWithArray:_tableData];
        for (NSDictionary *dic in data_array)
        {
            if ([dic[@"title"] isEqualToString:@"姓名"])
            {
                [data_array replaceObjectAtIndex:[data_array indexOfObject:dic] withObject:@{@"title":@"姓名", @"content":name}];
                break;
            }
        }
        _tableData = data_array;
        [_tableView reloadData];
        
        [self rightBarButtonItemAction:nil];
    }
}

@end
