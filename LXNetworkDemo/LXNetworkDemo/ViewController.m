//
//  ViewController.m
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-09-04.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import "ViewController.h"
#import "FirstTestApi.h"
#import "SecondTestApi.h"

//遵守回调协议LXBaseRequestCallBackDelegate
@interface ViewController () <LXBaseRequestCallBackDelegate>

//定义接口属性实现懒加载
@property (nonatomic, strong) FirstTestApi *firstApi;
@property (nonatomic, strong) SecondTestApi *secondApi;

@end

@implementation ViewController

#pragma mark --------- 懒加载 --------
- (FirstTestApi *)firstApi
{
    if (!_firstApi) {
        _firstApi = [[FirstTestApi alloc] init];
        _firstApi.delegate = self;
        _firstApi.tp = 1;
    }
    return _firstApi;
}

- (SecondTestApi *)secondApi
{
    if (!_secondApi) {
        _secondApi = [[SecondTestApi alloc] init];
        _secondApi.delegate = self;
    }
    return _secondApi;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加点击调用接口的按钮
    [self configBtns];
}

//firstApi调用刷新， 即page = 1
- (void)loadNew {
    self.firstApi.isLoadNew=YES;
    [self.firstApi loadData];
    
}

//firstApi调用加载更多， 即page++
- (void)loadMore {
    self.firstApi.isLoadNew=NO;
    [self.firstApi loadData];
}

- (void)loadSecondApi {
    [self.secondApi loadData];
    
    //调用block需注释掉self.secondApi懒加载中的_secondApi.delegate = self;
//    [self.secondApi loadDataWithSuccess:^(LXBaseRequest *request) {
//        
//        SecondTestApi *testApi = (SecondTestApi *)request;
//        NSLog(@"block 接口2请求成功 %@ ", testApi.dataModel);
//        
//    } fail:^(LXBaseRequest *request) {
//        NSLog(@"接口2请求失败");
//    }];
    
}

#pragma mark --------- LXBaseRequestCallBackDelegate --------



- (void)requestDidSuccess:(LXBaseRequest *)request {
//    if ([request isKindOfClass:[FirstTestApi class]]) {
//        FirstTestApi *testApi = (FirstTestApi *)request;
//        NSLog(@"接口1请求成功 %lu ", testApi.dataLength);
//    }
//    if ([request isKindOfClass:[SecondTestApi class]]) {
//        SecondTestApi *testApi = (SecondTestApi *)request;
//        NSLog(@"接口2请求成功 %@ ", testApi.dataModel);
//    }
}

- (NSDictionary<NSString *, NSString *> *)requestDicWithClassStrAndSELStr {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:NSStringFromSelector(@selector(handleFirstTestApi:)) forKey:@"FirstTestApi"];
    [dic setObject:NSStringFromSelector(@selector(handleSecondTestApi:)) forKey:@"SecondTestApi"];
    return [dic copy];
}

- (void)handleFirstTestApi:(FirstTestApi *)api {
    NSLog(@"接口1请求成功 %lu ", api.dataLength);
}

- (void)handleSecondTestApi:(SecondTestApi *)api {
    NSLog(@"接口2请求成功 %@ ", api.dataModel);
}

- (void)requestDidFailed:(LXBaseRequest *)request {
    NSLog(@"请求失败");
}

- (void)cleanCache {
    //通知方式
//    [self delegateCacheForNoti];
    //直接清除
    [self.firstApi deleteCache];
}

- (void)delegateCacheForNoti {
    [[NSNotificationCenter defaultCenter] postNotificationName:LXDeleteCacheNotification
                            object:nil
                          userInfo:@{LXDeleteCacheKey
                                     : @[NSClassFromString(@"TestApi"),
                                         NSClassFromString(@"xxxApi"),
                                         NSClassFromString(@"xxxApi"),
                                         ]}];
}


- (void)configBtns {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    [btn setTitle:@"接口1刷新" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(loadNew) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 50)];
    [btn1 setTitle:@"接口1下一页数据" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor orangeColor];
    [btn1 addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 200, 50)];
    [btn2 setTitle:@"接口2调用" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 addTarget:self action:@selector(loadSecondApi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *cachebtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 200, 50)];
    [cachebtn setTitle:@"清除接口1的缓存" forState:UIControlStateNormal];
    cachebtn.backgroundColor = [UIColor orangeColor];
    [cachebtn addTarget:self action:@selector(cleanCache) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cachebtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
