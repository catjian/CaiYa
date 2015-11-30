//
//  MM_Object.h
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/19.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ENUM_LOING_TYPE)
{
    ENUM_LOING_TYPE_WEIXIN,
    ENUM_LOING_TYPE_CAIYA_ACCOUNT
};

@interface MM_Object : NSObject

@end




@interface MMTextAttachment : NSTextAttachment

@property (nonatomic) CGRect rect;

@end