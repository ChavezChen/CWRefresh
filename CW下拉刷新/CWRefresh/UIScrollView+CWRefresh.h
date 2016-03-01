//
//  UIScrollView+CWRefresh.h
//  上下拉刷新
//
//  Created by macmini on 16/2/23.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CWRefreshHeaderView;
@interface UIScrollView (CWRefresh)
@property (nonatomic,strong) CWRefreshHeaderView *header;
// 添加下拉刷新控件
- (void)addCWHeaderWithShowTitle:(NSString *)title RefreshingFinishingBlock:(void (^)())block;
// 结束下拉刷新
- (void)endCWHeaderRefreshing;

@end
