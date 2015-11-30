//
//  MM_Object.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/19.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "MM_Object.h"

@implementation MM_Object

@end


@interface MMTextAttachment ()
{
    
}
@end

@implementation MMTextAttachment
//I want my emoticon has the same size with line's height
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0)
{
    if (self.rect.size.width != 0 && self.rect.size.height != 0)
    {
        return self.rect;
    }
    else
    {
        return CGRectMake(0 , 0 , 20 , 20);
    }
}
@end