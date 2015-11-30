//
//  MyForwardViewController.m
//  MicroMakeMoney
//
//  Created by zhang jian on 15/8/14.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "MyForwardViewController.h"
#import "ExtensionContentViewController.h"

#ifndef firsterCell_height
#define firsterCell_height 140
#endif

@interface MyForwardViewController() <UITableViewDataSource, UITableViewDelegate>

@end

@interface MyForwardTableCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *heightTitleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *allSendNumLab;
@property (nonatomic, strong) UILabel *restSendNumLab;
@property (nonatomic, strong) UILabel *beginDateLab;
@property (nonatomic, strong) UILabel *endDateLab;
@property (nonatomic) BOOL activityType;

@end

@implementation MyForwardTableCell

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
            
            UILabel *moneyTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, self.heightTitleLab.bottom+8, 60, 24)];
            MMTextAttachment *imageAttachment = [[MMTextAttachment alloc] initWithData:nil ofType:nil];
            imageAttachment.rect = CGRectMake(10, -2, 14, 14);
            imageAttachment.image = [UIImage imageNamed:@"item_award"];
            NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"   奖励"];
            [attributedString insertAttributedString:imageAttributedString atIndex:0];
            [moneyTitle setAttributedText:attributedString];
            [moneyTitle setTextColor:[UIColor whiteColor]];
            [moneyTitle setBackgroundColor:[UIColor orangeColor]];
            [moneyTitle setFont:[UIFont systemFontOfSize:12]];
            [moneyTitle.layer setCornerRadius:2];
            [moneyTitle.layer setMasksToBounds:YES];
            [view addSubview:moneyTitle];
            
            UILabel *moneyBack = [[UILabel alloc] initWithFrame:CGRectMake(moneyTitle.right-5, self.heightTitleLab.bottom+8,140, 24)];
            [moneyBack.layer setBorderWidth:1];
            [moneyBack.layer setBorderColor:[UIColor orangeColor].CGColor];
            [moneyBack.layer setCornerRadius:2];
            [view addSubview:moneyBack];
            
            self.moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(moneyTitle.right+5, self.heightTitleLab.bottom+8, 135, 24)];
            [self.moneyLab setFont:[UIFont systemFontOfSize:12]];
            [view addSubview:self.moneyLab];
            
            self.allSendNumLab = [[UILabel alloc] initWithFrame:CGRectMake(5, self.moneyLab.bottom+8,(SCREEN_Width-10)/2, 20)];
            [self.allSendNumLab setFont:[UIFont systemFontOfSize:is_iPhone6?12:10]];
            [view addSubview:self.allSendNumLab];
            
            self.restSendNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.allSendNumLab.right, self.allSendNumLab.top,
                                                                            self.allSendNumLab.width, 20)];
            [self.restSendNumLab setFont:[UIFont systemFontOfSize:is_iPhone6?12:10]];
            [view addSubview:self.restSendNumLab];
            
            [self.iconView setHeight:self.allSendNumLab.top-5];
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


@implementation MyForwardViewController
{
    UITableView *_tableView;
    NSArray *_tableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTarBarTitle:@"我的转发"];
    [self setBackItem];
}

- (void)loadView
{
    [super loadView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, SCREEN_Height-64)
                                              style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    [self.view addSubview:_tableView];   
    
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MM_HomePageTabController shared] showTabBar:NO];
}

- (void)backBarButtonItemAction:(UIButton *)btn
{
    [[MM_HomePageTabController shared] showTabBar:YES];
    [super backBarButtonItemAction:btn];
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
    MyForwardTableCell *cell = (MyForwardTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell)
    {
        cell = [[MyForwardTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    NSDictionary *dic = _tableData[indexPath.row];
    NSDictionary *article = dic[@"article"];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",IMAGESERVICE_URL,article[@"smallImage"]];
    [cell.iconView setImageWithURL:[NSURL URLWithString:imageUrl]
                  placeholderImage:[UIImage imageNamed:@"default_image"]];
    
    [cell.heightTitleLab setText:article[@"description"]];
    
    NSString *forwardMoney = [NSString stringWithFormat:@"%@元",article[@"cyRewardRule"][@"forwardMoney"]];
    NSString *readMoney = [NSString stringWithFormat:@"%@元",article[@"cyRewardRule"][@"readMoney"]];
    NSString *moneyLab = [NSString stringWithFormat:@"转发%@，阅读%@",forwardMoney,readMoney];
    {
        NSMutableAttributedString *attristring = [[NSMutableAttributedString alloc] initWithString:moneyLab];
        [attristring addAttribute:NSForegroundColorAttributeName
                            value:[UIColor orangeColor]
                            range:[moneyLab rangeOfString:forwardMoney]];
        [attristring addAttribute:NSForegroundColorAttributeName
                            value:[UIColor orangeColor]
                            range:[moneyLab rangeOfString:readMoney]];
        [cell.moneyLab setAttributedText:attristring];
    }
    
    NSString *cashMoney = [NSString stringWithFormat:@"%@",dic[@"cash"]];
    NSString *couponNum = [NSString stringWithFormat:@"%@",dic[@"coupon"]];
    NSString *allSendNumLab = [NSString stringWithFormat:@"现金收益:%@元,电子券:%@张", cashMoney,couponNum];
    {
        NSMutableAttributedString *attristring = [[NSMutableAttributedString alloc] initWithString:allSendNumLab];
        [attristring addAttribute:NSForegroundColorAttributeName
                            value:[UIColor orangeColor]
                            range:[allSendNumLab rangeOfString:cashMoney]];
        [attristring addAttribute:NSForegroundColorAttributeName
                            value:[UIColor orangeColor]
                            range:[allSendNumLab rangeOfString:couponNum]];
        MMTextAttachment *imageAttachment = [[MMTextAttachment alloc] initWithData:nil ofType:nil];
        imageAttachment.rect = CGRectMake(0, -1, 10, 10);
        imageAttachment.image = [UIImage imageNamed:@"throw_count"];
        NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [attristring insertAttributedString:imageAttributedString atIndex:0];
        [cell.allSendNumLab setAttributedText:attristring];
    }
    
    NSString *loseTimes = [NSString stringWithFormat:@"%ld",[dic[@"readedTimes"] integerValue]];
    NSString *restSendNumLab = [@"阅读次数: " stringByAppendingString:loseTimes];
    {
        NSMutableAttributedString *attristring = [[NSMutableAttributedString alloc] initWithString:restSendNumLab];
        [attristring addAttribute:NSForegroundColorAttributeName
                            value:[UIColor orangeColor]
                            range:[restSendNumLab rangeOfString:loseTimes]];
        MMTextAttachment *imageAttachment = [[MMTextAttachment alloc] initWithData:nil ofType:nil];
        imageAttachment.rect = CGRectMake(0, -1, 10, 10);
        imageAttachment.image = [UIImage imageNamed:@"surplus_count"];
        NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [attristring insertAttributedString:imageAttributedString atIndex:0];
        [cell.restSendNumLab setAttributedText:attristring];
    }
    
    NSString *startDate = article[@"startDateStr"];
    {
        NSMutableAttributedString *attristring = [[NSMutableAttributedString alloc] initWithString:startDate];
        MMTextAttachment *imageAttachment = [[MMTextAttachment alloc] initWithData:nil ofType:nil];
        imageAttachment.rect = CGRectMake(0, -2, 10, 10);
        imageAttachment.image = [UIImage imageNamed:@"time"];
        NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [attristring insertAttributedString:imageAttributedString atIndex:0];
        [cell.beginDateLab setAttributedText:attristring];
    }
    NSString *invalidDate = article[@"invalidDate"];
    if (invalidDate == nil)
    {
        [cell.endDateLab setText:[@"结束时间: " stringByAppendingString:@"2099年12月31日"]];
    }
    else
    {
        [cell.endDateLab setText:[@"结束时间: " stringByAppendingString:
                                  [[MM_Tools shareTools] getNewTimeWithOldTime:invalidDate OldTimeFormate:@"yyyy-MM-dd HH:mm:ss" NewTimeFormat:@"yyyy年M月dd日"]]];
    }
    
    cell.activityType = (indexPath.row%2 == 0)?YES:NO;
    
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
