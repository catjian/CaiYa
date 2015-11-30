//
//  NSString+DESDecryption.m
//  SchoolMateApp
//
//  Created by zhang jian on 15/5/4.
//  Copyright (c) 2015年 CY Tech. All rights reserved.
//

#import "NSString+DESDecryption.h"

@implementation NSString (DESDecryption)

- (NSData *)base64Decode
{
    if (self == nil || self.length <= 0)
    {
        return nil;
    }
    NSMutableData *rtnData = [[NSMutableData alloc]init];
    int slen = (int)self.length;
    int index = 0;
    while (true)
    {
        while (index < slen && [self characterAtIndex:index] <= ' ')
        {
            index++;
        }
        if (index >= slen || index  + 3 >= slen)
        {
            break;
        }
        
        int byte = ([self char2Int:[self characterAtIndex:index]] << 18) + ([self char2Int:[self characterAtIndex:index + 1]] << 12) + ([self char2Int:[self characterAtIndex:index + 2]] << 6) + [self char2Int:[self characterAtIndex:index + 3]];
        Byte temp1 = (byte >> 16) & 255;
        [rtnData appendBytes:&temp1 length:1];
        if([self characterAtIndex:index + 2] == '=') {
            break;
        }
        Byte temp2 = (byte >> 8) & 255;
        [rtnData appendBytes:&temp2 length:1];
        if([self characterAtIndex:index + 3] == '=') {
            break;
        }
        Byte temp3 = byte & 255;
        [rtnData appendBytes:&temp3 length:1];
        index += 4;
        
    }
    return rtnData;
}

- (int)char2Int:(char)c
{
    if (c >= 'A' && c <= 'Z') {
        return c - 65;
    } else if (c >= 'a' && c <= 'z') {
        return c - 97 + 26;
    } else if (c >= '0' && c <= '9') {
        return c - 48 + 26 + 26;
    } else {
        switch(c) {
            case '+':
                return 62;
            case '/':
                return 63;
            case '=':
                return 0;
            default:
                return -1;
        }
    }
}

@end
