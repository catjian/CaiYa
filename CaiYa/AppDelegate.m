//
//  AppDelegate.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/6/29.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate
{
    LoginViewController *_loginViewCon;
    MM_HomePageTabController *_homeRootVC;
}

+ (AppDelegate *)shared
{
    return (AppDelegate*)[[UIApplication sharedApplication]delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    if([[NSUserDefaults standardUserDefaults] stringForKey:@"ConnectUrl"].length >0)
//    {
//        [[MM_NetworkController sharedClient] initWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"ConnectUrl"]]];
//    }
//    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:WEBSERVICE_URL forKey:@"ConnectUrl"];
        [[MM_NetworkController sharedClient] initWithURL:[NSURL URLWithString:WEBSERVICE_URL]];
    }
    
    _loginViewCon = [[LoginViewController alloc] init];
    _homeRootVC = [MM_HomePageTabController shared];
    [_homeRootVC.view setAlpha:0];
    
//    [self showHomeRootViewController];
    [self showLoginViewController];
    
    DebugLog(@"%@",[[MM_Tools shareTools] getNowTimeWithFormat:@"YYYY-MM-dd HH:mm:ss:SSSS"]);
#pragma mark - 初始化Share SDK
//    [ShareSDK registerApp:SHARE_KEY];
    //添加QQ应用
//    [ShareSDK connectQQWithQZoneAppKey:SHARE_QQ_KEY
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];
//    //添加QQ空间应用
//    [ShareSDK connectQZoneWithAppKey:SHARE_QQ_KEY
//                           appSecret:SHARE_QQ_APP_KEY
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
    //添加微信应用
    [ShareSDK connectWeChatWithAppId:SHARE_WX_KEY wechatCls:[WXApi class]];
    [WXApi registerApp:SHARE_WX_KEY withDescription:@"菜牙"];
    
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];
    
    NSDictionary *parmeter = @{@"category.id":@"102", @"pageSize":@"1", @"pageNo":@"1"};
    NSDictionary *adDic = [[NSUserDefaults standardUserDefaults] objectForKey:START_PAGE_ADS];
    if (![adDic isNull] && adDic != nil)
    {
        UIView *adView = [[MM_Tools shareTools] createADViewWithInfo:[adDic[@"list"] lastObject]];
        [self.window addSubview:adView];
        [self.window bringSubviewToFront:adView];
    }
    [[MM_NetInstanceInterface sharedNetInstaceInterface] getArticleListWithParameter:parmeter
     SuccessBlock:^(id respInfo) {
        NSDictionary *responseDic = respInfo[@"page"];
         if ([adDic isNull] || adDic == nil)
         {
             UIView *adView = [[MM_Tools shareTools] createADViewWithInfo:[responseDic[@"list"] lastObject]];
             [self.window addSubview:adView];
             [self.window bringSubviewToFront:adView];
         }
         [[NSUserDefaults standardUserDefaults] setObject:responseDic forKey:START_PAGE_ADS];
         [[NSUserDefaults standardUserDefaults] synchronize];
     } FailuerBlock:^(NSDictionary *error) {
         
     }];
    
    return YES;
}

- (void)showLoginViewController
{
    if (!_loginViewCon)
    {
        _loginViewCon = [[LoginViewController alloc] init];
    }
    [_loginViewCon.view setAlpha:1];
    [_homeRootVC.view setAlpha:0];
    [self.window setRootViewController:[[MM_BaseNavigationController alloc] initWithRootViewController:_loginViewCon]];
}

- (void)showHomeRootViewController
{
    if (!_homeRootVC)
    {
        _homeRootVC = [MM_HomePageTabController shared];
    }
    [UIView animateWithDuration:0.2 animations:^{
        [_loginViewCon.view setAlpha:0];
    } completion:^(BOOL finished) {
        [self.window setRootViewController:_homeRootVC];
        [UIView animateWithDuration:0.5 animations:^{
            [_homeRootVC.view setAlpha:1];
        }];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - WX回调

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - WXApiDelegate

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
- (void)onReq:(BaseReq*)req
{
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp*)resp
{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    NSLog(@"resp Class = %@", NSStringFromClass([resp class]));
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = @"发送媒体消息结果";
        NSString *strMsg = resp.errStr;
        if (0 == resp.errCode)
        {
            NSDictionary *sendRep_dic = [[MM_Tools shareTools] getObjectForKey:WXAPI_SENDREP_TYPE];
            WXAPI_SENDREP_TYPE_SCENE type = [sendRep_dic[@"SCENE_TYPE"] integerValue];
            switch (type)
            {
                case WXAPI_SENDREP_TYPE_SCENE_SESSION:
                    strMsg = @"分享好友成功!";
                    break;
                case WXAPI_SENDREP_TYPE_SCENE_TIMELINE:
                    strMsg = @"分享朋友圈成功!";
                    break;
                case WXAPI_SENDREP_TYPE_SCENE_FAVORITE:
                    strMsg = @"收藏成功!";
                    break;
                default:
                    break;
            }
            if ([sendRep_dic[@"articleId"] isEqualToString:@"晒单"] ||
                [sendRep_dic[@"articleId"] isEqualToString:@"分享"])
            {
                strTitle = sendRep_dic[@"articleId"];
            }
            else
            {
                NSDictionary *loginDic = [[MM_Tools shareTools] getObjectForKey:LOGIN_ACTION_RESPINFO];
                [[MM_NetInstanceInterface sharedNetInstaceInterface] forwardArticleWithParameter:@{@"userId":loginDic[@"id"],
                                                                                                   @"articleId":sendRep_dic[@"articleId"]}
                                                                                    SuccessBlock:^(NSArray *respInfo) {
                                                                                        NSLog(@"respInfo = %@",respInfo);
                                                                                    }
                                                                                    FailuerBlock:^(NSDictionary *error) {
                                                                                        
                                                                                    }];
            }
        }
        
        
        [[MM_Tools shareTools] AlertViewWithTitle:strTitle MessageString:strMsg];
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        
        if (temp.errCode == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[MM_Tools shareTools] ShowHUDWithMessage:@"正在获取个人信息..."];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",SHARE_WX_KEY,SHARE_WX_SECRECT_KEY,temp.code]]];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"access_token = %@",json);
                data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",json[@"access_token"],json[@"openid"]]]];
                json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"userinfo = %@",json);
                if ([json count] > 0)
                {
                    [[MM_Tools shareTools] set:json KeyString:WEICHAT_LOGIN_ACTION_RESPINFO];
                    
                    [[MM_NetInstanceInterface sharedNetInstaceInterface] loginActionWithParameter:@{@"weixin":json[@"openid"]}
                                                                                    isWeiXingType:ENUM_LOING_TYPE_WEIXIN
                                                                                     SuccessBlock:^(id respInfo) {
                                                                                         [self showHomeRootViewController];
                                                                                         [self upLoadUserInfoWithDictionry:json];
                    }
                                                                                     FailuerBlock:^(NSDictionary *error) {
                        
                    }];
                }
                [[MM_Tools shareTools] HideHUD];
                
            });
        }
        else
        {
            [[MM_Tools shareTools] AlertViewWithTitle:@"登录失败" MessageString:temp.errCode == -2?@"用户取消":@"用户拒绝授权"];
        }
    }
}

- (void)upLoadUserInfoWithDictionry:(NSDictionary *)json
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *wxUserInfo = [[MM_Tools shareTools] getObjectForKey:WEICHAT_LOGIN_ACTION_RESPINFO];
    if (wxUserInfo && wxUserInfo.count > 0)
    {
        NSString *sex = [NSString stringWithFormat:@"%d",[wxUserInfo[@"sex"] intValue]];
        if (sex.length <= 0)
        {
            sex = @"1";
        }
        NSString *nickname = wxUserInfo[@"nickname"];
        if (nickname.length <= 0)
        {
            nickname = @"";
        }
        NSString *openid = wxUserInfo[@"openid"];
        if (openid.length <= 0)
        {
            openid = @"";
        }
        NSString *unionid = wxUserInfo[@"unionid"];
        if (unionid.length <= 0)
        {
            unionid = @"";
        }
        NSString *headimgurl = wxUserInfo[@"headimgurl"];
        if (headimgurl.length <= 0)
        {
            headimgurl = @"";
        }
        NSString *city = wxUserInfo[@"city"];
        if (city.length <= 0)
        {
            city = @"";
        }
        NSString *country = wxUserInfo[@"country"];
        if (country.length <= 0)
        {
            country = @"";
        }
        NSString *province = wxUserInfo[@"province"];
        if (province.length <= 0)
        {
            province = @"";
        }
        parameter = [NSMutableDictionary dictionaryWithDictionary:@{@"sex":sex,
                                                                    @"nickname":nickname,
                                                                    @"weixin":openid,
                                                                    @"unionid":unionid,
                                                                    @"photo":headimgurl,
                                                                    @"city":city,
                                                                    @"country":country,
                                                                    @"province":province}];
    }
    NSString *name = [NSString stringWithFormat:@"%@",json[@"name"]];
    if (name.length > 0)
    {
        [parameter setObject:name forKey:@"name"];
    }
    
    [[MM_NetInstanceInterface sharedNetInstaceInterface] upLoadUserInfoWithParameter:parameter
                                                                        SuccessBlock:^(id respInfo) {
                                                                            BOOL status = [respInfo[@"success"] intValue] > 0 ? YES:NO;
                                                                            if (status)
                                                                            {
                                                                                [[MM_Tools shareTools] set:respInfo[@"user"] KeyString:LOGIN_ACTION_RESPINFO];
                                                                            }
                                                                            else
                                                                            {
                                                                                [[MM_Tools shareTools] AlertViewWithTitle:@"错误" MessageString:respInfo[@"message"]];
                                                                            }
                                                                        }
                                                                        FailuerBlock:^(NSDictionary *error) {
                                                                            
                                                                        }];
}

@end
