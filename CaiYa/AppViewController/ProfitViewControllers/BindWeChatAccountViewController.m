//
//  BindWeChatAccountViewController.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/9.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "BindWeChatAccountViewController.h"
#import "ApplySuccessViewController.h"

@interface BindWeChatAccountViewController ()

@end

@implementation BindWeChatAccountViewController
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
    [self setNavTarBarTitle:@"提现"];
    [self setBackItem];
//    [self setRightItemWithTitle:@"提现"];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
}

- (void)loadView
{
    [super loadView];
    
    NSArray *arrayPlaceholder = @[[NSString stringWithFormat:@"提现金额(元) %.2f",[_dicData[@"cashable"] floatValue]], @"微信号", @"姓名"];
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
    [button setTitle:@"提现" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.layer setCornerRadius:3];
    [button addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)rightBarButtonItemAction:(UIButton *)but
{
    [self nextButtonAction:but];
}

- (void)nextButtonAction:(UIButton *)button
{
    UITextField *textField_weixin = (UITextField *)[self.view viewWithTag:11];
    if (textField_weixin.text.length <= 0)
    {
        [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"微信号不能为空!"];
        return;
    }
    
    UITextField *textField_name = (UITextField *)[self.view viewWithTag:12];
    if (textField_name.text.length <= 0)
    {
        [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:@"姓名不能为空!"];
        return;
    }
    
    NSDictionary *loginDic = [[MM_Tools shareTools] getObjectForKey:LOGIN_ACTION_RESPINFO];
    [[MM_NetInstanceInterface sharedNetInstaceInterface] applyCashWithParameter:@{@"user.id":loginDic[@"id"],
                                                                                  @"cash":[NSString stringWithFormat:@"%.2f",[_dicData[@"cashable"] floatValue]],
                                                                                  @"applyAccount":textField_weixin.text,
                                                                                  @"applyName":textField_weixin.text,
                                                                                  @"applyRealname":textField_name.text,
                                                                                  @"applyPath":@"weixin"}
                                                                   SuccessBlock:^(id respInfo) {
                                                                       if (respInfo && [respInfo isKindOfClass:[NSDictionary class]])
                                                                       {
                                                                           if ([respInfo[@"success"] integerValue] > 0)
                                                                           {
                                                                               [self.navigationController popViewControllerAnimated:YES];
                                                                               [[MM_Tools shareTools] AlertViewWithTitle:@"提示" MessageString:respInfo[@"message"]];
                                                                           }
                                                                           else
                                                                           {
                                                                               [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:respInfo[@"message"]];
                                                                           }
                                                                       }
    }
                                                                   FailuerBlock:^(NSDictionary *error) {
        
    }];
}

@end
