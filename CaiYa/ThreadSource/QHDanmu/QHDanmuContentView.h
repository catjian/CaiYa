//
//  QHDanmuContentView.h
//  DanMu_test
//
//  Created by zhang jian on 15/9/8.
//  Copyright (c) 2015年 zhang_jian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHDanmuUtil.h"
#import "QHDanmuView.h"

@protocol QHDanmuContentViewDelegate <NSObject>

@required
- (void)QHDanmuContentChlickAction:(NSDictionary *)content;

@end

@interface QHDanmuContentView : UIView

@property (nonatomic, weak) id<QHDanmuContentViewDelegate> delegate;

@property (nonatomic, strong, readonly) NSDictionary *info;
@property (nonatomic, readonly) DanmuState danmuState;
@property (nonatomic, readonly) CGFloat animationDuartion;
@property (nonatomic, strong, readonly) NSDictionary *dicOptional;

@property (nonatomic, readonly) CGFloat speed;
@property (nonatomic, readonly) CGFloat currentRightX;

@property (nonatomic, readonly) CGFloat startTime;
/**
 *  获取对应属性
 */
@property (nonatomic, getter=isFontSizeBig,     readonly) BOOL fontSizeBig;
@property (nonatomic, getter=isFontSizeMiddle,  readonly) BOOL fontSizeMiddle;
@property (nonatomic, getter=isFontSizeSmall,   readonly) BOOL fontSizeSmall;
@property (nonatomic, getter=isMoveModeRolling, readonly) BOOL moveModeRolling;
@property (nonatomic, getter=isMoveModeFadeOut, readonly) BOOL moveModeFadeOut;
@property (nonatomic, getter=isPositionTop,     readonly) BOOL positionTop;
@property (nonatomic, getter=isPositionMiddle,  readonly) BOOL positionMiddle;
@property (nonatomic, getter=isPositionBottom,  readonly) BOOL positionBottom;

+ (instancetype)createWithInfo:(NSDictionary *)info inView:(QHDanmuView *)view;

- (void)setDanmuChannel:(NSUInteger)channel offset:(CGFloat)xy;

- (void)animationDanmuItem:(NSTimeInterval)waitTime;

- (void)pause;

- (void)resume:(NSTimeInterval)nowTime;

- (void)removeDanmu;

@end
