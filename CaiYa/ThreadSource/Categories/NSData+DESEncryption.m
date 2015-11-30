//
//  NSData+DESEncryption.m
//  达此
//
//  Created by Frank Chen on 26/12/14.
//  Copyright (c) 2014 qwy. All rights reserved.
//

#import "NSData+DESEncryption.h"

@implementation NSData (DESEncryption)

- (NSString *)base64Encoding
{
    if (self.length == 0)
        return @"";
    char *characters = malloc(self.length*3/2);
    if (characters == NULL)
        return @"";
    
    int end = (int)self.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;

    while (index <= end) {
        int d = (((int)(((char *)[self bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[self bytes])[index + 1]) & 0x0ff) << 8) | ((int)(((char *)[self bytes])[index + 2]) & 0x0ff);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];

        index += 3;
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == self.length - 2)
    {
            
        int d = (((int)(((char *)[self bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[self bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == self.length - 1){
        int d = ((int)(((char *)[self bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    
    return rtnStr;
}

@end
