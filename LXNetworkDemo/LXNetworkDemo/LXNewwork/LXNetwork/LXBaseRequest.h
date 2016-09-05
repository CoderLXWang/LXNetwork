//
//  LXBaseRequest.h
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-09-04.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXResponse.h"

//定义网络请求ID字典名称
static NSString * const LXNRequestId = @"LXNRequestId";

#pragma mark -- LXBaseRequestState各种状态
typedef enum : NSUInteger {
    LXBaseRequestStateDefault,       //没有API请求，默认状态。
    LXBaseRequestStateSuccess,       //API请求成功且返回数据正确。
    LXBaseRequestStateNetError,      //API请求返回失败。
    LXBaseRequestStateContentError,  //API请求成功但返回数据不正确。
    LXBaseRequestStateParamsError,   //API请求参数错误。
    LXBaseRequestStateTimeout,       //API请求超时。
    LXBaseRequestStateNoNetWork      //网络故障。
    
} LXBaseRequestState;

#pragma mark -- HTTP请求方式
typedef enum : NSUInteger {
    LXBaseRequestTypeGet = 0,
    LXBaseRequestTypePost,
    LXBaseRequestTypeUpload
    
} LXBaseRequestType;


@class LXBaseRequest;

#pragma mark -- 获取API所需基本设置
@protocol LXBaseRequestDelegate <NSObject>

@required
- (NSString *)requestUrl;
- (LXBaseRequestType)requestType;
@optional
- (NSString *)cacheRegexKey;
/**
 *   在调用API之前额外添加一些参数，但不应该在这个函数里面修改已有的参数
 *   如果实现这个方法, 一定要在传入的params基础上修改 , 再返回修改后的params
 *   LXBaseRequest会先调用这个函数，然后才会调用到 id<LXBaseRequestValidator> 中的 manager:isCorrectWithParamsData: 所以这里返回的参数字典还是会被后面的验证函数去验证的
 */
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (BOOL)shouldCache;

@end

#pragma mark -- 获取调用API所需要的参数
@protocol LXBaseRequestParamDelegate <NSObject>
@required
- (NSDictionary *)paramsForRequest:(LXBaseRequest *)request;
@end

#pragma mark -- 获取调用API所需要的头部数据(一般用于携带token等)
@protocol LXBaseRequestHeaderDelegate <NSObject>
@required
- (NSDictionary *)headersForRequest:(LXBaseRequest *)request;
@end

#pragma mark -- 获取调用API所需要的上传数据
@protocol LXBaseRequestUploadDelegate <NSObject>
@required
- (NSDictionary *)uploadsForRequest:(LXBaseRequest *)manager;
@end

#pragma mark -- 接口调用的回调
@protocol LXBaseRequestCallBackDelegate <NSObject>
@required
- (void)requestDidSuccess:(LXBaseRequest *)request;
- (void)requestDidFailed:(LXBaseRequest *)request;
@optional
/** 
 如果一个控制器内存在多个接口，并使用协议代理方式回调，则可以实现下面方法，将各个请求回调分发到各自的方法里
 例如：字典key为接口类名，value为方法的selector字符串
 - (NSDictionary<NSString *, NSString *> *)requestDicWithClassStrAndSELStr {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:NSStringFromSelector(@selector(handleShopListService:)) forKey:@"ShopListService"];
    [dic setObject:NSStringFromSelector(@selector(handleRelationService:)) forKey:@"RelationService"];
    。。。
    return [dic copy];
 }
 */
- (NSDictionary<NSString *, NSString *> *)requestDicWithClassStrAndSELStr;
@end

#pragma mark -- 拦截器
@protocol LXBaseRequestInterceptor <NSObject>

@optional
//参数拦截器, 通过参数判断是否发送请求
- (BOOL)request:(LXBaseRequest *)request shouldCallAPIWithParams:(NSDictionary *)params;
- (void)request:(LXBaseRequest *)request afterCallAPIWithParams:(NSDictionary *)params;

//结果拦截器, 拿到返回的原始json数据, 处理成model再给SJAPIManagerCallBackDelegate 使用
- (void)request:(LXBaseRequest *)request beforePerformSuccessWithResponse:(LXResponse *)response;
- (void)request:(LXBaseRequest *)request beforePerformFailWithResponse:(LXResponse *)response;

- (void)request:(LXBaseRequest *)request afterPerformSuccessWithResponse:(LXResponse *)response;
- (void)request:(LXBaseRequest *)request afterPerformFailWithResponse:(LXResponse *)response;

@end

#pragma mark -- 验证器，用于验证API的返回或者调用API的参数是否正确
@protocol LXBaseRequestValidator <NSObject>
@required
//验证CallBack数据的正确性
- (BOOL)request:(LXBaseRequest *)request isCorrectWithResponseData:(NSDictionary *)data;
//验证传递的参数数据的正确性
- (BOOL)request:(LXBaseRequest *)request isCorrectWithParamsData:(NSDictionary *)data;
@end

typedef void(^LXReuqestCallback)(LXBaseRequest *request);
@interface LXBaseRequest : NSObject

@property (nonatomic, weak) NSObject<LXBaseRequestDelegate> *child; //!<获取请求基本设置
@property (nonatomic, weak) id<LXBaseRequestParamDelegate> paramSource; //!<获取参数代理
@property (nonatomic, weak) id<LXBaseRequestHeaderDelegate> headerSource; //!<获取请求头代理
@property (nonatomic, weak) id<LXBaseRequestUploadDelegate> uploadsSource; //!<获取上传数据代理
@property (nonatomic, weak) id<LXBaseRequestCallBackDelegate> delegate; //!<这个代理一般为控制器，实现回调相关操作
@property (nonatomic, weak) id<LXBaseRequestValidator> validator; //!<验证器
@property (nonatomic, weak) id<LXBaseRequestInterceptor> interceptor;  //!<拦截器

/** 服务器返回的message，具体根据不同json格式在LXResponse中设置 */
@property (nonatomic, copy, readonly) NSString *responseMessage;
@property (nonatomic, assign, readonly) int responseCode;
@property (nonatomic, readonly) LXBaseRequestState requestState;
/** 是否正在请求数据 */
@property (nonatomic, assign, readonly) BOOL isLoading;

/** 调用接口 */
- (NSInteger)loadData;
/** 调用接口, 并以block形式处理返回数据，如果使用这种方式，则响应控制器不需要遵守LXBaseRequestCallBackDelegate，响应请求类也不需要设置delegate */
- (NSInteger)loadDataWithSuccess:(LXReuqestCallback)success fail:(LXReuqestCallback)fail;
- (void)deleteCache;

//取消全部网络请求
- (void)cancelAllRequests;

//根据requestId取消网络请求
- (void)cancelRequestWithRequestId:(NSInteger)requestId;

// 拦截器方法，继承之后需要调用一下super，如果需要其他位置实现拦截， 使用代理
- (void)beforePerformSuccessWithResponse:(LXResponse *)response;
- (void)afterPerformSuccessWithResponse:(LXResponse *)response;

- (void)beforePerformFailWithResponse:(LXResponse *)response;
- (void)afterPerformFailWithResponse:(LXResponse *)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
- (void)afterCallingAPIWithParams:(NSDictionary *)params;

@end













