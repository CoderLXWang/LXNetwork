//
//  NSString+SJNetworkMatch.h
//  LXProject
//
//  Created by sharejoy_lx on 16-10-18.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SJNetworkMatch)

- (BOOL)sjMatchWithRegex:(NSString*)regexString;

@end
