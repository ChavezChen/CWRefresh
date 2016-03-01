//
//  UIScrollView+CWRefresh.m
//  上下拉刷新
//
//  Created by macmini on 16/2/23.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "UIScrollView+CWRefresh.h"
#import "CWRefreshHeaderView.h"
#import <objc/runtime.h>
@implementation UIScrollView (CWRefresh)

- (void)addCWHeaderWithShowTitle:(NSString *)title RefreshingFinishingBlock:(void (^)())block{
    CWRefreshHeaderView * heade = [[CWRefreshHeaderView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.frame)-60, CGRectGetWidth(self.frame), 60)];
    heade.showTitle = title;
    self.header = heade;
    // 拿到父视图的控制器
    UIViewController * viewController = [self viewController];
    // 兼容导航栏是否透明以及64偏移问题
    if ( viewController.navigationController.navigationBarHidden == YES) {
        viewController.automaticallyAdjustsScrollViewInsets = NO;
        [viewController.view setBounds:CGRectMake(0, -20, viewController.view.bounds.size.width, viewController.view.bounds.size.height)];
    }
    else {
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    heade.refreshingBlock = block;
}

// 根据View获取视图的控制器
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


#pragma mark - header
// 关联
static char CWRefreshHeaderKey;
- (void)setHeader:(CWRefreshHeaderView *)header{
    if (header != self.header) {
        [self.header removeFromSuperview];
        [self willChangeValueForKey:@"header"];
        objc_setAssociatedObject(self, &CWRefreshHeaderKey,
                                 header,
                                 OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"header"];
        [self addSubview:header];
    }
}

- (CWRefreshHeaderView *)header{
    return objc_getAssociatedObject(self, &CWRefreshHeaderKey);
}

- (void)endCWHeaderRefreshing{
    [self.header endRefresh];
}


#pragma mark -




@end
