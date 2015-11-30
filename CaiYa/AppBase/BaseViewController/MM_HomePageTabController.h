//
//  MM_HomePageTabController.h
//  SchollMateChat
//
//  Created by zhang jian on 15/4/13.
//  Copyright (c) 2015年 com.zhangjian.App.Account. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MM_HomePageTabController : UITabBarController

+ (MM_HomePageTabController *)shared;

-(void)showTabBar:(BOOL)isShow;

-(void)selectButtonInteger:(NSInteger)tag;

@end
