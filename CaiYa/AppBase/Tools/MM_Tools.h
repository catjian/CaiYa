//
//  MM_Tools.h
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/19.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "MM_Object.h"

#define START_PAGE_ADS @"START_PAGE_ADS"
#define LOGIN_ACTION_RESPINFO @"Login_Action_RespInfo"
#define WEICHAT_LOGIN_ACTION_RESPINFO @"WEICHAT_Login_Action_RespInfo"
#define WXAPI_SENDREP_TYPE @"WXAPI_SENDREP_TYPE"

typedef NS_ENUM(NSUInteger, WXAPI_SENDREP_TYPE_SCENE) {
    WXAPI_SENDREP_TYPE_SCENE_SESSION,
    WXAPI_SENDREP_TYPE_SCENE_TIMELINE,
    WXAPI_SENDREP_TYPE_SCENE_FAVORITE,
};

typedef NS_ENUM(NSUInteger, CUNSTOM_ALERTVIEW_TYPE) {
    CUNSTOM_ALERTVIEW_TYPE_ONLY_BUTTON,
    CUNSTOM_ALERTVIEW_TYPE_BUTTON_AND_TITLE,
    CUNSTOM_ALERTVIEW_TYPE_BUTTON_AND_TEXTFIELD,
};

typedef void (^AlertViewDlegate)(NSInteger buttonTag);

@interface MM_Tools : MM_Object

+ (MM_Tools *)shareTools;

- (void)set:(id)value KeyString:(NSString *)key;

- (id)getObjectForKey:(NSString *)key;

- (NSString *)getRandomNumberWithLenght:(NSInteger)length;

- (NSString *)AppVersion;

- (void)ShowHUD;

- (void)ShowHUDWithMessage:(NSString *)message;

- (void)HideHUD;

- (void)customAlertViewWithType:(CUNSTOM_ALERTVIEW_TYPE)type ButtonActionBlock:(AlertViewDlegate) block;

- (void)customAlertViewWithType:(CUNSTOM_ALERTVIEW_TYPE)type TitleOrTextFieldMessage:(NSString *)text ButtonActionBlock:(AlertViewDlegate) block;

- (void)hideCustomView;

- (void)customAlertViewWithCollectionWithContent:(NSArray *)content ActionBlock:(AlertViewDlegate) block;

- (void)AlertViewWithTitle:(NSString *)title MessageString:(NSString *)message;

- (void)AlertViewWithTitle:(NSString *)title MessageString:(NSString *)message AlertBlock:(AlertViewDlegate) block;

- (void)AlertViewWithTitle:(NSString *)title MessageString:(NSString *)message CancelButton:(NSString *)button AlertBlock:(AlertViewDlegate) block;

- (UIView *)createADViewWithInfo:(NSDictionary *)info;

- (NSString *)getNowTimeWithFormat:(NSString *)format;

- (NSString *)getNewTimeWithOldTime:(NSString *)oldTime OldTimeFormate:(NSString *)oldFormate NewTimeFormat:(NSString *)newFormate;
- (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate;
- (NSString *)convertTimeWithString:(NSString *)time;
- (NSString *)convertTimeWithDate:(NSDate *)time;

@end
