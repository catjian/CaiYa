//
//  ExtensionContentViewController.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/9.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "ExtensionContentViewController.h"

@interface ExtensionContentViewController () <UIWebViewDelegate>

@end

@implementation ExtensionContentViewController
{
    NSDictionary *_dicData;
    UIWebView *_webView;
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
    [self setNavTarBarTitle:@"分享"];
    [self setBackItem];
//    [self setRightItemWithTitle:@"分享"];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    // Do any additional setup after loading the view.
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [_webView setDelegate:self];
    [_webView setBackgroundColor:[UIColor orangeColor]];
    NSString *url = _dicData[@"url"];
    if (!url || [url length] <= 0)
    {
        url = _dicData[@"article"][@"url"];
    }
    NSString *urlstring = [NSString stringWithFormat:@"%@%@",IMAGESERVICE_URL,url];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstring]]];
    [self.view addSubview:_webView];
    
    NSString *forwardMoney = [NSString stringWithFormat:@"%@",_dicData[@"cyRewardRule"][@"forwardMoney"]];
    NSString *readMoney = [NSString stringWithFormat:@"%@",_dicData[@"cyRewardRule"][@"readMoney"]];
    NSString *profitMoney = [NSString stringWithFormat:@"%@",_dicData[@"cyRewardRule"][@"forwardCouponValue"]];
    NSString *moneyLab = [NSString stringWithFormat:@"转发:%@元,阅读:%@元,电子券:%@张",forwardMoney,readMoney,profitMoney];
    
    NSString *loseTimes = [NSString stringWithFormat:@"%d",[_dicData[@"readTimes"] intValue] - [_dicData[@"readedTimes"] intValue]];
    if ([loseTimes integerValue] == 0 || [_dicData[@"cyUserArticleStatic"][@"coupon"] integerValue] > 0 || [_dicData[@"isInvalid"] integerValue] == 1)
    {
        moneyLab = @"无偿分享到社交圈";
    }
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareButton setFrame:CGRectMake(10, self.view.height-60-50, self.view.width-20, 40)];
    [shareButton.layer setCornerRadius:5];
    [shareButton setBackgroundColor:[UIColor orangeColor]];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [shareButton setTitle:moneyLab forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    [self.view bringSubviewToFront:shareButton];
}

- (void)loadView
{
    [super loadView];
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

- (void)rightBarButtonItemAction:(UIButton *)but
{    
    [[MM_Tools shareTools] customAlertViewWithType:CUNSTOM_ALERTVIEW_TYPE_BUTTON_AND_TITLE ButtonActionBlock:^(NSInteger buttonTag) {
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = _dicData[@"title"];
        if (!message.title || [message.title length] <= 0)
        {
            message.title = _dicData[@"article"][@"title"];
        }
        message.description = _dicData[@"description"];
        if (!message.description || [message.description length] <= 0)
        {
            message.description = _dicData[@"article"][@"description"];
        }
        
        UIImageView *imageV = [[UIImageView alloc] init];
        NSString *url = _dicData[@"smallImage"];
        if (!url || [url length] <= 0)
        {
            url = _dicData[@"article"][@"smallImage"];
        }
        url = [NSString stringWithFormat:@"%@%@",IMAGESERVICE_URL,url];
        UIImage *image = [imageV cachedImageForRequestUrl:[NSURL URLWithString:url]];
        [message setThumbImage:image];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        url = _dicData[@"url"];
        if (!url || [url length] <= 0)
        {
            url = _dicData[@"article"][@"url"];
        }
        NSString *urlstring = [NSString stringWithFormat:@"%@%@",IMAGESERVICE_URL,url];
        ext.webpageUrl = urlstring;
        
        message.mediaObject = ext;
        message.mediaTagName = @"caiya";
        
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
                                                 @"articleId":_dicData[@"id"]} KeyString:WXAPI_SENDREP_TYPE];
                }
                    break;
                case 1:
                {
                    req.scene = WXSceneTimeline;
                    [[MM_Tools shareTools] set:@{@"SCENE_TYPE":@(WXAPI_SENDREP_TYPE_SCENE_TIMELINE),
                                                 @"articleId":_dicData[@"id"]} KeyString:WXAPI_SENDREP_TYPE];
                }
                    break;
                default:
                    break;
            }

            [WXApi sendReq:req];
            [[MM_Tools shareTools] set:@{@"SCENE_TYPE":@(WXAPI_SENDREP_TYPE_SCENE_SESSION),
                                         @"articleId":_dicData[@"id"]} KeyString:WXAPI_SENDREP_TYPE];
        }
        else
        {
            [[MM_Tools shareTools] AlertViewWithTitle:@"提示" MessageString:@"未发现微信应用，请去App Store下载"];
            return;
        }
    }];
}

#pragma mark - WebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[MM_Tools shareTools] ShowHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[MM_Tools shareTools] HideHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[MM_Tools shareTools] HideHUD];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DebugLog(@"request.URL.absoluteString = %@", request.URL.absoluteString);
    return YES;
}

@end
