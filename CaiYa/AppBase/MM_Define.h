//
//  MM_Define.h
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/3.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#ifndef MicroMakeMoney_MM_Define_h
#define MicroMakeMoney_MM_Define_h

#define SCREEN_Height [[UIScreen mainScreen]bounds].size.height

#define SCREEN_Width [[UIScreen mainScreen]bounds].size.width

#define is_IOS5 ([[UIDevice currentDevice].systemVersion intValue] == 5?YES:NO)
#define is_IOS6 ([[UIDevice currentDevice].systemVersion intValue] == 6?YES:NO)
#define is_IOS7 ([[UIDevice currentDevice].systemVersion intValue] == 7?YES:NO)
#define is_IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8?YES:NO)

#define is_iPhone4 (([[UIScreen mainScreen]bounds].size.height < 568)?YES:NO)
#define is_iPhone5 (([[UIScreen mainScreen]bounds].size.height == 568)?YES:NO)
#define is_iPhone6 (([[UIScreen mainScreen]bounds].size.height - 667) == 0?YES:NO)
#define is_iPhone6p (([[UIScreen mainScreen]bounds].size.height - 667) > 0?YES:NO)

//内网测试
//#define IMAGESERVICE_URL  @"http://192.168.1.200:8080"      
//#define WEBSERVICE_URL    @"http://192.168.1.200:8080/jeesite"
//外网测试
#define IMAGESERVICE_URL    @"http://nicozhu2015.imwork.net:25594"
#define WEBSERVICE_URL      @"http://nicozhu2015.imwork.net:25594/jeesite"

#ifndef DebugLog
#define DebugLog(s,...) if(1)\
                        {\
                            NSLog(@"DebugLog \n文件：%@ \n 方法名：%@:(第%d) >> \n%@",\
                                    [[NSString stringWithUTF8String:__FILE__] lastPathComponent],\
                                    [NSString stringWithUTF8String:__FUNCTION__],\
                                    __LINE__,\
                                    [NSString stringWithFormat:(s),##__VA_ARGS__]);\
                        }
#endif


#define REQ_JSON_KEY  @"jsonStringer"

#endif


@interface NSObject (judgementNull)

- (BOOL)isNull;

@end

@implementation NSObject (judgementNull)

- (BOOL)isNull
{
    if (self == nil)
    {
        return YES;
    }
    if ([self isKindOfClass:[NSString class]] && [(NSString *)self length] <= 0)
    {
        return YES;
    }
    if ([self isKindOfClass:[NSDictionary class]] && [(NSDictionary *)self count] <= 0)
    {
        return YES;
    }
    if ([self isKindOfClass:[NSArray class]] && [(NSArray *)self count] <= 0)
    {
        return YES;
    }
    if ([self isKindOfClass:[NSData class]] && [(NSData *)self length] <= 0)
    {
        return YES;
    }
    return NO;
}

@end