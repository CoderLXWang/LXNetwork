//
//  SJNetworkConfiguration.h
//  LXProject
//
//  Created by sharejoy_lx on 16-10-18.
//  Copyright © 2016年 wlx. All rights reserved.
//

#ifndef SJNetworkConfiguration_h
#define SJNetworkConfiguration_h

typedef NS_ENUM(NSUInteger, SJResponseStatus)
{
    SJResponseStatusSuccess,  //服务器请求成功即设置为此状态,内容是否错误由各子类验证
    SJResponseStatusTimeout,
    SJResponseStatusNoNetwork  // 默认除了超时以外的错误都是无网络错误。
};


static NSString *SJDeleteCacheNotification = @"SJDeleteCacheNotification";
static NSString *SJDeleteCacheKey = @"SJDeleteCacheKey";


//网络请求超时时间,默认设置为20秒
static NSTimeInterval kSJNTimeoutSeconds = 20.0f;
// 是否需要缓存的标志,默认为YES
static BOOL kSJNNeedCache = YES;
// cache过期时间 设置为30秒
static NSTimeInterval kSJNCacheOverdueSeconds = 30;
// cache容量限制,最多100条
static NSUInteger kSJNCacheCountLimit = 100;

#endif /* SJNetworkConfiguration_h */
