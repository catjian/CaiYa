//
//  SegmentView.m
//
//  Created by apple on 15-8-30.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "SegmentView.h"
#import "UIImage+Fit.h"

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#endif

@interface MyButton: UIButton
@end

@implementation MyButton
- (void)setHighlighted:(BOOL)highlighted{}
@end

@interface SegmentView()
{
    UIButton *_currentBtn;
    UIButton *_preformBtn;
}
@end

@implementation SegmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
    }
    return self;
}

- (id)initWithTitles:(NSArray *)titles
{
    CGRect frame=CGRectMake(0, 0, SCREEN_WIDTH, kBtnHeight);
    if (self = [self initWithFrame:frame])
    {
        self.titles = titles;
        self.tag=100;
    }
    return self;
}

- (id)initWithImages:(NSArray *)images
{
    CGRect frame=CGRectMake(0, 0, SCREEN_WIDTH, kBtnHeight);
    if (self = [self initWithFrame:frame])
    {
        self.images = images;
        self.tag=100;
    }
    return self;
}

- (void)btnDown:(UIButton *)btn
{
    if (btn == _currentBtn) return;
    _currentBtn.selected = NO;
    btn.selected = YES;
    _currentBtn = btn;
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(segmentView:didSelectedSegmentAtIndex:)])
    {
        [self.delegate segmentView:self didSelectedSegmentAtIndex:btn.tag];
    }
}

-(void)segemtBtnChange:(int)index
{
    UIButton *btn=(UIButton *)[self viewWithTag:index];
    if (btn == _currentBtn) return;
    _currentBtn.selected = NO;
    btn.selected = YES;
    _currentBtn = btn;
    
}

- (void)setTitles:(NSArray *)titles
{
    // 数组内容一致，直接返回
    if ([titles isEqualToArray:_titles])
        return;
        
    _titles = titles;
    
    
    // 1.移除所有的按钮
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    // 2.添加新的按钮
    CGFloat contentWidth = 0;
    NSInteger count = titles.count;
    for (int i = 0; i < count; i++)
    {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        CGSize titleSize = [titles[i] sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}];
        float btnWidth = titleSize.width+20;
        btn.tag = i;
        contentWidth += btnWidth;
        // 设置按钮的frame
        btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, kBtnHeight);
        NSString *normal = @"seg";
        NSString *selected = @"segselect";
        [btn setBackgroundImage:[UIImage resizeImage:normal] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage resizeImage:selected] forState:UIControlStateSelected];
        
        // 设置文字
        // btn.adjustsImageWhenHighlighted = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        
        // 设置监听器
        [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
        // 设置选中
        if (i == 0)
        {
            [self btnDown:btn];
        }
        // 添加按钮
        [self addSubview:btn];
        if (i<count-1)
        {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width+btn.frame.origin.x, 5, 1, kBtnHeight-10)];
            [line setBackgroundColor:[UIColor colorWithWhite:0.800 alpha:0.850]];
            [self addSubview:line];
        }
    }
    self.contentSize = CGSizeMake(contentWidth>SCREEN_WIDTH?contentWidth:SCREEN_WIDTH, self.frame.size.height);
}

- (void)setImages:(NSArray *)images
{
    // 数组内容一致，直接返回
    if ([images isEqualToArray:_images])
        return;
    
    images = _images;
    
    
    // 1.移除所有的按钮
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 2.添加新的按钮
    NSInteger count = images.count;
    CGFloat contentWidth = 0;
    for (int i = 0; i<count; i++)
    {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        UIImage *norImage = [UIImage imageNamed:images[i][0]];
        UIImage *selImage = [UIImage imageNamed:images[i][1]];
        btn.tag = i;
        contentWidth += norImage.size.width;
        
        // 设置按钮的frame
        btn.frame = CGRectMake(i * (norImage.size.width+1), 0, norImage.size.width, kBtnHeight);
        NSString *normal = @"seg";
        NSString *selected = @"segselect";
        [btn setBackgroundImage:[UIImage resizeImage:normal] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage resizeImage:selected] forState:UIControlStateSelected];
        
        // 设置文字
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setBackgroundImage:norImage forState:UIControlStateNormal];
        [btn setBackgroundImage:selImage forState:UIControlStateSelected];
        
        // 设置监听器
        [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
        // 设置选中
        if (i == 0)
        {
            [self btnDown:btn];
        }
        // 添加按钮
        [self addSubview:btn];
        
        if (i<count-1)
        {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width+btn.frame.origin.x, 0, 1, kBtnHeight)];
            [line setBackgroundColor:[UIColor colorWithWhite:0.800 alpha:0.850]];
            [self addSubview:line];
        }
    }
    self.contentSize = CGSizeMake(contentWidth>SCREEN_WIDTH?contentWidth:SCREEN_WIDTH, self.frame.size.height);
}
@end
