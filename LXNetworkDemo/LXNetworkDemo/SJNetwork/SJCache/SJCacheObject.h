//
//  SJCacheObject.h
//  LXProject
//
//  Created by sharejoy_lx on 16-10-18.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJCacheObject : NSObject

//只读属性
@property (nonatomic, copy, readonly) NSData *content;
@property (nonatomic, copy, readonly) NSDate *lastUpdateTime;


@property (nonatomic, assign, readonly) BOOL isOverdue;
@property (nonatomic, assign, readonly) BOOL isEmpty;


- (instancetype)initWithContent:(NSData *)content;

- (void)updateContent:(NSData *)content;

@end
