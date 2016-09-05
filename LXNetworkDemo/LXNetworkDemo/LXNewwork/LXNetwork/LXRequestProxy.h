//
//  LXRequestProxy.h
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-09-04.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"
#import "LXResponse.h"

typedef void(^suceesBlock)(NSURLSessionDataTask *task, id reponseObject);
typedef void(^failureBlock)(NSURLSessionDataTask *task, NSError *error);
typedef void(^LXProxyCallback)(LXResponse * response);
typedef void(^multipart)(id<AFMultipartFormData>);
typedef NS_ENUM(NSInteger, RequestType) {
    REQUEST_GET = 0,
    REQUEST_POST,
    REQUEST_UPLOAD
};


@interface LXRequestProxy : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params url:(NSString *)url  headers:(NSDictionary*)headers methodName:(NSString *)methodName success:(LXProxyCallback)success fail:(LXProxyCallback)fail;

- (NSInteger)callPOSTWithParams:(NSDictionary *)params url:(NSString *)url  headers:(NSDictionary*)headers methodName:(NSString *)methodName success:(LXProxyCallback)success fail:(LXProxyCallback)fail;

- (NSInteger)callUPLOADWithParams:(NSDictionary *)params url:(NSString *)url headers:(NSDictionary*)headers uploads:(NSDictionary*)uploads methodName:(NSString *)methodName success:(LXProxyCallback)success fail:(LXProxyCallback)fail;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
