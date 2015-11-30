//
//  LoginViewController.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/3.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AboutWebViewController.h"

@interface LoginViewController ()<WXApiDelegate>

@end

@implementation LoginViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView
{
    [super loadView];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, SCREEN_Height)];
    [backImageView setImage:[UIImage imageNamed:@"login_bg"]];
    [self.view addSubview:backImageView];
    
    CGSize imageSize = CGSizeMake(150, 150);
    imageSize.width *= (is_iPhone6p?1:0.6);
    imageSize.height *= (is_iPhone6p?1:0.6);
    CGFloat offset_y = [self initFastLoginViewWithTop];
    offset_y = offset_y/2;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_Width-imageSize.width)/2, (offset_y-imageSize.height)/2, imageSize.width, imageSize.height)];
    [iconImageView setImage:[UIImage imageNamed:@"login_bg_logo"]];
    [self.view addSubview:iconImageView];
    
    NSArray *p_string = @[@"输入邮箱或手机号码", @"输入密码"];
    NSArray *imageNames = @[@"login_input_password", @"login_input_user"];
    for (int i = 0; i < p_string.count; i++)
    {
        offset_y += i*45;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, offset_y, SCREEN_Width-40, 40)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view setAlpha:0.5];
        [view.layer setCornerRadius:5];
        [self.view addSubview:view];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        [imageview setImage:[UIImage imageNamed:imageNames[i]]];
        [view addSubview:imageview];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(view.left+40, offset_y, view.width-40, 40)];
        [textField setPlaceholder:p_string[i]];
        [textField setTag:10+i];
        [textField setText:@"3"];
        if (i == 1)
        {
            [textField setText:@"123456"];
            [textField setSecureTextEntry:YES];
        }
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [self.view addSubview:textField];
    }
    
    offset_y += 10+45;
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTag:20];
    [loginButton setFrame:CGRectMake(20, offset_y, SCREEN_Width-40, 40)];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton.layer setCornerRadius:5];
    [loginButton setBackgroundColor:[UIColor whiteColor]];
    [loginButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(loginCaiYaButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    offset_y = loginButton.bottom;
    p_string = @[@"注册账号", @"忘记密码"];//@"用户协议",
    for (int i = 0; i < p_string.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(20+i*(SCREEN_Width-40)/p_string.count, offset_y, (SCREEN_Width-40)/p_string.count, 30)];
        [button setTitle:p_string[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        if (0 == i)
        {
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, is_iPhone6p?120:80)];
        }
        else if (p_string.count-1 == i)
        {
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, is_iPhone6p?110:80, 0, 0)];
        }
        [button setTag:i+21];
        [button addTarget:self action:@selector(loginCaiYaButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    offset_y += 50;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    NSDictionary *dic = [[MM_Tools shareTools] getObjectForKey:@"Register_success_Phone_pwd"];
    if (dic && dic.count > 0)
    {
        UITextField *textField_phone = (UITextField *)[self.view viewWithTag:10];
        UITextField *textField_pwd = (UITextField *)[self.view viewWithTag:11];
        [textField_phone setText:dic[@"mobile"]];
        [textField_pwd setText:dic[@"password"]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (CGFloat)initFastLoginViewWithTop
{
    CGFloat offset_height = 100+(is_iPhone6?20:0);
    CGFloat offset_y = SCREEN_Height-offset_height;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, offset_y, SCREEN_Width, offset_height)];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:view];
    
    UILabel *fastLoginTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_Width-40, 30)];
    [fastLoginTitle setText:@"快捷登录"];
    [fastLoginTitle setTextColor:[UIColor whiteColor]];
    [view addSubview:fastLoginTitle];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(20, fastLoginTitle.bottom, fastLoginTitle.width, 1)];
    [line setBackgroundColor:[UIColor colorWithWhite:1.000 alpha:0.200]];
    [view addSubview:line];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake((SCREEN_Width-(40 + (is_iPhone6?20:0)))/2, line.bottom+(is_iPhone6?15:15), 40 + (is_iPhone6?20:0), 40+(is_iPhone6?20:0))];
    [button setBackgroundImage:[UIImage imageNamed:@"login_wechat"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginWeiXinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return offset_y;
}

- (void)loginCaiYaButtonAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    switch (tag)
    {
        case 20:
        {
            UITextField *name = (UITextField *)[self.view viewWithTag:10];
            UITextField *pwd = (UITextField *)[self.view viewWithTag:11];
            if (name.text.length <= 0)
            {
                [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"请输入邮箱或手机号码!"];
                return;
            }
            if (pwd.text.length <= 0)
            {
                [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"请输入密码!"];
                return;
            }
            [[MM_NetInstanceInterface sharedNetInstaceInterface] loginActionWithParameter:@{@"username":name.text,
                                                                                            @"password":pwd.text}
                                                                            isWeiXingType:ENUM_LOING_TYPE_CAIYA_ACCOUNT
                                                                             SuccessBlock:^(NSDictionary *respInfo) {
                                                                                 BOOL status = [respInfo[@"loginStatus"] boolValue];
                                                                                 if (status)
                                                                                 {
                                                                                     [[MM_Tools shareTools] set:respInfo KeyString:LOGIN_ACTION_RESPINFO];
                                                                                     [[AppDelegate shared] showHomeRootViewController];
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                     [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:respInfo[@"message"]];
                                                                                 }
                                                                             }
                                                                             FailuerBlock:^(NSDictionary *error) {
                                                                                 
                                                                             }];
        }
            break;
        case 21:
        {
            RegisterViewController *vc = [[RegisterViewController alloc] initWithType:Register_view_type_register_action];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
//        case 22:
//        {
//            AboutWebViewController *vc = [[AboutWebViewController alloc] initWithWebUrl:@"/f/view-103-1005.html"];
//            [vc setNavTarBarTitle:@"用户协议"];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
        case 22:
        {
            RegisterViewController *vc = [[RegisterViewController alloc] initWithType:Register_view_type_reset_password_action];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)loginWeiXinButtonAction:(UIButton *)sender
{
    if ([WXApi isWXAppInstalled])
    {
        SendAuthReq* req = [[SendAuthReq alloc] init] ;
        req.scope = @"snsapi_base,snsapi_userinfo";
        req.state = @"123";
        [WXApi sendReq:req];
    }
    else
    {
        [[MM_Tools shareTools] AlertViewWithTitle:@"提示" MessageString:@"未发现微信应用，请去App Store下载"];
    }
}

@end
