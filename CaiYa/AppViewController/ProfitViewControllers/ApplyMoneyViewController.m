//
//  ApplyMoneyViewController.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/9.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "ApplyMoneyViewController.h"
#import "BindWeChatAccountViewController.h"
#import "CashRecordListViewController.h"
#import "XSChart.h"

@interface ElecCouponTableCell : UITableViewCell

@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *moneyTitleLab;
@property (nonatomic, strong) UILabel *explainLab;
@property (nonatomic, strong) UILabel *remarkLab;
@property (nonatomic, strong) UILabel *useTimes;

@end

@implementation ElecCouponTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, SCREEN_Width-20, 90)];
        [self.contentView addSubview:self.backImage];
        CGFloat offset_height = self.backImage.height;
        
        self.moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 7.5, offset_height-15, offset_height-15)];
        [self.moneyLab setTextAlignment:NSTextAlignmentCenter];
        [self.moneyLab setFont:[UIFont boldSystemFontOfSize:60]];
        [self.backImage addSubview:self.moneyLab];
        
        offset_height = self.moneyLab.height/2;
        self.moneyTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.moneyLab.right, self.moneyLab.top, self.backImage.width/3, offset_height)];
        [self.moneyTitleLab setText:@"元现金券"];
        [self.moneyTitleLab setFont:[UIFont boldSystemFontOfSize:24]];
        [self.backImage addSubview:self.moneyTitleLab];
        
        offset_height = self.moneyLab.height/2;
        self.explainLab = [[UILabel alloc] initWithFrame:CGRectMake(self.moneyLab.right, self.moneyLab.bottom-offset_height, self.backImage.width/3, offset_height)];
        [self.explainLab setFont:[UIFont boldSystemFontOfSize:14]];
        [self.backImage addSubview:self.explainLab];
        
        offset_height = self.moneyLab.height;
        self.remarkLab = [[UILabel alloc] initWithFrame:CGRectMake(self.moneyTitleLab.right, self.moneyTitleLab.top, self.backImage.width-self.moneyTitleLab.right-5, offset_height-5)];
        [self.remarkLab setNumberOfLines:0];
        [self.remarkLab setLineBreakMode:NSLineBreakByCharWrapping];
        [self.remarkLab setFont:[UIFont systemFontOfSize:14]];
        [self.backImage addSubview:self.remarkLab];
        
        offset_height = 20;
        self.useTimes = [[UILabel alloc] initWithFrame:CGRectMake(0, self.backImage.height-offset_height, self.backImage.width-10, offset_height)];
        [self.useTimes setTextAlignment:NSTextAlignmentRight];
        [self.useTimes setFont:[UIFont systemFontOfSize:10]];
        [self.backImage addSubview:self.useTimes];
        
        for (UIView *view in self.backImage.subviews)
        {
            if ([view isKindOfClass:[UILabel class]])
            {
                UILabel *lab = (UILabel *)view;
                [lab setTextColor:[UIColor whiteColor]];
            }
        }
    }
    return self;
}

@end

@interface ApplyMoneyViewController () <XSChartDataSource,XSChartDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation ApplyMoneyViewController
{
    NSDictionary *_dicData;
    UITableView *_tableView;
    
    NSMutableArray *_typeViews;
    NSInteger _selectViewType;
    NSMutableArray *_chartData;
    NSMutableArray *_tableData;
    UIScrollView *_backScrollView;
    XSChart *_chart;
    UITableView *_ElecCouponTableView;
    
    NSDictionary *_CashData;
}

- (id)initWithData:(NSDictionary *)data
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _dicData = data;
        _typeViews = [[NSMutableArray alloc] init];
        _chartData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTarBarTitle:@"兑换中心"];
    [self setBackItem];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    
    CGFloat offset_height = 80+80+40+42;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, offset_height)
                                              style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setScrollEnabled:NO];
    [_tableView setTag:10000];
    [self.view addSubview:_tableView];
    
    if (!_dicData || _dicData.count <= 0)
    {
        [self getTableData];
    }
    
    CGFloat offset_y = 80+80+40+40;
    CGFloat offset_width = SCREEN_Width/4;
    
    
    _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, offset_y+3, SCREEN_Width, SCREEN_Height-60-offset_y)];
    [_backScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_backScrollView];
    
    NSArray *butTitles = @[@"现金", @"电子券"];
    for (int i = 0; i < butTitles.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(offset_width+i*(offset_width-5), 10, offset_width+5, 40)];
        [button setTitle:butTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button.layer setBorderWidth:1];
        [button.layer setCornerRadius:5];
        [button.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        if (0 == i)
        {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor blackColor]];
        }
        [button setTag:i+10];
        [button addTarget:self action:@selector(SelectTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backScrollView addSubview:button];
    }
    
    [self initMoneyView];
    [self initElectronicView];
    _selectViewType = 0;
    UIView *view = (UIView *)_typeViews[_selectViewType];
    [_backScrollView addSubview:view];    
    
    [self getCashStatic];
}

- (void)getTableData
{
    NSDictionary *loginDic = [[MM_Tools shareTools] getObjectForKey:LOGIN_ACTION_RESPINFO];
    [[MM_NetInstanceInterface sharedNetInstaceInterface] cashStaticWithParameter:@{@"user.id":loginDic[@"id"]}
                                                                    SuccessBlock:^(id respInfo) {
                                                                        if (respInfo && [respInfo isKindOfClass:[NSArray class]] && [(NSArray *)respInfo count]>0)
                                                                        {
                                                                            _dicData = [respInfo lastObject];
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

- (void)nextButtonAction:(UIButton *)button
{
    BindWeChatAccountViewController *bindVC = [[BindWeChatAccountViewController alloc] initWithData:_dicData];
    [self.navigationController pushViewController:bindVC animated:YES];
}

- (void)SelectTypeButtonAction:(UIButton *)button
{
    for (int i=0; i<2; i++)
    {
        UIButton *but = (UIButton *)[_backScrollView viewWithTag:i+10];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setBackgroundColor:[UIColor whiteColor]];
    }
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    _selectViewType = button.tag-10;
    if (_selectViewType == 0)
    {
        [self getCashStatic];
    }
    else
    {
        NSDictionary *loginDic = [[MM_Tools shareTools] getObjectForKey:LOGIN_ACTION_RESPINFO];
        [[MM_NetInstanceInterface sharedNetInstaceInterface] getElecCouponLisetWithParameter:@{@"user.id":loginDic[@"id"],
                                                                                               @"mobileLogin":@(YES)}
                                                                                SuccessBlock:^(id respInfo) {
                                                                                    NSLog(@"respInfo = %@",respInfo);
                                                                                    NSMutableArray *noInv = [[NSMutableArray alloc] init];
                                                                                    NSMutableArray *isInv = [[NSMutableArray alloc] init];
                                                                                    for (NSDictionary *dic in respInfo)
                                                                                    {
                                                                                        if ([dic[@"isInvalid"] integerValue] == 0)
                                                                                        {
                                                                                            [noInv addObject:dic];
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            [isInv addObject:dic];
                                                                                        }
                                                                                    }
                                                                                    _tableData = nil;
                                                                                    _tableData = [[NSMutableArray alloc] initWithObjects:noInv, isInv, nil];
                                                                                    [_ElecCouponTableView reloadData];
                                                                                }
                                                                                FailuerBlock:^(NSDictionary *error) {
                                                                                    
                                                                                }];
    }
    UIView *view = [self.view viewWithTag:99];
    [view removeFromSuperview];
    view = (UIView *)_typeViews[_selectViewType];
    [_backScrollView addSubview:view];
}

- (void)initMoneyView
{
    UIView *headerview = [_backScrollView viewWithTag:10];
    CGFloat offset_height = _backScrollView.height-headerview.bottom;
    if (offset_height < 250)
    {
        offset_height = 260;
        [_backScrollView setContentSize:CGSizeMake(SCREEN_Width, headerview.bottom+260)];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, headerview.bottom, SCREEN_Width, offset_height)];
    [view setTag:99];
    
    _chart=[[XSChart alloc]initWithFrame:CGRectMake(0, view.height-250, self.view.frame.size.width, 250)];
    _chart.dataSource=self;
    _chart.delegate=self;
    [view addSubview:_chart];
    
    [_typeViews addObject:view];
}

- (void)initElectronicView
{
    UIView *headerview = [_backScrollView viewWithTag:10];
    CGFloat offset_height = _backScrollView.height-headerview.bottom;
    if (offset_height < 250)
    {
        offset_height = 260;
        [_backScrollView setContentSize:CGSizeMake(SCREEN_Width, headerview.bottom+260)];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, headerview.bottom, SCREEN_Width, offset_height)];
    [view setTag:99];
    
    _ElecCouponTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, offset_height)
                                              style:UITableViewStyleGrouped];
    [_ElecCouponTableView setTag:10001];
    [_ElecCouponTableView setDelegate:self];
    [_ElecCouponTableView setDataSource:self];
    [_ElecCouponTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [view addSubview:_ElecCouponTableView];
    
    [_typeViews addObject:view];
}

- (void)getCashStatic
{
    NSDictionary *loginDic = [[MM_Tools shareTools] getObjectForKey:LOGIN_ACTION_RESPINFO];
    [[MM_NetInstanceInterface sharedNetInstaceInterface] cashStaticWithParameter:@{@"user.id":loginDic[@"id"]}
                                                                    SuccessBlock:^(id respInfo) {
                                                                        if (respInfo && [respInfo isKindOfClass:[NSArray class]] && [(NSArray *)respInfo count]>0)
                                                                        {
                                                                            [_chartData removeAllObjects];
                                                                            for (int i = 0; i < 7; i++)
                                                                            {
                                                                                if (i < [respInfo count])
                                                                                {
                                                                                    NSDictionary *info = respInfo[i];
                                                                                    NSString *money = [NSString stringWithFormat:@"%.2f",[info[@"v0"] floatValue]];
                                                                                    [_chartData addObject:money];
                                                                                }
                                                                                else
                                                                                {
                                                                                    [_chartData addObject:@"-1"];
                                                                                }
                                                                            }
                                                                            [_chart reload];
                                                                        }
                                                                    }
                                                                    FailuerBlock:^(NSDictionary *error) {
                                                                        
                                                                    }];
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_tableView])
    {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView])
    {
        return 4;
    }
    else
    {
        return [_tableData[section] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tableView])
    {
        switch (indexPath.row)
        {
            case 0:
            case 1:
                return 80;
            case 2:
            case 3:
            default:
                return 44;
                break;
        }
    }
    else
    {
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView])
    {
        return 0;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView])
    {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CELLIdentifier";
    if ([tableView isEqual:_tableView])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        }
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        switch (indexPath.row)
        {
            case 0:
            {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, SCREEN_Width-60, 30)];
                [lab setText:@"可用余额（元）"];
                [cell.contentView addSubview:lab];
                
                UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(lab.left, lab.bottom, lab.width, lab.height)];
                [money setText:[NSString stringWithFormat:@"%.2f",[_dicData[@"cashable"] floatValue]]];
                [money setTextAlignment:NSTextAlignmentCenter];
                [money setTextColor:[UIColor orangeColor]];
                [money setFont:[UIFont boldSystemFontOfSize:24]];
                [cell.contentView addSubview:money];
                
                UILabel *horizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 79, SCREEN_Width, 1)];
                [horizontalLine setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
                [cell.contentView addSubview:horizontalLine];
            }
                break;
            case 1:
            {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
                [imageV setImage:[UIImage imageNamed:@"share_dialog_weixin"]];
                [cell.contentView addSubview:imageV];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button setFrame:CGRectMake(SCREEN_Width-90, (80-30)/2, 80, 30)];
                [button setTitle:@"申请提现" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                [button.layer setBorderWidth:1];
                [button.layer setCornerRadius:3];
                [button.layer setBorderColor:[UIColor orangeColor].CGColor];
                [button addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
                UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(imageV.right+20, imageV.top+10, button.left-imageV.right-30, 20)];
                [lab1 setText:@"微信钱包"];
                [lab1 setFont:[UIFont boldSystemFontOfSize:18]];
                [cell.contentView addSubview:lab1];
                
                UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(lab1.left, lab1.bottom, lab1.width, lab1.height)];
                [lab2 setText:@"转账到微信钱包零钱"];
                [lab2 setTextColor:[UIColor orangeColor]];
                [lab2 setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:lab2];
                
                UILabel *horizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 79, SCREEN_Width, 1)];
                [horizontalLine setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
                [cell.contentView addSubview:horizontalLine];
            }
                break;
            case 2:
            {
                [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
                [cell.textLabel setText:@"提现记录"];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                
                UILabel *horizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_Width, 1)];
                [horizontalLine setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
                [cell.contentView addSubview:horizontalLine];
            }
                break;
            case 3:
            {
                [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
                [cell.textLabel setText:@"提现规则"];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                
                UILabel *horizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_Width, 1)];
                [horizontalLine setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
                [cell.contentView addSubview:horizontalLine];
            }
                break;
            default:
                break;
        }
        
        return cell;
    }
    else
    {
        ElecCouponTableCell *cell = (ElecCouponTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[ElecCouponTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if (indexPath.section == 0)
        {
            [cell.backImage setImage:[UIImage imageNamed:@"ElecCoupon_Accept"]];
        }
        else
        {
            [cell.backImage setImage:[UIImage imageNamed:@"ElecCoupon_Expire"]];
        }
        NSDictionary *dic = [_tableData[indexPath.section] objectAtIndex:indexPath.row];
        [cell.moneyLab setText:[NSString stringWithFormat:@"%@",dic[@"viewValue"]]];
        [cell.explainLab setText:dic[@"name"]];
        [cell.remarkLab setText:dic[@"remarks"]];
        
        [cell.moneyLab setWidth:cell.backImage.height-15];
        CGSize size = [cell.moneyLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:60]}];
        if (size.width > cell.moneyLab.width)
        {
            [cell.moneyLab setWidth:size.width+5];
        }
        [cell.moneyTitleLab setLeft:cell.moneyLab.right];
        [cell.explainLab setLeft:cell.moneyLab.right];
        [cell.remarkLab setLeft:cell.moneyTitleLab.right];
        
        NSString *startDate = dic[@"startDate"];
        if (startDate)
        {
            startDate = [[MM_Tools shareTools] getNewTimeWithOldTime:startDate OldTimeFormate:@"yyyy-MM-dd HH:mm:ss" NewTimeFormat:@"yyyy.MM.dd"];
        }
        else
        {
            startDate = [[MM_Tools shareTools] getNowTimeWithFormat:@"yyyy.MM.dd"];
        }
        NSString *invalidDate = dic[@"invalidDate"];
        if (invalidDate)
        {
            invalidDate = [[MM_Tools shareTools] getNewTimeWithOldTime:invalidDate OldTimeFormate:@"yyyy-MM-dd HH:mm:ss" NewTimeFormat:@"yyyy.MM.dd"];
        }
        else
        {
            invalidDate = @"2099.12.31";
        }
        
        [cell.useTimes setText:[NSString stringWithFormat:@"使用时间: %@-%@",startDate, invalidDate]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2)
    {
        CashRecordListViewController *vc = [[CashRecordListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 3)
    {
        [[MM_NetInstanceInterface sharedNetInstaceInterface] getCashRuleWithParameter:@{}
                                                                         SuccessBlock:^(id respInfo) {
                                                                             if (respInfo && [respInfo isKindOfClass:[NSDictionary class]])
                                                                             {
                                                                                 NSMutableString *message = [[NSMutableString alloc] init];
                                                                                 [message appendFormat:@"名称：%@\n", respInfo[@"name"]];
                                                                                 [message appendFormat:@"最小金额(元)：%.2f\n", [respInfo[@"naminCashme"] floatValue]];
                                                                                 [message appendFormat:@"最小间隔(天)：%.2f\n", [respInfo[@"minInterval"] floatValue]];
                                                                                 [message appendFormat:@"说明：%@", respInfo[@"remarks"]];
                                                                                 [[MM_Tools shareTools] AlertViewWithTitle:@"提现规则" MessageString:message];
                                                                             }
        }
                                                                         FailuerBlock:^(NSDictionary *error) {
            
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_ElecCouponTableView])
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, 40)];
        [view setBackgroundColor:[UIColor whiteColor]];
        NSArray *labs = @[@"可用电子券", @"已用或过期"];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_Width-20, 20)];
        [lab setBackgroundColor:[UIColor clearColor]];
        NSString *num = [NSString stringWithFormat:@"(%ld张)",(unsigned long)[_tableData[section] count]];
        NSString *text = [NSString stringWithFormat:@"%@ %@",labs[section],num];
        NSMutableAttributedString *attristring = [[NSMutableAttributedString alloc] initWithString:text];
        [attristring addAttribute:NSForegroundColorAttributeName
                            value:[UIColor orangeColor]
                            range:[text rangeOfString:num]];
        [lab setAttributedText:attristring];
        [view addSubview:lab];
        return view;
    }
    return nil;
}

#pragma mark - XSChartDataSource && XSChartDelegate
-(NSInteger)numberForChart:(XSChart *)chart
{
    return _chartData.count;
}

-(CGFloat)chart:(XSChart *)chart valueAtIndex:(NSInteger)index
{
    return [_chartData[index] floatValue];
}

-(BOOL)showDataAtPointForChart:(XSChart *)chart
{
    return YES;
}

-(NSString *)chart:(XSChart *)chart titleForXLabelAtIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%ld",(long)index+1];
}

-(NSString *)titleForChart:(XSChart *)chart
{
    return @"收入统计表";
}

-(NSString *)titleForXAtChart:(XSChart *)chart
{
    return @"";
}

-(NSString *)titleForYAtChart:(XSChart *)chart
{
    return @"";
}

-(void)chart:(XSChart *)view didClickPointAtIndex:(NSInteger)index
{
    DebugLog(@"click at index:%ld",(long)index);
}

@end
