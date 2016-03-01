//
//  CWRefreshHeaderView.h
//  上下拉刷新
//
//  Created by macmini on 16/2/23.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCWPanstate @"pan.state"
#define kCWContentoffset @"contentOffset"
#define KLabelWidth 30

@interface CWRefreshHeaderView : UIView

@property (nonatomic,copy) void(^refreshingBlock)();
// 父视图的scrollView
@property (nonatomic,strong) UIScrollView * scrollView;
// 刷新的时候显示的控件
@property (nonatomic,strong) UIActivityIndicatorView * activityView;
/** 记录scrollView刚开始的inset */
@property (assign, nonatomic) UIEdgeInsets scrollViewOriginalInset;
/** 刷新时显示的文字 */
@property (copy, nonatomic) NSString * showTitle;
/** 刷新时显示的背景图片 */
@property (strong, nonatomic) UIImageView * bgImageView;
@property (copy, nonatomic) NSString * showBgImageName;
/** 结束刷新 */
- (void)endRefresh;
@end
