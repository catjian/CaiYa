//
//  RegisterViewController.m
//  MicroMakeMoney
//
//  Created by zhang jian on 15/8/14.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "RegisterViewController.h"
#import "AboutWebViewController.h"

@implementation RegisterViewController
{
    Register_view_type _type;
}

- (id)initWithType:(Register_view_type)type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_type == Register_view_type_register_action)
    {
        [self setNavTarBarTitle:@"新用户注册"];
//        [self setRightItemWithTitle:@"注册"];
    }
    else if (_type == Register_view_type_reset_password_action)
    {
        [self setNavTarBarTitle:@"忘记密码"];
//        [self setRightItemWithTitle:@"提交"];
    }
    else if (_type == Register_view_type_reset_mobile_action)
    {
        [self setNavTarBarTitle:@"修改手机号"];
//        [self setRightItemWithTitle:@"提交"];
    }
    [self setBackItem];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
}

- (void)backBarButtonItemAction:(UIButton *)btn
{
    [super backBarButtonItemAction:btn];
}

- (void)loadView
{
    [super loadView];
    NSMutableArray *arrayPlaceholder = [[NSMutableArray alloc] initWithArray:@[@"输入手机号", @"验证码"]];
    if (_type == Register_view_type_register_action)
    {
        [arrayPlaceholder addObject:@"设置密码"];
        [arrayPlaceholder addObject:@"邀请码"];
    }
    else if (_type == Register_view_type_reset_password_action)
    {        
        [arrayPlaceholder addObject:@"设置密码"];
    }
    CGFloat offset_y = 10;
    for (int i = 0; i < arrayPlaceholder.count; i++)
    {
        offset_y = 10 + i*45;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, offset_y, SCREEN_Width-20, 40)];
        [textField setPlaceholder:arrayPlaceholder[i]];
        [textField setBackgroundColor:[UIColor whiteColor]];
        [textField setTag:i+10];
        [textField.layer setCornerRadius:3];
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [self.view addSubview:textField];
        if (0 == i)
        {
            UIButton *VerifyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [VerifyButton setFrame:CGRectMake(textField.right-90, 10, 90, 40)];
            [VerifyButton setTag:20];
            [VerifyButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            [VerifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [VerifyButton setBackgroundColor:[UIColor orangeColor]];
            [VerifyButton.layer setCornerRadius:3];
            [VerifyButton addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:VerifyButton];
        }
    }
    
    offset_y = 10 + arrayPlaceholder.count*45;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(10, offset_y+20, SCREEN_Width-20, 40)];
    [button setTag:21];
    if (_type == Register_view_type_register_action)
    {
        [button setTitle:@"注册" forState:UIControlStateNormal];
    }
    else if (_type == Register_view_type_reset_password_action)
    {
        [button setTitle:@"提交" forState:UIControlStateNormal];
    }
    else 
    {
        [button setTitle:@"提交" forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.layer setCornerRadius:3];
    [button addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    if (_type == Register_view_type_register_action)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(button.left, button.bottom+10, button.width/2+(is_iPhone6?0:40), 30)];
        [lab setText:@"注册即表示已阅读并同意"];
        [self.view addSubview:lab];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake(lab.right, lab.top, 70, lab.height)];
        [button setTitle:@"用户协议" forState:UIControlStateNormal];
        [button.titleLabel setFont:lab.font];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(UserProtocolButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)rightBarButtonItemAction:(UIButton *)but
{
    NSInteger tag = but.tag;
    UITextField *textField_phone = (UITextField *)[self.view viewWithTag:10];
    UITextField *textField_code = (UITextField *)[self.view viewWithTag:11];
    if (tag == 20)
    {
        if (textField_phone.text.length != 11)
        {
            [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"请输入正确的电话号码!"];
        }
        else
        {
            [[MM_NetInstanceInterface sharedNetInstaceInterface] getSmsCodeWithParameter:@{@"mobile":textField_phone.text}
                                                                            SuccessBlock:^(id respInfo) {
                                                                                BOOL status = [respInfo[@"success"] intValue] > 0 ? YES:NO;
                                                                                
                                                                                [[MM_Tools shareTools] AlertViewWithTitle:status?@"成功":@"错误" MessageString:respInfo[@"message"]];
                                                                            }
                                                                            FailuerBlock:^(NSDictionary *error) {
                                                                                
                                                                            }];
            [but setBackgroundColor:[UIColor colorWithWhite:0.800 alpha:1.000]];
            [but setTitle:@"30" forState:UIControlStateNormal];
            [but setEnabled:NO];
            [self timerAction];
        }
    }
    else
    {
        if (textField_phone.text.length != 11)
        {
            [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"电话号码长度不对!"];
            return;
        }
        if (textField_code.text.length <= 0)
        {
            [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"请输入验证码!"];
            return;
        }
        
        if (_type == Register_view_type_register_action)
        {
            UITextField *textField_pwd = (UITextField *)[self.view viewWithTag:12];
            if (textField_pwd.text.length <= 0)
            {
                [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"请输入密码!"];
                return;
            }
            UITextField *textField_inviteby = (UITextField *)[self.view viewWithTag:13];
            [[MM_NetInstanceInterface sharedNetInstaceInterface] registerActionWithParameter:@{@"mobile":textField_phone.text,
                                                                                               @"password":textField_pwd.text,
                                                                                               @"inviteby":textField_inviteby.text,
                                                                                               @"smsCode":textField_code.text,
                                                                                               @"mobileLogin":@(YES)}
                                                                                SuccessBlock:^(NSDictionary *respInfo) {
                                                                                    if ([respInfo[@"success"] integerValue] > 0)
                                                                                    {
                                                                                        [[MM_Tools shareTools] set:@{@"mobile":textField_phone.text,
                                                                                                                     @"password":textField_pwd.text}
                                                                                                         KeyString:@"Register_success_Phone_pwd"];
                                                                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:respInfo[@"message"]];
                                                                                    }
                                                                                }
                                                                                FailuerBlock:^(NSDictionary *error) {
                                                                                    
                                                                                }];
        }
        else if (_type == Register_view_type_reset_password_action)
        {
            UITextField *textField_pwd = (UITextField *)[self.view viewWithTag:12];
            if (textField_pwd.text.length <= 0)
            {
                [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"请输入密码!"];
                return;
            }
            [[MM_NetInstanceInterface sharedNetInstaceInterface] resetPasswordActionWithParameter:@{@"mobile":textField_phone.text,
                                                                                                    @"password":textField_pwd.text,
                                                                                                    @"smsCode":textField_code.text,
                                                                                                    @"mobileLogin":@(YES)}
                                                                                     SuccessBlock:^(NSDictionary *respInfo) {
                                                                                         if ([respInfo[@"success"] integerValue] > 0)
                                                                                         {
                                                                                             [[MM_Tools shareTools] set:@{@"mobile":textField_phone.text,
                                                                                                                          @"password":textField_pwd.text}
                                                                                                              KeyString:@"Register_success_Phone_pwd"];
                                                                                             [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                         }
                                                                                         else
                                                                                         {
                                                                                             [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:respInfo[@"message"]];
                                                                                         }
                                                                                     }
                                                                                     FailuerBlock:^(NSDictionary *error) {
                                                                                         
                                                                                     }];
        }
        else if (_type == Register_view_type_reset_mobile_action)
        {
            [[MM_NetInstanceInterface sharedNetInstaceInterface] modifyMobileActionWithParameter:@{@"mobile":textField_phone.text,
                                                                                                   @"smsCode":textField_code.text,
                                                                                                   @"mobileLogin":@(YES)}
                                                                                    SuccessBlock:^(NSDictionary *respInfo) {
                                                                                        BOOL status = [respInfo[@"success"] intValue] > 0 ? YES:NO;
                                                                                        
                                                                                        [[MM_Tools shareTools] AlertViewWithTitle:status?@"成功":@"错误" MessageString:respInfo[@"message"]];
                                                                                    }
                                                                                    FailuerBlock:^(NSDictionary *error) {

                                                                                    }];
        }
    }
}

- (void)timerAction
{
    UIButton *button = (UIButton *)[self.view viewWithTag:20];
    __block int num = [button.currentTitle intValue];
    if (num == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setBackgroundColor:[UIColor orangeColor]];
            [button setTitle:@"发送验证码" forState:UIControlStateNormal];
            [button setEnabled:YES];
        });
        return;
    }
    __weak RegisterViewController *this = self;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        num --;
        [button setTitle:[NSString stringWithFormat:@"%d",num] forState:UIControlStateNormal];
        if (num >= 0)
        {
            [this timerAction];
        }
    });
}

- (void)UserProtocolButtonAction
{    
    AboutWebViewController *vc = [[AboutWebViewController alloc] initWithWebUrl:@"/f/view-103-1005.html"];
    [vc setNavTarBarTitle:@"用户协议"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
