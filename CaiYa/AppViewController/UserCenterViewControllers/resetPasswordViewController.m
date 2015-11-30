//
//  resetPasswordViewController.m
//  MicroMakeMoney
//
//  Created by zhang jian on 15/8/16.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "resetPasswordViewController.h"

@implementation resetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTarBarTitle:@"修改密码"];
    [self setBackItem];
//    [self setRightItemWithTitle:@"修改密码"];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
}

- (void)loadView
{
    [super loadView];
    
    NSArray *arrayPlaceholder = @[@"原密码", @"新密码"];
    CGFloat offset_y = 10;
    for (int i = 0; i < arrayPlaceholder.count; i++)
    {
        offset_y = 10 + i*45;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, offset_y, SCREEN_Width-20, 40)];
        [textField setBackgroundColor:[UIColor whiteColor]];
        [textField setTag:i+10];
        [textField.layer setCornerRadius:3];
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [self.view addSubview:textField];
        if (0 == i)
        {
            [textField setText:arrayPlaceholder[i]];
            [textField setEnabled:NO];
        }
        else
        {
            [textField setPlaceholder:arrayPlaceholder[i]];
        }
    }
    
    offset_y = 10 + arrayPlaceholder.count*45;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(10, offset_y+20, SCREEN_Width-20, 40)];
    [button setTag:21];
    [button setTitle:@"修改密码" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.layer setCornerRadius:3];
    [button addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)rightBarButtonItemAction:(UIButton *)but
{
    UITextField *oldPwd = (UITextField *)[self.view viewWithTag:10];
    if (oldPwd.text.length <= 0)
    {
        [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"请输入原密码!"];
        return;
    }
    UITextField *newPwd = (UITextField *)[self.view viewWithTag:11];
    if (newPwd.text.length <= 0)
    {
        [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"请输入新密码!"];
        return;
    }
    
    [[MM_NetInstanceInterface sharedNetInstaceInterface] modifyPasswordActionWithParameter:@{@"oldPassword":oldPwd.text,
                                                                                             @"newPassword":newPwd.text,
                                                                                             @"mobileLogin":@(YES)}
                                                                              SuccessBlock:^(NSDictionary *respInfo) {
                                                                                  NSLog(@"respInfo = %@",respInfo);
                                                                              }
                                                                              FailuerBlock:^(NSDictionary *error) {

                                                                              }];
}

@end
