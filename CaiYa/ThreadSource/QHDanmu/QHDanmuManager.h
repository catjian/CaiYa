//
//  QHDanmuManager.h
//  QHDanumuDemo
//
//  Created by chen on 15/6/28.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QHDanmuUtil.h"
#import "QHDanmuView.h"

@protocol QHDanmuManamgerDelegate <NSObject>

@required
- (void)QHDanmuManamgerChlickAction:(NSDictionary *)content;
- (void)QHDanmuManamgerShowEnd;

@end

/**
 *  弹幕状态
 */
typedef NS_ENUM(NSUInteger, DanmuManagerState) {
    /**
     *  弹幕准备
     */
    DanmuManagerStateWait = 1,
    /**
     *  弹幕关闭
     */
    DanmuManagerStateStop,
    /**
     *  弹幕运动
     */
    DanmuManagerStateAnimationing,
    /**
     *  弹幕暂停
     */
    DanmuManagerStatePause
};

@interface QHDanmuManager : NSObject
/**
 *  弹幕添加的UIView
 */
@property (nonatomic, strong, readonly) QHDanmuView *danmuView;
/**
 *  弹幕状态
 */
@property (nonatomic, readonly) DanmuManagerState danmuManagerState;

@property (nonatomic, weak) id<QHDanmuManamgerDelegate> delegate;
/**
 *  创建弹幕管理对象
 *
 *  @param frame 弹幕显示的frame
 *  @param infos 弹幕信息，数组集合
 *  @param view  弹幕添加的UIView
 *  @param time  弹幕刷新的间隔时间，一般1秒
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)infos inView:(UIView *)view durationTime:(NSUInteger)time;
/**
 *  弹幕初始化创建
 */
- (void)initStart;
/**
 *  弹幕滚动
 *
 *  @param startTime 目前的时间点
 */
- (void)rollDanmu:(NSTimeInterval)startTime;
/**
 *  弹幕关闭
 */
- (void)stop;
/**
 *  弹幕暂停
 */
- (void)pause;
/**
 *  弹幕继续
 *
 *  @param nowTime 现在的时间点
 */
- (void)resume:(NSTimeInterval)nowTime;
/**
 *  弹幕重新恢复
 */
- (void)restart;
/**
 *  发射弹幕
 *
 *  @param info 弹幕信息，字典集合
 */
- (void)insertDanmu:(NSDictionary *)info;
/**
 *  重置弹幕
 *
 *  @param frame 弹幕显示的frame
 *  @param infos 弹幕信息，数组集合
 *  @param view  弹幕添加的UIView
 *  @param time  弹幕刷新的间隔时间，一般1秒
 */
- (void)resetDanmuWithFrame:(CGRect)frame data:(NSArray *)infos inView:(UIView *)view durationTime:(NSUInteger)time;
/**
 *  重置弹幕
 *
 *  @param frame 弹幕显示的frame
 */
- (void)resetDanmuWithFrame:(CGRect)frame;

@end
