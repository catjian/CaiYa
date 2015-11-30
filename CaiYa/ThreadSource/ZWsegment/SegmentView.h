//
//  SegmentView.h
//
//  Created by apple on 15-8-30.
//  Copyright (c) 2015年 itcast. All rights reserved.
//  
#define kBtnWidth 107
#define kBtnHeight 40
#import <UIKit/UIKit.h>

@class SegmentView;

@protocol SegmentViewDelegate <NSObject, UIScrollViewDelegate>
- (void)segmentView:(SegmentView *)segmentView didSelectedSegmentAtIndex:(NSInteger)index;
@end

@interface SegmentView : UIScrollView

- (id)initWithTitles:(NSArray *)titles;


- (id)initWithImages:(NSArray *)images;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;

@property (nonatomic, weak) id<SegmentViewDelegate> delegate;

-(void)segemtBtnChange:(int)index;

@end