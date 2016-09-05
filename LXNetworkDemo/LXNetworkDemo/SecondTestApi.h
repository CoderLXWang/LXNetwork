//
//  SecondTestApi.h
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-09-05.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import "LXBaseRequest.h"

@interface SecondTestApi : LXBaseRequest <LXBaseRequestDelegate, LXBaseRequestParamDelegate>

@property (nonatomic, strong) id dataModel;

@end
