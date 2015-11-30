//
//  FirsterViewController.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/5.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "FirsterViewController.h"
#import "SDRefresh.h"
#import "JXBAdPageView.h"
#import "ExtensionContentViewController.h"
#import "DanmuContentViewController.h"
#import "SegmentView.h"
#import "AboutWebViewController.h"

#ifndef firsterCell_height
#define firsterCell_height 140
#endif

typedef NS_ENUM(NSUInteger, Article_Activity_Type)
{
    Article_Activity_Type_Zero,
    Article_Activity_Type_Time_Run,
    Article_Activity_Type_Time_Out,
    Article_Activity_Type_No_Money,
    Article_Activity_Type_Maximum
};

@interface FirsterViewController ()<UITableViewDataSource, UITableViewDelegate, JXBAdPageViewDelegate, SegmentViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@interface FirsterTableCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *heightTitleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *allSendNumLab;
@property (nonatomic, strong) UILabel *restSendNumLab;
@property (nonatomic, strong) UILabel *beginDateLab;
@property (nonatomic, strong) UILabel *endDateLab;
@property (nonatomic) Article_Activity_Type activityType;
@property (nonatomic, strong) UILabel *activityLab;

@end

@implementation FirsterTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_Width-10, firsterCell_height-25)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:view];
        {
            CGFloat offset_width = 100;
            self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(view.width-5-offset_width, 5, offset_width, 75)];
            [view addSubview:self.iconView];
            
            self.heightTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.iconView.left-10, 40)];
            [self.heightTitleLab setFont:[UIFont systemFontOfSize:16]];
            [self.heightTitleLab setTextColor:[UIColor blackColor]];
            [self.heightTitleLab setNumberOfLines:0];
            [self.heightTitleLab setLineBreakMode:NSLineBreakByCharWrapping];
            [view addSubview:self.heightTitleLab];
            
            UILabel *moneyTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, self.heightTitleLab.bottom+8, 55+(is_iPhone6?5:0), 24)];
            MMTextAttachment *imageAttachment = [[MMTextAttachment alloc] initWithData:nil ofType:nil];
            imageAttachment.rect = CGRectMake(10, -2, 14, 14);
            imageAttachment.image = [UIImage imageNamed:@"item_award"];
            NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"   奖励:"];
            [attributedString insertAttributedString:imageAttributedString atIndex:0];
            [moneyTitle setAttributedText:attributedString];
            [moneyTitle setTextColor:[UIColor whiteColor]];
            [moneyTitle setBackgroundColor:[UIColor orangeColor]];
            [moneyTitle setFont:[UIFont systemFontOfSize:12]];
            [moneyTitle.layer setCornerRadius:2];
            [moneyTitle.layer setMasksToBounds:YES];
            [view addSubview:moneyTitle];
            
            UILabel *moneyBack = [[UILabel alloc] initWithFrame:CGRectMake(moneyTitle.right-5, self.heightTitleLab.bottom+8, 145+(is_iPhone6?40:0), 24)];
            [moneyBack.layer setBorderWidth:1];
            [moneyBack.layer setBorderColor:[UIColor orangeColor].CGColor];
            [moneyBack.layer setCornerRadius:2];
            [view addSubview:moneyBack];
            
            self.moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(moneyTitle.right+1, self.heightTitleLab.bottom+8, 139+(is_iPhone6?40:0), 24)];
            [self.moneyLab setFont:[UIFont systemFontOfSize:is_iPhone6?12:9]];
            [view addSubview:self.moneyLab];
             
            self.allSendNumLab = [[UILabel alloc] initWithFrame:CGRectMake(5, self.moneyLab.bottom+10,(SCREEN_Width-10)/2-20, 20)];
            [self.allSendNumLab setFont:[UIFont systemFontOfSize:is_iPhone6?12:10]];
            [view addSubview:self.allSendNumLab];
            
            self.restSendNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.allSendNumLab.right, self.allSendNumLab.top,
                                                                            self.allSendNumLab.width, 20)];
            [self.restSendNumLab setFont:[UIFont systemFontOfSize:is_iPhone6?12:10]];
            [view addSubview:self.restSendNumLab];
            
            [self.iconView setHeight:self.allSendNumLab.top-5];
            
            self.activityLab = [[UILabel alloc] initWithFrame:CGRectMake(view.width-50-5, self.allSendNumLab.top+2, 50, 20)];
            [self.activityLab setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
            [self.activityLab setTextColor:[UIColor blackColor]];
            [self.activityLab setTextAlignment:NSTextAlignmentCenter];
            [self.activityLab setFont:[UIFont systemFontOfSize:12]];
            [self.activityLab.layer setCornerRadius:10];
            [self.activityLab.layer setMasksToBounds:YES];
            [view addSubview:self.activityLab];
        }
        
        UIView *Bottomview = [[UIView alloc] initWithFrame:CGRectMake(5, view.bottom+1, SCREEN_Width-10, 20)];
        [Bottomview setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:Bottomview];
        {
            self.beginDateLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,(Bottomview.width-20)/2, 20)];
            [self.beginDateLab setFont:[UIFont systemFontOfSize:10]];
            [self.beginDateLab setTextAlignment:NSTextAlignmentLeft];
            [Bottomview addSubview:self.beginDateLab];
            
            self.endDateLab = [[UILabel alloc] initWithFrame:CGRectMake(self.beginDateLab.right, 0,(Bottomview.width-20)/2, 20)];
            [self.endDateLab setFont:[UIFont systemFontOfSize:10]];
            [self.endDateLab setTextAlignment:NSTextAlignmentRight];
            [Bottomview addSubview:self.endDateLab];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    for (int i = 0; i < 2; i++)
    {
        UIView *view = [self.contentView viewWithTag:99+i];
        [view setHidden:YES];
        [view removeFromSuperview];
        view = nil;
    }
}

@end

@implementation FirsterViewController
{
    UITableView *_tableView;
    NSMutableArray *_tableData;
    SDRefreshFooterView *_refreshFooter;
    JXBAdPageView *_adScrollView;
    NSArray *_adPageDataArray;
    UICollectionView *_collectionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTarBarTitle:@"首页"];
    
    _tableData = [[NSMutableArray alloc] init];
    
    NSDictionary *loginDic = [[MM_Tools shareTools] getObjectForKey:LOGIN_ACTION_RESPINFO];
    NSString *playRole = loginDic[@"user"][@"playRole"];
    if (playRole == nil || playRole.length <= 0)
    {
        NSDictionary *parmeter = @{@"type":@"play_role", @"mobileLogin":@(YES)};
        [[MM_NetInstanceInterface sharedNetInstaceInterface] getDictListWithParameter:parmeter SuccessBlock:^(id respInfo) {
            if (respInfo && [respInfo isKindOfClass:[NSArray class]] && [(NSArray *)respInfo count] > 0)
            {
                NSMutableArray *names = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in respInfo)
                {
                    [names addObject:dic[@"value"]];
                }
                [[MM_Tools shareTools] customAlertViewWithCollectionWithContent:names ActionBlock:^(NSInteger buttonTag) {
                    [[MM_NetInstanceInterface sharedNetInstaceInterface] updatePlayRoleWithParameter:@{@"playRole":names[buttonTag]} SuccessBlock:^(id respInfo) {
                        [[MM_Tools shareTools] AlertViewWithTitle:respInfo[@"message"] MessageString:[NSString stringWithFormat:@"%@,您好",names[buttonTag]]];
                    } FailuerBlock:^(NSDictionary *error) {
                        
                    }];
                }];
            }
        } FailuerBlock:^(NSDictionary *error) {
        }];
    }
    else
    {
        [[MM_Tools shareTools] AlertViewWithTitle:nil MessageString:[NSString stringWithFormat:@"%@,您好",playRole]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MM_Tools shareTools] HideHUD];
    [self.navigationController setNavigationBarHidden:YES];
    [[MM_HomePageTabController shared] showTabBar:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

- (void)loadView
{
    [super loadView];
    CGFloat ip6_scale = 1;
    if (is_iPhone6)
    {
        ip6_scale = SCREEN_Width/320;
    }
    _adScrollView = [[JXBAdPageView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_Width, 110*ip6_scale)];
    [_adScrollView setBackgroundColor:[UIColor orangeColor]];
    _adScrollView.delegate = self;
    _adScrollView.bWebImage = YES;
    _adScrollView.iDisplayTime = 0;
    [self.view addSubview:_adScrollView];
    
    SegmentView *  segOne = [[SegmentView alloc] initWithTitles:@[@"列表",@"格子"]];
    [segOne setFrame:CGRectMake(0, _adScrollView.bottom, SCREEN_Width, 40)];
    segOne.backgroundColor = [UIColor whiteColor];
    segOne.delegate = self;
    [self.view addSubview:segOne];
    
    [self createTableViewWithTop:segOne.bottom];
    [self createCollectionViewWithTop:segOne.bottom];
}

- (void)createTableViewWithTop:(CGFloat)top
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, SCREEN_Width, SCREEN_Height-top-60)
                                              style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    [self.view addSubview:_tableView];
    [self setupFooter];
    [self setupHeader];
}

- (void)setDataSource
{
    __weak FirsterViewController *this = self;
    NSDictionary *parmeter = @{@"category.id":@"104", @"pageSize":@"3", @"pageNo":@"1"};
    [[MM_NetInstanceInterface sharedNetInstaceInterface] getArticleListWithParameter:parmeter
                                                                        SuccessBlock:^(NSDictionary *respInfo) {
                            __block NSDictionary *responseDic = respInfo[@"page"];
                            NSMutableArray *images = [[NSMutableArray alloc] init];
                            _adPageDataArray = responseDic[@"list"];
                            for (int i = 0; i < _adPageDataArray.count; i++)
                            {
                                NSDictionary *dic = _adPageDataArray[i];
                                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",IMAGESERVICE_URL,dic[@"image"]];
                                UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _adScrollView.width, _adScrollView.height)];
                                [contentView setBackgroundColor:[UIColor colorWithWhite:0.200 alpha:0.402]];
                                
                                switch (i)
                                {
                                    case 0:
                                    {
                                        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentView.width, contentView.height)];
                                        [lab setNumberOfLines:0];
                                        [lab setLineBreakMode:NSLineBreakByCharWrapping];
                                        [lab setText:[NSString stringWithFormat:@"亲，今日又发布了%ld个任务，速度分享吧！",[responseDic[@"count"] integerValue]]];
                                        [lab setTextColor:[UIColor whiteColor]];
                                        [lab setTextAlignment:NSTextAlignmentCenter];
                                        [contentView addSubview:lab];
                                    }
                                        break;
                                    case 1:
                                    {
                                        __strong FirsterViewController *stringThis = this;
                                        UIView *topView = [stringThis createTopView];
                                        [contentView addSubview:topView];
                                    }
                                        break;
                                    case 2:
                                    {
                                        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentView.width, contentView.height)];
                                        [lab setNumberOfLines:0];
                                        [lab setLineBreakMode:NSLineBreakByCharWrapping];
                                        [lab setText:@"get新技能！快来看看赚钱攻略吧，想赚多少就多少。"];
                                        [lab setTextColor:[UIColor whiteColor]];
                                        [lab setTextAlignment:NSTextAlignmentCenter];
                                        [contentView addSubview:lab];
                                    }
                                        break;
                                    default:
                                        break;
                                }
                                [images addObject:@{@"image":imageUrl, @"view":contentView}];
                            }
                            [_adScrollView startAdsWithContentArray:images block:^(NSInteger clickIndex) {
                                switch (clickIndex) {
                                    case 0:
                                    {
                                        
                                    }
                                        break;
                                    case 1:
                                    {
                                        MM_HomePageTabController *hRCon = (MM_HomePageTabController *)[AppDelegate shared].window.rootViewController;
                                        [hRCon selectButtonInteger:1];
                                    }
                                        break;
                                    case 2:
                                    {
                                        AboutWebViewController *vc = [[AboutWebViewController alloc] initWithWebUrl:@"/f/view-103-1001.html"];
                                        [vc setNavTarBarTitle:@"功能介绍"];
                                        [self.navigationController pushViewController:vc animated:YES];
                                    }
                                        break;
                                    default:
                                        break;
                                }
                                
                            }];
                                                                            
                                                                        }
                                                                        FailuerBlock:^(NSDictionary *error) {
                                                                            
                                                                        }];
    parmeter = @{@"category.id":@"101", @"posid":@"2", @"pageSize":@"10", @"pageNo":@"1"};
    [[MM_NetInstanceInterface sharedNetInstaceInterface] getArticleListWithParameter:parmeter
                                                                        SuccessBlock:^(NSDictionary *respInfo) {
                                                                            [_tableData removeAllObjects];
                            NSDictionary *responseDic = respInfo[@"page"];
                            for (NSDictionary *dic in responseDic[@"list"])
                            {
                                DebugLog(@"responseObject = %@",dic);
                                [_tableData addObject:dic];
                            }
                            [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                                                        }
                                                                        FailuerBlock:^(NSDictionary *error) {
                                                                            
                                                                        }];
}

- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader setBackgroundColor:[UIColor whiteColor]];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:_tableView isEffectedByNavigationController:NO];
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    __weak FirsterViewController *this = self;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [this setDataSource];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}

- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter setBackgroundColor:[UIColor whiteColor]];
    [refreshFooter addToScrollView:_tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    refreshFooter.isNoMoreRefreshing = NO;
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *parmeter = @{@"category.id":@"101", @"posid":@"2", @"pageSize":@"10", @"pageNo":@"2"};
        [[MM_NetInstanceInterface sharedNetInstaceInterface] getArticleListWithParameter:parmeter
                                                                            SuccessBlock:^(NSDictionary *respInfo) {
                            NSDictionary *responseDic = respInfo[@"page"];
                            for (NSDictionary *dic in responseDic[@"list"])
                            {
                                DebugLog(@"responseObject = %@",dic);
                                [_tableData addObject:dic];
                            }
                            if ([responseDic[@"count"] integerValue]< [responseDic[@"pageSize"] integerValue])
                            {
                                _refreshFooter.isNoMoreRefreshing = YES;
                                [_refreshFooter TextForNormalState:@"已经到最后了！"];
                            }
                            [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                                                            }
                                                                            FailuerBlock:^(NSDictionary *error) {
                                                                                
                                                                            }];
        [_refreshFooter endRefreshing];
    });
}

- (void)createCollectionViewWithTop:(CGFloat)top
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((SCREEN_Width-24)/3, (SCREEN_Width-24)/3)];//设置cell的尺寸
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    flowLayout.sectionInset = UIEdgeInsetsMake(6, 6, 6, 6);//设置其边界
    [flowLayout setMinimumLineSpacing:6];
    [flowLayout setMinimumInteritemSpacing:6];//左右间隔
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, top, SCREEN_Width, SCREEN_Height-top-60)
                                         collectionViewLayout:flowLayout];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    //注册Cell,必须要有
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    [_collectionView setTag:10];
    [_collectionView setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    [self.view addSubview:_collectionView];
    [_collectionView setHidden:YES];
}

- (UIView *)createTopView
{
    CGFloat offset_width = 50;
    UIView *titleTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, 100)];
    [titleTopView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *todayLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_Width-30-offset_width, 40)];
    [todayLab setTextColor:[UIColor whiteColor]];
    [todayLab setText:@"今日收益: "];
    [todayLab setFont:[UIFont systemFontOfSize:14]];
    [todayLab setTag:20];
    [titleTopView addSubview:todayLab];
    
    UILabel *forwardNumLab = [[UILabel alloc] initWithFrame:CGRectMake(todayLab.left, todayLab.bottom, todayLab.width/2, todayLab.height)];
    [forwardNumLab setTextColor:[UIColor whiteColor]];
    [forwardNumLab setText:@"今日转发: "];
    [forwardNumLab setFont:[UIFont systemFontOfSize:14]];
    [forwardNumLab setTag:21];
    [titleTopView addSubview:forwardNumLab];
    
    UILabel *readNumLab = [[UILabel alloc] initWithFrame:CGRectMake(forwardNumLab.right, forwardNumLab.top,
                                                                    forwardNumLab.width, forwardNumLab.height)];
    [readNumLab setTextColor:[UIColor whiteColor]];
    [readNumLab setText:@"今日阅读量: "];
    [readNumLab setFont:[UIFont systemFontOfSize:14]];
    [readNumLab setTag:22];
    [titleTopView addSubview:readNumLab];
    
    [self getCashStaticWithView:titleTopView];
    
    return titleTopView;
}

- (void)getCashStaticWithView:(UIView *)view
{
    __weak UIView *thisView = view;
    NSDictionary *loginDic = [[MM_Tools shareTools] getObjectForKey:LOGIN_ACTION_RESPINFO];
    [[MM_NetInstanceInterface sharedNetInstaceInterface] cashStaticWithParameter:@{@"user.id":loginDic[@"id"]}
                                                                    SuccessBlock:^(id respInfo) {
                                                                        if (respInfo && [respInfo isKindOfClass:[NSArray class]] && [(NSArray *)respInfo count]>0)
                                                                        {
                                                                            __strong UIView *strongView = thisView;
                                                                            NSDictionary *lastObject = [respInfo lastObject];
                                                                            UILabel *Lab = (UILabel *)[strongView viewWithTag:20];
                                                                            NSMutableString *labText = [[NSMutableString alloc] initWithString:@"今日收益: "];
                                                                            NSString *money = [NSString stringWithFormat:@"%.2f",[lastObject[@"v0"] floatValue]];
                                                                            [labText appendFormat:@"%@元     %d张电子券",money, [lastObject[@"v0coupon"] intValue]];
                                                                            NSMutableAttributedString *attristring = [[NSMutableAttributedString alloc] initWithString:labText];
                                                                            [attristring addAttribute:NSFontAttributeName
                                                                                                value:[UIFont boldSystemFontOfSize:24]
                                                                                                range:[labText rangeOfString:money]];
                                                                            [Lab setAttributedText:attristring];
                                                                            
                                                                            Lab = (UILabel *)[self.view viewWithTag:21];
                                                                            labText = [NSMutableString stringWithString:@"今日转发: "];
                                                                            [labText appendFormat:@"%d",[lastObject[@"v0f"] intValue]];
                                                                            [Lab setText:labText];
                                                                            
                                                                            Lab = (UILabel *)[self.view viewWithTag:22];
                                                                            labText = [NSMutableString stringWithString:@"今日阅读量: "];
                                                                            [labText appendFormat:@"%d",[lastObject[@"v0c"] intValue]];
                                                                            [Lab setText:labText];
                                                                        }
                                                                    }
                                                                    FailuerBlock:^(NSDictionary *error) {
                                                                        
                                                                    }];
}

#pragma mark - SegmentViewDelegate

- (void)segmentView:(SegmentView *)segmentView didSelectedSegmentAtIndex:(NSInteger)index
{
    if (index == 0)
    {
        [_tableView setHidden:NO];
        [_collectionView setHidden:YES];
    }
    else if (index == 1)
    {
        [_tableView setHidden:YES];
        [_collectionView setHidden:NO];
        [_collectionView reloadData];
    }
}

#pragma mark - tableView Delegate DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return firsterCell_height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"CELL_IDENTIFER";
    FirsterTableCell *cell = (FirsterTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell)
    {
        cell = [[FirsterTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    NSDictionary *dic = _tableData[indexPath.row];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",IMAGESERVICE_URL,dic[@"smallImage"]];
    [cell.iconView setWidth:100];
    [cell.iconView setHeight:75];
    CGPoint centerPoint = cell.iconView.center;
    __weak FirsterTableCell *this = cell;
    [cell.iconView setImageWithURL:[NSURL URLWithString:imageUrl]
                  placeholderImage:[UIImage imageNamed:@"ic_launch"]
                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                               UIImage *iconImage = image;
                               if (iconImage)
                               {
                                   [this.iconView setImage:image];
                                   CGSize newsize = iconImage.size;
                                   if (iconImage.size.width > iconImage.size.height)
                                   {
                                       if (iconImage.size.width/iconImage.size.height > this.iconView.width/this.iconView.height)
                                       {
                                           newsize = CGSizeMake(this.iconView.width, iconImage.size.height*(this.iconView.width/iconImage.size.width));
                                       }
                                       else
                                       {
                                           newsize = CGSizeMake(iconImage.size.width*(this.iconView.height/iconImage.size.height), this.iconView.height);
                                       }
                                   }
                                   if (iconImage.size.width < iconImage.size.height)
                                   {
                                       if (iconImage.size.height < this.iconView.height)
                                       {
                                           newsize = CGSizeMake(iconImage.size.width*(this.iconView.height/iconImage.size.height), this.iconView.height);
                                       }
                                       else
                                       {                
                                           newsize = CGSizeMake(iconImage.size.width*(this.iconView.height/iconImage.size.height), this.iconView.height);
                                       }
                                   }
                                   [this.iconView setWidth:newsize.width];
                                   [this.iconView setHeight:newsize.height];
                                   [this.iconView setCenter:centerPoint];
                               }
                  }];
    
    [cell.heightTitleLab setText:dic[@"description"]];
    
    NSString *forwardMoney = [NSString stringWithFormat:@"%@",dic[@"cyRewardRule"][@"forwardMoney"]];
    NSString *readM = [NSString stringWithFormat:@"%@",dic[@"cyRewardRule"][@"readMoney"]];
    NSString *readMoney = [NSString stringWithFormat:@"阅读:%@元",readM];
    NSString *profitMoney = [NSString stringWithFormat:@"%@张",dic[@"cyRewardRule"][@"forwardCouponValue"]];
    NSString *moneyLab = [NSString stringWithFormat:@"转发:%@元,%@,电子券:%@",forwardMoney,readMoney,profitMoney];
    {
        NSRange range = [moneyLab rangeOfString:forwardMoney];
        NSMutableAttributedString *attristring = [[NSMutableAttributedString alloc] initWithString:moneyLab];
        [attristring addAttribute:NSForegroundColorAttributeName
                            value:[UIColor orangeColor]
                            range:range];
        range = [moneyLab rangeOfString:readMoney];
        [attristring addAttribute:NSForegroundColorAttributeName
                            value:[UIColor orangeColor]
                            range:NSMakeRange(range.location+3, [readMoney rangeOfString:readM].length)];
        range = [moneyLab rangeOfString:profitMoney];
        [attristring addAttribute:NSForegroundColorAttributeName
                            value:[UIColor orangeColor]
                            range:NSMakeRange(range.location, 1)];
        [cell.moneyLab setAttributedText:attristring];
    }
    
    NSString *readTimes = [NSString stringWithFormat:@"%@",dic[@"readTimes"]];
    NSString *allSendNumLab = [@"投放次数: " stringByAppendingString:readTimes];
    {
        NSMutableAttributedString *attristring = [[NSMutableAttributedString alloc] initWithString:allSendNumLab];
        MMTextAttachment *imageAttachment = [[MMTextAttachment alloc] initWithData:nil ofType:nil];
        imageAttachment.rect = CGRectMake(0, -1, 10, 10);
        imageAttachment.image = [UIImage imageNamed:@"throw_count"];
        NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [attristring insertAttributedString:imageAttributedString atIndex:0];
        [cell.allSendNumLab setAttributedText:attristring];
    }
    
    NSString *loseTimes = [NSString stringWithFormat:@"%d",[dic[@"readTimes"] intValue] - [dic[@"readedTimes"] intValue]];
    NSString *restSendNumLab = [@"剩余次数: " stringByAppendingString:loseTimes];
    {
        NSMutableAttributedString *attristring = [[NSMutableAttributedString alloc] initWithString:restSendNumLab];
        MMTextAttachment *imageAttachment = [[MMTextAttachment alloc] initWithData:nil ofType:nil];
        imageAttachment.rect = CGRectMake(0, -1, 10, 10);
        imageAttachment.image = [UIImage imageNamed:@"surplus_count"];
        NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [attristring insertAttributedString:imageAttributedString atIndex:0];
        [cell.restSendNumLab setAttributedText:attristring];
    }
    
    NSString *startDate = dic[@"startDateStr"];
    {
        NSMutableAttributedString *attristring = [[NSMutableAttributedString alloc] initWithString:startDate];
        MMTextAttachment *imageAttachment = [[MMTextAttachment alloc] initWithData:nil ofType:nil];
        imageAttachment.rect = CGRectMake(0, -2, 10, 10);
        imageAttachment.image = [UIImage imageNamed:@"time"];
        NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [attristring insertAttributedString:imageAttributedString atIndex:0];
        [cell.beginDateLab setAttributedText:attristring];
    }
    NSString *invalidDate = dic[@"invalidDate"];
    if (invalidDate == nil)
    {
        [cell.endDateLab setText:[@"结束时间: " stringByAppendingString:@"2099年12月31日"]];
    }
    else
    {
        [cell.endDateLab setText:[@"结束时间: " stringByAppendingString:
                              [[MM_Tools shareTools] getNewTimeWithOldTime:invalidDate OldTimeFormate:@"yyyy-MM-dd HH:mm:ss" NewTimeFormat:@"yyyy年M月dd日"]]];
    }
    
    cell.activityType = Article_Activity_Type_Time_Run;
    if ([loseTimes integerValue] == 0 || [dic[@"cyUserArticleStatic"][@"coupon"] integerValue] > 0)
    {
        cell.activityType = Article_Activity_Type_No_Money;
    }
    else if ([dic[@"isInvalid"] integerValue] == 1)
    {
        cell.activityType = Article_Activity_Type_Time_Out;
    }
    
    [cell.activityLab setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    [cell.activityLab setTextColor:[UIColor blackColor]];
    switch (cell.activityType)
    {
        case Article_Activity_Type_Time_Run:
        {
            [cell.activityLab setText:@"进行中"];
            [cell.activityLab setBackgroundColor:[UIColor orangeColor]];
            [cell.activityLab setTextColor:[UIColor whiteColor]];
        }
            break;
        case Article_Activity_Type_Time_Out:
            [cell.activityLab setText:@"已过期"];
            break;
        case Article_Activity_Type_No_Money:
            [cell.activityLab setText:@"已分享"];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = _tableData[indexPath.row];
    DanmuContentViewController *vc = [[DanmuContentViewController alloc] initWithData:dic];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JXBAdPageView Delegate

- (void)setWebImage:(UIImageView *)imgView imgUrl:(NSString *)imgUrl
{
    [imgView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"m1"]];
}

#pragma mark - CollectionView Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _tableData.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _tableData[indexPath.row];
    //    ExtensionContentViewController *vc = [[ExtensionContentViewController alloc] initWithData:dic];
    DanmuContentViewController *vc = [[DanmuContentViewController alloc] initWithData:dic];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.layer setBorderWidth:1];
    [cell.layer setBorderColor:[UIColor colorWithWhite:0.592 alpha:1.000].CGColor];
    
    CGFloat offset_widht = cell.width-10;
    CGRect frame = CGRectMake((cell.width-offset_widht)/2, (cell.height-offset_widht)/2, offset_widht, offset_widht);
    UIImageView *cornerView = (UIImageView *)[cell viewWithTag:11];
    if (cornerView == nil)
    {
        cornerView = [[UIImageView alloc] initWithFrame:frame];
        [cornerView setTag:11];
        [cell addSubview:cornerView];
    }
    [cornerView setFrame:frame];
    NSDictionary *dic = _tableData[indexPath.row];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",IMAGESERVICE_URL,dic[@"smallImage"]];
    CGPoint centerPoint = cornerView.center;
    UIImageView *this = cornerView;
    [cornerView setImageWithURL:[NSURL URLWithString:imageUrl]
                  placeholderImage:[UIImage imageNamed:@"ic_launch"]
                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                               UIImage *iconImage = image;
                               if (iconImage)
                               {
                                   [this setImage:image];
                                   CGSize newsize = iconImage.size;
                                   if (iconImage.size.width > iconImage.size.height)
                                   {
                                       if (iconImage.size.width/iconImage.size.height > this.width/this.height)
                                       {
                                           newsize = CGSizeMake(this.width, iconImage.size.height*(this.width/iconImage.size.width));
                                       }
                                       else
                                       {
                                           newsize = CGSizeMake(iconImage.size.width*(this.height/iconImage.size.height), this.height);
                                       }
                                   }
                                   if (iconImage.size.width < iconImage.size.height)
                                   {
                                       if (iconImage.size.height < this.height)
                                       {
                                           newsize = CGSizeMake(iconImage.size.width*(this.height/iconImage.size.height), this.height);
                                       }
                                       else
                                       {
                                           newsize = CGSizeMake(iconImage.size.width*(this.height/iconImage.size.height), this.height);
                                       }
                                   }
                                   [this setWidth:newsize.width];
                                   [this setHeight:newsize.height];
                                   [this setCenter:centerPoint];
                               }
                           }];
    
    return cell;
}

@end
