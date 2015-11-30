//
//  MM_BaseViewController.h
//  phoneBank
//
//  Created by long gang on 14-2-19.
//  Copyright (c) 2014年 ccrt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MM_BaseViewController : UIViewController

- (void)setNavTarBarTitle:(NSString *)title;

- (void)loadViewController:(NSString *)viewController;

- (void)loadViewController:(NSString *)viewController hidesBottomBarWhenPushed:(BOOL)ishide;

- (void)setBackItem;

- (void)setBackItemWithTitle:(NSString *)title;

- (void)setLeftItem;

- (void)setRightItem;

- (void)setRightItemWithTitle:(NSString *)title;

- (void)backBarButtonItemAction:(UIButton *)btn;

- (void)leftBarButtonItemAction:(UIButton *)btn;

- (void)rightBarButtonItemAction:(UIButton *)but;

@end
