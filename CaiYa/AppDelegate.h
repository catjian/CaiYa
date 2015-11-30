//
//  AppDelegate.h
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/6/29.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SHARE_KEY @"5d7db323fa6c"
#define SHARE_SECRECT_KEY @"973ebac6dc8520ba9e615d9821e6a42b"


// share社交分享
#define SHARE_QQ_KEY          @"1102581580"
#define SHARE_QQ_APP_KEY      @"z5zOlXglIVE3uPiY"
#define SHARE_WX_KEY          @"wx38da89f5a9e1948e"
#define SHARE_WX_SECRECT_KEY  @"dafe6439afbcbb931f463692df021e4e"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)shared;

- (void)showLoginViewController;

- (void)showHomeRootViewController;

- (void)upLoadUserInfoWithDictionry:(NSDictionary *)json;

@end

