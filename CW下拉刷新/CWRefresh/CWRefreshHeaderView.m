//
//  CWRefreshHeaderView.m
//  上下拉刷新
//
//  Created by macmini on 16/2/23.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "CWRefreshHeaderView.h"

@implementation CWRefreshHeaderView
{
    NSInteger index; // 闪动的字位置
    UILabel * flashLabel; // 闪动的label
    NSTimer * _timer;
    BOOL _isRefreshing; // 是否在刷新状态
}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.activityView];
    }
    return self;
}

- (void)endRefresh{
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentInset = self.scrollViewOriginalInset;
    } completion:^(BOOL finished) {
        [self.activityView stopAnimating];
        for (UILabel * lb in [self getAllLabel]) {
            lb.hidden = YES;
        }
        _isRefreshing = NO;
    }];
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    // KVO监听 偏移量 以及手势
    [newSuperview addObserver:self forKeyPath:kCWPanstate options:NSKeyValueObservingOptionNew context:nil];
    [newSuperview addObserver:self forKeyPath:kCWContentoffset options:NSKeyValueObservingOptionNew context:nil];
    self.scrollView = (UIScrollView *)newSuperview;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollViewOriginalInset = self.scrollView.contentInset;
}

- (void)dealloc{
    [self.superview removeObserver:self forKeyPath:kCWContentoffset];
    [self.superview removeObserver:self forKeyPath:kCWPanstate];
}

#pragma mark - private
- (void)layoutSubviews {
    [super layoutSubviews];

}
// 获取所有的label
- (NSMutableArray *)getAllLabel{
    NSMutableArray * labelArray = [NSMutableArray array];
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [labelArray addObject:view];
        }
    }
    return labelArray;
}

#pragma mark - setter\getter
- (void)setShowTitle:(NSString *)showTitle{
    if (showTitle.length > 16) {
        showTitle = [showTitle substringToIndex:15];
        _showTitle = [showTitle stringByAppendingString:@"…"];
    }else{
        _showTitle = showTitle;
    }
    CGFloat width = self.frame.size.width;
    NSInteger count = _showTitle.length;
    if (count > 0) {
        // 字数＋转动的菊花 == 实际控件个数
        CGFloat interval = (width - (count + 1 )*KLabelWidth)/(count + 2);
        CGRect frame = self.activityView.frame;
        frame.origin.x = interval;
        self.activityView.frame = frame;
        for (int i = 1; i < count + 1; i++) {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((interval + KLabelWidth) *i +interval, 0, KLabelWidth, KLabelWidth)];
            CGPoint center = label.center;
            center.y = self.activityView.center.y;
            label.center = center;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:rand()%10 *0.1 green:rand()%10 *0.1 blue:rand()%10 *0.1 alpha:1];
            NSRange range;
            range.location = i-1;
            range.length = 1;
            label.text = [_showTitle substringWithRange:range];
            label.hidden = YES;
            [self addSubview:label];
        }
    }
}

#pragma mark － 懒加载
- (UIActivityIndicatorView *)activityView{
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _activityView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return _activityView;
}

- (UIImageView *)bgImageView{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [_bgImageView sendSubviewToBack:self];
    }
    return _bgImageView;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:kCWPanstate]) {
        if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if (_scrollView.contentOffset.y <= -100) {
                if (_isRefreshing) {
                    return;
                }
                for (UILabel * lb in [self getAllLabel]) {
                    lb.hidden = YES;
                }
                [self.activityView startAnimating];
                [UIView animateWithDuration:0.5 animations:^{
                    _scrollView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.frame), 0, 0, 0);
                } completion:^(BOOL finished) {
                    _isRefreshing = YES;
                    if (self.refreshingBlock) {
                        // 在主线程回调block
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.refreshingBlock();
                        });
                    }
                    if (_timer) {
                        [_timer invalidate];
                        _timer = nil;
                    }
                    index = 0;
                    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(labelFlash) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
                }];
            }
        }
    }else if ([keyPath isEqualToString:kCWContentoffset]){
        // 暂不使用  在拉动过程中 会调用该方法 可用于定制 动画效果
    }
}

#pragma mark - timer
-(void)labelFlash{
    for (int i = 0; i < [self getAllLabel].count; i++) {
        
        if (i == index) {
            UILabel *label = [self getAllLabel][index];
            label.hidden = NO;
        }
    }
    index ++;
}
@end
