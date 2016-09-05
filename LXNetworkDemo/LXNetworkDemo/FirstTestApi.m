//
//  TestApi.m
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-09-04.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import "FirstTestApi.h"

//基本url，可定义成全局变量或者宏， 拼接URL使用
#define BaseUrl @"http://api.zsreader.com/v2/"

@implementation FirstTestApi
{
    int page;//记录页码值
    int pageSize;//每页条数
    NSInteger total;//记录总条数
    
}

//重写init方法是为了设置获取参数和请求头的代理， LXBaseRequestDelegate不用设置是因为已在父类中设置好， 如果只需要最基本的LXBaseRequestDelegate则不需要重写init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.paramSource = self;
        self.headerSource = self;
    }
    return self;
}

- (LXBaseRequestType)requestType {
    return LXBaseRequestTypeGet;
}

//1. 如果是POST请求下面两个方法都不用写
//2. 如果接口需要缓存, 这个可以不写，默认需要
//3. 某些GET接口, 不需要缓存一定要写, 比如需要数据及时变化的
- (BOOL)shouldCache {
    return YES;
}

//1. 删除缓存的时候要用来拼接缓存的key, 所以如果使用了缓存, 这个方法最好要写, 简单点就是直接返回requestUrl, 复杂一点的情况, 写各种不同的url的共同部分, 比如一个接口类里面有两个相近的url，@"pub/home/2"和@"pub/found/2", 则可以写@"pub/"， 区共同部分，清缓存时都清掉
//2. 不能引用当前类的变量, 直接崩掉, self.的东西都不行
//3. 如果有不同情况, (@"情况1"|@"情况2")， 比如 @"pub/home" 和 @"pub/found" 可以写[NSString stringWithFormat:@"%@(%@|%@)", BaseUrl, @"pub/home", @"pub/found"];
- (NSString *)cacheRegexKey {
    return [NSString stringWithFormat:@"%@%@", BaseUrl, @"pub/home/2"];
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@%@", BaseUrl, @"pub/home/2"];
}

//伪代码， 本接口不需要header， 演示一下
- (NSDictionary *)headersForRequest:(LXBaseRequest *)request {
    
//    if (app.isLogin) {
//        return @{@"token":app.token};
//    }
    return nil;
}


- (NSDictionary *)paramsForRequest:(LXBaseRequest *)request {
    //假如是上拉刷新，取下一页
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!self.isLoadNew) {
        params[@"page"]=@(page);
    }
    params[@"tp"] = @(self.tp);
    return [params copy];
}


//在调用API之前额外添加一些参数，但不应该在这个函数里面修改已有的参数
//如果实现这个方法, 一定要在传入的params基础上修改 , 再返回修改后的params
- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *mParams = [params mutableCopy];
    [mParams setObject:@"test" forKey:@"test"];
    return [mParams copy];
}

//获取到包装之后的LXResponse类型的返回数据，先处理一下，比如讲数据转成模型，供控制器回调使用
-(void)beforePerformSuccessWithResponse:(LXResponse *)response
{
    [super beforePerformSuccessWithResponse:response];
    if(self.isLoadNew){
        page=1;
        pageSize = [response.content[@"count"] intValue];
        total = [response.content[@"total"] integerValue];
    }
    self.isLastPage=(total<=page*pageSize);
    
    //可以在这转好模型, 控制器里直接用
    self.dataModel = response.result;
    self.dataLength = response.responseData.length;
    
    page++;
    
    
}


@end
