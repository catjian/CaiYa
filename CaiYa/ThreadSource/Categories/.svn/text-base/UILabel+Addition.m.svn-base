//
//  UILabel+Addition.m
//  达此
//
//  Created by kongbo on 14/12/2.
//  Copyright (c) 2014年 qwy. All rights reserved.
//

#import "UILabel+Addition.h"

@implementation UILabel (Addition)
- (float)getLabelHeight
{
    CGSize size = CGSizeMake(self.width, 0);
    
    CGRect labelsize = [self.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName] context:nil];
    
    return labelsize.size.height;
}

- (float)getLabelWidth
{
    CGSize size = CGSizeMake(0, self.height);
    
    CGRect labelsize = [self.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName] context:nil];
    
    return labelsize.size.width;
}

@end
