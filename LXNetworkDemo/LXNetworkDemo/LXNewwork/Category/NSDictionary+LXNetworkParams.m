//
//  NSDictionary+LXNetworkParams.m
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-09-04.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import "NSDictionary+LXNetworkParams.h"
#import "NSArray+LXNetworkParams.h"

@implementation NSDictionary (LXNetworkParams)

/** params 转换为NSString */
- (NSString *)lxUrlParamsToString {
    //字典排序
    NSArray *sortedArray = [self lxUrlParamsToArray];
    //数组生成字符串
    return [sortedArray lxUrlParamArrayToString];
}

- (NSString *)lxUrlParamsToJsonString {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSArray *)lxUrlParamsToArray {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        
        obj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)obj,  NULL,  (CFStringRef)@"!*'();:@&;=+$,/?%#[]",  kCFStringEncodingUTF8));
        
//        if ([obj length] > 0 && (![key isEqualToString:TIMESTAMP_KEY] && ![key isEqualToString:SIGNATURE_KEY]) ) {
            [result addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
//        }
    }];
    NSArray *sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;
}

@end
