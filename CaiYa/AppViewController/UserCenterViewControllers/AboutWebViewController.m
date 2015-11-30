//
//  AboutWebViewController.m
//  MicroMakeMoney
//
//  Created by zhang jian on 15/8/16.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "AboutWebViewController.h"

@implementation AboutWebViewController
{
    NSString *_urlString;
}

- (id)initWithWebUrl:(NSString *)url
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _urlString = [NSString stringWithFormat:@"%@%@",WEBSERVICE_URL,url];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackItem];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [webView setDelegate:self];
    [webView setBackgroundColor:[UIColor orangeColor]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    [self.view addSubview:webView];
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
