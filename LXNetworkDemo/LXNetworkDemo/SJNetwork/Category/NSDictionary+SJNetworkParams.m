//
//  NSDictionary+SJNetworkParams.m
//  LXProject
//
//  Created by sharejoy_lx on 16-10-18.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import "NSDictionary+SJNetworkParams.h"
#import "NSArray+SJNetworkParams.h"

@implementation NSDictionary (SJNetworkParams)

/** params 转换为NSString */
- (NSString *)sjUrlParamsToString {
    //字典排序
    NSArray *sortedArray = [self sjUrlParamsToArray];
    //数组生成字符串
    return [sortedArray sjUrlParamArrayToString];
}

- (NSString *)sjUrlParamsToJsonString {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSArray *)sjUrlParamsToArray {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        obj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)obj,  NULL,  (CFStringRef)@"!*'();:@&;=+$,/?%#[]",  kCFStringEncodingUTF8));
        
//        ([obj length] > 0 && (![key isEqualToString:TIMESTAMP_KEY] && ![key isEqualToString:SIGNATURE_KEY])
        if ([obj length] > 0 ) {
            [result addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    NSArray *sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;
}





@end
