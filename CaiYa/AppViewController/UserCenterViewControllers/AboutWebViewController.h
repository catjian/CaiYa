//
//  AboutWebViewController.h
//  MicroMakeMoney
//
//  Created by zhang jian on 15/8/16.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "MM_BaseViewController.h"

@interface AboutWebViewController : MM_BaseViewController <UIWebViewDelegate>

- (id)initWithWebUrl:(NSString *)url;

@end
