//
//  LXCache.m
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-09-04.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import "LXCache.h"
#import "LXNetworkConfiguration.h"
#import "LXCacheObject.h"
#import "NSDictionary+LXNetworkParams.h"
#import "NSArray+LXNetworkParams.h"
#import "NSString+LXNetworkMatch.h"

#import <objc/runtime.h>

@interface LXCache ()

@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) NSMutableSet* keys;

@end

@implementation LXCache


+ (instancetype)sharedInstance{
    static LXCache * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LXCache alloc] init];
    });
    return instance;
}

#pragma mark - life cycle
- (NSData *)fetchCachedDataWithAPIResources:(NSString *)methodName
                              requestParams:(NSDictionary *)requestParams{
    return [self fetchCachedDataWithKey:[self keyWithAPIResources:methodName requestParams:requestParams]];
}

- (void)saveCacheWithData:(NSData *)cachedData
               methodName:(NSString *)methodName
            requestParams:(NSDictionary *)requestParams{
    [self saveCacheWithData:cachedData key:[self keyWithAPIResources:methodName requestParams:requestParams]];
}

- (void)deleteCacheWithAPIResources:(NSString *)methodName
                      requestParams:(NSDictionary *)requestParams{
    [self deleteCacheWithKey:[self keyWithAPIResources:methodName requestParams:requestParams]];
}

- (void)clean{
    [self.cache removeAllObjects];
}

#pragma mark - getters and setters
- (NSCache *)cache{
    if (nil == _cache) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = kLXNCacheCountLimit;
    }
    return _cache;
}

-(NSMutableSet *)keys
{
    if (!_keys) {
        _keys = [[NSMutableSet alloc] init];
    }
    return _keys;
}

#pragma mark - private methods

- (NSData *)fetchCachedDataWithKey:(NSString *)key{
    LXCacheObject *cachedObject = [self.cache objectForKey:key];
    //    NSLog(@"fetchCacheKey %@", key);
    //    NSLog(@"fetchCache %@", [self.cache objectForKey:key]);
    if (cachedObject == nil || cachedObject.isOverdue || cachedObject.isEmpty) {
        return nil;
    } else {
        return cachedObject.content;
    }
}

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key
{
    LXCacheObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject == nil) {
        cachedObject = [[LXCacheObject alloc] init];
    }
    [cachedObject updateContent:cachedData];
    [self.cache setObject:cachedObject forKey:key];
    [self.keys addObject:key];
    //    NSLog(@"saveCacheKey %@", key);
    //    NSLog(@"saveCache %@", self.cache);
}

- (void)deleteCacheWithKey:(NSString *)key
{
    //    NSLog(@"deleteBefore %@",[self.cache objectForKey:key]);
    [self.cache removeObjectForKey:key];
    [self.keys removeObject:key];
    //    NSLog(@"deleteAfter %@",[self.cache objectForKey:key]);
}

-(void)deleteCacheWithMethodName:(NSString *)methodName
{
    for (NSString* key in [self.keys allObjects]) {
        if ([key rangeOfString:methodName].location != NSNotFound) {
            [self deleteCacheWithKey:key];
        }
    }
}

-(void)deleteCacheWithClass:(Class)cls
{
    
    //调用Class的getCacheKey方法获得key，再按照正则表达式来匹配key,匹配到的数据将被删除
    NSString* regexKey;
    NSString* matchKey;
    //class_getInstanceMethod 得到类的实例方法    class_getClassMethod 得到类的类方法
    //想要可以控制删除缓存, cacheRegexKey必须实现
    Method method = class_getInstanceMethod(cls, NSSelectorFromString(@"cacheRegexKey"));
    if (method) {
        IMP imp = method_getImplementation(method);
        regexKey = ((NSString*(*)())imp)();
        //        matchKey = [NSString stringWithFormat:@".*_%@_%@.*", SBAPPDelegate.token ? SBAPPDelegate.token : @"token", regexKey];
        
        matchKey = [NSString stringWithFormat:@".*_%@.*", regexKey];
        for (NSString* key in [self.keys allObjects]) {
            if ([key lxMatchWithRegex: matchKey]) {
                [self deleteCacheWithKey:key];
            }
        }
    }
}

- (NSString*)keyWithAPIResources:(NSString *)methodName requestParams:(NSDictionary *)requestParams{
    return [NSString stringWithFormat:@"%@%@",methodName, [requestParams lxUrlParamsToString]];
}

@end
