//
//  SecondTestApi.m
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-09-05.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import "SecondTestApi.h"

#define kRecommend (@"http://api.zsreader.com/v2/pub/discovery/recommend")

@implementation SecondTestApi

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.paramSource = self;
    }
    return self;
}

- (LXBaseRequestType)requestType {
    return LXBaseRequestTypeGet;
}

- (BOOL)shouldCache {
    return NO;
}

- (NSString *)requestUrl {
    return kRecommend;
}

- (NSDictionary *)paramsForRequest:(LXBaseRequest *)request {
    NSInteger rand = arc4random() % 101;
    return @{@"rand":[NSString stringWithFormat:@"%zd", rand]};
}

- (void)beforePerformSuccessWithResponse:(LXResponse *)response {
    [super beforePerformSuccessWithResponse:response];
    
    self.dataModel = response.result;
}

@end
