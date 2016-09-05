//
//  NSDictionary+LXNetworkParams.h
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-09-04.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (LXNetworkParams)

//params 转换为NSString
- (NSString *)lxUrlParamsToString;
//params 转换为JSON
- (NSString *)lxUrlParamsToJsonString;
//params 转换为NSArray
- (NSArray *)lxUrlParamsToArray;

@end
