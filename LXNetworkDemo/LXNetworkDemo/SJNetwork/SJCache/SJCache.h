//
//  SJCache.h
//  LXProject
//
//  Created by sharejoy_lx on 16-10-18.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJCache : NSObject

+ (instancetype)sharedInstance;

- (NSData *)fetchCachedDataWithAPIResources:(NSString *)methodName
                              requestParams:(NSDictionary *)requestParams;

- (void)saveCacheWithData:(NSData *)cachedData
               methodName:(NSString *)methodName
            requestParams:(NSDictionary *)requestParams;

- (void)deleteCacheWithAPIResources:(NSString *)methodName
                      requestParams:(NSDictionary *)requestParams;

//根据方法名删除缓存
-(void)deleteCacheWithMethodName:(NSString*)methodName;
//根据class名删除缓存，这里的Class主要是服务名对应的Class
-(void)deleteCacheWithClass:(Class)cls;

- (void)clean;

@end
