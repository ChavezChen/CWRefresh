//
//  CWRefresh.h
//  上下拉刷新
//
//  Created by macmini on 16/2/24.
//  Copyright © 2016年 Chavez. All rights reserved.
//

/** 使用方法
 1、导入该头文件
 2、对需要刷新的对象 调用- (void)addCWHeaderWithRefreshingFinishingBlock:(void (^)())block;这个方法，block内执行刷新需要的操作
 3、刷新的对象使用- (void)endCWHeaderRefreshing; 方法结束刷新
 
 说明：该框架 为下拉刷新简易版本 使用者可以借鉴之后自行添加各种炫酷的效果
 */

#import "UIScrollView+CWRefresh.h"
#import "CWRefreshHeaderView.h"


