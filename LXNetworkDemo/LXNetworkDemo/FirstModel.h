//
//  FirstModel.h
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-12-06.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface FirstModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *share_count;
@property (nonatomic, copy) NSString *votes_up;
@property (nonatomic, copy) NSString *votes_down;
@property (nonatomic, copy) NSString *user_name;

@end
