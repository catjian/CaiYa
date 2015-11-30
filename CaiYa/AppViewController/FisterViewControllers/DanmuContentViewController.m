//
//  DanmuContentViewController.m
//  CaiYa
//
//  Created by zhang jian on 15/9/11.
//  Copyright (c) 2015年 zhang_jian. All rights reserved.
//

#import "DanmuContentViewController.h"
#import "QHDanmuManager.h"
#import "SDRefresh.h"
#import "NSTimer+EOCBlocksSupport.h"

typedef NS_ENUM(NSUInteger, Article_Activity_Type)
{
    Article_Activity_Type_Zero,
    Article_Activity_Type_Time_Run,
    Article_Activity_Type_Time_Out,
    Article_Activity_Type_No_Money,
    Article_Activity_Type_Maximum
};

@interface DanmuContentViewTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *contentLab;

@end

@implementation DanmuContentViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.photo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 50, 50)];
        [self.photo.layer setCornerRadius:25];
        [self.photo.layer setMasksToBounds:YES];
        [self.contentView addSubview:self.photo];
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(self.photo.right+10, self.photo.top, SCREEN_Width-self.photo.right-10, 30)];
        [self.nameLab setFont:self.textLabel.font];
        [self.contentView addSubview:self.nameLab];
        
        self.contentLab = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLab.left, self.nameLab.bottom, self.nameLab.width, 20)];
        [self.contentLab setFont:self.detailTextLabel.font];
        [self.contentView addSubview:self.contentLab];
    }
    return self;
}

@end

@interface DanmuContentViewController() <QHDanmuManamgerDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation DanmuContentViewController
{
    QHDanmuManager *_danmuManager;
    NSTimer *_timer;
    NSInteger _countTime;
    
    UITableView *_tableView;
    NSDictionary *_dicData;
    
    NSMutableArray *_tableData;
    SDRefreshFooterView *_refreshFooter;
    
    NSInteger _pageNum;
}

- (id)initWithData:(NSDictionary *)data
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _dicData = data;
        _tableData = [[NSMutableArray alloc] init];
        _pageNum = 2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTarBarTitle:@"分享"];
    [self setBackItem];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, SCREEN_Height) style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    
    [_tableView setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MM_HomePageTabController shared] showTabBar:NO];
    
    NSDictionary *parmeter = @{@"contentId":_dicData[@"id"], @"delFlag":@"0", @"mobileLogin":@"1", @"pageSize":@"10", @"pageNo":@"1"};
    [[MM_NetInstanceInterface sharedNetInstaceInterface] getCommentListWithParameter:parmeter
                                                                        SuccessBlock:^(NSArray *respInfo) {
                                                                            _tableData = [NSMutableArray arrayWithArray:respInfo];
                                                                            [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                                                            
                                                                            
                                                                            UIView *headerView = [self createHeaderView];
                                                                            [_tableView setTableHeaderView:headerView];
                                                                            
                                                                            [self setupFooter];
                                                                        }
                                                                        FailuerBlock:^(NSDictionary *error) {
                                                                            
                                                                        }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_tableView removeObserver:_refreshFooter forKeyPath:SDRefreshViewObservingkeyPath];
    [super viewWillDisappear:animated];
}

- (void)setupFooter
{
    _refreshFooter = [[SDRefreshFooterView alloc] init];
    [_refreshFooter setBackgroundColor:[UIColor whiteColor]];
    [_refreshFooter addToScrollView:_tableView];
    [_refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter.isNoMoreRefreshing = NO;
}

- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *parmeter = @{@"contentId":_dicData[@"id"], @"delFlag":@"0", @"mobileLogin":@(YES), @"pageSize":@"10", @"pageNo":@(_pageNum)};
        [[MM_NetInstanceInterface sharedNetInstaceInterface] getCommentListWithParameter:parmeter
                                                                            SuccessBlock:^(NSArray *respInfo) {
                                                                                if ([respInfo count] < 10)
                                                                                {
                                                                                    _refreshFooter.isNoMoreRefreshing = YES;
                                                                                    [_refreshFooter TextForNormalState:@"已经到最后了！"];
                                                                                }
                                                                                else
                                                                                {
                                                                                    _pageNum++;
                                                                                }
                                                                                [_tableData addObjectsFromArray:respInfo];
                                                                                [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                                                            }
                                                                            FailuerBlock:^(NSDictionary *error) {
                                                                                
                                                                            }];
        [_refreshFooter endRefreshing];
    });
}

- (void)backBarButtonItemAction:(UIButton *)btn
{
    [[MM_HomePageTabController shared] showTabBar:YES];
    [super backBarButtonItemAction:btn];
}

- (UIView *)createHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, SCREEN_Width)];
    [view setBackgroundColor:[UIColor colorWithWhite:0.800 alpha:1.000]];
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [logoImage setImage:[UIImage imageNamed:@"ic_launch"]];
    [view addSubview:logoImage];
    UILabel *logoName = [[UILabel alloc] initWithFrame:CGRectMake(logoImage.right+10, logoImage.top, SCREEN_Width - 240, logoImage.height)];
    [logoName setFont:[UIFont systemFontOfSize:16]];
    [logoName setText:@"国信安泰科技有限公司"];
    [logoName setNumberOfLines:0];
    [logoName setLineBreakMode:NSLineBreakByCharWrapping];
    [view addSubview:logoName];
    
    UILabel *activityLab = [[UILabel alloc] initWithFrame:CGRectMake(logoName.right+10, logoName.top, 120, 30)];
    [activityLab setFont:[UIFont boldSystemFontOfSize:14]];
    [activityLab setTextAlignment:NSTextAlignmentCenter];
    [activityLab.layer setCornerRadius:activityLab.height/2];
    [activityLab.layer setMasksToBounds:YES];
    [view addSubview:activityLab];
    Article_Activity_Type activityType = Article_Activity_Type_Time_Run;
    switch (activityType)
    {
        case Article_Activity_Type_Time_Run:
        {
            [activityLab setText:@"疯狂转发进行中"];
            [activityLab setBackgroundColor:[UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000]];
            [activityLab setTextColor:[UIColor whiteColor]];
        }
            break;
        case Article_Activity_Type_Time_Out:
            [activityLab setText:@"已过期"];
            [activityLab setFont:[UIFont boldSystemFontOfSize:16]];
            break;
        case Article_Activity_Type_No_Money:
            [activityLab setText:@"已分享"];
            [activityLab setFont:[UIFont boldSystemFontOfSize:16]];
            break;
        default:
            break;
    }
    
    UILabel *articleNum = [[UILabel alloc] initWithFrame:CGRectMake(activityLab.right, activityLab.top, 45, activityLab.height)];
    [articleNum setFont:[UIFont systemFontOfSize:14]];
    [articleNum setTextColor:[UIColor greenColor]];
    [articleNum setTextAlignment:NSTextAlignmentCenter];
    [articleNum setText:@"1.7K"];
    [view addSubview:articleNum];
    
    UILabel *endTime = [[UILabel alloc] initWithFrame:CGRectMake(activityLab.left, activityLab.bottom+5, activityLab.width+articleNum.width, 20)];
    [endTime setFont:[UIFont systemFontOfSize:10]];
    [endTime setTextAlignment:NSTextAlignmentRight];
    [endTime setText:@"截止日期：2015.09.26"];
    [view addSubview:endTime];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",IMAGESERVICE_URL, _dicData[@"smallImage"]];
    UIView *danmuShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_Width, SCREEN_Width*3/4)];
    UIImageView *contentImage = [[UIImageView alloc] initWithFrame:danmuShowView.frame];
    [view addSubview:contentImage];
    UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_Width-120, 0, 120, 60)];
    [moneyLab setTextAlignment:NSTextAlignmentCenter];
    NSString *forwardMoney = [NSString stringWithFormat:@"%@元",_dicData[@"cyRewardRule"][@"forwardMoney"]];
    NSString *moneyString = [NSString stringWithFormat:@"奖:%@",forwardMoney];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:moneyString];
    [attriString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:28]
                        range:[moneyString rangeOfString:forwardMoney]];
    [moneyLab setTextColor:[UIColor orangeColor]];
    [moneyLab setAttributedText:attriString];
    [moneyLab setBackgroundColor:[UIColor clearColor]];
    [view addSubview:moneyLab];
    [view addSubview:danmuShowView];
    
    CGPoint centerPoint = contentImage.center;
    __weak UIImageView *this = contentImage;
    [contentImage setImageWithURL:[NSURL URLWithString:imageUrl]
                 placeholderImage:[UIImage imageNamed:@"ic_launch"]
                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                              UIImage *iconImage = image;
                              if (iconImage)
                              {
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
                                  [danmuShowView setHeight:newsize.height];
                              }
                              [moneyLab setTop:this.bottom-moneyLab.height];
                              [self initDanmuManagerWithShowView:danmuShowView];
                          }];
    
    
    NSString *description = _dicData[@"description"];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, contentImage.bottom, SCREEN_Width-20, 40)];
    [title setFont:[UIFont systemFontOfSize:18]];
    [title setText:description];
    [view addSubview:title];
    CGSize descriptionSize = [description sizeWithAttributes:@{NSFontAttributeName:title.font}];
    if (descriptionSize.width > title.width)
    {
        [title setNumberOfLines:0];
        [title setLineBreakMode:NSLineBreakByCharWrapping];
        CGFloat times = descriptionSize.width/title.width;
        if (times > 1 && times <= 2)
        {
            title.height *= 1.5;
        }
        if (times > 2 && times <= 3)
        {
            title.height *= 2;
        }
        if (times > 3 && times <= 4)
        {
            title.height *= 2.5;
        }
    }
    
    NSMutableArray *testArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < _tableData.count; i++)
    {
        NSDictionary *dic = [_tableData objectAtIndex:i];
        [testArr addObject:dic[@"commentBy"][@"photo"]];
    }
    UIScrollView *userImages = [self commentUserImagesWithUsersInfo:testArr];
    [userImages setTop:title.bottom];
    [view addSubview:userImages];
    view.height = userImages.bottom;
    
    return view;
}

- (UIScrollView *)commentUserImagesWithUsersInfo:(NSArray *)infos
{
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, 40)];
    [scrollV setShowsVerticalScrollIndicator:NO];
    [scrollV setShowsHorizontalScrollIndicator:YES];
    [scrollV setContentSize:CGSizeMake(40*(infos.count+1), 40)];
    
    for (int i = 0; i < infos.count; i++)
    {
        NSString *imageUrl = infos[i];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(40+i*40, 5, 30, 30)];
        [imageV.layer setCornerRadius:imageV.height/2];
        [imageV.layer setMasksToBounds:YES];
        [imageV setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"user_icon"]];
        [scrollV addSubview:imageV];
    }
    
    return scrollV;
}

- (void)initDanmuManagerWithShowView:(UIView *)view
{   
    NSMutableArray *danmudata = [[NSMutableArray alloc] init];
    int i = 0;
    for (; i < 10; i++)
    {
        [danmudata addObject:@{kDanmuContentKey:[NSString stringWithFormat:@"---->%d",i], kDanmuTimeKey:[NSString stringWithFormat:@"%d",i]}];
    }
    _danmuManager = [[QHDanmuManager alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, view.height) data:danmudata inView:view durationTime:1];
    [_danmuManager initStart];
    [_danmuManager setDelegate:self];
    
    _countTime = -1;
    
    [self start];
}

- (void)start
{
    [_danmuManager initStart];
    
    if ([_timer isValid])
    {
        return;
    }
    if (_timer == nil)
    {
        __weak typeof(self) weakSelf = self;
        _timer = [NSTimer eoc_scheduledTimerWithTimeInterval:1 block:^{
            DanmuContentViewController *strogSelf = weakSelf;
            [strogSelf progressVideo];
        } repeats:YES];
    }
}

- (void)progressVideo
{
    _countTime++;
    [_danmuManager rollDanmu:_countTime];
}

- (void)pause
{
    if (_timer != nil)
    {
        [_timer invalidate];
        _timer = nil;
    }
    [_danmuManager pause];
}

- (void)resume
{
    [_danmuManager resume:_countTime];
    
    [self start];
}

#pragma mark - QHDanmuContentViewDelegate

- (void)QHDanmuManamgerShowEnd
{
    if (_timer != nil)
    {
        [_timer invalidate];
        _timer = nil;
    }
    _countTime = -1;
    [_danmuManager restart];
    
    [self start];
}

- (void)QHDanmuManamgerChlickAction:(NSDictionary *)content
{
    [self pause];
    [self showForwardCheckAlertView:content[@"content"]];
}

- (void)showForwardCheckAlertView:(NSString *)content
{
    __weak DanmuContentViewController *this = self;
    [[MM_Tools shareTools] customAlertViewWithType:CUNSTOM_ALERTVIEW_TYPE_BUTTON_AND_TEXTFIELD
                           TitleOrTextFieldMessage:content
                                 ButtonActionBlock:^(NSInteger buttonTag) {
                                     __strong DanmuContentViewController *strongThis = this;
                                     if (buttonTag == -1)
                                     {
                                         [strongThis resume];
                                         return ;
                                     }
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = _dicData[@"title"];
        if (!message.title || [message.title length] <= 0)
        {
            message.title = _dicData[@"article"][@"title"];
        }
        message.description = _dicData[@"description"];
        if (!message.description || [message.description length] <= 0)
        {
            message.description = _dicData[@"article"][@"description"];
        }
        
        UIImageView *imageV = [[UIImageView alloc] init];
        NSString *url = _dicData[@"smallImage"];
        if (!url || [url length] <= 0)
        {
            url = _dicData[@"article"][@"smallImage"];
        }
        url = [NSString stringWithFormat:@"%@%@",IMAGESERVICE_URL,url];
        UIImage *image = [imageV cachedImageForRequestUrl:[NSURL URLWithString:url]];
        [message setThumbImage:image];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        url = _dicData[@"url"];
        if (!url || [url length] <= 0)
        {
            url = _dicData[@"article"][@"url"];
        }
        NSString *urlstring = [NSString stringWithFormat:@"%@%@",IMAGESERVICE_URL,url];
        ext.webpageUrl = urlstring;
        
        message.mediaObject = ext;
        message.mediaTagName = @"caiya";
        
        if ([WXApi isWXAppInstalled])
        {
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            switch (buttonTag)
            {
                case 0:
                {
                    req.scene = WXSceneSession;
                    [[MM_Tools shareTools] set:@{@"SCENE_TYPE":@(WXAPI_SENDREP_TYPE_SCENE_SESSION),
                                                 @"articleId":_dicData[@"id"]} KeyString:WXAPI_SENDREP_TYPE];
                }
                    break;
                case 1:
                {
                    req.scene = WXSceneTimeline;
                    [[MM_Tools shareTools] set:@{@"SCENE_TYPE":@(WXAPI_SENDREP_TYPE_SCENE_TIMELINE),
                                                 @"articleId":_dicData[@"id"]} KeyString:WXAPI_SENDREP_TYPE];
                }
                    break;
                default:
                {
                    [strongThis resume];
                }
                    break;
            }
            
            [WXApi sendReq:req];
            [[MM_Tools shareTools] set:@{@"SCENE_TYPE":@(WXAPI_SENDREP_TYPE_SCENE_SESSION),
                                         @"articleId":_dicData[@"id"]} KeyString:WXAPI_SENDREP_TYPE];
        }
        else
        {
            [[MM_Tools shareTools] AlertViewWithTitle:@"提示" MessageString:@"未发现微信应用，请去App Store下载"];
            [strongThis resume];
            return;
        }
    }];
}

#pragma mark - tableView Delegate DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"CELL_IDENTIFER";
    DanmuContentViewTableViewCell *cell = (DanmuContentViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell)
    {
        cell = [[DanmuContentViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    NSDictionary *dic = [_tableData objectAtIndex:indexPath.row];
    [cell.photo setImageWithURL:[NSURL URLWithString:dic[@"commentBy"][@"photo"]] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    NSString *timeLab = [NSString stringWithFormat:@"转发于%@",[[MM_Tools shareTools] convertTimeWithString:dic[@"createDate"]]];
    NSString *text = [NSString stringWithFormat:@"%@ %@",dic[@"commentBy"][@"nickname"], timeLab];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:text];
    [attriString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:12]
                        range:[text rangeOfString:timeLab]];
    [cell.nameLab setAttributedText:attriString];
    [cell.contentLab setText:dic[@"content"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

@end
