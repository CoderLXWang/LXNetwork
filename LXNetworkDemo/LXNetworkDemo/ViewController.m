//
//  ViewController.m
//  SJNetworkDemo
//
//  Created by sharejoy_SJ on 16-09-04.
//  Copyright © 2016年 wSJ. All rights reserved.
//

#import "ViewController.h"
#import "FirstTestApi.h"
#import "SecondTestApi.h"
#import <Masonry.h>
#import "FirstCell.h"
#import <MJRefresh.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define WeakSelf(weakSelf)  __weak __typeof(&*self) weakSelf = self

/**
 清除缓存方法
 1. 在appdelegate中监听SJDeleteCacheNotification通知，处理相关清除代码
 
 2. 在适当的时刻及位置发送类似通知
 [SJNotice postNotificationName:SJDeleteCacheNotification object:nil userInfo:@{SJDeleteCacheKey
 : @[NSClassFromString(@"FirstTestApi"), NSClassFromString(@"SecondTestApi")]}];
 
 */

//遵守回调协议SJBaseRequestCallBackDelegate
@interface ViewController () <SJBaseRequestCallBackDelegate, UITableViewDelegate, UITableViewDataSource>

//定义接口属性实现懒加载
@property (nonatomic, strong) FirstTestApi *firstApi;

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *deleCacheBtn;

@end

@implementation ViewController

#pragma mark --------- 懒加载 --------
- (FirstTestApi *)firstApi
{
    if (!_firstApi) {
        _firstApi = [[FirstTestApi alloc] init];
        _firstApi.delegate = self;
    }
    return _firstApi;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //添加下拉和上拉刷新并隐藏上拉刷新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
        header.lastUpdatedTimeLabel.hidden=YES;
        _tableView.mj_header=header;
        
        MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        _tableView.mj_footer = footer;
        _tableView.mj_footer.hidden=YES;
    }
    return _tableView;
}

- (UIButton *)deleCacheBtn {
    if (!_deleCacheBtn) {
        _deleCacheBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 20, 60, 30)];
        [_deleCacheBtn setTitle:@"清缓存" forState:UIControlStateNormal];
        _deleCacheBtn.backgroundColor = [UIColor lightGrayColor];
        [_deleCacheBtn addTarget:self action:@selector(deleCacheBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleCacheBtn;
}

- (void)deleCacheBtnClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:SJDeleteCacheNotification object:nil userInfo:@{SJDeleteCacheKey
                                                                                   : @[NSClassFromString(@"FirstTestApi")]}];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configView];
    
    [self loadNew];
}

- (void)configView {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.deleCacheBtn];
}

#pragma mark --------- tableView代理 --------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstCell *cell = [[FirstCell alloc] init];
    FirstModel *model = self.dataArray[indexPath.row];
    cell.firstModel = model;
    return cell;
}

//firstApi调用刷新， 即page = 1
- (void)loadNew {
    self.firstApi.isLoadNew=YES;
    [self.firstApi loadData];
    
    
    //可以用 block 实现网络回调，如使用block，则不需要设置接口的代理，如设置了代理，则优先回调代理方法
    //要测试block回调, 需将上面[self.firstApi loadData] 和 _firstApi.delegate = self; 注释掉
//    WeakSelf(ws);
//    [self.firstApi loadDataWithSuccess:^(FirstTestApi *api) {
//        [ws handleFirstTestApi:api];
//    } fail:^(FirstTestApi *api) {
//        NSLog(@"请求失败");
//    }];
    
}

//firstApi调用加载更多， 即page++
- (void)loadMore {
    self.firstApi.isLoadNew=NO;
    [self.firstApi loadData];
    
    
//    WeakSelf(ws);
//    [self.firstApi loadDataWithSuccess:^(FirstTestApi *api) {
//        [ws handleFirstTestApi:api];
//    } fail:^(FirstTestApi *api) {
//        NSLog(@"请求失败");
//    }];
}


#pragma mark --------- SJBaseRequestCallBackDelegate --------



- (void)requestDidSuccess:(SJBaseRequest *)request {
    
    NSLog(@"对应接口实现了requestSuccessDicWithClassStrAndSELStr， 则不用在这个方法里实现，如果本控制器相关接口全部分发出去，则可不写这个方法");
}

//写这个是为了演示多个接口， 实际本Demo只有一个，可以直接写requestDidSuccess里或者block
- (NSDictionary<NSString *, NSString *> *)requestSuccessDicWithClassStrAndSELStr {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:NSStringFromSelector(@selector(handleFirstTestApi:)) forKey:@"FirstTestApi"];
    return [dic copy];
}

- (void)handleFirstTestApi:(FirstTestApi *)api {
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    switch (api.responseCode) {
        case 0:
        {
            if (api.isLastPage) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            
            if (api.isLoadNew) {
                self.dataArray = api.dataArray;
                [self.tableView reloadData];
            } else {
                NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
                [array addObjectsFromArray:api.dataArray];
                self.dataArray = array.copy;
                [self.tableView reloadData];
            }
            
            
        }
            break;
            
        default:
            break;
    }
    
}


- (void)requestDidFailed:(SJBaseRequest *)request {
    NSLog(@"请求失败");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
