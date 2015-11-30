//
//  QHDanmuContentView.m
//  DanMu_test
//
//  Created by zhang jian on 15/9/8.
//  Copyright (c) 2015年 zhang_jian. All rights reserved.
//

#import "QHDanmuContentView.h"

static NSString * const DANMU_FONT_SIZE_BIG = @"l";
static NSString * const DANMU_FONT_SIZE_MIDDLE = @"m";
static NSString * const DANMU_FONT_SIZE_SMALL = @"s";

static NSString * const DANMU_MOVE_MODE_ROLLING = @"l";
static NSString * const DANMU_MOVE_MODE_FADEOUT = @"f";

static NSString * const DANMU_POSITION_TOP = @"t";
static NSString * const DANMU_POSITION_MIDDLE = @"m";
static NSString * const DANMU_POSITION_BOTTOM = @"b";

#define ARC4RANDOM_MAX      0x100000000

#define ROLL_ANIMATION_DURATION_TIME 5

#define FADE_ANIMATION_DURATION_TIME 2
#define ANIMATION_DELAY_TIME 3

@interface QHDanmuContentView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) NSDictionary *info;
@property (nonatomic, readwrite) DanmuState danmuState;
@property (nonatomic, readwrite) CGFloat animationDuartion;
@property (nonatomic, strong, readwrite) NSDictionary *dicOptional;

@property (nonatomic, readwrite) CGFloat speed;
@property (nonatomic, readwrite) CGFloat currentRightX;

@property (nonatomic) NSUInteger nChannel;
@property (nonatomic, weak)   QHDanmuView *superView;

@property (nonatomic) CGFloat originalX;

@end

@implementation QHDanmuContentView
{
    UIImageView *_contentIconH;
    UIImageView *_contentIconF;
    UILabel *_contentlable;
}

- (void)dealloc
{
    _info = nil;
    _dicOptional = nil;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _contentIconH = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_contentIconH setImage:[UIImage imageNamed:@"danmu_default_icon"]];
        [_contentIconH.layer setMasksToBounds:YES];
        [self addSubview:_contentIconH];
        
        _contentIconF = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_contentIconF setImage:[UIImage imageNamed:@"danmu_default_icon"]];
        [_contentIconF.layer setMasksToBounds:YES];
//        [self addSubview:_contentIconF];
        
        _contentlable = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentlable setBackgroundColor:[UIColor redColor]];
        [self addSubview:_contentlable];
    }
    return self;
}

- (void)danmuContentViewClickAction:(UITapGestureRecognizer *)tapGesture
{
    CGPoint touchPoint = [tapGesture locationInView:_superView];
    for (NSDictionary *dic in _superView.movingLayers)
    {
        NSString *key = dic.allKeys.lastObject;
        CALayer *movingLayer = (CALayer *)[dic objectForKey:key];
        if ([movingLayer.presentationLayer hitTest:touchPoint])
        {
            NSLog(@"danmuContentViewButtonInAction content = %@",key);
            if (self.delegate && [self.delegate respondsToSelector:@selector(QHDanmuContentChlickAction:)])
            {
                [self.delegate QHDanmuContentChlickAction:@{@"content":key}];
            }
        }
    }
}

#pragma mark - Private

- (void)p_initData
{
    _contentlable.textColor = [UIColor blackColor];
    id optional = [QHDanmuUtil randomOptions];
    self.dicOptional = [NSDictionary dictionaryWithDictionary:optional];
    
    CGFloat fontsize = 15;
    if (self.isFontSizeBig)
    {
        fontsize = 19;
    }else if (self.isFontSizeMiddle)
    {
        fontsize = 17;
    }
    
    UIFont *font = [UIFont systemFontOfSize:fontsize];
    _contentlable.font = font;
    
    NSString *content = [_info objectForKey:kDanmuContentKey];
    _contentlable.text = content;
}

- (void)p_initFrame:(CGFloat)offsetX
{
    if (self.isMoveModeFadeOut)
    {
        NSInteger plus = ((arc4random() % 2) + 1) == 1 ? 1 : -1;
        offsetX = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 30.0f)*plus;
        NSString *content = [self.info objectForKey:kDanmuContentKey];
        CGSize size = [QHDanmuUtil getSizeWithString:content withFont:_contentlable.font size:(CGSize){MAXFLOAT, CHANNEL_HEIGHT}];
        CGRect frame = (CGRect){(CGPoint){0, 0}, (CGSize){size.width+CHANNEL_HEIGHT*3+10,CHANNEL_HEIGHT}};
        self.frame = frame;
        
        CGPoint center = _superView.center;
        center.x += offsetX;
        self.center = center;
        
        
        [_contentIconH setFrame:CGRectMake(0, 0, CHANNEL_HEIGHT, CHANNEL_HEIGHT)];
        [_contentIconH.layer setCornerRadius:CHANNEL_HEIGHT/2];
        
        [_contentlable setFrame:(CGRect){_contentIconH.frame.origin.x+_contentIconH.frame.size.width+5,0,(CGSize){size.width,CHANNEL_HEIGHT}}];
        
        [_contentIconF setFrame:CGRectMake(_contentlable.frame.origin.x+_contentlable.frame.size.width+5, 0, CHANNEL_HEIGHT, CHANNEL_HEIGHT)];
        [_contentIconF.layer setCornerRadius:CHANNEL_HEIGHT/2];
    }
    else
    {
        NSString *content = [self.info objectForKey:kDanmuContentKey];
        CGSize size = [QHDanmuUtil getSizeWithString:content withFont:_contentlable.font size:(CGSize){MAXFLOAT, CHANNEL_HEIGHT}];
        CGRect frame = (CGRect){(CGPoint){_superView.frame.size.width + offsetX, 0}, (CGSize){size.width+CHANNEL_HEIGHT*3+10,CHANNEL_HEIGHT}};
        self.frame = frame;
        _originalX = frame.origin.x + frame.size.width;
        
        
        [_contentIconH setFrame:CGRectMake(0, 0, CHANNEL_HEIGHT, CHANNEL_HEIGHT)];
        [_contentIconH.layer setCornerRadius:CHANNEL_HEIGHT/2];
        
        [_contentlable setFrame:(CGRect){_contentIconH.frame.origin.x+_contentIconH.frame.size.width+5,0,(CGSize){size.width,CHANNEL_HEIGHT}}];
        
        [_contentIconF setFrame:CGRectMake(_contentlable.frame.origin.x+_contentlable.frame.size.width+5, 0, CHANNEL_HEIGHT, CHANNEL_HEIGHT)];
        [_contentIconF.layer setCornerRadius:CHANNEL_HEIGHT/2];
    }
}

- (void)p_rollAnimation:(CGFloat)time delay:(NSTimeInterval)waitTime
{
    self.danmuState = DanmuStateAnimationing;
    
    CGSize layerSize = self.frame.size;
    self.layer.bounds = CGRectMake(0, 0, layerSize.width, layerSize.height);
    self.layer.anchorPoint = CGPointMake(0, 0);
    CALayer *movingLayer = self.layer;
    CGRect frame = self.frame;
    CABasicAnimation *moveLayerAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    [moveLayerAnimation setDelegate:self];
    moveLayerAnimation.fromValue = [NSValue valueWithCGPoint:frame.origin];
    frame.origin.x = -self.frame.size.width;
    moveLayerAnimation.toValue = [NSValue valueWithCGPoint:frame.origin];
    moveLayerAnimation.duration = time;
    moveLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [movingLayer addAnimation:moveLayerAnimation forKey:@"move"];
    
    [_superView.movingLayers addObject:@{_contentlable.text:movingLayer}];
    
    UITapGestureRecognizer *tagGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(danmuContentViewClickAction:)];
    [_superView addGestureRecognizer:tagGR];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        [self removeDanmu];
    }
}

- (void)p_fadeAnimation:(CGFloat)time delay:(NSTimeInterval)disappearTime waitTime:(NSTimeInterval)waitTime
{
    if (waitTime == 0)
    {
        self.alpha = 1;
        self.danmuState = DanmuStateAnimationing;
        [UIView animateWithDuration:time delay:disappearTime options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 0.2;
        } completion:^(BOOL finished) {
            if (finished)
                [self removeDanmu];
        }];
    }
    else
    {
        self.alpha = 0;
        [UIView animateWithDuration:0 delay:waitTime options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            self.danmuState = DanmuStateAnimationing;
            [UIView animateWithDuration:time delay:disappearTime options:UIViewAnimationOptionCurveLinear animations:^{
                self.alpha = 0.2;
            } completion:^(BOOL finished) {
                if (finished)
                    [self removeDanmu];
            }];
        }];
    }
}

#pragma mark - Action

+ (instancetype)createWithInfo:(NSDictionary *)info inView:(QHDanmuView *)view
{
    QHDanmuContentView *danmuLabel = [[QHDanmuContentView alloc] init];
    
    danmuLabel.info = info;
    danmuLabel.superView = view;
    danmuLabel.nChannel = 0;
    
    [danmuLabel p_initData];
    [danmuLabel p_initFrame:0];
    
    return danmuLabel;
}

- (void)setDanmuChannel:(NSUInteger)channel offset:(CGFloat)xy
{
    if (self.isMoveModeFadeOut)
    {
        self.danmuState = DanmuStateStop;
        self.nChannel = channel;
        CGRect frame = self.frame;
        frame.origin.y = xy;
        self.frame = frame;
        [_superView addSubview:self];
        [_superView bringSubviewToFront:self];
    }
    else
    {
        self.danmuState = DanmuStateStop;
        self.nChannel = channel;
        CGRect frame = self.frame;
        frame.origin.x += xy;
        frame.origin.y = [self getNewOriginY:xy];
        self.frame = frame;
        _originalX = frame.origin.x + frame.size.width;
        [_superView addSubview:self];
        [_superView bringSubviewToFront:self];
    }
}

- (CGFloat)getNewOriginY:(CGFloat)xy
{
    CGFloat offset_y = xy;
    if (offset_y > _superView.frame.size.height-CHANNEL_HEIGHT*1.5)
    {
        offset_y -= CHANNEL_HEIGHT*1.5;
        offset_y = [self getNewOriginY:offset_y];
    }
    return offset_y;
}

- (void)animationDanmuItem:(NSTimeInterval)waitTime
{
    if (self.isMoveModeFadeOut)
    {
        [self p_fadeAnimation:FADE_ANIMATION_DURATION_TIME delay:ANIMATION_DELAY_TIME waitTime:waitTime];
    }
    else
    {
        [self p_rollAnimation:self.animationDuartion delay:waitTime];
    }
}

- (void)pause
{
    self.danmuState = DanmuStateStop;
    UIView *view = self;
    CALayer *layer = view.layer;
    CGRect rect = view.frame;
    if (layer.presentationLayer) {
        rect = ((CALayer *)layer.presentationLayer).frame;
    }
    view.frame = rect;
    [view.layer removeAllAnimations];
}

- (void)resume:(NSTimeInterval)nowTime
{
    if (self.isMoveModeFadeOut)
    {
        if (self.danmuState == DanmuStateStop)
            [self p_fadeAnimation:FADE_ANIMATION_DURATION_TIME delay:ANIMATION_DELAY_TIME waitTime:0];
    }
    else
    {
        CGFloat waitTime = self.startTime;
        if (waitTime > nowTime)
            waitTime = waitTime - nowTime;
        else
            waitTime = 0;
        
        CGFloat time = (self.frame.origin.x + self.frame.size.width)/self.speed;
        [self p_rollAnimation:time delay:waitTime];
    }
}

- (void)removeDanmu
{
    if (self.isMoveModeFadeOut)
    {
        self.danmuState = DanmuStateFinish;
        [self.layer removeAllAnimations];
        [self removeFromSuperview];
    }
    else
    {
        self.danmuState = DanmuStateFinish;
        [self.layer removeAllAnimations];
        [self removeFromSuperview];
    }
}

#pragma mark - Get

- (CGFloat)speed
{
    _speed = _originalX/self.animationDuartion;
    return _speed;
}

- (CGFloat)animationDuartion
{
    if (self.isMoveModeFadeOut)
    {
        //如果是竖屏
        _animationDuartion = FADE_ANIMATION_DURATION_TIME + ANIMATION_DELAY_TIME;
        //如果是横屏，根据不同尺寸，可能有不同的总时间
    }
    else
    {
        _animationDuartion = ROLL_ANIMATION_DURATION_TIME;
    }
    return _animationDuartion;
}

- (CGFloat)currentRightX
{
    switch (self.danmuState)
    {
        case DanmuStateStop:
        {
            _currentRightX = CGRectGetMaxX(self.frame) - _superView.frame.size.width;
            break;
        }
        case DanmuStateAnimationing:
        {
            CALayer *layer = self.layer;
            _currentRightX = _originalX;
            if (layer.presentationLayer)
                _currentRightX = ((CALayer *)layer.presentationLayer).frame.origin.x + self.frame.size.width;
            _currentRightX -= _superView.frame.size.width;
            break;
        }
        case DanmuStateFinish:
        {
            _currentRightX = -_superView.frame.size.width;
            break;
        }
        default:
        {
            break;
        }
    }
    return _currentRightX;
}

#pragma mark -

- (CGFloat)startTime
{
    return [[self.info valueForKey:kDanmuTimeKey] floatValue];
}

- (NSString *)fontSize
{
    return [self.dicOptional valueForKey: @"s"];
}

- (NSString *)moveMode
{
    return [self.dicOptional valueForKey: @"m"];
}

- (NSString *)position
{
    return [self.dicOptional valueForKey: @"p"];
}

- (BOOL)isFontSizeBig
{
    return [[self fontSize] isEqualToString: DANMU_FONT_SIZE_BIG];
}

- (BOOL)isFontSizeMiddle
{
    return [[self fontSize] isEqualToString: DANMU_FONT_SIZE_MIDDLE];
}

- (BOOL)isFontSizeSmall
{
    return [[self fontSize] isEqualToString: DANMU_FONT_SIZE_SMALL];
}

- (BOOL)isMoveModeRolling
{
    return [[self moveMode] isEqualToString: DANMU_MOVE_MODE_ROLLING];
}

- (BOOL)isMoveModeFadeOut
{
    return [[self moveMode] isEqualToString: DANMU_MOVE_MODE_FADEOUT];
}

- (BOOL)isPositionTop
{
    return [[self position] isEqualToString: DANMU_POSITION_TOP];
}

- (BOOL)isPositionMiddle
{
    return [[self position] isEqualToString: DANMU_POSITION_MIDDLE];
}

- (BOOL)isPositionBottom
{
    return [[self position] isEqualToString: DANMU_POSITION_BOTTOM];
}

@end

