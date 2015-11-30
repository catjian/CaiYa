//
//  MM_BaseNavigationController.m
//  CaiYa
//
//  Created by zhangjian on 15/11/26.
//  Copyright © 2015年 zhang_jian. All rights reserved.
//

#import "MM_BaseNavigationController.h"

@implementation MM_BaseNavigationController

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

@end
