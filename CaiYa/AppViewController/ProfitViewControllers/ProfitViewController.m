//
//  ProfitViewController.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/5.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "ProfitViewController.h"
#import "ShowProfitViewController.h"
#import "ExtensionContentViewController.h"

#ifndef firsterCell_height
#define firsterCell_height 120
#endif

@interface MyForwardCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *heightTitleLab;
@property (nonatomic, strong) UILabel *allSendNumLab;
@property (nonatomic, strong) UILabel *endDateLab;

@end

@implementation MyForwardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        CGFloat offset_width = 100;
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, offset_width, offset_width)];
        [self.contentView addSubview:self.iconView];
        
        self.heightTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.right+10, 5, SCREEN_Width-20-self.iconView.right, 50)];
        [self.heightTitleLab setFont:[UIFont systemFontOfSize:16]];
        [self.heightTitleLab setTextColor:[UIColor blackColor]];
        [self.heightTitleLab setNumberOfLines:0];
        [self.heightTitleLab setLineBreakMode:NSLineBreakByCharWrapping];
        [self.contentView addSubview:self.heightTitleLab];
        
        self.allSendNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.heightTitleLab.left, self.heightTitleLab.bottom, self.heightTitleLab.width, 30)];
        [self.allSendNumLab setFont:[UIFont systemFontOfSize:16]];
        [self.allSendNumLab setTextColor:[UIColor orangeColor]];
        [self.contentView addSubview:self.allSendNumLab];
        
        self.endDateLab = [[UILabel alloc] initWithFrame:CGRectMake(self.heightTitleLab.left, self.allSendNumLab.bottom,self.heightTitleLab.width, 30)];
        [self.endDateLab setFont:[UIFont systemFontOfSize:16]];
        [self.contentView addSubview:self.endDateLab];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, firsterCell_height-1, SCREEN_Width, 1)];
        [line setBackgroundColor:[UIColor colorWithWhite:0.800 alpha:1.000]];
        [self.contentView addSubview:line];
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

@interface ProfitViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ProfitViewController
{
    NSDictionary *_CashData;
    UIScrollView *_backScrollView;
    UITableView *_tableView;
    NSArray *_tableData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTarBarTitle:@"收益"];
    // Do any additional setup after loading the view.
    _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.top, SCREEN_Width, SCREEN_Height-60)];
    [_backScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_backScrollView];
    
    CGFloat offset_y = 0;
    offset_y = [self initTopView];
    offset_y = [self initProfitTitleViewWithTop:offset_y];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, offset_y, SCREEN_Width, SCREEN_Height-64-offset_y)
                                              style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    [self.view addSubview:_tableView];
    
    [self getCashStatic];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    if (_tableData == nil || _tableData.count <= 0)
    {
        NSDictionary *loginDic = [[MM_Tools shareTools] getObjectForKey:LOGIN_ACTION_RESPINFO];
        NSDictionary *parmeter = @{@"user.id":loginDic[@"id"], @"pageSize":@"1000", @"pageNo":@"1"};
        [[MM_NetInstanceInterface sharedNetInstaceInterface] userArticleStaticWithParameter:parmeter
                                                                               SuccessBlock:^(id respInfo) {
                                                                                   if (respInfo && [respInfo isKindOfClass:[NSArray class]] && [respInfo count] > 0)
                                                                                   {
                                                                                       _tableData = respInfo;
                                                                                       [_tableView reloadData];
                                                                                   }
                                                                               }
                                                                               FailuerBlock:^(NSDictionary *error) {
                                                                                   
                                                                               }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

- (CGFloat)initTopView
{
    CGFloat offset_width = 50;
    UIView *titleTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, 100)];
    [titleTopView setBackgroundColor:[UIColor blackColor]];
    [_backScrollView addSubview:titleTopView];
    
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
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(todayLab.right, todayLab.top+(todayLab.height-20)/2, offset_width, 24)];
    [button setTitle:@"晒单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"profit_show"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 30);
    [button setBackgroundColor:[UIColor orangeColor]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button.layer setCornerRadius:5];
    [button addTarget:self action:@selector(ShowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleTopView addSubview:button];
    
    return titleTopView.bottom;
}

- (CGFloat)initProfitTitleViewWithTop:(CGFloat)offset_y
{
    UIView *profitTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, offset_y, SCREEN_Width, 75)];
    [profitTitleView setBackgroundColor:[UIColor whiteColor]];
    [profitTitleView setTag:100];
    [_backScrollView addSubview:profitTitleView];
    
    UILabel *todayLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, profitTitleView.width-40, 30)];
    [todayLab setTextColor:[UIColor blackColor]];
    [todayLab setText:@"历史总收益: "];
    [todayLab setFont:[UIFont systemFontOfSize:14]];
    [todayLab setTag:103];
    [profitTitleView addSubview:todayLab];
    
    UILabel *forwardNumLab = [[UILabel alloc] initWithFrame:CGRectMake(todayLab.left, todayLab.bottom+5, todayLab.width, todayLab.height)];
    [forwardNumLab setTextColor:[UIColor blackColor]];
    [forwardNumLab setText:@"可用收益: "];
    [forwardNumLab setFont:[UIFont systemFontOfSize:14]];
    [forwardNumLab setTag:104];
    [profitTitleView addSubview:forwardNumLab];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, profitTitleView.height-1, profitTitleView.width, 1)];
    [line setBackgroundColor:[UIColor colorWithWhite:0.800 alpha:1.000]];
    [profitTitleView addSubview:line];
    
    return profitTitleView.bottom;
}

- (void)ShowButtonAction:(UIButton *)button
{
    [[MM_Tools shareTools] customAlertViewWithType:CUNSTOM_ALERTVIEW_TYPE_ONLY_BUTTON ButtonActionBlock:^(NSInteger buttonTag) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = nil;
        message.description = [NSString stringWithFormat:@"通过菜牙我已经赚了%.2f元，小伙伴们一起行动吧!",[_CashData[@"totalcash"] floatValue]];
        [message setThumbImage:[UIImage imageNamed:@"ic_launch"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        NSString *urlstring = [NSString stringWithFormat:@"%@/f/view-103-1003.html",WEBSERVICE_URL];
        ext.webpageUrl = urlstring;
        
        message.mediaObject = ext;
        message.mediaTagName = @"MicroMakeMoney";
        
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
                                                 @"articleId":@"晒单"} KeyString:WXAPI_SENDREP_TYPE];
                }
                    break;
                case 1:
                {                    
                    req.scene = WXSceneTimeline;
                    [[MM_Tools shareTools] set:@{@"SCENE_TYPE":@(WXAPI_SENDREP_TYPE_SCENE_TIMELINE),
                                                 @"articleId":@"晒单"} KeyString:WXAPI_SENDREP_TYPE];
                }
                    break;
                default:
                    break;
            }
            [WXApi sendReq:req];
        }
        else
        {            
            [[MM_Tools shareTools] AlertViewWithTitle:@"提示" MessageString:@"未发现微信应用，请去App Store下载"];
            return;
        }
    }];
}

- (void)getCashStatic
{
    NSDictionary *loginDic = [[MM_Tools shareTools] getObjectForKey:LOGIN_ACTION_RESPINFO];
    [[MM_NetInstanceInterface sharedNetInstaceInterface] cashStaticWithParameter:@{@"user.id":loginDic[@"id"]}
                                                                    SuccessBlock:^(id respInfo) {
                                                                        if (respInfo && [respInfo isKindOfClass:[NSArray class]] && [(NSArray *)respInfo count]>0)
                                                                        {
                                                                            NSDictionary *lastObject = [respInfo lastObject];
                                                                            _CashData = lastObject;
                                                                            UILabel *Lab = (UILabel *)[self.view viewWithTag:20];
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
                                                                            
                                                                            UIView *profitTitleView = [_backScrollView viewWithTag:100];
                                                                            Lab = (UILabel *)[profitTitleView viewWithTag:103];
                                                                            labText = [[NSMutableString alloc] initWithString:@"历史总收益:  "];
                                                                            money = [NSString stringWithFormat:@"%.2f",[lastObject[@"totalcash"] floatValue]];
                                                                            [labText appendFormat:@"%@元     %d张电子券",money, [lastObject[@"totalcoupon"] intValue]];
                                                                            attristring = [[NSMutableAttributedString alloc] initWithString:labText];
                                                                            [attristring addAttribute:NSFontAttributeName
                                                                                                value:[UIFont boldSystemFontOfSize:24]
                                                                                                range:[labText rangeOfString:money]];
                                                                            [Lab setAttributedText:attristring];
                                                                            
                                                                            Lab = (UILabel *)[profitTitleView viewWithTag:104];
                                                                            labText = [[NSMutableString alloc] initWithString:@"可用收益:   "];
                                                                            money = [NSString stringWithFormat:@"%.2f",[lastObject[@"cashable"] floatValue]];
                                                                            [labText appendFormat:@"%@元     %d张电子券",money, [lastObject[@"v0coupon"] intValue]];
                                                                            attristring = [[NSMutableAttributedString alloc] initWithString:labText];
                                                                            [attristring addAttribute:NSFontAttributeName
                                                                                                value:[UIFont boldSystemFontOfSize:24]
                                                                                                range:[labText rangeOfString:money]];
                                                                            [Lab setAttributedText:attristring];
                                                                        }
                                                                    }
                                                                    FailuerBlock:^(NSDictionary *error) {
                                                                        
                                                                    }];
}

#pragma mark - tableView Delegate DataSource

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
    MyForwardCell *cell = (MyForwardCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell)
    {
        cell = [[MyForwardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    NSDictionary *dic = _tableData[indexPath.row];
    NSDictionary *article = dic[@"article"];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",IMAGESERVICE_URL,article[@"smallImage"]];
    
    CGPoint centerPoint = cell.iconView.center;
    __weak MyForwardCell *this = cell;
    [cell.iconView setImageWithURL:[NSURL URLWithString:imageUrl]
                  placeholderImage:[UIImage imageNamed:@"default_image"]
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
    
    [cell.heightTitleLab setText:article[@"title"]];
    
    NSString *cashMoney = [NSString stringWithFormat:@"%@",dic[@"cash"]];
    NSString *couponNum = [NSString stringWithFormat:@"%@",dic[@"coupon"]];
    NSString *allSendNumLab = [NSString stringWithFormat:@"已奖励: %.2f元   %@张电子券", [cashMoney floatValue],couponNum];
    [cell.allSendNumLab setText:allSendNumLab];
    
    NSString *invalidDate = dic[@"updateDate"];
    if (invalidDate == nil)
    {
        [cell.endDateLab setText:[@"结束时间: " stringByAppendingString:@"2099年12月31日"]];
    }
    else
    {
        [cell.endDateLab setText:[@"结束时间: " stringByAppendingString:
                                  [[MM_Tools shareTools] getNewTimeWithOldTime:invalidDate OldTimeFormate:@"yyyy-MM-dd HH:mm:ss" NewTimeFormat:@"yyyy年M月dd日"]]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = _tableData[indexPath.row];
    ExtensionContentViewController *vc = [[ExtensionContentViewController alloc] initWithData:dic];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
