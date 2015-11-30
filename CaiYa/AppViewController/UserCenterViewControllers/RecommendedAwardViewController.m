//
//  RecommendedAwardViewController.m
//  MicroMakeMoney
//
//  Created by zhang jian on 15/8/27.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "RecommendedAwardViewController.h"

@implementation RecommendedAwardViewController
{
    BOOL _isCan;
    NSDictionary *_RegisterRuleDic;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTarBarTitle:@"推荐有奖"];
    [self setBackItem];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    _isCan = NO;
    CGSize imageSize = CGSizeMake(120, 120);
    UIImage *yuanbao_img = [UIImage imageNamed:@"share_dialog_yuanbao"];
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_Width-yuanbao_img.size.width*(imageSize.height/yuanbao_img.size.height))/2, 60,
                                                                        yuanbao_img.size.width*(imageSize.height/yuanbao_img.size.height), imageSize.height)];
    [imagev setImage:[UIImage imageNamed:@"share_dialog_yuanbao"]];
    [self.view addSubview:imagev];
    
    __weak RecommendedAwardViewController *this = self;
    [[MM_NetInstanceInterface sharedNetInstaceInterface] getRegisterRuleWithParameter:@{} SuccessBlock:^(id respInfo) {
        if (respInfo && [respInfo isKindOfClass:[NSDictionary class]])
        {
            _RegisterRuleDic = (NSDictionary *)respInfo;
            if (_RegisterRuleDic.count > 0)
            {
                _isCan = YES;
                NSString *inviteCash = [NSString stringWithFormat:@"%.2f元",[_RegisterRuleDic[@"inviteCash"] doubleValue]];
                NSString *inviteCoupon = [NSString stringWithFormat:@"%2.f元",[_RegisterRuleDic[@"inviteCouponType"] doubleValue]];
                NSString *text = [NSString stringWithFormat:@"推荐一个用户奖励：现金%@，\n面值%@电子券1张", inviteCash, inviteCoupon];
                NSMutableAttributedString *attristring = [[NSMutableAttributedString alloc] initWithString:text];
                [attristring addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor orangeColor]
                                    range:[text rangeOfString:inviteCash]];
                [attristring addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor orangeColor]
                                    range:[text rangeOfString:inviteCoupon]];
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, imagev.bottom+10, SCREEN_Width-20, 50)];
                [lab setTag:10];
                [lab setNumberOfLines:0];
                [lab setLineBreakMode:NSLineBreakByCharWrapping];
                [lab setTextColor:[UIColor blackColor]];
                [lab setTextAlignment:NSTextAlignmentCenter];
                [lab setAttributedText:attristring];
                [this.view addSubview:lab];
            }
        }
    } FailuerBlock:^(NSDictionary *error) {
        _isCan = NO;
    }];
    
    NSDictionary *loginDic = [[MM_Tools shareTools] getObjectForKey:LOGIN_ACTION_RESPINFO];
    UILabel *inviteCodeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, imagev.bottom+70, SCREEN_Width-20, 30)];
    [inviteCodeLab setTextAlignment:NSTextAlignmentCenter];
    [inviteCodeLab setTextColor:[UIColor blackColor]];
    [inviteCodeLab setFont:[UIFont systemFontOfSize:20]];
    NSString *text = [NSString stringWithFormat:@"我的邀请码：%@",loginDic[@"invitecode"]];
    NSMutableAttributedString *attristring = [[NSMutableAttributedString alloc] initWithString:text];
    [attristring addAttribute:NSForegroundColorAttributeName
                        value:[UIColor orangeColor]
                        range:[text rangeOfString:loginDic[@"invitecode"]]];
    [inviteCodeLab setAttributedText:attristring];
    [self.view addSubview:inviteCodeLab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake((SCREEN_Width-100)/2, inviteCodeLab.bottom+20, 100, 40)];
    [button setTitle:@"分享" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"profit_show"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 30);
    [button setBackgroundColor:[UIColor orangeColor]];
    [button.layer setCornerRadius:5];
    [button addTarget:self action:@selector(ShowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MM_HomePageTabController shared] showTabBar:NO];
}

- (void)backBarButtonItemAction:(UIButton *)btn
{
    [[MM_HomePageTabController shared] showTabBar:YES];
    [super backBarButtonItemAction:btn];
}

- (void)ShowButtonAction:(UIButton *)button
{
    if (_isCan)
    {
        [[MM_Tools shareTools] customAlertViewWithType:CUNSTOM_ALERTVIEW_TYPE_ONLY_BUTTON ButtonActionBlock:^(NSInteger buttonTag) {
            NSDictionary *loginDic = [[MM_Tools shareTools] getObjectForKey:LOGIN_ACTION_RESPINFO];
            NSString *msgText = [NSString stringWithFormat:@"菜牙有奖注册啦！填写我的邀请码%@注册奖励:现金%.2f元,面值%.2f元电子券1张",
                                 loginDic[@"invitecode"],[_RegisterRuleDic[@"registerCash"] doubleValue],[_RegisterRuleDic[@"registerCouponValue"] doubleValue]];
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = msgText;
            message.description = msgText;
            [message setThumbImage:[UIImage imageNamed:@"ic_launch"]];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            NSString *urlstring = [NSString stringWithFormat:@"%@/f/view-103-1003.html",WEBSERVICE_URL];
            ext.webpageUrl = urlstring;
            
            message.mediaObject = ext;
            message.mediaTagName = @"MicroMakeMoney";
            
            if ([WXApi isWXAppInstalled])
            {
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                req.message = message;
                switch (buttonTag)
                {
                    case 0:
                    {
                        req.scene = WXSceneSession;
                        [[MM_Tools shareTools] set:@{@"SCENE_TYPE":@(WXAPI_SENDREP_TYPE_SCENE_SESSION),
                                                     @"articleId":@"分享"} KeyString:WXAPI_SENDREP_TYPE];
                    }
                        break;
                    case 1:
                    {
                        req.scene = WXSceneTimeline;
                        [[MM_Tools shareTools] set:@{@"SCENE_TYPE":@(WXAPI_SENDREP_TYPE_SCENE_TIMELINE),
                                                     @"articleId":@"分享"} KeyString:WXAPI_SENDREP_TYPE];
                    }
                        break;
                    default:
                        break;
                }
                [WXApi sendReq:req];
            }
            else
            {
                [[MM_Tools shareTools] AlertViewWithTitle:@"提示" MessageString:@"未发现微信应用，请去App Store下载"];
                return;
            }
        }];
    }
}

@end
