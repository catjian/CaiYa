//
//  JXBAdPageView.m
//  XBAdPageView
//
//  Created by Peter Jin mail:i@Jxb.name on 15/5/13.
//  Github ---- https://github.com/JxbSir
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "JXBAdPageView.h"

@interface JXBAdPageView()<UIScrollViewDelegate>
@property (nonatomic,assign)int                 indexShow;
@property (nonatomic,copy)NSArray               *arrImage;
@property (nonatomic,strong)UIScrollView        *scView;
@property (nonatomic,strong)UIImageView         *imgPrev;
@property (nonatomic,strong)UIImageView         *imgCurrent;
@property (nonatomic,strong)UIImageView         *imgNext;
@property (nonatomic,strong)NSTimer             *myTimer;
@property (nonatomic,strong)JXBAdPageCallback   myBlock;
@end

@implementation JXBAdPageView
{
    NSInteger contentType;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initUI];
}

- (void)initUI {
    _scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scView.delegate = self;
    _scView.pagingEnabled = YES;
    _scView.bounces = NO;
    _scView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
    _scView.showsHorizontalScrollIndicator = NO;
    _scView.showsVerticalScrollIndicator = NO;
    [_scView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self addSubview:_scView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAds)];
    [_scView addGestureRecognizer:tap];
    
    
    _imgPrev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _imgCurrent = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    _imgNext = [[UIImageView alloc] initWithFrame:CGRectMake(2*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    
    [_scView addSubview:_imgPrev];
    [_scView addSubview:_imgCurrent];
    [_scView addSubview:_imgNext];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-10, self.frame.size.width, 0)];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:_pageControl];
}

/**
 *  启动函数
 *
 *  @param imageArray 图片数组
 *  @param block      click回调
 */
- (void)startAdsWithBlock:(NSArray*)imageArray block:(JXBAdPageCallback)block {
    contentType = 0;
    if(imageArray.count <= 1)
        _scView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    _pageControl.numberOfPages = imageArray.count;
    _arrImage = imageArray;
    _myBlock = block;
    [self reloadImages];
}

- (void)startAdsWithContentArray:(NSArray*)contentArray block:(JXBAdPageCallback)block {
    contentType = 1;
    if(contentArray.count <= 1)
        _scView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    _pageControl.numberOfPages = contentArray.count;
    _arrImage = contentArray;
    _myBlock = block;
    [self reloadImages];
}

/**
 *  点击广告
 */
- (void)tapAds
{
    if (_myBlock != NULL)
    {
        _myBlock(_indexShow);
    }
}

/**
 *  加载图片顺序
 */
- (void)reloadImages
{
    if (_indexShow >= (int)_arrImage.count)
        _indexShow = 0;
    if (_indexShow < 0)
        _indexShow = (int)_arrImage.count - 1;
    int prev = _indexShow - 1;
    if (prev < 0)
        prev = (int)_arrImage.count - 1;
    int next = _indexShow + 1;
    if (next > _arrImage.count - 1)
        next = 0;
    _pageControl.currentPage = _indexShow;
    if (contentType == 0)
    {
        NSString* prevImage = [_arrImage objectAtIndex:prev];
        NSString* curImage = [_arrImage objectAtIndex:_indexShow];
        NSString* nextImage = [_arrImage objectAtIndex:next];
        if(_bWebImage)
        {
            if(_delegate && [_delegate respondsToSelector:@selector(setWebImage:imgUrl:)])
            {
                [_delegate setWebImage:_imgPrev imgUrl:prevImage];
                [_delegate setWebImage:_imgCurrent imgUrl:curImage];
                [_delegate setWebImage:_imgNext imgUrl:nextImage];
            }
            else
            {
                _imgPrev.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:prevImage]]];
                _imgCurrent.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:curImage]]];
                _imgNext.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nextImage]]];
            }
        }
        else
        {
            _imgPrev.image = [UIImage imageNamed:prevImage];
            _imgCurrent.image = [UIImage imageNamed:curImage];
            _imgNext.image = [UIImage imageNamed:nextImage];
        }
    }
    else if (contentType == 1)
    {
        NSDictionary* prevDic = [_arrImage objectAtIndex:prev];
        NSDictionary* curDic = [_arrImage objectAtIndex:_indexShow];
        NSDictionary* nextDic = [_arrImage objectAtIndex:next];
        UIView *subView = prevDic[@"view"];
        if (subView != nil)
        {
            [_imgPrev addSubview:subView];
        }
        subView = curDic[@"view"];
        if (subView != nil)
        {
            [_imgCurrent addSubview:subView];
        }
        subView = nextDic[@"view"];
        if (subView != nil)
        {
            [_imgNext addSubview:subView];
        }
        if(_bWebImage)
        {
            if(_delegate && [_delegate respondsToSelector:@selector(setWebImage:imgUrl:)])
            {
                [_delegate setWebImage:_imgPrev imgUrl:prevDic[@"image"]];
                [_delegate setWebImage:_imgCurrent imgUrl:curDic[@"image"]];
                [_delegate setWebImage:_imgNext imgUrl:nextDic[@"image"]];
            }
            else
            {
                _imgPrev.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:prevDic[@"image"]]]];
                _imgCurrent.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:curDic[@"image"]]]];
                _imgNext.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nextDic[@"image"]]]];
            }
        }
        else
        {
            _imgPrev.image = [UIImage imageNamed:prevDic[@"image"]];
            _imgCurrent.image = [UIImage imageNamed:curDic[@"image"]];
            _imgNext.image = [UIImage imageNamed:nextDic[@"image"]];
        }
    }
    [_scView scrollRectToVisible:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO];
    
    if (_iDisplayTime > 0)
        [self startTimerPlay];
}

/**
 *  切换图片完毕事件
 *
 *  @param scrollView
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_myTimer)
        [_myTimer invalidate];
    if (scrollView.contentOffset.x >=self.frame.size.width*2)
        _indexShow++;
    else if (scrollView.contentOffset.x < self.frame.size.width)
        _indexShow--;
    [self reloadImages];
}

- (void)startTimerPlay {
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:_iDisplayTime target:self selector:@selector(doImageGoDisplay) userInfo:nil repeats:NO];
}

/**
 *  轮播图片
 */
- (void)doImageGoDisplay {
    [_scView scrollRectToVisible:CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height) animated:YES];
    _indexShow++;
    [self performSelector:@selector(reloadImages) withObject:nil afterDelay:0.3];
}

@end
