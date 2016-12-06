//
//  FirstModel.m
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-12-06.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import "FirstModel.h"

@implementation FirstModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"user_name":@"user.login",
             @"votes_down":@"votes.down",
             @"votes_up":@"votes.up",
             };
}

@end
