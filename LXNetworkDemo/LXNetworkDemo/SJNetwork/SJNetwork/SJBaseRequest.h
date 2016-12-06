//
//  SJBaseRequest.h
//  LXProject
//
//  Created by sharejoy_lx on 16-10-18.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJResponse.h"

//定义网络请求ID字典名称
static NSString * const SJNRequestId = @"SJNRequestId";

#pragma mark -- SJBaseRequestState各种状态
typedef enum : NSUInteger {
    SJBaseRequestStateDefault,       //没有API请求，默认状态。
    SJBaseRequestStateSuccess,       //API请求成功且返回数据正确。
    SJBaseRequestStateNetError,      //API请求返回失败。
    SJBaseRequestStateContentError,  //API请求成功但返回数据不正确。
    SJBaseRequestStateParamsError,   //API请求参数错误。
    SJBaseRequestStateTimeout,       //API请求超时。
    SJBaseRequestStateNoNetWork      //网络故障。
    
} SJBaseRequestState;

#pragma mark -- HTTP请求方式
typedef enum : NSUInteger {
    SJBaseRequestTypeGet = 0,
    SJBaseRequestTypePost,
    SJBaseRequestTypeUpload
    
} SJBaseRequestType;


@class SJBaseRequest;

#pragma mark -- 获取API所需基本设置
@protocol SJBaseRequestDelegate <NSObject>

@required
- (NSString *)requestUrl;
- (SJBaseRequestType)requestType;
@optional
- (NSString *)cacheRegexKey;
/**
 *   在调用API之前额外添加一些参数，但不应该在这个函数里面修改已有的参数
 *   如果实现这个方法, 一定要在传入的params基础上修改 , 再返回修改后的params
 *   SJBaseRequest会先调用这个函数，然后才会调用到 id<SJBaseRequestValidator> 中的 manager:isCorrectWithParamsData: 所以这里返回的参数字典还是会被后面的验证函数去验证的
 */
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (BOOL)shouldCache;

@end

#pragma mark -- 获取调用API所需要的参数
@protocol SJBaseRequestParamDelegate <NSObject>
@required
- (NSDictionary *)paramsForRequest:(SJBaseRequest *)request;
@end

#pragma mark -- 获取调用API所需要的头部数据(一般用于携带token等)
@protocol SJBaseRequestHeaderDelegate <NSObject>
@required
- (NSDictionary *)headersForRequest:(SJBaseRequest *)request;
@end

#pragma mark -- 获取调用API所需要的上传数据
@protocol SJBaseRequestUploadDelegate <NSObject>
@required
- (NSDictionary *)uploadsForRequest:(SJBaseRequest *)manager;
@end

#pragma mark -- 接口调用的回调
@protocol SJBaseRequestCallBackDelegate <NSObject>
@required
- (void)requestDidSuccess:(SJBaseRequest *)request;
- (void)requestDidFailed:(SJBaseRequest *)request;
@optional
/**
 如果一个控制器内存在多个接口，并使用协议代理方式回调，则可以实现下面方法，将各个请求回调分发到各自的方法里
 注意：使用了这个方法，则对应接口的requestDidSuccess 和 successBlock 都不会被执行
 例如：字典key为接口类名，value为方法的selector字符串
 - (NSDictionary<NSString *, NSString *> *)requestDicWithClassStrAndSELStr {
 NSMutableDictionary *dic = [NSMutableDictionary dictionary];
 [dic setObject:NSStringFromSelector(@selector(handleShopListService:)) forKey:@"ShopListService"];
 [dic setObject:NSStringFromSelector(@selector(handleRelationService:)) forKey:@"RelationService"];
 。。。
 return [dic copy];
 }
 */
- (NSDictionary<NSString *, NSString *> *)requestSuccessDicWithClassStrAndSELStr;
@end



#pragma mark -- 验证器，用于验证API的返回或者调用API的参数是否正确
@protocol SJBaseRequestValidator <NSObject>
@required
//验证CallBack数据的正确性
- (BOOL)request:(SJBaseRequest *)request isCorrectWithResponseData:(NSDictionary *)data;
//验证传递的参数数据的正确性
- (BOOL)request:(SJBaseRequest *)request isCorrectWithParamsData:(NSDictionary *)data;
@end

typedef void(^SJReuqestCallback)(id api);
@interface SJBaseRequest : NSObject

@property (nonatomic, weak) NSObject<SJBaseRequestDelegate> *child; //!<获取请求基本设置
@property (nonatomic, weak) id<SJBaseRequestParamDelegate> paramSource; //!<获取参数代理
@property (nonatomic, weak) id<SJBaseRequestHeaderDelegate> headerSource; //!<获取请求头代理
@property (nonatomic, weak) id<SJBaseRequestUploadDelegate> uploadsSource; //!<获取上传数据代理
@property (nonatomic, weak) id<SJBaseRequestCallBackDelegate> delegate; //!<这个代理一般为控制器，实现回调相关操作
@property (nonatomic, weak) id<SJBaseRequestValidator> validator; //!<验证器

/** 服务器返回的message，具体根据不同json格式在SJResponse中设置 */
@property (nonatomic, strong, readonly) SJResponse *response;
@property (nonatomic, copy, readonly) NSString *responseMessage;
@property (nonatomic, assign, readonly) int responseCode;
@property (nonatomic, readonly) SJBaseRequestState requestState;
/** 是否正在请求数据 */
@property (nonatomic, assign, readonly) BOOL isLoading;

/** 调用接口 */
- (NSInteger)loadData;
/** 调用接口, 并以block形式处理返回数据，如果使用这种方式，则响应控制器不需要遵守SJBaseRequestCallBackDelegate，响应请求类也不需要设置delegate */
- (NSInteger)loadDataWithSuccess:(SJReuqestCallback)success fail:(SJReuqestCallback)fail;


- (void)deleteCache;


+ (void)cancelRequestWith:(NSArray<SJBaseRequest *> *)requestArray;

//取消全部网络请求
- (void)cancelAllRequests;

//根据requestId取消网络请求
- (void)cancelRequestWithRequestId:(NSInteger)requestId;

// 拦截器方法，继承之后需要调用一下super，如果需要其他位置实现拦截， 使用代理
- (void)beforePerformSuccessWithResponse:(SJResponse *)response;
- (void)afterPerformSuccessWithResponse:(SJResponse *)response;

- (void)beforePerformFailWithResponse:(SJResponse *)response;
- (void)afterPerformFailWithResponse:(SJResponse *)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
- (void)afterCallingAPIWithParams:(NSDictionary *)params;

@end
