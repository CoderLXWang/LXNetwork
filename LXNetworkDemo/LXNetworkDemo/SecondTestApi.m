//
//  SecondTestApi.m
//  SJNetworkDemo
//
//  Created by sharejoy_SJ on 16-09-05.
//  Copyright © 2016年 wSJ. All rights reserved.
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

- (SJBaseRequestType)requestType {
    return SJBaseRequestTypeGet;
}

- (BOOL)shouldCache {
    return NO;
}

- (NSString *)requestUrl {
    return kRecommend;
}

- (NSDictionary *)paramsForRequest:(SJBaseRequest *)request {
    NSInteger rand = arc4random() % 101;
    return @{@"rand":[NSString stringWithFormat:@"%zd", rand]};
}

- (void)beforePerformSuccessWithResponse:(SJResponse *)response {
    [super beforePerformSuccessWithResponse:response];
    
    self.dataModel = response.result;
}

@end
