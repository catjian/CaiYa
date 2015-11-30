//
//  CashRecordListViewController.m
//  MicroMakeMoney
//
//  Created by zhang jian on 15/8/15.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "CashRecordListViewController.h"

@interface CashRecordListViewController() <UITableViewDataSource, UITableViewDelegate>

@end

@interface CashRecordListCell : UITableViewCell

@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *applyName;
@property (nonatomic, strong) UILabel *applyTime;
@property (nonatomic, strong) UILabel *applyType;

@end

@implementation CashRecordListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_Width-20, 60)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view.layer setCornerRadius:5];
        [view.layer setMasksToBounds:YES];
        [self.contentView addSubview:view];
        
        self.moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width/4, view.height)];
        [self.moneyLab setTextColor:[UIColor orangeColor]];
        [self.moneyLab setTextAlignment:NSTextAlignmentCenter];
        [self.moneyLab setFont:[UIFont systemFontOfSize:18]];
        [view addSubview:self.moneyLab];
        
        self.applyName = [[UILabel alloc] initWithFrame:CGRectMake(self.moneyLab.right, 10, view.width/2, 20)];
        [self.applyName setFont:[UIFont systemFontOfSize:18]];
        [view addSubview:self.applyName];
        
        self.applyTime = [[UILabel alloc] initWithFrame:CGRectMake(self.applyName.left, self.applyName.bottom, self.applyName.width, self.applyName.height)];
        [self.applyTime setFont:[UIFont systemFontOfSize:14]];
        [self.applyTime setTextColor:[UIColor orangeColor]];
        [view addSubview:self.applyTime];
        
        self.applyType = [[UILabel alloc] initWithFrame:CGRectMake(self.applyName.right+10, 15, view.width/4 - 20, 30)];
        [self.applyType.layer setCornerRadius:15];
        [self.applyType.layer setMasksToBounds:YES];
        [self.applyType setBackgroundColor:[UIColor orangeColor]];
        [self.applyType setTextColor:[UIColor whiteColor]];
        [self.applyType setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:self.applyType];
    }
    return self;
}

@end

@implementation CashRecordListViewController
{
    UITableView *_tableView;
    NSArray *_tableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTarBarTitle:@"提现记录"];
    [self setBackItem];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, SCREEN_Height-64) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    [self.view addSubview:_tableView];
    
    [self getCashRecodeData];
}

- (void)getCashRecodeData
{
    NSDictionary *loginDic = [[MM_Tools shareTools] getObjectForKey:LOGIN_ACTION_RESPINFO];
    [[MM_NetInstanceInterface sharedNetInstaceInterface] cashRecordListWithParameter:@{@"user.id":loginDic[@"id"]}
                                                                        SuccessBlock:^(id respInfo) {
                                                                            NSLog(@"%@",respInfo);
                                                                            if (respInfo && [respInfo isKindOfClass:[NSArray class]] && [respInfo count] > 0)
                                                                            {
                                                                                _tableData = respInfo;
                                                                                [_tableView reloadData];
                                                                            }
    }
                                                                        FailuerBlock:^(NSDictionary *error) {
        
    }];
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CELLIdentifier";
    CashRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[CashRecordListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dic = [_tableData objectAtIndex:indexPath.row];
    [cell.moneyLab setText:[NSString stringWithFormat:@"%.2f元", [dic[@"cash"] floatValue]]];

    [cell.applyName setText:[NSString stringWithFormat:@"提现到：%@", dic[@"applyName"]]];
    [cell.applyTime setText:dic[@"applyDate"]];
    [cell.applyType setText:[dic[@"ApproveAccount"] length] > 0?@"完成":@"申请中"];
    return cell;
}

@end
