//
//  MM_Tools.m
//  MicroMakeMoney
//
//  Created by zhang_jian on 15/7/19.
//  Copyright (c) 2015年 MMMoney. All rights reserved.
//

#import "MM_Tools.h"
#import "HYProgressHUD.h"

static MM_Tools *tools = nil;

@interface MM_Tools() <UIAlertViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation MM_Tools
{
    NSMutableDictionary *section_data;
    AlertViewDlegate _alert_delegate;
    
    UIView *_customView;
    NSArray *_collectionData;
    NSInteger _collectionSelectIndex;
}

+ (MM_Tools *)shareTools
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[MM_Tools alloc] init];
    });
    return tools;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        section_data = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)set:(id)value KeyString:(NSString *)key
{
    @synchronized(self)
    {
        if (value)
        {
            [section_data setObject:value forKey:key];
        }
        else
        {
            [section_data removeObjectForKey:key];
        }
    }
}

- (id)getObjectForKey:(NSString *)key
{
    return [section_data objectForKey:key];
}

- (NSString *)getRandomNumberWithLenght:(NSInteger)length
{
    NSMutableString *random = [[NSMutableString alloc] init];
    for (int i = 0; i < length; i++)
    {
        int x = arc4random() % 10;
        [random appendFormat:@"%d", x];
    }
    return random;
}

- (NSString *)AppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

#pragma mark - HUD
- (void)ShowHUD
{
    [self ShowHUDWithMessage:nil];
}

- (void)ShowHUDWithMessage:(NSString *)message
{
    [[HYProgressHUD sharedProgressHUD] showInView:[AppDelegate shared].window];
    [[HYProgressHUD sharedProgressHUD] setText:message];
}

- (void)HideHUD
{
    [[HYProgressHUD sharedProgressHUD] hide];
}

#pragma mark - AlertView
- (void)customAlertViewWithType:(CUNSTOM_ALERTVIEW_TYPE)type ButtonActionBlock:(AlertViewDlegate) block
{
    [self customAlertViewWithType:type TitleOrTextFieldMessage:nil ButtonActionBlock:block];
}

- (void)customAlertViewWithType:(CUNSTOM_ALERTVIEW_TYPE)type TitleOrTextFieldMessage:(NSString *)text ButtonActionBlock:(AlertViewDlegate) block
{
    if (_customView)
    {
        return;
    }
    _customView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_Height, SCREEN_Width, SCREEN_Height)];
    [_customView setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.800]];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCustomView)];
    [_customView addGestureRecognizer:tapGR];
    
    switch (type)
    {
        case CUNSTOM_ALERTVIEW_TYPE_ONLY_BUTTON:
            [_customView addSubview:[self contentViewTypeOnlyButton]];
            break;
        case CUNSTOM_ALERTVIEW_TYPE_BUTTON_AND_TITLE:
            [_customView addSubview:[self contentViewTypeButtonAndTitle:text]];
            break;
        case CUNSTOM_ALERTVIEW_TYPE_BUTTON_AND_TEXTFIELD:
            [_customView addSubview:[self contentViewTypeButtonAndTextField:text]];
            break;
        default:
            break;
    }
    
    [[AppDelegate shared].window addSubview:_customView];
    _alert_delegate = nil;
    _alert_delegate = block;
    [self showCustomView];
}

- (UIView *)contentViewTypeOnlyButton
{
    CGFloat offset_height = 120;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, (_customView.height-offset_height)/2, SCREEN_Width-20, offset_height)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView.layer setCornerRadius:10];
    
    NSArray *imageNames = @[@"share_dialog_weixin", @"share_dialog_friend"];
    NSArray *titls = @[@"微信好友", @"朋友圈"];
    CGSize imageSize = CGSizeMake(70, 70);
    for (int i = 0; i < imageNames.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = i+20;
        CGFloat offset_x = (contentView.width-imageSize.width*2)/3;
        [button setFrame:CGRectMake(offset_x + i*(imageSize.width+offset_x), (contentView.height-imageSize.height)/2-10, imageSize.width, imageSize.height)];
        [button setBackgroundImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(customButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(button.left, button.bottom, button.width, 20)];
        [lab setText:titls[i]];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [contentView addSubview:lab];
    }
    return contentView;
}

- (UIView *)contentViewTypeButtonAndTitle:(NSString *)text
{
    CGFloat offset_height = 240;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, (_customView.height-offset_height)/2, SCREEN_Width-20, offset_height)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView.layer setCornerRadius:10];
    
    CGSize imageSize = CGSizeMake(70, 70);
    UIImage *yuanbao_img = [UIImage imageNamed:@"share_dialog_yuanbao"];
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake((contentView.width-yuanbao_img.size.width*(imageSize.height/yuanbao_img.size.height))/2, 10,
                                                                        yuanbao_img.size.width*(imageSize.height/yuanbao_img.size.height), imageSize.height)];
    [imagev setImage:[UIImage imageNamed:@"share_dialog_yuanbao"]];
    [contentView addSubview:imagev];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, imagev.bottom+10, contentView.width-10, 30)];
    [title setText:@"分享到朋友圈或者好友阅读之后都有奖励"];
    if (![text isNull])
    {
        [title setText:text];
    }
    [title setTextColor:[UIColor orangeColor]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont systemFontOfSize:16]];
    [contentView addSubview:title];
    
    NSArray *imageNames = @[@"share_dialog_weixin", @"share_dialog_friend"];
    NSArray *titls = @[@"微信好友", @"朋友圈"];
    for (int i = 0; i < imageNames.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = i+20;
        CGFloat offset_x = (contentView.width-imageSize.width*2)/3;
        [button setFrame:CGRectMake(offset_x + i*(imageSize.width+offset_x), title.bottom+10, imageSize.width, imageSize.height)];
        [button setBackgroundImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(customButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(button.left, button.bottom, button.width, 20)];
        [lab setText:titls[i]];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [contentView addSubview:lab];
    }
    return contentView;
}

- (UIView *)contentViewTypeButtonAndTextField:(NSString *)text
{
    CGFloat offset_height = 170;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, (_customView.height-offset_height)/2, SCREEN_Width-20, offset_height)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView.layer setCornerRadius:10];
    
    CGSize imageSize = CGSizeMake(70, 70);
    
    UITextField *title = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, contentView.width-20, 30)];
    [title setText:text];
    [title setTextColor:[UIColor orangeColor]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont systemFontOfSize:16]];
    [title becomeFirstResponder];
    [contentView addSubview:title];
    
    UIView *fieldBackV = [[UIView alloc] initWithFrame:title.frame];
    fieldBackV.left -=2;
    fieldBackV.top -=2;
    fieldBackV.height += 4;
    fieldBackV.width += 4;
    [fieldBackV.layer setBorderWidth:1];
    [fieldBackV.layer setBorderColor:[UIColor blackColor].CGColor];
    [fieldBackV.layer setCornerRadius:5];
    [fieldBackV.layer setMasksToBounds:YES];
    [contentView addSubview:fieldBackV];
    
    NSArray *imageNames = @[@"share_dialog_weixin", @"share_dialog_friend"];
    NSArray *titls = @[@"微信好友", @"朋友圈"];
    for (int i = 0; i < imageNames.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = i+20;
        CGFloat offset_x = (contentView.width-imageSize.width*2)/3;
        [button setFrame:CGRectMake(offset_x + i*(imageSize.width+offset_x), title.bottom+10, imageSize.width, imageSize.height)];
        [button setBackgroundImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(customButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(button.left, button.bottom, button.width, 20)];
        [lab setText:titls[i]];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [contentView addSubview:lab];
    }
    return contentView;
}

- (void)customButtonAction:(UIButton *)but
{
    [self hideCustomView];
    if (_alert_delegate)
    {
        _alert_delegate(but.tag-20);
    }
    _alert_delegate = nil;
}

- (void)showCustomView
{
    [UIView animateWithDuration:0.5 animations:^{
        [_customView setTop:0];
    }];
}

- (void)hideCustomView
{
    [UIView animateWithDuration:0.5 animations:^{
        [_customView setTop:SCREEN_Height];
    } completion:^(BOOL finished) {
        if (_alert_delegate)
        {
            _alert_delegate(-1);
        }
        _alert_delegate = nil;
        [_customView removeFromSuperview];
        _customView = nil;
    }];
}

- (void)customAlertViewWithCollectionWithContent:(NSArray *)content ActionBlock:(AlertViewDlegate) block
{
    _collectionSelectIndex = -1;
    _collectionData = content;
    _customView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_Height, SCREEN_Width, SCREEN_Height)];
    [_customView setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.800]];
    
    [[AppDelegate shared].window addSubview:_customView];
    _alert_delegate = nil;
    _alert_delegate = block;
    
    CGFloat offset_width = SCREEN_Width-20;
    CGFloat offset_height = 60+(content.count/2+content.count%2)*((offset_width-80)/6)+20+(content.count/2+content.count%2+1)*10+(offset_width-80)/6+5;
    if (offset_height > SCREEN_Height*2/3)
    {
        offset_height = SCREEN_Height*2/3;
    }
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, (_customView.height-offset_height)/2, offset_width, offset_height)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView.layer setCornerRadius:10];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, contentView.width-10, 60)];
    [title setText:@"分享到朋友圈或者好友阅读之后都有奖励"];
//    if (![text isNull])
//    {
//        [title setText:text];
//    }
    [title setTextColor:[UIColor orangeColor]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont systemFontOfSize:16]];
    [contentView addSubview:title];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((contentView.width-80)/2, (contentView.width-80)/6)];//设置cell的尺寸
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);//设置其边界
    [flowLayout setMinimumLineSpacing:10];
    [flowLayout setMinimumInteritemSpacing:20];//左右间隔
    UICollectionView *_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, title.bottom, contentView.width,
                                                                                           offset_height-title.bottom-10-(offset_width-80)/6)
                                                           collectionViewLayout:flowLayout];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    //注册Cell,必须要有
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    [_collectionView setTag:10];
    [_collectionView setBackgroundColor:[UIColor colorWithWhite:0.926 alpha:1.000]];
    [contentView addSubview:_collectionView];
    [_customView addSubview:contentView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGFloat offset_x = (contentView.width-(contentView.width-80)/2)/2;
    [button setFrame:CGRectMake(offset_x , _collectionView.bottom+5, (contentView.width-80)/2, (contentView.width-80)/6-5)];
    [button addTarget:self action:@selector(customCollectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button.layer setBorderWidth:1];
    [button.layer setCornerRadius:5];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"就这么定了" forState:UIControlStateNormal];
    [contentView addSubview:button];
    
    [self showCustomView];
}

- (void)customCollectionButtonAction:(UIButton *)send
{
    [self hideCustomView];
    if (_alert_delegate && _collectionSelectIndex >= 0)
    {
        _alert_delegate(_collectionSelectIndex);
    }
    _alert_delegate = nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _collectionData.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _collectionSelectIndex = indexPath.row;
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    for (int i = 0; i < _collectionData.count; i++)
    {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor orangeColor]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.layer setBorderWidth:1];
    [cell.layer setBorderColor:[UIColor colorWithWhite:0.592 alpha:1.000].CGColor];
    
    UILabel *lab = (UILabel *)[cell viewWithTag:10];
    if (!lab)
    {
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
        [lab setTag:10];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:lab];
    }
    [lab setText:_collectionData[indexPath.row]];
    
    return cell;
}

- (void)AlertViewWithTitle:(NSString *)title MessageString:(NSString *)message
{
    [self AlertViewWithTitle:title MessageString:message AlertBlock:nil];
}

- (void)AlertViewWithTitle:(NSString *)title MessageString:(NSString *)message AlertBlock:(AlertViewDlegate) block
{
    [self AlertViewWithTitle:title MessageString:message CancelButton:nil AlertBlock:block];
}

- (void)AlertViewWithTitle:(NSString *)title MessageString:(NSString *)message CancelButton:(NSString *)button AlertBlock:(AlertViewDlegate) block
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:button otherButtonTitles:@"确定", nil];
    _alert_delegate = nil;
    _alert_delegate = block;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_alert_delegate)
    {
        _alert_delegate(buttonIndex);
    }
    _alert_delegate = nil;
}


- (UIView *)createADViewWithInfo:(NSDictionary *)info
{
    _customView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_Height, SCREEN_Width, SCREEN_Height)];
    [_customView setBackgroundColor:[UIColor whiteColor]];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",IMAGESERVICE_URL,info[@"image"]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, SCREEN_Height)];
    [_customView addSubview:imageView];
    CGPoint centerPoint = imageView.center;
    UIImageView *this = imageView;
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl]
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGFloat offset_x = SCREEN_Width-60;
    [button setFrame:CGRectMake(offset_x , 25, 50, 30)];
    [button addTarget:self action:@selector(hideCustomView) forControlEvents:UIControlEventTouchUpInside];
    [button.layer setBorderWidth:1];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"跳过" forState:UIControlStateNormal];
    [_customView addSubview:button];
    
    [self showCustomView];
    [self performSelector:@selector(hideCustomView) withObject:nil afterDelay:5];
    return _customView;
}

#pragma mark - Time Controller

- (NSString *)getNowTimeWithFormat:(NSString *)format
{
    NSString *time;
    NSDateFormatter *timeFormate = [[NSDateFormatter alloc] init];
    [timeFormate setDateFormat:format];
    time = [timeFormate stringFromDate:[NSDate date]];
    return time;
}

- (NSString *)getNewTimeWithOldTime:(NSString *)oldTime OldTimeFormate:(NSString *)oldFormate NewTimeFormat:(NSString *)newFormate
{
    NSString *newTime;
    NSDateFormatter *timeFormate = [[NSDateFormatter alloc] init];
    [timeFormate setDateFormat:oldFormate];
    NSDate *date = [timeFormate dateFromString:oldTime];
    [timeFormate setDateFormat:newFormate];
    newTime = [timeFormate stringFromDate:date];
    return newTime;
}

#pragma mark - 日期格式转换
- (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSString *str = [formatter stringFromDate:date];
    formatter = nil;
    return str;
}

- (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

/**
 *  重序列化时间
 *  E MMM d HH:mm:ss Z yyyy Sat Jan 12 11:50:16 +0800 2013
 *  @param  datestring 时间
 *
 *  @return 返回一个时间格式为 MM-dd HH:mm 的时间
 */
- (NSString *)formateString:(NSString *)datestring
{
    NSString *formate = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate *createDate = [self dateFromFomate:datestring formate:formate];
    NSString *text = [self stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}

#pragma mark -- 获取当前时间的字符串
/**
 *  获取当前时间
 *
 *  @param dateFormat 时间格式 当为nil的时候 格式为yyyy-MM-dd HH:mm:ss
 *
 *  @return 返回当前时间
 */
- (NSString *)getNowDateTime:(NSString *)dateFormat
{
    if (!dateFormat)
    {
        dateFormat  = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:dateFormat];
    NSString *str = [dateformat stringFromDate:nowDate];
    return str;
}

#pragma mark -- 根据字符串和格式获取时间
- (NSDate *)getDateFromString:(NSString *)dateStr dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:dateFormat];
    NSDate *date = [dateformat dateFromString:dateStr];
    return date;
}

- (NSString *)convertTimeWithString:(NSString *)time
{
    if (!time || time.length <= 0)
    {
        return @"99天前";
    }
    NSDate *pk_date = [self dateFromFomate:time
                                   formate: @"yyyy-MM-dd HH:mm:ss"];
    
    NSString *foregroundStr = [self getNowDateTime:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *foregroundDate = [self getDateFromString:foregroundStr dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    long timeSecond = (long)([foregroundDate timeIntervalSince1970] - [pk_date timeIntervalSince1970]);
    
    if (timeSecond/(3600*24)>0)
    {
        return [NSString stringWithFormat:@"%d天前",(int)timeSecond/(3600*24)];
    }
    else if (timeSecond/(3600)>0)
    {
        return [NSString stringWithFormat:@"%d小时前",(int)timeSecond/(3600)];
    }
    else if (timeSecond/(60)>0)
    {
        return [NSString stringWithFormat:@"%d分钟前",(int)timeSecond/(60)];
    }
    else if (timeSecond > 0)
    {
        return [NSString stringWithFormat:@"%d秒前",(abs((int)timeSecond))];
    }
    else
    {
        return @"刚刚";
    }
}

- (NSString *)convertTimeWithDate:(NSDate *)time
{
    if (!time)
    {
        return @"99天前";
    }
    
    NSString *foregroundStr = [self getNowDateTime:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *foregroundDate = [self getDateFromString:foregroundStr dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    long timeSecond = (long)([foregroundDate timeIntervalSince1970] - [time timeIntervalSince1970]);
    
    if (timeSecond/(3600*24)>0)
    {
        return [NSString stringWithFormat:@"%d天前",(int)timeSecond/(3600*24)];
    }
    else if (timeSecond/(3600)>0)
    {
        return [NSString stringWithFormat:@"%d小时前",(int)timeSecond/(3600)];
    }
    else if (timeSecond/(60)>0)
    {
        return [NSString stringWithFormat:@"%d分钟前",(int)timeSecond/(60)];
    }
    else if (timeSecond > 0)
    {
        return [NSString stringWithFormat:@"%d秒前",(abs((int)timeSecond))];
    }
    else
    {
        return @"刚刚";
    }
}

@end
