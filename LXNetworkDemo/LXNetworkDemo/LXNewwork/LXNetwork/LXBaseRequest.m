//
//  LXBaseRequest.m
//  LXNetworkDemo
//
//  Created by sharejoy_lx on 16-09-04.
//  Copyright © 2016年 wlx. All rights reserved.
//

#import "LXBaseRequest.h"
#import "LXCache.h"
#import <AFNetworking.h>
#import "LXRequestProxy.h"


@interface LXBaseRequest ()

/** 返回信息 */
@property (nonatomic, copy, readwrite) NSString *responseMessage;
@property (nonatomic, assign, readwrite) int responseCode;
/** 状态类型: 默认/成功/返回数据不正确/参数错误/超时/网络故障 */
@property (nonatomic, assign, readwrite) LXBaseRequestState requestState;
/** 请求id(app生命周期内递增) */
@property (nonatomic, strong) NSMutableArray *requestIdList;
/** 缓存对象 */
@property (nonatomic, strong) LXCache *cache;


@property (nonatomic, copy) LXReuqestCallback successBlock;
@property (nonatomic, copy) LXReuqestCallback failBlock;


@end

@implementation LXBaseRequest

#pragma mark - --getters and setters
- (LXCache *)cache
{
    if (_cache == nil) {
        _cache = [LXCache sharedInstance];
    }
    return _cache;
}

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

- (BOOL)isLoading
{
    return [self.requestIdList count] > 0;
}

#pragma mark - --life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        
        _responseMessage = nil;
        _requestState = LXBaseRequestStateDefault;
        
        if ([self conformsToProtocol:@protocol(LXBaseRequestDelegate)]) {
            self.child = (id <LXBaseRequestDelegate>)self;
        }
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - --公有方法
- (void)cancelAllRequests
{
    [[LXRequestProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}


- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[LXRequestProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

-(void)deleteCache
{
    NSString *methodName = [self getMethodName];
    [self.cache deleteCacheWithMethodName:methodName];
}

#pragma mark - --发起请求
- (NSInteger)loadData
{
    //参数等通过代理获得, 所以即使是子类, 也一定要遵守协议, 实现代理
    NSDictionary *params = [self.paramSource paramsForRequest:self];
    NSDictionary *headers = [self.headerSource headersForRequest:self];
    NSDictionary *uploads = [self.uploadsSource uploadsForRequest:self];
    //loadData是子类调用父类方法实现的
    NSInteger requestId = [self loadDataWithParams:params headers:headers uploads:uploads];
    return requestId;
}

- (NSInteger)loadDataWithSuccess:(LXReuqestCallback)success fail:(LXReuqestCallback)fail
{
    self.successBlock = success;
    self.failBlock = fail;
    
    //参数等通过代理获得, 所以即使是子类, 也一定要遵守协议, 实现代理
    NSDictionary *params = [self.paramSource paramsForRequest:self];
    NSDictionary *headers = [self.headerSource headersForRequest:self];
    NSDictionary *uploads = [self.uploadsSource uploadsForRequest:self];
    //loadData是子类调用父类方法实现的
    NSInteger requestId = [self loadDataWithParams:params headers:headers uploads:uploads];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params headers:(NSDictionary*)headers uploads:(NSDictionary*) uploads
{
    if (!([self.child respondsToSelector:@selector(requestType)] && self.child.requestUrl)) return 0;
    
    NSInteger requestId = 0;
    
    NSDictionary *apiParams;
    if ([self.child respondsToSelector:@selector(reformParams:)]) {
        apiParams = [self.child reformParams:params];
    } else {
        apiParams = params;
    }
    
    if ([self shouldCallAPIWithParams:apiParams]) {       //通过参数决定是否发送请求
        if ([self isCorrectWithParamsData:apiParams]) {    //检查参数正确性
            
            // 先检查一下是否有缓存
            if (self.child.requestType == LXBaseRequestTypeGet && [self shouldCache] && [self hasCacheWithParams:apiParams]) {  //需要缓存并且有缓存
                
                //在hasCacheWithParams中已发出
                NSLog(@"%@ : 这次请求用的是缓存", NSStringFromClass([self.child class]) );
                
                return 0;
            }

            // 实际的网络请求
            if ([self isReachable]) {              // 有网络
                switch (self.child.requestType)    // get/post/upload
                {
                    case LXBaseRequestTypeGet:
                    {
                        requestId = [[LXRequestProxy sharedInstance] callGETWithParams:apiParams url:self.child.requestUrl headers:headers methodName:self.getMethodName success:^(LXResponse *response) {
                            
                            [self successedOnCallingAPI:response];
                            
                        } fail:^(LXResponse *response) {
                            
                            [self failedOnCallingAPI:response withErrorType:LXBaseRequestStateNetError];
                            
                        }];
                        
                        [self.requestIdList addObject:@(requestId)];
                    }
                        
                        break;
                        
                    case LXBaseRequestTypePost:
                    {
                        requestId = [[LXRequestProxy sharedInstance] callPOSTWithParams:apiParams url:self.child.requestUrl headers:headers methodName:self.getMethodName success:^(LXResponse *response) {
                            
                            [self successedOnCallingAPI:response];
                            
                        } fail:^(LXResponse *response) {
                            
                            [self failedOnCallingAPI:response withErrorType:LXBaseRequestStateNetError];
                            
                        }];
                        
                        [self.requestIdList addObject:@(requestId)];
                    }
                        break;
                        
                    case LXBaseRequestTypeUpload:
                    {
                        requestId = [[LXRequestProxy sharedInstance] callUPLOADWithParams:apiParams url:self.child.requestUrl headers:headers uploads:uploads methodName:self.getMethodName success:^(LXResponse *response) {
                            
                            [self successedOnCallingAPI:response];
                            
                        } fail:^(LXResponse *response) {
                            
                            [self failedOnCallingAPI:response withErrorType:LXBaseRequestStateNetError];
                            
                        }];
                        
                        [self.requestIdList addObject:@(requestId)];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[LXNRequestId] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;
                
            } else {
                [self failedOnCallingAPI:nil withErrorType:LXBaseRequestStateNoNetWork];//网络故障,没网
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:LXBaseRequestStateParamsError];
            return requestId;
        }
    }
    return requestId;
}


#pragma mark - API回调执行的方法
- (void)successedOnCallingAPI:(LXResponse *)response
{
    self.requestState = LXBaseRequestStateSuccess;
    self.responseCode = response.responseCode;
    self.responseMessage = response.responseMessage;
    
    [self removeRequestIdWithRequestID:response.requestId];
    
    if ([self isCorrectWithResponseData:response.content]) {
        
        if (self.child.requestType == LXBaseRequestTypeGet && [self shouldCache] && !response.isCache) {
            
            //检查get请求/需要缓存/不是缓存数据  就保存缓存
            [self.cache saveCacheWithData:response.responseData methodName:[self getMethodName] requestParams:response.requestParams];
        }
        //        //token非法处理
        //        if (response.responseCode == 403000) {
        //            [SBNotice postNotificationName:SBLogoutNotification object:@(0)];
        //            return;
        //        }
        
        [self beforePerformSuccessWithResponse:response];
        if ([self.delegate respondsToSelector:@selector(requestDidSuccess:)]) {
            [self.delegate requestDidSuccess:self];
            
        } else {
            if (self.successBlock) {
                self.successBlock(self);
                self.successBlock = nil;
            }
        }
        
        //多请求 分发
        if ([self.delegate respondsToSelector:@selector(requestDicWithClassStrAndSELStr)]) {
            [self dispatchService];
        }
        
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:LXBaseRequestStateContentError];
    }
}


-(void)dispatchService
{
    for (NSString *str in [self.delegate requestDicWithClassStrAndSELStr].allKeys) {
        if ([self isKindOfClass:NSClassFromString(str)]) {
            SEL sel = NSSelectorFromString([[self.delegate requestDicWithClassStrAndSELStr] objectForKey:str]);
            if (sel) {
                SuppressPerformSelectorLeakWarning
                (
                 [self.delegate performSelector:sel withObject:self]
                 );
                return;
            }
        }
    }
}



- (void)failedOnCallingAPI:(LXResponse *)response withErrorType:(LXBaseRequestState)errorType
{
    self.requestState = errorType;
    self.responseCode = response.responseCode;
    self.responseMessage = response.responseMessage;
    
    [self removeRequestIdWithRequestID:response.requestId];
    
    if (errorType == LXBaseRequestStateNetError) {
        if (response.status == LXResponseStatusTimeout) {
            self.requestState = LXBaseRequestStateTimeout;
        }
    }
    if (errorType == LXBaseRequestStateNoNetWork) {
        self.requestState = LXBaseRequestStateNoNetWork;
    }
    
    [self beforePerformFailWithResponse:response];
    
    if ([self.delegate respondsToSelector:@selector(requestDidFailed:)]) {
        [self.delegate requestDidFailed:self];
    } else {
        if (self.failBlock) {
            self.failBlock(self);
            self.failBlock = nil;
        }
    }
    
    [self afterPerformFailWithResponse:response];
    
    switch (self.requestState) {
        case LXBaseRequestStateTimeout:
//#ifdef DEBUG
//            [SBHUD showBriefMsg:[NSString stringWithFormat:@"网络超时 %@", NSStringFromClass([self class])]];
//#else
//            [SBHUD showBriefMsg:@"网络超时"];
//#endif
            break;
            
        case LXBaseRequestStateNetError:
//#ifdef DEBUG
//            [SBHUD showBriefMsg:[NSString stringWithFormat:@"网络错误 %@", NSStringFromClass([self class])]];
//#else
//            [SBHUD showBriefMsg:@"网络错误"];
//#endif
            break;
            
        case LXBaseRequestStateNoNetWork:
//            [SBHUD showBriefMsg:@"网络异常, 请检查网络设置"];
            break;
            
        default:
            break;
    }

    
}




#pragma mark - --BaseManager实现的子类或者代理的方法
#pragma mark - interceptor(拦截器)方法
/*
 拦截器的功能可以由子类通过继承实现，也可以由其它对象实现, 两种做法可以共存(共存是指一个接口, 既需要子类验证, 也需要其他类验证, 相当于要经过两次验证)
 当两种情况共存的时候，子类重写的方法最后(或之前) 一定要调用一下super
 这样才可以保证, 子类重新的方法被调用之后, 其他类的验证也可以被调用
 
 notes:
 一般使用中，可直接通过继承直接实现这些方法，如果有一些全局的操作可以写在父类中，重写子类方法的时候调用一下super
 如果两种情况同时存在， 即重写了子类的相应方法，又有其他的类来做拦截，则一定要调用super
 */
/** 是否允许调用接口 */
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if ([self.interceptor respondsToSelector:@selector(request:shouldCallAPIWithParams:)]) {
        return [self.interceptor request:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

/** 调用接口之后做的操作 */
- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if ([self.interceptor respondsToSelector:@selector(request:afterCallAPIWithParams:)]) {
        [self.interceptor request:self afterCallAPIWithParams:params];
    }
}

/** 接口返回成功，返回控制器回调requestDidSuccess之前的操作 */
- (void)beforePerformSuccessWithResponse:(LXResponse *)response
{
    if ([self.interceptor respondsToSelector:@selector(request:beforePerformSuccessWithResponse:)]) {
        [self.interceptor request:self beforePerformSuccessWithResponse:response];
    }
}

/** 接口返回失败，返回控制器回调requestDidFailed之前的操作 */
- (void)beforePerformFailWithResponse:(LXResponse *)response
{
    if ([self.interceptor respondsToSelector:@selector(request:beforePerformFailWithResponse:)]) {
        [self.interceptor request:self beforePerformFailWithResponse:response];
    }
}

/** 接口返回成功，返回控制器回调requestDidSuccess之后的操作 */
- (void)afterPerformSuccessWithResponse:(LXResponse *)response
{
    if ([self.interceptor respondsToSelector:@selector(request:afterPerformSuccessWithResponse:)]) {
        [self.interceptor request:self afterPerformSuccessWithResponse:response];
    }
}

/** 接口返回失败，返回控制器回调requestDidFailed之后的操作 */
- (void)afterPerformFailWithResponse:(LXResponse *)response
{
    if ([self.interceptor respondsToSelector:@selector(request:afterPerformFailWithResponse:)]) {
        [self.interceptor request:self afterPerformFailWithResponse:response];
    }
}

#pragma mark -- 验证器(validator)方法
-(BOOL)isCorrectWithParamsData:(NSDictionary*)params
{
    if ([self.validator respondsToSelector:@selector(request:isCorrectWithParamsData:)]) {
        return [self.validator request:self isCorrectWithParamsData:params];
    }else{
        return YES;
    }
}

-(BOOL)isCorrectWithResponseData:(NSDictionary*)data
{
    if ([self.validator respondsToSelector:@selector(request:isCorrectWithResponseData:)]) {
        return [self.validator request:self isCorrectWithResponseData:data];
    }else{
        return YES;
    }
}


-(NSString*)getMethodName
{
    
    //    NSString *methodName = [NSString stringWithFormat:@"%@_%@_%@",[self convertRequestType:self.child.requestType], SBAPPDelegate.token ? SBAPPDelegate.token : @"token", self.child.requestUrl];
    NSString *methodName = [NSString stringWithFormat:@"%@_%@_%@",[self convertRequestType:self.child.requestType], @"token", self.child.requestUrl];
    
    return methodName;
}

- (BOOL)shouldCache
{
    return kLXNNeedCache;
}

#pragma mark - --私有方法
- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params
{
    NSString *methodName = [self getMethodName];
    NSData *result = [self.cache fetchCachedDataWithAPIResources:methodName  requestParams:params];
    
    if (result == nil) {
        return NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        LXResponse *response = [[LXResponse alloc] initWithData:result];
        response.requestParams = params;
        [self successedOnCallingAPI:response];
    });
    return YES;
}



- (NSString*)convertRequestType:(LXBaseRequestType)type
{
    NSString* str;
    switch (type) {
        case LXBaseRequestTypePost:
            str = @"POST";
            break;
        case LXBaseRequestTypeGet:
            str = @"GET";
            break;
        case LXBaseRequestTypeUpload:
            str = @"UPLOAD";
            break;
        default:
            break;
    }
    return str;
}






@end









