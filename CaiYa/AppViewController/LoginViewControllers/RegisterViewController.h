//
//  RegisterViewController.h
//  MicroMakeMoney
//
//  Created by zhang jian on 15/8/14.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "MM_BaseViewController.h"

typedef NS_ENUM(NSUInteger, Register_view_type)
{
    Register_view_type_Zero,
    Register_view_type_register_action,
    Register_view_type_reset_password_action,
    Register_view_type_reset_mobile_action,
    Register_view_type_Maximum
};

@interface RegisterViewController : MM_BaseViewController

- (id)initWithType:(Register_view_type)type;

@end
