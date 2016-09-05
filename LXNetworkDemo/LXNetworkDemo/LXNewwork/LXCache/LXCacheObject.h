//
//  LXCacheObject.h
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-09-04.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXCacheObject : NSObject

//只读属性
@property (nonatomic, copy, readonly) NSData *content;
@property (nonatomic, copy, readonly) NSDate *lastUpdateTime;


@property (nonatomic, assign, readonly) BOOL isOverdue;
@property (nonatomic, assign, readonly) BOOL isEmpty;


- (instancetype)initWithContent:(NSData *)content;

- (void)updateContent:(NSData *)content;


@end
