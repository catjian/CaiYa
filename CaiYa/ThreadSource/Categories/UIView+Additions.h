//
//  UIView+Additions.h
//  Daci
//
//  Created by Frank Chen on 14-8-10.
//  Copyright (c) 2014年 qwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

//事件响应链
- (UIViewController *)viewController;

@end
