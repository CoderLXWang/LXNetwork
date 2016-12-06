//
//  TestApi.h
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-09-04.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import "SJBaseRequest.h"

//要遵守什么协议取决于这个接口需要如何构造， LXBaseRequestDelegate一定要遵守，用于获取url等基本信息
@interface FirstTestApi : SJBaseRequest<SJBaseRequestDelegate, SJBaseRequestParamDelegate, SJBaseRequestHeaderDelegate>



/** 是否为读取新数据(对应下拉刷新) */
@property (nonatomic, assign) BOOL isLoadNew;
/** 是否为最后一页 */
@property (nonatomic, assign) BOOL isLastPage;

/** 可以是转好的数据模型，这里只是示意一下 */
@property (nonatomic, copy) NSArray *dataArray;

@end
