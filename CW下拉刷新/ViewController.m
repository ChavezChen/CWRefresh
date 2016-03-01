//
//  ViewController.m
//  CW下拉刷新
//
//  Created by macmini on 16/2/24.
//  Copyright © 2016年 Chavez. All rights reserved.
//

#import "ViewController.h"
#import "CWRefresh.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.dataSource addObject:[NSString stringWithFormat:@"%zd",self.dataSource.count]];
    
    
    // 添加下拉刷新
    __weak ViewController * weakSelf = self;
    [self.tableView addCWHeaderWithShowTitle:@"云之讯.开放平台" RefreshingFinishingBlock:^{
        [weakSelf performSelector:@selector(addData) withObject:nil afterDelay:3.0];
    }];
    
}

- (void)addData{
    for (int i = 0; i < 5; i++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"%zd",self.dataSource.count]];
    }
    [self.tableView reloadData];
    // 结束下拉刷新方法1
//    [self.tableView.header endRefresh];
    // 结束下拉刷新方法2
    [self.tableView endCWHeaderRefreshing];
}



- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        CGRect frame = _tableView.frame;
        frame.size.height -= 64;
        _tableView.frame = frame;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:rand()%255/255.0 green:rand()%255/255.0 blue:rand()%255/255.0 alpha:0.8];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
