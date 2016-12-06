//
//  SecondTestApi.h
//  SJNetworkDemo
//
//  Created by sharejoy_SJ on 16-09-05.
//  Copyright © 2016年 wSJ. All rights reserved.
//

#import "SJBaseRequest.h"

@interface SecondTestApi : SJBaseRequest <SJBaseRequestDelegate, SJBaseRequestParamDelegate>

@property (nonatomic, strong) id dataModel;

@end
