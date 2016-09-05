//
//  NSString+LXNetworkMatch.m
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-09-04.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import "NSString+LXNetworkMatch.h"

@implementation NSString (LXNetworkMatch)

- (BOOL)lxMatchWithRegex:(NSString*)regexString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexString];
    return [predicate evaluateWithObject:self];
}

@end
