//
//  LXNetworkConfiguration.h
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-09-04.
//  Copyright © 2016年 wlx. All rights reserved.
//

#ifndef LXNetworkConfiguration_h
#define LXNetworkConfiguration_h

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

typedef NS_ENUM(NSUInteger, LXResponseStatus)
{
    LXResponseStatusSuccess,  //服务器请求成功即设置为此状态,内容是否错误由各子类验证
    LXResponseStatusTimeout,
    LXResponseStatusNoNetwork  // 默认除了超时以外的错误都是无网络错误。
};


static NSString *LXDeleteCacheNotification = @"LXDeleteCacheNotification";
static NSString *LXDeleteCacheKey = @"LXDeleteCacheKey";


//网络请求超时时间,默认设置为20秒
static NSTimeInterval kLXNTimeoutSeconds = 20.0f;
// 是否需要缓存的标志,默认为YES
static BOOL kLXNNeedCache = YES;
// cache过期时间 设置为30秒
static NSTimeInterval kLXNCacheOverdueSeconds = 30;
// cache容量限制,最多100条
static NSUInteger kLXNCacheCountLimit = 100;

#endif /* LXNetworkConfiguration_h */
