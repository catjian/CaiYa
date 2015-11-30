//
//  MM_BaseTableView.h
//  phoneBank
//
//  Created by long gang on 14-3-6.
//  Copyright (c) 2014年 ccrt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchTableViewDelegate <NSObject>

@optional

- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface MM_BaseTableView : UITableView
{
@private
    __unsafe_unretained id _touchDelegate;
}

@property(nonatomic,assign)id<TouchTableViewDelegate>touchDelegate;

@end
