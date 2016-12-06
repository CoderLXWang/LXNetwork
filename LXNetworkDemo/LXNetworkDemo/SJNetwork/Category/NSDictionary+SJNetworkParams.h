//
//  NSDictionary+SJNetworkParams.h
//  LXProject
//
//  Created by sharejoy_lx on 16-10-18.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SJNetworkParams)

//params 转换为NSString
- (NSString *)sjUrlParamsToString;
//params 转换为JSON
- (NSString *)sjUrlParamsToJsonString;
//params 转换为NSArray
- (NSArray *)sjUrlParamsToArray;


@end
